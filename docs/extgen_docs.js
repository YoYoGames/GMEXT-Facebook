/**
 * @function_partial fb_initialize
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_ready
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_status
 * @returns {Enum.FacebookLoginStatus}
 * @function_end
 */

/**
 * @function_partial fb_user_id
 * @returns {String}
 * @function_end
 */

/**
 * @function_partial fb_access_token
 * @returns {String}
 * @function_end
 */

/**
 * @function_partial fb_logout
 * @function_end
 */

/**
 * @function_partial fb_set_auto_log_app_events_enabled
 * @param {Bool} enabled
 * @function_end
 */

/**
 * @function_partial fb_set_advertiser_id_collection_enabled
 * @param {Bool} enabled
 * @function_end
 */

/**
 * @function_partial fb_check_permission
 * @param {String} permission
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_login
 * @param {Array[String]} permissions
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_request_read_permissions
 * @param {Array[String]} permissions
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_request_publish_permissions
 * @param {Array[String]} permissions
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_refresh_access_token
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_graph_request
 * @param {String} graph_path
 * @param {Array[Enum.FacebookHttpMethod]} method
 * @param {Array[Struct.FacebookNamedValue]} parameters
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_dialog
 * @param {String} link_url
 * @param {Function} callback
 * @function_end
 */

/**
 * @function_partial fb_send_event
 * @param {Array[Enum.FacebookAppEvent]} event
 * @param {Real} value
 * @param {Array[Struct.FacebookEventParameterValue]} parameters
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_send_custom_event
 * @param {String} event_name
 * @param {Real} value
 * @param {Array[Struct.FacebookNamedValue]} parameters
 * @returns {Bool}
 * @function_end
 */

/**
 * @struct_partial FacebookEventParameterValue
 * @member {Real} key
 * @member {String} string_value
 * @member {Real} number_value
 * @member {Bool} use_number
 * @struct_end
 */

/**
 * @struct_partial FacebookNamedValue
 * @member {String} name
 * @member {String} string_value
 * @member {Real} number_value
 * @member {Bool} use_number
 * @struct_end
 */

/**
 * @struct_partial FacebookCallbackResult
 * @member {Bool} success
 * @member {Real} status
 * @member {Real} request_id
 * @member {String} error_message
 * @member {String} access_token
 * @member {String} user_id
 * @member {String} response_text
 * @member {String} post_id
 * @struct_end
 */

/**
 * @enum_partial FacebookLoginStatus
 * @member Idle
 * @member Processing
 * @member Failed
 * @member Authorised
 * @enum_end
 */

/**
 * @enum_partial FacebookOperationStatus
 * @member Success
 * @member Cancelled
 * @member Error
 * @enum_end
 */

/**
 * @enum_partial FacebookHttpMethod
 * @member Get
 * @member Post
 * @member Delete
 * @enum_end
 */

/**
 * @enum_partial FacebookAppEvent
 * @member AchievedLevel
 * @member AddedPaymentInfo
 * @member AddedToCart
 * @member AddedToWishlist
 * @member CompletedRegistration
 * @member CompletedTutorial
 * @member InitiatedCheckout
 * @member Rated
 * @member Searched
 * @member SpentCredits
 * @member UnlockedAchievement
 * @member ViewedContent
 * @enum_end
 */

/**
 * @enum_partial FacebookAppEventParameter
 * @member ContentId
 * @member ContentType
 * @member Currency
 * @member Description
 * @member Level
 * @member MaxRatingValue
 * @member NumItems
 * @member PaymentInfoAvailable
 * @member RegistrationMethod
 * @member SearchString
 * @member Success
 * @enum_end
 */

/**
 * @const_partial macros
 * @const_end
 */

