
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

        callback.call(
            FacebookCallbackResult(
                success: true,
                status: FacebookOperationStatus.Success.rawValue,
                request_id: requestId,
                error_message: "",
                access_token: AccessToken.current?.tokenString ?? "",
                user_id: AccessToken.current?.userID ?? "",
                response_text: "",
                post_id: postId
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
                status: FacebookOperationStatus.Error.rawValue,
                request_id: requestId,
                error_message: error.localizedDescription,
                access_token: "",
                user_id: "",
                response_text: "",
                post_id: ""
            )
        )

        complete()
    }

    func sharerDidCancel(_ sharer: Sharing) {
        callback.call(
            FacebookCallbackResult(
                success: false,
                status: FacebookOperationStatus.Cancelled.rawValue,
                request_id: requestId,
                error_message: "",
                access_token: "",
                user_id: "",
                response_text: "",
                post_id: ""
            )
        )

        complete()
    }
}

/**
 Extension Generator conversion of YYFacebook.

 Meta iOS SDK target: 18.0.3.
 Social Async DS-map events were replaced by per-function GMFunction callbacks.
 */
public final class GMFacebookSwift: GMFacebookInternalSwift {
    private var ready = false
    private var loginStatus = FacebookLoginStatus.Idle
    private var nextRequestId: Int32 = 1

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

    private func result(
        success: Bool,
        status: FacebookOperationStatus,
        requestId: Int32,
        errorMessage: String = "",
        accessToken: String = "",
        userId: String = "",
        responseText: String = "",
        postId: String = ""
    ) -> FacebookCallbackResult {
        return FacebookCallbackResult(
            success: success,
            status: status.rawValue,
            request_id: requestId,
            error_message: errorMessage,
            access_token: accessToken,
            user_id: userId,
            response_text: responseText,
            post_id: postId
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
            _ = ApplicationDelegate.shared.application(
                UIApplication.shared,
                didFinishLaunchingWithOptions: nil
            )

            Profile.isUpdatedWithAccessTokenChange = true

            self.ready = true
            self.loginStatus =
                AccessToken.current != nil
                    ? FacebookLoginStatus.Authorised
                    : FacebookLoginStatus.Idle

            callback.call(self.success(0))
        }
    }

    public override func fb_ready() -> Bool {
        return ready
    }

    public override func fb_status() -> FacebookLoginStatus {
        return loginStatus
    }

    public override func fb_user_id() -> String {
        return AccessToken.current?.userID ?? ""
    }

    public override func fb_access_token() -> String {
        return AccessToken.current?.tokenString ?? ""
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

    public override func fb_set_advertiser_id_collection_enabled(
        enabled: Bool
    ) {
        Settings.shared.isAdvertiserIDCollectionEnabled = enabled
    }

    public override func fb_check_permission(
        permission: String
    ) -> Bool {
        return AccessToken.current?.hasGranted(
            permission: permission
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

                self.loginStatus = .Authorised

                callback.call(
                    self.result(
                        success: true,
                        status: .Success,
                        requestId: requestId,
                        accessToken:
                            loginResult.token?.tokenString
                            ?? AccessToken.current?.tokenString
                            ?? "",
                        userId:
                            loginResult.token?.userID
                            ?? AccessToken.current?.userID
                            ?? ""
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

        guard AccessToken.current != nil else {
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
                callback.call(
                    self.failure(
                        requestId,
                        error.localizedDescription
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
                    accessToken: self.fb_access_token(),
                    userId: self.fb_user_id()
                )
            )
        }
    }

    public override func fb_graph_request(
        graph_path: String,
        method: [FacebookHttpMethod],
        parameters: [FacebookNamedValue],
        callback: GMFunction
    ) {
        let requestId = newRequestId()

        guard requireReady(callback, requestId) else {
            return
        }

        guard AccessToken.current != nil else {
            callback.call(
                failure(
                    requestId,
                    "Facebook user is not logged in."
                )
            )
            return
        }

        guard let methodValue = method.first else {
            callback.call(
                failure(requestId, "No HTTP method specified.")
            )
            return
        }

        let httpMethod: HTTPMethod
        switch methodValue {
        case .Get:
            httpMethod = .get
        case .Delete:
            httpMethod = .delete
        case .Post:
            httpMethod = .post
        }

        let request = GraphRequest(
            graphPath: graph_path,
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

        guard let url = URL(string: link_url) else {
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
        event: [FacebookAppEvent],
        value: Double,
        parameters: [FacebookEventParameterValue]
    ) -> Bool {
        guard let eventValue = event.first else {
            return false
        }

        guard let eventName = standardEventName(eventValue) else {
            return false
        }

        AppEvents.shared.logEvent(
            eventName,
            valueToSum: value,
            parameters: eventValues(parameters)
        )

        return true
    }

    public override func fb_send_custom_event(
        event_name: String,
        value: Double,
        parameters: [FacebookNamedValue]
    ) -> Bool {
        guard !event_name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            return false
        }

        AppEvents.shared.logEvent(
            AppEvents.Name(rawValue: event_name),
            valueToSum: value,
            parameters: namedEventValues(parameters)
        )

        return true
    }

    private func namedValues(
        _ values: [FacebookNamedValue]
    ) -> [String: Any] {
        var output: [String: Any] = [:]

        for value in values {
            guard !value.name.isEmpty else {
                continue
            }

            output[value.name] =
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
            guard !value.name.isEmpty else {
                continue
            }

            output[AppEvents.ParameterName(rawValue: value.name)] =
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
        }
    }

    private func standardParameterName(
        _ key: Int32
    ) -> AppEvents.ParameterName? {
        switch key {
        case 1003:
            return .contentID
        case 1004:
            return .contentType
        case 1005:
            return .currency
        case 1006:
            return .description
        case 1007:
            return .level
        case 1008:
            return .maxRatingValue
        case 1009:
            return .numItems
        case 1010:
            return .paymentInfoAvailable
        case 1011:
            return .registrationMethod
        case 1012:
            return .searchString
        case 1013:
            return .success
        default:
            return nil
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
        _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions:
                launchOptions as? [
                    UIApplication.LaunchOptionsKey: Any
                ]
        )

        Profile.enableUpdatesOnAccessTokenChange(true)
    }

    @objc public func onResume() {
        AppEvents.shared.activateApp()
    }

    @objc public func onOpenURL(
        url: NSURL,
        sourceApplication: String,
        annotation: Any
    ) -> Bool {
        return ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url as URL,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
}
