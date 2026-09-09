/**
 * @struct FacebookResult
 * @desc The uniform outcome record that is given as the **first** argument of every asynchronous
 * callback in this extension. You should check `success` before trusting anything else in the
 * callback, as the optional payload argument that follows it is only meaningful on success.
 *
 * Both `error_message` and `sdk_error_code` are absent on success, and `error_message` is also
 * absent when the user simply cancelled (in which case `status` is
 * ${constant.FacebookOperationStatus}.Cancelled). The `sdk_error_code` member carries Meta's own
 * numeric error code exactly as Meta gave it, and only appears when the failure came back from
 * Meta's SDK. A call that this extension rejected before it ever reached Meta reports itself through
 * the synchronous ${constant.FacebookError} return value instead, and no callback is called at all.
 * @member {Bool} success Whether the operation succeeded.
 * @member {Enum.FacebookOperationStatus} status The named outcome, which is either succeeded,
 * cancelled by the user, or failed.
 * @member {String} [error_message] Meta's own error message. This is only present on failure, and
 * not when the user cancelled.
 * @member {Real} [sdk_error_code] Meta's raw error code. This is only present when the failure came
 * from Meta's SDK, for example a Graph API error number.
 * @struct_end
 */

/**
 * @struct FacebookNamedValue
 * @desc A single name/value pair, used wherever Meta's SDK takes an arbitrary string-keyed
 * parameter, which means the query parameters of ${function.fb_graph_request} and the custom
 * parameters of ${function.fb_send_custom_event} and ${function.fb_send_purchase}.
 *
 * The struct has both a string slot and a number slot, and `use_number` decides which of the two is
 * actually sent, with the unused slot being ignored. This is a generated extension record, so it is
 * created with an empty constructor and every field is assigned afterwards.
 * @member {String} name The parameter name. A pair with an empty name is skipped.
 * @member {String} string_value The value to send when `use_number` is `false`.
 * @member {Real} number_value The value to send when `use_number` is `true`.
 * @member {Bool} use_number Whether to send `number_value` (`true`) or `string_value` (`false`).
 * @struct_end
 */

/**
 * @function fb_initialize
 * @desc This function initialises Meta's Facebook SDK using the **App ID**, **Display Name** and
 * **Client Token** that you filled into the extension's options (see ${page.extension_options}). It
 * should be called once, before any other function in this extension, as everything else will fail
 * with ${constant.FacebookError}.NotInitialized until it has completed successfully.
 *
 * It is safe to call it again once the SDK is already up, in which case the callback is called
 * immediately with a success result and nothing is initialised a second time.
 * @param {Function} callback The function to call once initialisation completes or fails.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the request was accepted, or
 * ${constant.FacebookError}.ActivityNull if the game's activity is not available yet. Note that the
 * callback is **not** called when a value other than Ok is returned.
 * @event callback
 * @desc Called once, when the SDK finishes starting up (or fails to). This callback takes a single
 * argument, as there is no payload.
 * @member {Struct.FacebookResult} result The outcome of the initialisation. A failure here usually
 * means that the App ID or the Client Token option was left empty.
 * @event_end
 * @example
 * ```gml
 * var _error = fb_initialize(function(_result)
 * {
 *     if (_result.success)
 *         show_debug_message("Facebook SDK initialized.");
 *     else
 *         show_debug_message("Facebook initialization failed: " + (_result.error_message ?? "Unknown error."));
 * });
 *
 * if (_error != FacebookError.Ok)
 *     show_debug_message("Facebook initialization rejected: " + string(_error));
 * ```
 * @function_end
 */

/**
 * @function fb_ready
 * @desc This function returns whether ${function.fb_initialize} has completed successfully and the
 * SDK is ready to take calls. Note that this tells you about the SDK and not about the user, for
 * which you should use ${function.fb_is_logged_in} instead.
 * @returns {Bool} `true` once the SDK is initialised, `false` otherwise.
 * @example
 * ```gml
 * if (!fb_ready())
 * {
 *     show_debug_message("Facebook SDK is not initialized yet.");
 *     exit;
 * }
 * ```
 * @function_end
 */

/**
 * @function fb_status
 * @desc This function returns the current login status as a ${constant.FacebookLoginStatus} value.
 * Unlike ${function.fb_is_logged_in}, it also tells you whether a login is currently *in flight*,
 * which is what you want when you are guarding a login button against a double tap.
 *
 * The status is reconciled against the live access token every time you read it, so a session that
 * has expired or been revoked outside the game will report Idle rather than remaining Authorised.
 * @returns {Enum.FacebookLoginStatus} The current login status.
 * @example
 * ```gml
 * if (fb_status() == FacebookLoginStatus.Processing)
 * {
 *     show_debug_message("A Facebook login request is already running.");
 *     exit;
 * }
 * ```
 * @function_end
 */

/**
 * @function fb_is_logged_in
 * @desc This function returns whether there is a live, unexpired Facebook access token for the
 * current user. This is the check that you should make before calling ${function.fb_graph_request}
 * or ${function.fb_refresh_access_token}.
 * @returns {Bool} `true` if a user is logged in with an active token, `false` otherwise.
 * @function_end
 */

/**
 * @function fb_user_id
 * @desc This function returns the Facebook user ID of the user that is currently logged in. Note
 * that this is an **app-scoped** ID, meaning that the same person has a different ID in every app,
 * so it is only meaningful to your own app and your own backend.
 * @returns {String} The app-scoped user ID, or an empty string if no user is logged in.
 * @function_end
 */

/**
 * @function fb_access_token
 * @desc This function returns the raw access token string for the current session, for those cases
 * where your own backend needs to verify the user against Meta's servers.
 * [[Warning: An access token is a credential. You should never log it or display it, and it should
 * only ever be sent over HTTPS to a server that you control.]]
 * @returns {String} The access token, or an empty string if no user is logged in.
 * @function_end
 */

/**
 * @function fb_logout
 * @desc This function clears the current access token and logs the user out of Facebook within this
 * app. It does not sign them out of the Facebook app itself, nor out of their browser.
 *
 * A login that is still in flight is deliberately left alone, so its callback is still called as
 * normal and ${function.fb_status} will keep reporting Processing until it is. If you need to
 * abandon it instead then you should use ${function.fb_reset_pending}.
 * @function_end
 */

/**
 * @function fb_reset_pending
 * @desc This function abandons any login or share request that is still waiting on the user,
 * immediately calling each held callback with a ${struct.FacebookResult} whose `status` is
 * ${constant.FacebookOperationStatus}.Cancelled and whose payload argument is `undefined`.
 *
 * This is a recovery hatch rather than a part of the normal flow. It exists for the case where the
 * user dismissed Meta's login or share screen in a way that the SDK never reported back, leaving
 * ${function.fb_login} or ${function.fb_dialog} rejecting every later call with LoginInProgress or
 * ShareInProgress.
 * [[Note: This does not log the user out and it does not close anything on screen, as all it does is
 * release the callbacks that this extension is holding.]]
 * @function_end
 */

/**
 * @const FacebookLoginStatus
 * @desc The state of the current login session, as reported by ${function.fb_status}. These
 * constants are owned by the extension, as Meta's SDK exposes the access token rather than a status
 * value.
 * @member Idle No login is in progress and no user is logged in.
 * @member Processing A ${function.fb_login} request is currently waiting on the user.
 * @member Failed The last login or token refresh attempt failed.
 * @member Authorised A user is logged in with a live access token.
 * @const_end
 */

/**
 * @const FacebookOperationStatus
 * @desc The named outcome carried by ${struct.FacebookResult}.status. These constants are owned by
 * the extension, as Meta models these three outcomes as three separate callback methods rather than
 * as a value.
 * @member Success The operation completed successfully.
 * @member Cancelled The user dismissed the login or share screen. This is not an error, and
 * ${struct.FacebookResult}.error_message is absent in this case.
 * @member Error The operation failed. See ${struct.FacebookResult}.error_message.
 * @const_end
 */

/**
 * @const FacebookError
 * @desc The extension-defined codes that are returned **synchronously** by every function that can
 * reject a call before it reaches Meta's SDK. These are not Meta error codes, as a failure that came
 * back from Meta arrives asynchronously in a ${struct.FacebookResult} instead.
 *
 * When one of these is returned (that is, anything other than Ok), the callback that you passed in
 * is **never called**, which makes this return value the only place where such a pre-flight failure
 * is reported.
 * @member Ok The call was accepted.
 * @member NotInitialized ${function.fb_initialize} has not completed successfully yet.
 * @member ActivityNull The game's activity/view is not available yet, which means it is too early in
 * the app lifecycle.
 * @member NotLoggedIn The call needs a live access token and there is none, so you should log in
 * first with ${function.fb_login}.
 * @member InvalidArgument An argument was empty or malformed, for example an empty Graph path, or a
 * link URL with no scheme.
 * @member LoginInProgress A ${function.fb_login} request is already waiting on the user. You should
 * wait for its callback, or abandon it with ${function.fb_reset_pending}.
 * @member ShareInProgress A ${function.fb_dialog} request is already waiting on the user. You should
 * wait for its callback, or abandon it with ${function.fb_reset_pending}.
 * @const_end
 */

/**
 * @const macros
 * @const_end
 */

/**
 * @module general
 * @title General
 * @desc Initialisation, session state, and the shared result types that the callbacks of every other
 * module use.
 *
 * @section_func
 * @desc Initialisation and session state.
 * @ref fb_initialize
 * @ref fb_ready
 * @ref fb_status
 * @ref fb_is_logged_in
 * @ref fb_user_id
 * @ref fb_access_token
 * @ref fb_logout
 * @ref fb_reset_pending
 * @section_end
 *
 * @section_struct
 * @desc Shared data types used across every module.
 * @ref FacebookResult
 * @ref FacebookNamedValue
 * @section_end
 *
 * @section_const
 * @desc Session state and the synchronous error codes.
 * @ref FacebookLoginStatus
 * @ref FacebookOperationStatus
 * @ref FacebookError
 * @section_end
 *
 * @module_end
 */
