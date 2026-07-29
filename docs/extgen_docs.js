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
 * @function_partial fb_is_logged_in
 * @returns {Bool}
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
 * @function_partial fb_auto_log_app_events_enabled
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_set_advertiser_id_collection_enabled
 * @param {Bool} enabled
 * @function_end
 */

/**
 * @function_partial fb_advertiser_id_collection_enabled
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_set_event_data_usage_limited
 * @param {Bool} enabled
 * @function_end
 */

/**
 * @function_partial fb_event_data_usage_limited
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_set_data_processing_options
 * @param {Array[String]} options
 * @param {Real} country
 * @param {Real} state
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
 * @param {Enum.FacebookHttpMethod} method
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
 * @param {Enum.FacebookAppEvent} event
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
 * @function_partial fb_send_purchase
 * @param {Real} amount
 * @param {String} currency
 * @param {Array[Struct.FacebookNamedValue]} parameters
 * @returns {Bool}
 * @function_end
 */

/**
 * @function_partial fb_flush_events
 * @function_end
 */

/**
 * @function_partial fb_set_event_user_id
 * @param {String} user_id
 * @function_end
 */

/**
 * @function_partial fb_get_event_user_id
 * @returns {String}
 * @function_end
 */

/**
 * @function_partial fb_clear_event_user_id
 * @function_end
 */

/**
 * @struct_partial FacebookEventParameterValue
 * @member {Enum.FacebookAppEventParameter} key
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
 * @member {Enum.FacebookOperationStatus} status
 * @member {Real} request_id
 * @member {String} error_message
 * @member {String} access_token
 * @member {String} user_id
 * @member {String} response_text
 * @member {String} post_id
 * @member {Array[String]} granted_permissions
 * @member {Array[String]} declined_permissions
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
 * @member Contact
 * @member CustomizeProduct
 * @member Donate
 * @member FindLocation
 * @member Schedule
 * @member StartTrial
 * @member SubmitApplication
 * @member Subscribe
 * @member AdImpression
 * @member AdClick
 * @enum_end
 */

/**
 * @enum_partial FacebookAppEventParameter
 * @member Content
 * @member AdType
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
 * @member OrderId
 * @enum_end
 */

/**
 * @const_partial macros
 * @const_end
 */

