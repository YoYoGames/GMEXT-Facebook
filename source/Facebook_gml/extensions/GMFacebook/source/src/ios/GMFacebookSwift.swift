
import Foundation
import UIKit
import CxxStdlib
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

private final class GMFacebookShareDelegate: NSObject, SharingDelegate {
    let requestId: Int32
    let callback: GMFunction
    let complete: () -> Void

    init(
        requestId: Int32,
        callback: GMFunction,
        complete: @escaping () -> Void
    ) {
        self.requestId = requestId
        self.callback = callback
        self.complete = complete
        super.init()
    }

    func sharer(
        _ sharer: Sharing,
        didCompleteWithResults results: [String: Any]
    ) {
        let postId =
            (results["postId"] as? String)
            ?? (results["post_id"] as? String)
            ?? ""

        let token = AccessToken.current
        let activeToken = token?.isExpired == false ? token : nil

        callback.call(
            FacebookCallbackResult(
                success: true,
                status: FacebookOperationStatus.Success,
                request_id: requestId,
                error_message: "",
                access_token: activeToken?.tokenString ?? "",
                user_id: activeToken?.userID ?? "",
                response_text: "",
                post_id: postId,
                granted_permissions: [],
                declined_permissions: []
            )
        )

        complete()
    }

    func sharer(
        _ sharer: Sharing,
        didFailWithError error: Error
    ) {
        callback.call(
            FacebookCallbackResult(
                success: false,
                status: FacebookOperationStatus.Error,
                request_id: requestId,
                error_message: error.localizedDescription,
                access_token: "",
                user_id: "",
                response_text: "",
                post_id: "",
                granted_permissions: [],
                declined_permissions: []
            )
        )

        complete()
    }

    func sharerDidCancel(_ sharer: Sharing) {
        callback.call(
            FacebookCallbackResult(
                success: false,
                status: FacebookOperationStatus.Cancelled,
                request_id: requestId,
                error_message: "",
                access_token: "",
                user_id: "",
                response_text: "",
                post_id: "",
                granted_permissions: [],
                declined_permissions: []
            )
        )

        complete()
    }
}

/**
 Extension Generator conversion of YYFacebook.

 Meta iOS SDK target: 18.1.x.
 Social Async DS-map events were replaced by per-function GMFunction callbacks.
 */
public final class GMFacebookSwift: GMFacebookInternalSwift {
    private var ready = false
    private var loginStatus = FacebookLoginStatus.Idle
    private var nextRequestId: Int32 = 1
    private var applicationDelegateInitialized = false

    private let loginManager = LoginManager()

    private var shareDelegate: GMFacebookShareDelegate?
    private var shareDialog: ShareDialog?

    public override init() {
        super.init()
    }

    private func newRequestId() -> Int32 {
        let value = nextRequestId
        nextRequestId += 1
        return value
    }

    private var activeAccessToken: AccessToken? {
        guard let token = AccessToken.current,
              !token.isExpired
        else {
            return nil
        }

        return token
    }

    private func initializeApplicationDelegateIfNeeded(
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

    private func result(
        success: Bool,
        status: FacebookOperationStatus,
        requestId: Int32,
        errorMessage: String = "",
        accessToken: String = "",
        userId: String = "",
        responseText: String = "",
        postId: String = "",
        grantedPermissions: [String] = [],
        declinedPermissions: [String] = []
    ) -> FacebookCallbackResult {
        return FacebookCallbackResult(
            success: success,
            status: status,
            request_id: requestId,
            error_message: errorMessage,
            access_token: accessToken,
            user_id: userId,
            response_text: responseText,
            post_id: postId,
            granted_permissions: grantedPermissions,
            declined_permissions: declinedPermissions
        )
    }

    private func success(_ requestId: Int32) -> FacebookCallbackResult {
        return result(
            success: true,
            status: .Success,
            requestId: requestId,
            accessToken: fb_access_token(),
            userId: fb_user_id()
        )
    }

    private func failure(
        _ requestId: Int32,
        _ message: String
    ) -> FacebookCallbackResult {
        return result(
            success: false,
            status: .Error,
            requestId: requestId,
            errorMessage: message
        )
    }

    private func requireReady(
        _ callback: GMFunction,
        _ requestId: Int32
    ) -> Bool {
        guard ready else {
            callback.call(
                failure(
                    requestId,
                    "Facebook SDK is not initialized."
                )
            )
            return false
        }

        return true
    }

    private func topViewController(
        _ root: UIViewController? =
            UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)?
                .rootViewController
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

    public override func fb_initialize(callback: GMFunction) {
        DispatchQueue.main.async {
            if self.ready {
                callback.call(self.success(0))
                return
            }

            self.initializeApplicationDelegateIfNeeded()
            self.ready = true
            self.loginStatus =
                self.activeAccessToken != nil
                    ? .Authorised
                    : .Idle

            callback.call(self.success(0))
        }
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
        loginStatus = .Idle
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
    ) {
        Settings.shared.isEventDataUsageLimited = enabled
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
    ) {
        requestReadPermissions(
            permissions: permissions,
            callback: callback
        )
    }

    public override func fb_request_read_permissions(
        permissions: [String],
        callback: GMFunction
    ) {
        requestReadPermissions(
            permissions: permissions,
            callback: callback
        )
    }

    private func requestReadPermissions(
        permissions: [String],
        callback: GMFunction
    ) {
        let requestId = newRequestId()

        guard requireReady(callback, requestId) else {
            return
        }

        guard loginStatus != .Processing else {
            callback.call(
                failure(
                    requestId,
                    "A Facebook login request is already in progress."
                )
            )
            return
        }

        let requested =
            permissions.isEmpty
                ? ["public_profile"]
                : permissions

        loginStatus = .Processing

        DispatchQueue.main.async {
            self.loginManager.logIn(
                permissions: requested,
                from: self.topViewController()
            ) { loginResult, error in
                if let error {
                    self.loginStatus = .Failed
                    callback.call(
                        self.failure(
                            requestId,
                            error.localizedDescription
                        )
                    )
                    return
                }

                guard let loginResult else {
                    self.loginStatus = .Failed
                    callback.call(
                        self.failure(
                            requestId,
                            "Facebook login returned no result."
                        )
                    )
                    return
                }

                if loginResult.isCancelled {
                    self.loginStatus = .Idle
                    callback.call(
                        self.result(
                            success: false,
                            status: .Cancelled,
                            requestId: requestId
                        )
                    )
                    return
                }

                guard let token =
                    loginResult.token
                    ?? self.activeAccessToken,
                      !token.isExpired
                else {
                    self.loginStatus = .Failed
                    callback.call(
                        self.failure(
                            requestId,
                            "Facebook login returned no active access token."
                        )
                    )
                    return
                }

                self.loginStatus = .Authorised

                callback.call(
                    self.result(
                        success: true,
                        status: .Success,
                        requestId: requestId,
                        accessToken: token.tokenString,
                        userId: token.userID,
                        grantedPermissions:
                            Array(loginResult.grantedPermissions).sorted(),
                        declinedPermissions:
                            Array(loginResult.declinedPermissions).sorted()
                    )
                )
            }
        }
    }

    public override func fb_request_publish_permissions(
        permissions: [String],
        callback: GMFunction
    ) {
        callback.call(
            failure(
                newRequestId(),
                "Facebook publish permissions are not supported by the current extension API."
            )
        )
    }

    public override func fb_refresh_access_token(
        callback: GMFunction
    ) {
        let requestId = newRequestId()

        guard activeAccessToken != nil else {
            callback.call(
                failure(
                    requestId,
                    "A logged-in Facebook user is required before refreshing the access token."
                )
            )
            return
        }

        AccessToken.refreshCurrentAccessToken {
            _, _, error in

            if let error {
                self.loginStatus = .Failed
                callback.call(
                    self.failure(
                        requestId,
                        error.localizedDescription
                    )
                )
                return
            }

            guard let token = self.activeAccessToken else {
                self.loginStatus = .Failed
                callback.call(
                    self.failure(
                        requestId,
                        "Facebook returned no active access token."
                    )
                )
                return
            }

            self.loginStatus = .Authorised

            callback.call(
                self.result(
                    success: true,
                    status: .Success,
                    requestId: requestId,
                    accessToken: token.tokenString,
                    userId: token.userID
                )
            )
        }
    }

    public override func fb_graph_request(
        graph_path: String,
        method: FacebookHttpMethod,
        parameters: [FacebookNamedValue],
        callback: GMFunction
    ) {
        let requestId = newRequestId()

        guard requireReady(callback, requestId) else {
            return
        }

        guard activeAccessToken != nil else {
            callback.call(
                failure(
                    requestId,
                    "Facebook user is not logged in."
                )
            )
            return
        }

        let trimmedPath = graph_path.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedPath.isEmpty else {
            callback.call(
                failure(requestId, "Graph path is empty.")
            )
            return
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
                callback.call(
                    self.failure(
                        requestId,
                        error.localizedDescription
                    )
                )
                return
            }

            callback.call(
                self.result(
                    success: true,
                    status: .Success,
                    requestId: requestId,
                    accessToken: self.fb_access_token(),
                    userId: self.fb_user_id(),
                    responseText: self.responseText(value)
                )
            )
        }
    }

    public override func fb_dialog(
        link_url: String,
        callback: GMFunction
    ) {
        let requestId = newRequestId()

        guard requireReady(callback, requestId) else {
            return
        }

        let trimmedURL = link_url.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard let url = URL(string: trimmedURL),
              url.scheme != nil
        else {
            callback.call(
                failure(requestId, "Invalid share URL.")
            )
            return
        }

        DispatchQueue.main.async {
            let content = ShareLinkContent()
            content.contentURL = url

            let delegate = GMFacebookShareDelegate(
                requestId: requestId,
                callback: callback
            ) { [weak self] in
                self?.shareDialog = nil
                self?.shareDelegate = nil
            }

            let dialog = ShareDialog(
                viewController: self.topViewController(),
                content: content,
                delegate: delegate
            )

            self.shareDelegate = delegate
            self.shareDialog = dialog

            if !dialog.show() {
                callback.call(
                    self.failure(
                        requestId,
                        "Facebook ShareDialog could not be shown."
                    )
                )

                self.shareDialog = nil
                self.shareDelegate = nil
            }
        }
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

    // GameMaker iOS lifecycle bridge hooks.

    @objc public func onLaunch(
        launchOptions: NSDictionary
    ) {
        initializeApplicationDelegateIfNeeded(
            launchOptions:
                launchOptions as? [
                    UIApplication.LaunchOptionsKey: Any
                ]
        )
    }

    @objc public func onResume() {
        AppEvents.shared.activateApp()
    }

    @objc public func onOpenURL(
        url: NSURL,
        sourceApplication: String,
        annotation: Any
    ) -> Bool {
        var options: [
            UIApplication.OpenURLOptionsKey: Any
        ] = [
            .sourceApplication: sourceApplication
        ]

        options[.annotation] = annotation

        return ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url as URL,
            options: options
        )
    }
}
