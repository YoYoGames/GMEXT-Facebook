// Functions

/**
 * @function fb_login
 * @desc This function starts a login, requesting the given list of permissions.
 * 
 * For every requested permission, a key is added to ${var.async_load} with the value being either `"granted"` or `"declined"`.
 * 
 * See: [Facebook Login](https://developers.facebook.com/docs/facebook-login)
 * 
 * [[Note: This function is only supported on Android, iOS and HTML5.]]
 * 
 * [[Note: If your app asks for more than the default public profile fields and email, Facebook must review it before you release it. See [App Review](https://developers.facebook.com/docs/resp-plat-initiatives/individual-processes/app-review).]]
 * 
 * @param {ds_list} permissions The permissions to request
 * 
 * @returns {real}
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"facebook_login_result"`
 * @member {real} requestId The async request ID
 * @member {string} status The status of the request, as a string (one of `"success"`, `"cancelled"` or `"error"`)
 * @member {string} [exception] The exception message, in case of an error
 * @member {string} [permission_status] A key-value pair added to ${var.async_load} with the key the permission name and the value either `"granted"` or `"declined"`
 * @event_end
 * 
 * @example
 * ```gml
 * permissions = ds_list_create();
 * ds_list_add(permissions, "public_profile");
 * fb_login(real(permissions));
 * ```
 * The code above logs in using ${function.fb_login}, requesting the default `"public_profile"` permission.
 * 
 * If the login succeeds, a ${event.social} will be triggered: 
 * ```gml
 * if(async_load[?"type"] == "facebook_login_result")
 * {
 *     var _status = async_load[?"status"];
 *     if(_status == "success")
 *     {
 *         show_debug_message("Facebook Token: " + fb_accesstoken());
 *         
 *         show_debug_message("Permissions:");
 *         for(var i = 0;i < ds_list_size(permissions);i++)
 *         {
 *             var _permission = permissions[|i];
 *             show_debug_message($"{_permission}: {async_load[? _permission]}");
 *         };
 *         
 *         ds_list_destroy(permissions);
 *     }
 *     else if(_status == "cancelled")
 *     {
 *         
 *     }
 *     else if(_status == "error")
 *     {
 *         var _exception = ds_map_find_value(async_load, "exception");
 *         show_message_async(_exception);
 *     }
 * }
 * ```
 * If the status equals `"success"`, the access token as well as the permissions are shown in a debug message.
 * @func_end
 */

/**
 * @function fb_login_oauth
 * @desc This function starts a login using OAuth.
 * 
 * The function sends a request to the Facebook API's OAuth endpoint.
 * 
 * OAuth authentication is supported on all platforms and can be used as an alternative login method on platforms that use the SDK (using ${function.fb_login}).
 * 
 * @param {string} state A unique state value that's sent with the login request
 * 
 * @example
 * See the OAuth section of the ${page.guide_login} page for a detailed code example.
 * @function_end
 */

/**
 * @function fb_logout
 * @desc This function logs out of Facebook.
 * @func_end
 */

/**
 * @function fb_status
 * @desc This function returns the current login status.
 * 
 * This status can be one of the following values: 
 * 
 * * `"IDLE"`
 * * `"PROCESSING"`
 * * `"FAILED"`
 * * `"AUTHORISED"`
 * 
 * @returns {string}
 * 
 * @example
 * ```gml
 * var _status = fb_status();
 * show_debug_message(_status);
 * ```
 * The above code requests the login status and outputs it in a debug message.
 * @func_end
 */

/**
 * @function fb_graph_request
 * @desc This function sends a request to the provided endpoint with the parameters defined as a set of key-value pairs.
 * 
 * See the [User reference](https://developers.facebook.com/docs/graph-api/reference/user#posts) for the possible key-value pairs.
 * 
 * See: [Graph API](https://developers.facebook.com/docs/graph-api/)
 * 
 * @param {string} graph_path the path to the endpoint in the graph to access
 * @param {string} http_method the HTTP method to use. Can be one of the following: `"GET"`, `"POST"`, `"DELETE"`
 * @param {ds_list} params The parameters to use, provided as key-value pairs
 * 
 * @returns {real}
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"fb_graph_request"`
 * @member {real} requestId The ID of the async request
 * @member {string} status The status of the request, as a string (one of `"success"`, `"cancelled"` or `"error"`)
 * @member {string} [exception] The exception message, in case of an error
 * @member {string} [response_text] The response text, if the request was successful
 * @event_end
 * 
 * @example
 * ```gml
 * fb_graph_request("me/friends", "GET", -1);
 * ```
 * The code above gets the current user's friends.
 * @func_end
 */

/**
 * @function fb_dialog
 * @desc This function brings up a share dialog to share the given link on the user's Timeline.
 * 
 * See: [Sharing](https://developers.facebook.com/docs/sharing)
 * 
 * @param {string} link The link to share
 * 
 * @returns {real}
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"fb_dialog"`
 * @member {real} requestId The async request ID
 * @member {string} status The status of the request, as a string (one of `"success"`, `"cancelled"` or `"error"`)
 * @member {string} [exception] The exception message, in case of an error
 * @member {string} [postId] The ID of the post
 * @event_end
 * 
 * @example
 * ```gml
 * fb_dialog("www.gamemaker.io");
 * ```
 * The code above brings up a share dialog to share the given URL.
 * @func_end
 */

/**
 * @function fb_check_permission
 * @desc This functions checks if the given permission is present in the current [access token](https://developers.facebook.com/docs/facebook-login/guides/access-tokens#usertokens).
 * 
 * @param {string} permission The name of the permission to check
 * 
 * @returns {boolean}
 * 
 * @example
 * ```gml
 * if(!fb_check_permission("user_likes"))
 * {
 *     show_debug_message("Permission user_likes not granted.");
 * }
 * ```
 * @func_end
 */

/**
 * @function fb_accesstoken
 * @desc This function returns the current [access token](https://developers.facebook.com/docs/facebook-login/guides/access-tokens#usertokens).
 * 
 * If no access token exists an empty string `""` is returned.
 * 
 * @returns {string}
 * 
 * @func_end
 */

/**
 * @function fb_request_read_permissions
 * @desc This function reauthenticates the currently logged in user with read permissions.
 * 
 * [[Note: If your app asks for more than the default public profile fields and email, Facebook must review it before you release it. See [App Review](https://developers.facebook.com/docs/resp-plat-initiatives/individual-processes/app-review).]]
 * 
 * @param {ds_list} permissions The permissions to request
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"facebook_login_result"`
 * @member {real} requestId The async request ID
 * @member {string} status The status of the request, as a string (one of `"success"`, `"cancelled"` or `"error"`)
 * @member {string} [exception] The exception message, in case of an error
 * @event_end
 * 
 * @example
 * ```gml
 * var _permissions = ds_list_create();
 * ds_list_add(_permissions,
 *     "user_age_range",
 *     "user_birthday",
 *     "user_location"
 * );
 * fb_request_read_permissions(real(_permissions));
 * ds_list_destroy(_permissions);
 * ```
 * The code above creates a ${type.ds_list} and adds a few permissions (scopes) to it. It then requests read permissions on this list of items. Finally, the list is destroyed.
 * @func_end
 */

/**
 * @function fb_request_publish_permissions
 * @desc This function reauthenticates the currently logged in user with publish permissions.
 * 
 * [[Note: If your app asks for more than the default public profile fields and email, Facebook must review it before you release it. See [App Review](https://developers.facebook.com/docs/resp-plat-initiatives/individual-processes/app-review).]]
 * 
 * @param {ds_list} permissions The permissions to request
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"facebook_login_result"`
 * @member {real} requestId The async request ID
 * @member {string} status The status of the request, as a string (one of `"success"`, `"cancelled"` or `"error"`)
 * @member {string} [exception] The exception message, in case of an error
 * @event_end
 * 
 * @example
 * ```gml
 * var _permissions = ds_list_create();
 * ds_list_add(_permissions, "publish_actions");
 * fb_request_publish_permissions(real(_permissions));
 * ds_list_destroy(_permissions);
 * ```
 * The code above creates a ${type.ds_list} and adds a permission (scope) to it. It then requests publish permissions on this list of items. Finally, the list is destroyed.
 * @func_end
 */

/**
 * @function fb_user_id
 * @desc This function returns the user ID of the user that's currently logged in.
 * 
 * The user ID is a string of numbers that doesn't personally identify you but does connect to your Facebook profile and specific chats on Messenger.
 * 
 * If no valid user ID was found, an empty string `""` is returned.
 * 
 * @returns {string}
 * 
 * @func_end
 */

/**
 * @function fb_ready
 * @desc This function returns if the extension has been initialised. See ${function.fb_init}.
 * 
 * @returns {bool}
 * @example
 * ```gml
 * if (!fb_ready()) { exit; }
 * 
 * // Call fb_* functions here
 * // ...
 * ```
 * The code above checks if the Facebook extension has been initialised and exits the current block of code if not.
 * If code execution reaches the next line, calls to the `fb_*` functions can be made here.
 * @func_end
 */

/**
 * @function fb_init
 * @desc This function initialises the Facebook extension.
 * 
 * [[Note: This function must be called before using any other extension functions. Use ${function.fb_ready} to check if the extension was initialised successfully.]]
 * 
 * @example
 * ```gml
 * fb_init();
 * ```
 * @func_end
 */

/**
 * @function fb_refresh_accesstoken
 * @desc This function refreshes the current [access token](https://developers.facebook.com/docs/facebook-login/guides/access-tokens#usertokens).
 * 
 * @returns {real}
 * 
 * @event social
 * @desc 
 * @member {string} type The string `"fb_refresh_accesstoken"`
 * @member {real} requestId The async request ID
 * @member {string} status The status of the request, either `"success"` or `"error"`
 * @member {string} [exception] The exception message in case of an error
 * @event_end
 * 
 * @example
 * ```gml
 * fb_refresh_accesstoken();
 * ```
 * @func_end
 */

/**
 * @function fb_send_event
 * @desc This function logs a custom app event.
 * 
 * The function returns whether the event was sent successfully.
 * 
 * See: [App Events](https://developers.facebook.com/docs/app-events/overview/)
 * 
 * @param {constant.FacebookExtension2_EVENT} event_name The name of the event to log
 * @param {real} [value_to_sum] The value to add to the sum for this event
 * @param {ds_list} [event_params] The event parameters (one or more of ${constant.FacebookExtension2_PARAM}) as key-value pairs
 * 
 * @example
 * ```gml
 * var _params = ds_list_create();
 * ds_list_add(_params,
 *     FacebookExtension2_PARAM_CONTENT_ID, "ContentIdTest",
 *     FacebookExtension2_PARAM_CURRENCY, "GBP",
 *     FacebookExtension2_PARAM_NUM_ITEMS, 3
 * );
 * fb_send_event(FacebookExtension2_EVENT_ADDED_TO_WISHLIST, 10, real(_params));
 * ds_list_destroy(_params);
 * ```
 * The code above first creates a ${type.ds_list} and adds the key-value pairs to be used as the parameters to it. It then logs an "Added To Wishlist" event with these parameters, adding 10 to the value to sum for this event.
 * @func_end
 */

/**
 * @function fb_send_event_string
 * @desc This function logs a custom app event.
 * 
 * See: [App Events](https://developers.facebook.com/docs/app-events/overview/)
 * 
 * @param {constant.FACEBOOK_EVENT_NAME} event_name The name of the event to log
 * @param {real} value_to_sum The value to add to the sum for this event
 * @param {ds_list} event_params A ${type.ds_list} of ${constant.FACEBOOK_EVENT_PARAM}.
 * 
 * @example 
 * ```gml
 * var _params = ds_list_create();
 * ds_list_add(_params, 
 *     FACEBOOK_EVENT_PARAM.CONTENT_ID, "ContentIdTest",
 *     FACEBOOK_EVENT_PARAM.CURRENCY, "GBP",
 *     FACEBOOK_EVENT_PARAM.NUM_ITEMS, 3);
 * 
 * fb_send_event_string(FACEBOOK_EVENT_NAME.ADDED_TO_WISHLIST, 123, real(_params));
 * 
 * ds_list_destroy(_params);
 * ```
 * The code example above logs an app event. The parameters are added to a temporary ${type.ds_list}, which is destroyed after the call to the function.
 * @function_end
 */

// Constants

/**
 * @constant FacebookExtension2_PARAM
 * @desc > **Facebook Constants**: [EVENT_PARAM_*](https://developers.facebook.com/docs/reference/android/current/class/AppEventsConstants/)
 * 
 * This set of constants represents the possible event parameter types.
 * 
 * @member FacebookExtension2_PARAM_CONTENT_ID Parameter key used to specify an ID for the specific piece of content being logged about. This could be an EAN, article identifier, etc., depending on the nature of the app.
 * @member FacebookExtension2_PARAM_CONTENT_TYPE Parameter key used to specify a generic content type/family for the logged event, e.g. "music", "photo", "video". Options to use will vary depending on the nature of the app.
 * @member FacebookExtension2_PARAM_CURRENCY Parameter key used to specify currency used with logged event. E.g. "USD", "EUR", "GBP". See ISO-4217 for specific values.
 * @member FacebookExtension2_PARAM_DESCRIPTION Parameter key used to specify a description appropriate to the event being logged. E.g., the name of the achievement unlocked in the `EVENT_NAME_ACHIEVEMENT_UNLOCKED` event.
 * @member FacebookExtension2_PARAM_LEVEL Parameter key used to specify the level achieved in an `EVENT_NAME_LEVEL_ACHIEVED` event.
 * @member FacebookExtension2_PARAM_MAX_RATING_VALUE Parameter key used to specify the maximum rating available for the `EVENT_NAME_RATE` event. E.g., "5" or "10".
 * @member FacebookExtension2_PARAM_NUM_ITEMS Parameter key used to specify how many items are being processed for an `EVENT_NAME_INITIATED_CHECKOUT` or `EVENT_NAME_PURCHASE` event.
 * @member FacebookExtension2_PARAM_PAYMENT_INFO_AVAILABLE Parameter key used to specify whether payment info is available for the `EVENT_NAME_INITIATED_CHECKOUT` event. `EVENT_PARAM_VALUE_YES` and `EVENT_PARAM_VALUE_NO` are good canonical values to use for this parameter.
 * @member FacebookExtension2_PARAM_REGISTRATION_METHOD Parameter key used to specify the method the user has used to register for the app, e.g., "Facebook", "email", "Twitter", etc.
 * @member FacebookExtension2_PARAM_SEARCH_STRING Parameter key used to specify the string provided by the user for a search operation.
 * @member FacebookExtension2_PARAM_SUCCESS Parameter key used to specify whether the activity being logged about was successful or not. `EVENT_PARAM_VALUE_YES` and `EVENT_PARAM_VALUE_NO` are good canonical values to use for this parameter.
 * @const_end
 */

/**
 * @const FacebookExtension2_EVENT
 * @desc > **Facebook Constants**: [EVENT_NAME_*](https://developers.facebook.com/docs/reference/android/current/class/AppEventsConstants/)
 * 
 * This set of constants represents the possible built-in event names.
 * 
 * @member FacebookExtension2_EVENT_ACHIEVED_LEVEL Log this event when the user has achieved a level in the app.
 * @member FacebookExtension2_EVENT_ADDED_PAYMENT_INFO Log this event when the user has entered their payment info.
 * @member FacebookExtension2_EVENT_ADDED_TO_CART Log this event when the user has added an item to their cart. The `valueToSum` passed to ${function.fb_send_event} should be the item's price.
 * @member FacebookExtension2_EVENT_ADDED_TO_WISHLIST Log this event when the user has added an item to their wishlist. The `valueToSum` passed to ${function.fb_send_event} should be the item's price.
 * @member FacebookExtension2_EVENT_COMPLETED_REGISTRATION Log this event when the user has completed registration with the app.
 * @member FacebookExtension2_EVENT_COMPLETED_TUTORIAL Log this event when the user has completed a tutorial in the app.
 * @member FacebookExtension2_EVENT_INITIATED_CHECKOUT Log this event when the user has entered the checkout process. The `valueToSum` passed to ${function.fb_send_event} should be the total price in the cart.
 * @member FacebookExtension2_EVENT_RATED Log this event when the user has rated an item in the app. The `valueToSum` passed to ${function.fb_send_event} should be the numeric rating.
 * @member FacebookExtension2_EVENT_SEARCHED Log this event when the user has performed a search within the app.
 * @member FacebookExtension2_EVENT_SPENT_CREDITS Log this event when the user has spent app credits. The `valueToSum` passed to ${function.fb_send_event} should be the number of credits spent.
 * @member FacebookExtension2_EVENT_UNLOCKED_ACHIEVEMENT Log this event when the user has unlocked an achievement in the app.
 * @member FacebookExtension2_EVENT_VIEWED_CONTENT Log this event when the user has viewed a form of content in the app.
 * 
 * @const_end
 */

/**
 * @const FACEBOOK_EVENT_NAME
 * @desc > **Facebook Object**: [AppEventsConstants](https://github.com/facebook/facebook-android-sdk/blob/ade6cec4c97be018302f1ba3da5a8ccae1118c3c/facebook-core/src/main/java/com/facebook/appevents/AppEventsConstants.kt)
 * 
 * This set of constants represents the possible built-in event names.
 * 
 * @member ACTIVATED_APP The launch of your app. Takes no event parameters.
 * @member DEACTIVATED_APP The app is deactivated.
 * @member SESSION_INTERRUPTIONS 
 * @member TIME_BETWEEN_SESSIONS 
 * @member COMPLETED_REGISTRATION Log this event when the user has completed registration with the app. Takes event parameters: `FACEBOOK_EVENT_PARAM.REGISTRATION_METHOD`.
 * @member VIEWED_CONTENT Log this event when the user has viewed a form of content in the app. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID`, `FACEBOOK_EVENT_PARAM.CONTENT`, `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member SEARCHED A search performed on your website, app or other property, such as product searches, travel searches, etc. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.SEARCH_STRING`, `FACEBOOK_EVENT_PARAM.SUCCESS`.
 * @member RATED Log this event when the user has rated an item in the app. The `value_to_sum` passed to ${function.fb_send_event} should be the numeric rating. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` or `FACEBOOK_EVENT_PARAM.CONTENT`, `FACEBOOK_EVENT_PARAM.MAX_RATING_VALUE`.
 * @member COMPLETED_TUTORIAL Log this event when the user has completed a tutorial in the app. Takes event parameters: `FACEBOOK_EVENT_PARAM.SUCCESS`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` or `FACEBOOK_EVENT_PARAM.CONTENT`.
 * @member ADDED_TO_CART Log this event when the user has added an item to their cart. The `value_to_sum` passed to ${function.fb_send_event} should be the item's price. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` or `FACEBOOK_EVENT_PARAM.CONTENT` and `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member ADDED_TO_WISHLIST Log this event when the user has added an item to their wishlist. The `value_to_sum` passed to ${function.fb_send_event} should be the item's price. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` or `FACEBOOK_EVENT_PARAM.CONTENT` and `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member INITIATED_CHECKOUT Log this event when the user has entered the checkout process. The `value_to_sum` passed to ${function.fb_send_event} should be the total price in the cart. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` OR `FACEBOOK_EVENT_PARAM.CONTENT`, `FACEBOOK_EVENT_PARAM.NUM_ITEMS`, `FACEBOOK_EVENT_PARAM.PAYMENT_INFO_AVAILABLE`, `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member ADDED_PAYMENT_INFO Log this event when the user has entered their payment info. Takes event parameters: `FACEBOOK_EVENT_PARAM.SUCCESS`.
 * @member PURCHASED [Deprecated] The completion of a purchase, usually signified by receiving order or purchase confirmation or a transaction receipt. Takes event parameters: `FACEBOOK_EVENT_PARAM.NUM_ITEMS`, `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID`, `FACEBOOK_EVENT_PARAM.CONTENT`, `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member ACHIEVED_LEVEL Log this event when the user has achieved a level in the app. Takes event parameters: `FACEBOOK_EVENT_PARAM.LEVEL`.
 * @member UNLOCKED_ACHIEVEMENT Log this event when the user has unlocked an achievement in the app. Takes event parameters: `FACEBOOK_EVENT_PARAM.DESCRIPTION`.
 * @member SPENT_CREDITS The completion of a transaction where people spend credits specific to your business or application, such as in-app currency. Log this event when the user has spent app credits. The `value_to_sum` passed to ${function.fb_send_event} should be the number of credits spent. Takes event parameters: `FACEBOOK_EVENT_PARAM.CONTENT_TYPE`, `FACEBOOK_EVENT_PARAM.CONTENT_ID` or `FACEBOOK_EVENT_PARAM.CONTENT`.
 * @member CONTACT A telephone or SMS, email, chat or other type of contact between a customer and your business.
 * @member CUSTOMIZE_PRODUCT The customization of products through a configuration tool or other application your business owns.
 * @member DONATE The donation of funds to your organization or cause.
 * @member FIND_LOCATION When a person finds one of your locations via web or app, with an intention to visit. For example, searching for a product and finding it at one of your local stores.
 * @member SCHEDULE The booking of an appointment to visit one of your locations.
 * @member START_TRIAL The start of a free trial of a product or service you offer, such as a trial subscription. Takes event parameters: `FACEBOOK_EVENT_PARAM.SUBSCRIPTION_ID`, `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member SUBMIT_APPLICATION The submission of an application for a product, service or program you offer (example: credit card, educational program or job)
 * @member SUBSCRIBE The start of a paid subscription for a product or service you offer. Takes event parameters: `FACEBOOK_EVENT_PARAM.SUBSCRIPTION_ID`, `FACEBOOK_EVENT_PARAM.CURRENCY`.
 * @member AD_IMPRESSION An ad from a third-party platform appears on-screen within your app. If `value_to_sum` is provided, the event can be used for in-app ads optimization. The `value_to_sum` value represents the in-app ads revenue generated from a user viewing an ad in your app. Refer to the [documentation here](https://developers.facebook.com/docs/app-events/guides/maximize-in-app-ad-revenue) to learn about maximizing the value of in-app ad impressions. Takes event parameters: `FACEBOOK_EVENT_PARAM.AD_TYPE`.
 * @member AD_CLICK An ad from a third-party platform is clicked within your app. Takes event parameters: `FACEBOOK_EVENT_PARAM.AD_TYPE`.
 * @member LIVE_STREAMING_START Live streaming event
 * @member LIVE_STREAMING_STOP Live streaming event
 * @member LIVE_STREAMING_PAUSE Live streaming event
 * @member LIVE_STREAMING_RESUME Live streaming event
 * @member LIVE_STREAMING_ERROR Live streaming event
 * @member LIVE_STREAMING_UPDATE_STATUS Live streaming event
 * @member PRODUCT_CATALOG_UPDATE Update of a product catalog item
 * 
 * @const_end
 */

/**
 * @const FACEBOOK_EVENT_PARAM
 * @desc > **Facebook Object**: [AppEventsConstants](https://github.com/facebook/facebook-android-sdk/blob/ade6cec4c97be018302f1ba3da5a8ccae1118c3c/facebook-core/src/main/java/com/facebook/appevents/AppEventsConstants.kt)
 * 
 * This set of constants represents the possible built-in event parameter types.
 * 
 * @member CURRENCY Parameter key used to specify currency used with logged event.  E.g. `"USD"`, `"EUR"`, `"GBP"`. See [ISO-4217](http://en.wikipedia.org/wiki/ISO_4217) for specific values.
 * @member REGISTRATION_METHOD Parameter key used to specify the method the user has used to register for the app, e.g., `"Facebook"`, `"email"`, `"Twitter"`, etc.
 * @member CONTENT_TYPE Parameter key used to specify a generic content type/family for the logged event, e.g. `"music"`, `"photo"`, `"video"`.  Options to use will vary depending on the nature of the app.
 * @member CONTENT_ID Parameter key used to specify an ID for the specific piece of content being logged about. This could be an EAN, article identifier, etc., depending on the nature of the app.
 * @member SEARCH_STRING Parameter key used to specify the string provided by the user for a search operation.
 * @member SUCCESS Parameter key used to specify whether the activity being logged about was successful or not. `FACEBOOK_EVENT_PARAM.VALUE_YES` and `FACEBOOK_EVENT_PARAM.VALUE_NO` are good canonical values to use for this parameter.
 * @member MAX_RATING_VALUE Parameter key used to specify the maximum rating available for the `FACEBOOK_EVENT_NAME.RATED` event. E.g., `"5"` or `"10"`.
 * @member PAYMENT_INFO_AVAILABLE Parameter key used to specify whether payment info is available for the `FACEBOOK_EVENT_NAME.INITIATED_CHECKOUT` event. `FACEBOOK_EVENT_PARAM.VALUE_YES` and `FACEBOOK_EVENT_PARAM.VALUE_NO` are good canonical values to use for this parameter.
 * @member NUM_ITEMS Parameter key used to specify how many items are being processed for a `FACEBOOK_EVENT_NAME.INITIATED_CHECKOUT` or `FACEBOOK_EVENT_NAME.PURCHASED` event.
 * @member LEVEL Parameter key used to specify the level achieved in a `FACEBOOK_EVENT_NAME.LEVEL_ACHIEVED` event.
 * @member DESCRIPTION Parameter key used to specify a description appropriate to the event being logged. E.g., the name of the achievement unlocked in the `FACEBOOK_EVENT_NAME.ACHIEVEMENT_UNLOCKED` event.
 * @member SOURCE_APPLICATION Parameter key used to specify source application package.
 * @member VALUE_YES Yes-valued parameter value to be used with parameter keys that need a Yes/No value
 * @member VALUE_NO No-valued parameter value to be used with parameter keys that need a Yes/No value
 * @member LIVE_STREAMING_PREV_STATUS Live streaming event parameter
 * @member LIVE_STREAMING_STATUS Live streaming event parameter
 * @member LIVE_STREAMING_ERROR Live streaming event parameter
 * @member AD_TYPE Type of ad: banner, interstitial, rewarded_video, native
 * @member ORDER_ID The unique ID for all events within a subscription
 * @member VALUE_TO_SUM The value to sum for the event
 * @member PRODUCT_CUSTOM_LABEL_0 Parameter key used to specify additional information about item for `EVENT_NAME.PRODUCT_CATALOG_UPDATE` event
 * @member PRODUCT_CUSTOM_LABEL_1 Parameter key used to specify additional information about item for `EVENT_NAME.PRODUCT_CATALOG_UPDATE` event
 * @member PRODUCT_CUSTOM_LABEL_2 Parameter key used to specify additional information about item for `EVENT_NAME.PRODUCT_CATALOG_UPDATE` event
 * @member PRODUCT_CUSTOM_LABEL_3 Parameter key used to specify additional information about item for `EVENT_NAME.PRODUCT_CATALOG_UPDATE` event
 * @member PRODUCT_CUSTOM_LABEL_4 Parameter key used to specify additional information about item for `EVENT_NAME.PRODUCT_CATALOG_UPDATE` event
 * @member PRODUCT_CATEGORY Product category
 * @member PRODUCT_APPLINK_IOS_URL App Link event parameter
 * @member PRODUCT_APPLINK_IOS_APP_STORE_ID App Link event parameter
 * @member PRODUCT_APPLINK_IOS_APP_NAME App Link event parameter
 * @member PRODUCT_APPLINK_IPHONE_URL App Link event parameter
 * @member PRODUCT_APPLINK_IPHONE_APP_STORE_ID App Link event parameter
 * @member PRODUCT_APPLINK_IPHONE_APP_NAME App Link event parameter
 * @member PRODUCT_APPLINK_IPAD_APP_STORE_ID App Link event parameter
 * @member PRODUCT_APPLINK_IPAD_APP_NAME App Link event parameter
 * @member PRODUCT_APPLINK_ANDROID_URL App Link event parameter
 * @member PRODUCT_APPLINK_ANDROID_PACKAGE App Link event parameter
 * @member PRODUCT_APPLINK_ANDROID_APP_NAME App Link event parameter
 * @member PRODUCT_APPLINK_WINDOWS_PHONE_URL App Link event parameter
 * @member PRODUCT_APPLINK_WINDOWS_PHONE_APP_ID App Link event parameter
 * @member PRODUCT_APPLINK_WINDOWS_PHONE_APP_NAME App Link event parameter
 * @const_end
 */

// Modules

/**
 * @module home
 * @title Home
 * @desc This is the Facebook extension, which contains various functionality for Facebook, including sign in.
 * 
 * The sign-in functionality is supported on all platforms. Other functionality may not be available on all platforms.
 * 
 * [[Important: Some functions of this extension take a parameter of type ${type.ds_list}. However, extension functions currently cannot accept DS list references. To fix this you can wrap the list in a function call to ${function.real}.]]
 * 
 * @section Guides
 * @desc These are the guides for the Facebook extension:
 * @ref page.guide_setup
 * @ref page.guide_login
 * @section_end
 * 
 * @section_func
 * @desc These are the functions in the Facebook extension:
 * @ref fb_*
 * @section_end
 * 
 * @section_const
 * @desc These are the constants used by the Facebook extension.
 * 
 * @ref FacebookExtension2_PARAM
 * @ref FacebookExtension2_EVENT
 * @ref FACEBOOK_EVENT_NAME
 * @ref FACEBOOK_EVENT_PARAM
 * @section_end
 * 
 * @module_end
 */
