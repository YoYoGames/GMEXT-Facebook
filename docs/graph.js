/**
 * @function fb_graph_request
 * @desc This function sends a request to Meta's
 * [Graph API](https://developers.facebook.com/docs/graph-api) using the current access token, and
 * hands the raw response body back to you as a string. It is the general escape hatch of the
 * extension, in that anything Meta exposes over the Graph API and this extension does not wrap
 * explicitly can still be reached through here.
 *
 * The response is **not** parsed for you and arrives exactly as Meta sent it, so you will need to
 * run it through `json_parse` yourself. The function requires a live session (see
 * ${function.fb_login}), and the endpoint that you are calling still has to be covered by a
 * permission that the session actually holds.
 * @param {String} graph_path The Graph API path, without a leading slash, for example `"me"` or
 * `"me/friends"`.
 * @param {Enum.FacebookHttpMethod} method The HTTP method to use.
 * @param {Array[Struct.FacebookNamedValue]} parameters The query parameters to send. Pass an empty
 * array for none.
 * @param {Function} callback The function to call once the request completes or fails.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the request was sent, NotInitialized
 * if the SDK is not up, NotLoggedIn if there is no live token, or InvalidArgument if `graph_path` is
 * empty. Note that the callback is **not** called when a value other than Ok is returned.
 * @event callback
 * @desc Called once, when Meta answers.
 * @member {Struct.FacebookResult} result The outcome of the request. On a Graph API error,
 * ${struct.FacebookResult}.sdk_error_code will carry Meta's own numeric error code.
 * @member {String} [response_text] The raw response body. This is only present on success.
 * @event_end
 * @example
 * ```gml
 * var _parameter = new FacebookNamedValue();
 * _parameter.name = "fields";
 * _parameter.string_value = "id,name,picture";
 * _parameter.number_value = 0;
 * _parameter.use_number = false;
 *
 * var _error = fb_graph_request("me", FacebookHttpMethod.Get, [_parameter],
 *     function(_result, _response_text)
 *     {
 *         if (_result.success)
 *         {
 *             var _profile = json_parse(_response_text);
 *             show_debug_message("Facebook name: " + _profile.name);
 *         }
 *         else
 *         {
 *             show_debug_message("Graph request failed: " + (_result.error_message ?? "Unknown error."));
 *         }
 *     });
 *
 * if (_error != FacebookError.Ok)
 *     show_debug_message("Graph request could not be started (error " + string(_error) + ").");
 * ```
 * @function_end
 */

/**
 * @function fb_dialog
 * @desc This function opens Meta's share dialog on a link, letting the user post it to their feed
 * with whatever comment they choose. If the Facebook app is installed then the dialog opens there,
 * and if it is not then it falls back to a web dialog.
 *
 * The user does **not** need to be logged in through ${function.fb_login} for this, as Meta's share
 * dialog handles its own account. What the login state does change is the payload, because Meta only
 * returns a post ID when your app holds publish permissions, which makes `post_id` being `undefined`
 * on success the normal case rather than a failure.
 *
 * Only one share can be in flight at a time, so a second call made while the first one is still open
 * will return ${constant.FacebookError}.ShareInProgress.
 * [[Note: Meta does not allow an app to pre-fill the message, the title or the image of a share.
 * Only the link is yours to set, and everything the post says comes either from the user or from the
 * Open Graph tags on the page that you linked to.]]
 * @param {String} link_url The URL to share. It must include a scheme, for example
 * `"https://example.com"`.
 * @param {Function} callback The function to call once the dialog closes.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok if the dialog was opened, or
 * NotInitialized / ActivityNull / InvalidArgument / ShareInProgress if it was rejected up front.
 * Note that the callback is **not** called when a value other than Ok is returned.
 * @event callback
 * @desc Called once, when the user finishes with the share dialog or dismisses it.
 * @member {Struct.FacebookResult} result The outcome of the share. A user that dismissed the dialog
 * will report `status` as ${constant.FacebookOperationStatus}.Cancelled rather than as an error.
 * @member {String} [post_id] The ID of the created post. This is only present when the app holds
 * publish permissions, so a successful share with no post ID is perfectly normal.
 * @event_end
 * @example
 * ```gml
 * var _error = fb_dialog("https://gamemaker.io", function(_result, _post_id)
 * {
 *     if (_result.success)
 *     {
 *         if (!is_undefined(_post_id))
 *             show_debug_message("Facebook post ID: " + _post_id);
 *         else
 *             show_debug_message("Facebook share completed.");
 *     }
 *     else if (_result.status == FacebookOperationStatus.Cancelled)
 *     {
 *         show_debug_message("Facebook share cancelled.");
 *     }
 * });
 *
 * if (_error == FacebookError.ShareInProgress)
 *     show_debug_message("A Facebook share dialog is already open.");
 * ```
 * @function_end
 */

/**
 * @const FacebookHttpMethod
 * @desc The HTTP method used by ${function.fb_graph_request}. These constants mirror the three
 * methods that Meta's Graph API accepts.
 * @member Get Read data.
 * @member Post Create or update data.
 * @member Delete Remove data.
 * @const_end
 */

/**
 * @module graph
 * @title Graph API and Sharing
 * @desc Reaching Meta's Graph API directly, and opening the share dialog on a link.
 *
 * @section_func
 * @desc Graph API and sharing functions.
 * @ref fb_graph_request
 * @ref fb_dialog
 * @section_end
 *
 * @section_const
 * @desc Graph API constants.
 * @ref FacebookHttpMethod
 * @section_end
 *
 * @module_end
 */
