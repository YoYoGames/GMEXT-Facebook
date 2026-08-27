/**
 * @struct FacebookLoginInfo
 * @desc The session payload delivered as the second argument of the ${function.fb_login} and
 * ${function.fb_refresh_access_token} callbacks. Only present on success - on a failure or a
 * cancellation the argument is `undefined`.
 * @member {String} access_token The access token for the new session. Treat it as a credential.
 * @member {String} user_id The app-scoped Facebook user ID.
 * @member {Array[String]} permissions The permissions the user actually granted.
 * @member {Array[String]} declined_permissions The permissions the user was asked for and refused.
 * Asking again for a declined permission is only worth doing once you have explained why you need it.
 * @struct_end
 */

/**
 * @function fb_login
 * @desc Starts Meta's login flow, asking the user for the permissions you list. If the Facebook app
 * is installed the flow happens there, otherwise it falls back to a Custom Tab / web view.
 *
 * Only one login can be in flight at a time - a second call while the first is still waiting on the
 * user returns ${constant.FacebookError}.LoginInProgress. Passing an empty array asks for
 * `"public_profile"` only.
 * [[Note: Anything beyond `"public_profile"`, `"email"` and `"user_friends"` has to be approved by
 * Meta through App Review before it works for anyone other than the app's own testers.]]
 * @param {Array[String]} permissions The permissions to request, e.g. `["public_profile", "email"]`.
 * @param {Function} callback The function to call once the login completes, fails or is cancelled.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the login was started, or
 * NotInitialized / ActivityNull / LoginInProgress if it was rejected up front. The callback does
 * **not** fire when a value other than Ok is returned.
 * @event callback
 * @desc Fires once, when the user finishes with Meta's login screen.
 * @member {Struct.FacebookResult} result The login outcome. A user who backed out of the login screen
 * reports `status` as ${constant.FacebookOperationStatus}.Cancelled rather than as an error.
 * @member {Struct.FacebookLoginInfo} [login_info] The new session. Only present on success.
 * @event_end
 * @example
 * ```gml
 * var _error = fb_login(["public_profile"], function(_result, _login_info)
 * {
 *     if (_result.success)
 *     {
 *         show_debug_message("Facebook user: " + _login_info.user_id);
 *         show_debug_message("Permissions: " + json_stringify(_login_info.permissions));
 *     }
 *     else if (_result.status == FacebookOperationStatus.Cancelled)
 *     {
 *         show_debug_message("Facebook login cancelled.");
 *     }
 *     else
 *     {
 *         show_debug_message("Facebook login failed: " + (_result.error_message ?? "Unknown error."));
 *     }
 * });
 *
 * if (_error != FacebookError.Ok)
 *     show_debug_message("Facebook login could not be started (error " + string(_error) + ").");
 * ```
 * @function_end
 */

/**
 * @function fb_refresh_access_token
 * @desc Asks Meta to refresh the current access token, returning an up-to-date
 * ${struct.FacebookLoginInfo} - including the permission lists, which is the point of calling it: a
 * user can revoke a permission from Facebook's own settings at any time, and only a refresh will tell
 * you.
 *
 * There is no need to call this on a timer. Meta's SDK extends a healthy token on its own; this is
 * for the cases where you want the refreshed permission lists, or want to confirm the session is
 * still valid after a long time in the background.
 * @param {Function} callback The function to call once the refresh completes or fails.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the refresh was started,
 * NotInitialized if the SDK is not up, or NotLoggedIn if there is no live token to refresh. The
 * callback does **not** fire when a value other than Ok is returned.
 * @event callback
 * @desc Fires once, when Meta answers.
 * @member {Struct.FacebookResult} result The refresh outcome.
 * @member {Struct.FacebookLoginInfo} [login_info] The refreshed session. Only present on success.
 * @event_end
 * @example
 * ```gml
 * var _error = fb_refresh_access_token(function(_result, _login_info)
 * {
 *     if (!_result.success)
 *     {
 *         show_debug_message("Facebook token refresh failed: " + (_result.error_message ?? "Unknown error."));
 *         return;
 *     }
 *
 *     show_debug_message("Permissions now granted: " + json_stringify(_login_info.permissions));
 * });
 * ```
 * @function_end
 */

/**
 * @function fb_check_permission
 * @desc Checks whether the current session already holds a given permission, without going anywhere
 * near the network. Use it before a call that needs one, so you can ask for it with
 * ${function.fb_login} rather than letting the request fail.
 *
 * The answer reflects the permissions attached to the live access token, so it is only as fresh as
 * that token - call ${function.fb_refresh_access_token} first if the user may have revoked something
 * from Facebook's own settings while your game was running.
 * @param {String} permission The permission name to check, e.g. `"email"`.
 * @returns {Bool} `true` if a live token holds that permission, `false` otherwise (including when no
 * user is logged in).
 * @example
 * ```gml
 * if (!fb_check_permission("email"))
 * {
 *     fb_login(["email"], function(_result, _login_info)
 *     {
 *         // Handle the new session here.
 *     });
 * }
 * ```
 * @function_end
 */

/**
 * @module login
 * @title Login and Permissions
 * @desc Signing the user in, keeping the session fresh, and checking what the session is allowed to
 * do.
 *
 * @section_func
 * @desc Login and permission functions.
 * @ref fb_login
 * @ref fb_refresh_access_token
 * @ref fb_check_permission
 * @section_end
 *
 * @section_struct
 * @desc Login data types.
 * @ref FacebookLoginInfo
 * @section_end
 *
 * @module_end
 */
