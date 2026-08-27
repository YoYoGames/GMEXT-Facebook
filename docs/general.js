/**
 * @struct FacebookResult
 * @desc The uniform outcome record delivered as the **first** argument of every asynchronous callback
 * in this extension. Check `success` before trusting anything else in the callback - the optional
 * payload argument that follows it is only meaningful on success.
 *
 * `error_message` and `sdk_error_code` are both absent on success, and `error_message` is also absent
 * when the user simply cancelled (`status` is ${constant.FacebookOperationStatus}.Cancelled).
 * `sdk_error_code` carries Meta's own numeric error code verbatim, and only appears when the failure
 * came back from Meta's SDK - a call this extension rejected before ever reaching Meta reports itself
 * through the synchronous ${constant.FacebookError} return value instead, and never fires a callback
 * at all.
 * @member {Bool} success Whether the operation succeeded.
 * @member {Enum.FacebookOperationStatus} status The named outcome - succeeded, cancelled by the user,
 * or failed.
 * @member {String} [error_message] Meta's own error message. Only present on failure, and not on a
 * user cancellation.
 * @member {Real} [sdk_error_code] Meta's raw error code. Only present when the failure came from
 * Meta's SDK (for example a Graph API error number).
 * @struct_end
 */

/**
 * @struct FacebookNamedValue
 * @desc A single name/value pair, used wherever Meta's SDK takes an arbitrary string-keyed parameter:
 * ${function.fb_graph_request} query parameters, and the custom parameters of
 * ${function.fb_send_custom_event} and ${function.fb_send_purchase}.
 *
 * The struct carries both a string and a number slot, and `use_number` selects which one is actually
 * sent - the unused slot is ignored. This is a generated extension record, so it is created with an
 * empty constructor and every field is assigned afterwards.
 * @member {String} name The parameter name. A pair with an empty name is skipped.
 * @member {String} string_value The value to send when `use_number` is `false`.
 * @member {Real} number_value The value to send when `use_number` is `true`.
 * @member {Bool} use_number Whether to send `number_value` (`true`) or `string_value` (`false`).
 * @struct_end
 */

/**
 * @function fb_initialize
 * @desc Initializes Meta's Facebook SDK using the **App ID**, **Display Name** and **Client Token**
 * you filled into the extension's options (see ${page.extension_options}). Call this once, before any
 * other function in this extension - everything else fails with
 * ${constant.FacebookError}.NotInitialized until it has completed successfully.
 *
 * Calling it again once the SDK is already up is safe: the callback fires immediately with a success
 * result and nothing is re-initialized.
 * @param {Function} callback The function to call once initialization completes or fails.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the request was accepted, or
 * ${constant.FacebookError}.ActivityNull if the game's activity is not available yet. The callback
 * does **not** fire when a value other than Ok is returned.
 * @event callback
 * @desc Fires once, when the SDK finishes starting up (or fails to). This callback takes a single
 * argument - there is no payload.
 * @member {Struct.FacebookResult} result The initialization outcome. A failure here usually means the
 * App ID or Client Token option was left empty.
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
 * @desc Returns whether ${function.fb_initialize} has completed successfully and the SDK is ready to
 * take calls. This is about the SDK, not about the user - see ${function.fb_is_logged_in} for that.
 * @returns {Bool} `true` once the SDK is initialized, `false` otherwise.
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
 * @desc Returns the current login status as a ${constant.FacebookLoginStatus} value. Unlike
 * ${function.fb_is_logged_in}, this also tells you whether a login is currently *in flight*, which is
 * what you want if you are guarding a login button against a double tap.
 *
 * The status is reconciled against the live access token every time you read it: a session that has
 * expired or been revoked outside the game reports Idle rather than staying Authorised.
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
 * @desc Returns whether there is a live, unexpired Facebook access token for the current user. This
 * is the check to make before ${function.fb_graph_request} or ${function.fb_refresh_access_token}.
 * @returns {Bool} `true` if a user is logged in with an active token, `false` otherwise.
 * @function_end
 */

/**
 * @function fb_user_id
 * @desc Returns the Facebook user ID of the currently logged-in user. This is an **app-scoped** ID -
 * the same person has a different ID in each app, so it is only meaningful to your own app and your
 * own backend.
 * @returns {String} The app-scoped user ID, or an empty string if no user is logged in.
 * @function_end
 */

/**
 * @function fb_access_token
 * @desc Returns the raw access token string for the current session, for cases where your own backend
 * needs to verify the user against Meta's servers.
 * [[Warning: An access token is a credential. Never log it, never display it, and only ever send it
 * over HTTPS to a server you control.]]
 * @returns {String} The access token, or an empty string if no user is logged in.
 * @function_end
 */

/**
 * @function fb_logout
 * @desc Clears the current access token and logs the user out of Facebook within this app. It does
 * not sign them out of the Facebook app or of their browser.
 *
 * A login that is still in flight is deliberately left alone - its callback still fires normally, and
 * ${function.fb_status} keeps reporting Processing until it does. Use ${function.fb_reset_pending} if
 * you need to abandon it instead.
 * @function_end
 */

/**
 * @function fb_reset_pending
 * @desc Abandons any login or share request that is still waiting on the user, immediately firing
 * each held callback with a ${struct.FacebookResult} whose `status` is
 * ${constant.FacebookOperationStatus}.Cancelled and whose payload argument is `undefined`.
 *
 * This is a recovery hatch, not part of the normal flow. It exists for the case where the user
 * dismissed Meta's login or share screen in a way the SDK never reported back, leaving
 * ${function.fb_login} or ${function.fb_dialog} rejecting every later call with LoginInProgress or
 * ShareInProgress.
 * [[Note: This does not log the user out and does not close anything on screen - it only releases the
 * callbacks this extension is holding.]]
 * @function_end
 */

/**
 * @const FacebookLoginStatus
 * @desc The state of the current login session, as reported by ${function.fb_status}.
 * Extension-owned - Meta's SDK exposes the access token rather than a status value.
 * @member Idle No login is in progress and no user is logged in.
 * @member Processing A ${function.fb_login} request is currently waiting on the user.
 * @member Failed The last login or token refresh attempt failed.
 * @member Authorised A user is logged in with a live access token.
 * @const_end
 */

/**
 * @const FacebookOperationStatus
 * @desc The named outcome carried by ${struct.FacebookResult}.status. Extension-owned - Meta models
 * these three outcomes as three separate callback methods rather than as a value.
 * @member Success The operation completed successfully.
 * @member Cancelled The user dismissed the login or share screen. Not an error, and
 * ${struct.FacebookResult}.error_message is absent in this case.
 * @member Error The operation failed. See ${struct.FacebookResult}.error_message.
 * @const_end
 */

/**
 * @const FacebookError
 * @desc Extension-defined codes returned **synchronously** by every function that can reject a call
 * before it reaches Meta's SDK. These are not Meta error codes - a failure that came back from Meta
 * arrives asynchronously in ${struct.FacebookResult} instead.
 *
 * When one of these is returned (anything other than Ok), the callback you passed is **never
 * called**, so this return value is the only place a pre-flight failure is reported.
 * @member Ok The call was accepted.
 * @member NotInitialized ${function.fb_initialize} has not completed successfully yet.
 * @member ActivityNull The game's activity/view is not available yet (too early in the app lifecycle).
 * @member NotLoggedIn The call needs a live access token and there is none - log in first with
 * ${function.fb_login}.
 * @member InvalidArgument An argument was empty or malformed (an empty Graph path, a link URL with no
 * scheme).
 * @member LoginInProgress A ${function.fb_login} request is already waiting on the user. Wait for its
 * callback, or abandon it with ${function.fb_reset_pending}.
 * @member ShareInProgress A ${function.fb_dialog} request is already waiting on the user. Wait for
 * its callback, or abandon it with ${function.fb_reset_pending}.
 * @const_end
 */

/**
 * @const macros
 * @const_end
 */

/**
 * @module general
 * @title General
 * @desc Initialization, session state, and the shared result types every other module's callbacks
 * use.
 *
 * @section_func
 * @desc Initialization and session state.
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
