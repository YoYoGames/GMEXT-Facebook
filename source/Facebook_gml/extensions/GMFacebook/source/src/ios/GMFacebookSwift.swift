
import Foundation
import UIKit
import CxxStdlib
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

// Every path here takes the pending callback through `take` before firing it,
// so a delivery for a request fb_reset_pending already abandoned finds nothing
// and is dropped rather than firing the GML callback a second time.
private final class GMFacebookShareDelegate: NSObject, SharingDelegate {
    let requestId: Int32
    let take: (Int32) -> GMFunction?

    init(
        requestId: Int32,
        take: @escaping (Int32) -> GMFunction?
    ) {
        self.requestId = requestId
        self.take = take
        super.init()
    }

    func sharer(
        _ sharer: Sharing,
        didCompleteWithResults results: [String: Any]
    ) {
        guard let callback = take(requestId) else {
            return
        }

        // Meta only returns a post id when the app holds publish permissions,
        // so absent is the normal case rather than a failure to report.
        let raw =
            (results["postId"] as? String)
            ?? (results["post_id"] as? String)
        let postId: String? = (raw?.isEmpty == false) ? raw : nil

        callback.call(GMFacebookSwift.successResult(), postId as Any)
    }

    func sharer(
        _ sharer: Sharing,
        didFailWithError error: Error
    ) {
        guard let callback = take(requestId) else {
            return
        }

        callback.call(
            GMFacebookSwift.failureResult(error.localizedDescription),
            GMFacebookSwift.noPayload
        )
    }

    func sharerDidCancel(_ sharer: Sharing) {
        guard let callback = take(requestId) else {
            return
        }

        callback.call(
            GMFacebookSwift.cancelledResult(),
            GMFacebookSwift.noPayload
        )
    }
}

/**
 Extension Generator conversion of YYFacebook.

 Meta iOS SDK target: 18.1.x.
 Social Async DS-map events were replaced by per-function GMFunction callbacks.
 */
public final class GMFacebookSwift: GMFacebookInternalSwift {
    private struct PendingCall {
        let requestId: Int32
        let callback: GMFunction
    }

    // ShareDialog holds its delegate weakly, so this is the only strong
    // reference keeping a pending share alive. Both are filled in after the
    // slot is claimed, which is why they are optional rather than let.
    private struct ShareSession {
        let requestId: Int32
        let callback: GMFunction
        var dialog: ShareDialog?
        var delegate: GMFacebookShareDelegate?
    }

    // Everything below is written from the main queue and from SDK completion
    // handlers, and read from the game thread. Android marks the equivalent
    // fields volatile and guards its counter with synchronized; this lock is
    // that. Never hold it across a callback.call(...).
    private let stateLock = NSLock()

    private var _ready = false
    private var _loginStatus = FacebookLoginStatus.Idle
    private var _nextRequestId: Int32 = 1
    private var _pendingLogin: PendingCall?
    private var _pendingShare: ShareSession?

    private let loginManager = LoginManager()

    public override init() {
        super.init()
    }

    private var ready: Bool {
        get {
            stateLock.lock()
            defer { stateLock.unlock() }
            return _ready
        }
        set {
            stateLock.lock()
            defer { stateLock.unlock() }
            _ready = newValue
        }
    }

    private var loginStatus: FacebookLoginStatus {
        get {
            stateLock.lock()
            defer { stateLock.unlock() }
            return _loginStatus
        }
        set {
            stateLock.lock()
            defer { stateLock.unlock() }
            _loginStatus = newValue
        }
    }

    // Claims the login slot and allocates the request id in one critical
    // section. Doing it in two took the lock twice, so a second caller could
    // pass the Processing check before the first had written it.
    private func beginLogin(_ callback: GMFunction) -> Int32? {
        stateLock.lock()
        defer { stateLock.unlock() }

        guard _pendingLogin == nil else {
            return nil
        }

        let requestId = _nextRequestId
        _nextRequestId += 1
        _pendingLogin = PendingCall(requestId: requestId, callback: callback)
        _loginStatus = .Processing
        return requestId
    }

    // Returns the held callback only when the ids match, so a delivery for a
    // request fb_reset_pending already abandoned finds nothing and is dropped
    // instead of firing a second time.
    private func takePendingLogin(_ requestId: Int32) -> GMFunction? {
        stateLock.lock()
        defer { stateLock.unlock() }

        guard let pending = _pendingLogin,
              pending.requestId == requestId
        else {
            return nil
        }

        _pendingLogin = nil
        return pending.callback
    }

    private func takeAnyPendingLogin() -> GMFunction? {
        stateLock.lock()
        defer { stateLock.unlock() }

        let pending = _pendingLogin
        _pendingLogin = nil
        return pending?.callback
    }

    // One share at a time - a second fb_dialog is rejected synchronously, so
    // the dialog and delegate the previous keyed dictionary existed to hold
    // apart now fit in a single slot claimed here.
    private func beginShare(_ callback: GMFunction) -> Int32? {
        stateLock.lock()
        defer { stateLock.unlock() }

        guard _pendingShare == nil else {
            return nil
        }

        let requestId = _nextRequestId
        _nextRequestId += 1
        _pendingShare = ShareSession(
            requestId: requestId,
            callback: callback,
            dialog: nil,
            delegate: nil
        )
        return requestId
    }

    private func attachShareDialog(
        _ requestId: Int32,
        dialog: ShareDialog,
        delegate: GMFacebookShareDelegate
    ) {
        stateLock.lock()
        defer { stateLock.unlock() }

        guard _pendingShare?.requestId == requestId else {
            return
        }

        _pendingShare?.dialog = dialog
        _pendingShare?.delegate = delegate
    }

    private func takePendingShare(_ requestId: Int32) -> GMFunction? {
        stateLock.lock()
        defer { stateLock.unlock() }

        guard let pending = _pendingShare,
              pending.requestId == requestId
        else {
            return nil
        }

        _pendingShare = nil
        return pending.callback
    }

    private func takeAnyPendingShare() -> GMFunction? {
        stateLock.lock()
        defer { stateLock.unlock() }

        let pending = _pendingShare
        _pendingShare = nil
        return pending?.callback
    }

    private var activeAccessToken: AccessToken? {
        guard let token = AccessToken.current,
              !token.isExpired
        else {
            return nil
        }

        return token
    }

    // GMFunction.call takes Any..., where a bare nil has no contextual type.
    // A boxed empty optional is what reaches GML as undefined.
    static let noPayload: Any = Optional<String>.none as Any

    static func successResult() -> FacebookResult {
        return FacebookResult(
            success: true,
            status: .Success,
            error_message: nil,
            sdk_error_code: nil
        )
    }

    // Backing out of a dialog is not an error, so no message is attached.
    static func cancelledResult() -> FacebookResult {
        return FacebookResult(
            success: false,
            status: .Cancelled,
            error_message: nil,
            sdk_error_code: nil
        )
    }

    static func failureResult(
        _ message: String,
        sdkErrorCode: Int32? = nil
    ) -> FacebookResult {
        return FacebookResult(
            success: false,
            status: .Error,
            error_message: message,
            sdk_error_code: sdkErrorCode
        )
    }

    private func loginInfo(_ token: AccessToken) -> FacebookLoginInfo {
        return FacebookLoginInfo(
            access_token: token.tokenString,
            user_id: token.userID,
            // AccessToken's Swift overlay returns Set<Permission>, not the
            // Set<String> that LoginManagerLoginResult's own permission sets
            // use - hence .name here and a bare Array(...) there.
            permissions: token.permissions.map(\.name).sorted(),
            declined_permissions: token.declinedPermissions.map(\.name).sorted()
        )
    }

    // The scene API is iOS 13, and this extension deploys at 12.0 to match the
    // runner's own target - so the pre-scene keyWindow lookup has to stay as
    // the fallback rather than being assumed dead.
    private static func keyWindowRoot() -> UIViewController? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)?
                .rootViewController
        }

        return UIApplication.shared.keyWindow?.rootViewController
    }

    private func topViewController(
        _ root: UIViewController? = GMFacebookSwift.keyWindowRoot()
    ) -> UIViewController? {
        if let navigation = root as? UINavigationController {
            return topViewController(navigation.visibleViewController)
        }

        if let tab = root as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }

        if let presented = root?.presentedViewController {
            return topViewController(presented)
        }

        return root
    }

    public override func fb_initialize(callback: GMFunction) -> FacebookError {
        DispatchQueue.main.async {
            if self.ready {
                callback.call(GMFacebookSwift.successResult())
                return
            }

            GMFacebookLifecycle.initializeApplicationDelegateIfNeeded()

            // Info.plist carries these through the extension's YYIosPlist
            // injection, so an unset appId/clientToken option reaches the SDK
            // as an empty string. Android names the same failure rather than
            // reporting a successful init and failing at first login.
            let appId = (Settings.shared.appID ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !appId.isEmpty else {
                callback.call(
                    GMFacebookSwift.failureResult("FacebookAppID is empty.")
                )
                return
            }

            let clientToken = (Settings.shared.clientToken ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !clientToken.isEmpty else {
                callback.call(
                    GMFacebookSwift.failureResult(
                        "FacebookClientToken is empty."
                    )
                )
                return
            }

            self.ready = true
            self.loginStatus =
                self.activeAccessToken != nil
                    ? .Authorised
                    : .Idle

            callback.call(GMFacebookSwift.successResult())
        }

        // iOS has no activity to be missing; the configuration check above is a
        // project-setup outcome and stays in the callback, matching Android.
        return .Ok
    }

    public override func fb_ready() -> Bool {
        return ready
    }

    public override func fb_status() -> FacebookLoginStatus {
        if loginStatus == .Processing {
            return loginStatus
        }

        if fb_is_logged_in() {
            loginStatus = .Authorised
            return loginStatus
        }

        if loginStatus == .Authorised {
            loginStatus = .Idle
        }

        return loginStatus
    }

    public override func fb_is_logged_in() -> Bool {
        return activeAccessToken != nil
    }

    public override func fb_user_id() -> String {
        return activeAccessToken?.userID ?? ""
    }

    public override func fb_access_token() -> String {
        return activeAccessToken?.tokenString ?? ""
    }

    public override func fb_logout() {
        loginManager.logOut()

        // A login still in flight is left alone - reporting Idle while its
        // callback is still held would contradict the LoginInProgress the next
        // fb_login would return. Abandoning one is fb_reset_pending's job.
        stateLock.lock()
        if _pendingLogin == nil {
            _loginStatus = .Idle
        }
        stateLock.unlock()
    }

    public override func fb_reset_pending() {
        // Both takes complete before either callback fires - stateLock must
        // never be held across a callback.call(...).
        let login = takeAnyPendingLogin()
        let share = takeAnyPendingShare()

        if let login {
            loginStatus = .Idle
            login.call(
                GMFacebookSwift.cancelledResult(),
                GMFacebookSwift.noPayload
            )
        }

        share?.call(
            GMFacebookSwift.cancelledResult(),
            GMFacebookSwift.noPayload
        )
    }

    public override func fb_set_auto_log_app_events_enabled(
        enabled: Bool
    ) {
        Settings.shared.isAutoLogAppEventsEnabled = enabled
    }

    public override func fb_auto_log_app_events_enabled() -> Bool {
        return Settings.shared.isAutoLogAppEventsEnabled
    }

    public override func fb_set_advertiser_id_collection_enabled(
        enabled: Bool
    ) {
        Settings.shared.isAdvertiserIDCollectionEnabled = enabled
    }

    public override func fb_advertiser_id_collection_enabled() -> Bool {
        return Settings.shared.isAdvertiserIDCollectionEnabled
    }

    public override func fb_set_event_data_usage_limited(
        enabled: Bool
    ) -> FacebookError {
        // Settings.shared applies whatever the app is doing, so unlike Android
        // there is no initialization state that can make this fail.
        Settings.shared.isEventDataUsageLimited = enabled
        return .Ok
    }

    public override func fb_event_data_usage_limited() -> Bool {
        return Settings.shared.isEventDataUsageLimited
    }

    public override func fb_set_data_processing_options(
        options: [String],
        country: Int32,
        state: Int32
    ) {
        Settings.shared.setDataProcessingOptions(
            options,
            country: country,
            state: state
        )
    }

    public override func fb_check_permission(
        permission: String
    ) -> Bool {
        let requestedPermission = permission.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !requestedPermission.isEmpty else {
            return false
        }

        return activeAccessToken?.hasGranted(
            permission: requestedPermission
        ) ?? false
    }

    public override func fb_login(
        permissions: [String],
        callback: GMFunction
    ) -> FacebookError {
        guard ready else {
            return .NotInitialized
        }

        let requested =
            permissions.isEmpty
                ? ["public_profile"]
                : permissions

        guard let requestId = beginLogin(callback) else {
            return .LoginInProgress
        }

        DispatchQueue.main.async {
            self.loginManager.logIn(
                permissions: requested,
                from: self.topViewController()
            ) { loginResult, error in
                guard let pending = self.takePendingLogin(requestId) else {
                    return
                }

                if let error {
                    self.loginStatus = .Failed
                    pending.call(
                        GMFacebookSwift.failureResult(
                            error.localizedDescription
                        ),
                        GMFacebookSwift.noPayload
                    )
                    return
                }

                guard let loginResult else {
                    self.loginStatus = .Failed
                    pending.call(
                        GMFacebookSwift.failureResult(
                            "Facebook login returned no result."
                        ),
                        GMFacebookSwift.noPayload
                    )
                    return
                }

                if loginResult.isCancelled {
                    self.loginStatus = .Idle
                    pending.call(
                        GMFacebookSwift.cancelledResult(),
                        GMFacebookSwift.noPayload
                    )
                    return
                }

                guard let token =
                    loginResult.token
                    ?? self.activeAccessToken,
                      !token.isExpired
                else {
                    self.loginStatus = .Failed
                    pending.call(
                        GMFacebookSwift.failureResult(
                            "Facebook login returned no active access token."
                        ),
                        GMFacebookSwift.noPayload
                    )
                    return
                }

                self.loginStatus = .Authorised

                let info: FacebookLoginInfo? = self.loginInfo(token)
                pending.call(GMFacebookSwift.successResult(), info as Any)
            }
        }

        return .Ok
    }

    public override func fb_refresh_access_token(
        callback: GMFunction
    ) -> FacebookError {
        guard ready else {
            return .NotInitialized
        }

        guard activeAccessToken != nil else {
            return .NotLoggedIn
        }

        AccessToken.refreshCurrentAccessToken {
            _, _, error in

            if let error {
                self.loginStatus = .Failed
                callback.call(
                    GMFacebookSwift.failureResult(
                        error.localizedDescription
                    ),
                    GMFacebookSwift.noPayload
                )
                return
            }

            guard let token = self.activeAccessToken else {
                self.loginStatus = .Failed
                callback.call(
                    GMFacebookSwift.failureResult(
                        "Facebook returned no active access token."
                    ),
                    GMFacebookSwift.noPayload
                )
                return
            }

            self.loginStatus = .Authorised

            let info: FacebookLoginInfo? = self.loginInfo(token)
            callback.call(GMFacebookSwift.successResult(), info as Any)
        }

        return .Ok
    }

    public override func fb_graph_request(
        graph_path: String,
        method: FacebookHttpMethod,
        parameters: [FacebookNamedValue],
        callback: GMFunction
    ) -> FacebookError {
        guard ready else {
            return .NotInitialized
        }

        guard activeAccessToken != nil else {
            return .NotLoggedIn
        }

        let trimmedPath = graph_path.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedPath.isEmpty else {
            return .InvalidArgument
        }

        let httpMethod: HTTPMethod
        switch method {
        case .Get:
            httpMethod = .get
        case .Delete:
            httpMethod = .delete
        case .Post:
            httpMethod = .post
        }

        let request = GraphRequest(
            graphPath: trimmedPath,
            parameters: namedValues(parameters),
            httpMethod: httpMethod
        )

        request.start { _, value, error in
            if let error {
                // Meta's own documented Graph error number, the same value
                // Android reads from FacebookRequestError.getErrorCode().
                // Deliberately not (error as NSError).code, which is FBSDK's
                // own error-domain numbering and would only look like it.
                // Absent when the failure was not a Graph API error.
                let graphCode =
                    (error as NSError)
                        .userInfo[GraphRequestErrorGraphErrorCodeKey]
                        as? Int

                callback.call(
                    GMFacebookSwift.failureResult(
                        error.localizedDescription,
                        sdkErrorCode: graphCode.map(Int32.init)
                    ),
                    GMFacebookSwift.noPayload
                )
                return
            }

            let text: String? = self.responseText(value)
            callback.call(GMFacebookSwift.successResult(), text as Any)
        }

        return .Ok
    }

    public override func fb_dialog(
        link_url: String,
        callback: GMFunction
    ) -> FacebookError {
        guard ready else {
            return .NotInitialized
        }

        let trimmedURL = link_url.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard let url = URL(string: trimmedURL),
              url.scheme != nil
        else {
            return .InvalidArgument
        }

        guard let requestId = beginShare(callback) else {
            return .ShareInProgress
        }

        DispatchQueue.main.async {
            let content = ShareLinkContent()
            content.contentURL = url

            let delegate = GMFacebookShareDelegate(
                requestId: requestId
            ) { [weak self] id in
                self?.takePendingShare(id)
            }

            let dialog = ShareDialog(
                viewController: self.topViewController(),
                content: content,
                delegate: delegate
            )

            self.attachShareDialog(
                requestId,
                dialog: dialog,
                delegate: delegate
            )

            if !dialog.show() {
                guard let pending = self.takePendingShare(requestId) else {
                    return
                }

                pending.call(
                    GMFacebookSwift.failureResult(
                        "Facebook ShareDialog could not be shown."
                    ),
                    GMFacebookSwift.noPayload
                )
            }
        }

        return .Ok
    }

    public override func fb_send_event(
        event: FacebookAppEvent,
        value: Double,
        parameters: [FacebookEventParameterValue]
    ) {
        guard ready,
              value.isFinite,
              let eventName = standardEventName(event)
        else {
            return
        }

        AppEvents.shared.logEvent(
            eventName,
            valueToSum: value,
            parameters: eventValues(parameters)
        )
    }

    public override func fb_send_custom_event(
        event_name: String,
        value: Double,
        parameters: [FacebookNamedValue]
    ) {
        let name = event_name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard ready,
              value.isFinite,
              !name.isEmpty
        else {
            return
        }

        AppEvents.shared.logEvent(
            AppEvents.Name(rawValue: name),
            valueToSum: value,
            parameters: namedEventValues(parameters)
        )
    }

    public override func fb_send_purchase(
        amount: Double,
        currency: String,
        parameters: [FacebookNamedValue]
    ) {
        let currencyCode = currency.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).uppercased()

        guard ready,
              amount.isFinite,
              amount >= 0,
              currencyCode.count == 3
        else {
            return
        }

        AppEvents.shared.logPurchase(
            amount: amount,
            currency: currencyCode,
            parameters: namedEventValues(parameters)
        )
    }

    public override func fb_flush_events() {
        guard ready else {
            return
        }

        AppEvents.shared.flush()
    }

    public override func fb_set_event_user_id(
        user_id: String
    ) {
        let value = user_id.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        AppEvents.shared.userID =
            value.isEmpty
                ? nil
                : value
    }

    public override func fb_get_event_user_id() -> String {
        return AppEvents.shared.userID ?? ""
    }

    public override func fb_clear_event_user_id() {
        AppEvents.shared.userID = nil
    }

    private func namedValues(
        _ values: [FacebookNamedValue]
    ) -> [String: Any] {
        var output: [String: Any] = [:]

        for value in values {
            let name = value.name.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard !name.isEmpty else {
                continue
            }

            output[name] =
                value.use_number
                    ? value.number_value
                    : value.string_value
        }

        return output
    }

    private func namedEventValues(
        _ values: [FacebookNamedValue]
    ) -> [AppEvents.ParameterName: Any] {
        var output: [AppEvents.ParameterName: Any] = [:]

        for value in values {
            let name = value.name.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            guard !name.isEmpty else {
                continue
            }

            output[AppEvents.ParameterName(rawValue: name)] =
                value.use_number
                    ? value.number_value
                    : value.string_value
        }

        return output
    }

    private func eventValues(
        _ values: [FacebookEventParameterValue]
    ) -> [AppEvents.ParameterName: Any] {
        var output: [AppEvents.ParameterName: Any] = [:]

        for value in values {
            guard let name = standardParameterName(value.key) else {
                continue
            }

            output[name] =
                value.use_number
                    ? value.number_value
                    : value.string_value
        }

        return output
    }

    private func standardEventName(
        _ event: FacebookAppEvent
    ) -> AppEvents.Name? {
        switch event {
        case .AchievedLevel:
            return .achievedLevel
        case .AddedPaymentInfo:
            return .addedPaymentInfo
        case .AddedToCart:
            return .addedToCart
        case .AddedToWishlist:
            return .addedToWishlist
        case .CompletedRegistration:
            return .completedRegistration
        case .CompletedTutorial:
            return .completedTutorial
        case .InitiatedCheckout:
            return .initiatedCheckout
        case .Rated:
            return .rated
        case .Searched:
            return .searched
        case .SpentCredits:
            return .spentCredits
        case .UnlockedAchievement:
            return .unlockedAchievement
        case .ViewedContent:
            return .viewedContent
        case .Contact:
            return AppEvents.Name(rawValue: "Contact")
        case .CustomizeProduct:
            return AppEvents.Name(rawValue: "CustomizeProduct")
        case .Donate:
            return AppEvents.Name(rawValue: "Donate")
        case .FindLocation:
            return AppEvents.Name(rawValue: "FindLocation")
        case .Schedule:
            return AppEvents.Name(rawValue: "Schedule")
        case .StartTrial:
            return AppEvents.Name(rawValue: "StartTrial")
        case .SubmitApplication:
            return AppEvents.Name(rawValue: "SubmitApplication")
        case .Subscribe:
            return AppEvents.Name(rawValue: "Subscribe")
        case .AdImpression:
            return AppEvents.Name(rawValue: "AdImpression")
        case .AdClick:
            return AppEvents.Name(rawValue: "AdClick")
        }
    }

    private func standardParameterName(
        _ key: FacebookAppEventParameter
    ) -> AppEvents.ParameterName? {
        switch key {
        case .Content:
            return AppEvents.ParameterName(rawValue: "fb_content")
        case .AdType:
            return AppEvents.ParameterName(rawValue: "ad_type")
        case .ContentId:
            return .contentID
        case .ContentType:
            return .contentType
        case .Currency:
            return .currency
        case .Description:
            return .description
        case .Level:
            return .level
        case .MaxRatingValue:
            return .maxRatingValue
        case .NumItems:
            return .numItems
        case .PaymentInfoAvailable:
            return .paymentInfoAvailable
        case .RegistrationMethod:
            return .registrationMethod
        case .SearchString:
            return .searchString
        case .Success:
            return .success
        case .OrderId:
            return AppEvents.ParameterName(rawValue: "fb_order_id")
        }
    }

    private func responseText(_ value: Any?) -> String {
        guard let value else {
            return ""
        }

        if let string = value as? String {
            return string
        }

        guard JSONSerialization.isValidJSONObject(value),
              let data = try? JSONSerialization.data(
                  withJSONObject: value
              ),
              let string = String(
                  data: data,
                  encoding: .utf8
              )
        else {
            return String(describing: value)
        }

        return string
    }
}

/**
 GameMaker iOS lifecycle bridge.

 The runner instantiates the class named by the extension's `classname`
 (GMFacebook) and sends it onLaunch:, onResume and
 onOpenURL:sourceApplication:annotation:. That object cannot reach this
 extension's Swift implementation - the generated bridge keeps its
 GMFacebookSwift instance in a private ivar - so GMFacebook_ios.mm forwards the
 hooks here instead.

 Nothing below needs instance state; all three go straight to an FBSDK
 singleton. The runner sends them on the main thread, which is also where
 fb_initialize runs, so the latch needs no lock.
 */
@objc(GMFacebookLifecycle)
public final class GMFacebookLifecycle: NSObject {
    private static var applicationDelegateInitialized = false

    // Takes [AnyHashable: Any] rather than the natural
    // [UIApplication.LaunchOptionsKey: Any] on purpose. The generated
    // GMFacebook-Swift.h would otherwise name UIApplicationLaunchOptionsKey in
    // this selector, and the .mm files that include that header are compiled
    // without -fmodules, so its own `@import UIKit` is skipped and the type is
    // undeclared. Keeping UIKit out of the ObjC-visible signature is the only
    // fix that also covers the generated .mm, which must not be edited.
    @objc(onLaunch:)
    public static func onLaunch(launchOptions: [AnyHashable: Any]?) {
        var mapped: [UIApplication.LaunchOptionsKey: Any]?

        if let launchOptions {
            var options: [UIApplication.LaunchOptionsKey: Any] = [:]

            for (key, value) in launchOptions {
                guard let name = key as? String else {
                    continue
                }

                options[UIApplication.LaunchOptionsKey(rawValue: name)] = value
            }

            mapped = options
        }

        initializeApplicationDelegateIfNeeded(launchOptions: mapped)
    }

    @objc(onResume)
    public static func onResume() {
        AppEvents.shared.activateApp()
    }

    @objc(onOpenURL:sourceApplication:annotation:)
    public static func onOpenURL(
        url: URL,
        sourceApplication: String?,
        annotation: Any?
    ) {
        var options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        options[.sourceApplication] = sourceApplication
        options[.annotation] = annotation

        _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            options: options
        )
    }

    static func initializeApplicationDelegateIfNeeded(
        launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]? = nil
    ) {
        guard !applicationDelegateInitialized else {
            return
        }

        _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: launchOptions
        )

        applicationDelegateInitialized = true
        Profile.isUpdatedWithAccessTokenChange = true
    }
}
