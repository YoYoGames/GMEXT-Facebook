#macro FACEBOOK_EVENT_NAME global.__FACEBOOK_EVENT_NAME

global.__FACEBOOK_EVENT_NAME =
{
    ACTIVATED_APP: "fb_mobile_activate_app",
    DEACTIVATED_APP: "fb_mobile_deactivate_app",
    SESSION_INTERRUPTIONS: "fb_mobile_app_interruptions",
    TIME_BETWEEN_SESSIONS: "fb_mobile_time_between_sessions",
    /** Log this event when the user has completed registration with the app. */
    COMPLETED_REGISTRATION: "fb_mobile_complete_registration",
    /** Log this event when the user has viewed a form of content in the app. */
    VIEWED_CONTENT: "fb_mobile_content_view",
    /** Log this event when the user has performed a search within the app. */
    SEARCHED: "fb_mobile_search",
    /**
     * Log this event when the user has rated an item in the app.
     * The valueToSum passed to logEvent should be the numeric rating.
     */
    RATED: "fb_mobile_rate",
    /** Log this event when the user has completed a tutorial in the app. */
    COMPLETED_TUTORIAL: "fb_mobile_tutorial_completion",
    // Ecommerce related
    /**
     * Log this event when the user has added an item to their cart.
     * The valueToSum passed to logEvent should be the item's price.
     */
    ADDED_TO_CART: "fb_mobile_add_to_cart",
    /**
     * Log this event when the user has added an item to their wishlist.
     * The valueToSum passed to logEvent should be the item's price.
     */
    ADDED_TO_WISHLIST: "fb_mobile_add_to_wishlist",
    /**
     * Log this event when the user has entered the checkout process.
     * The valueToSum passed to logEvent should be the total price in the cart.
     */
    INITIATED_CHECKOUT: "fb_mobile_initiated_checkout",
    /** Log this event when the user has entered their payment info. */
    ADDED_PAYMENT_INFO: "fb_mobile_add_payment_info",
    /**
     *  @deprecated Use {@link
     *  AppEventsLogger#logPurchase(java.math.BigDecimal, java.util.Currency)} instead.
     *  Log this event when the user has completed a purchase. The {@link
     *  AppEventsLogger#logPurchase(java.math.BigDecimal, java.util.Currency)} method is a shortcut
     *  for logging this event.
     */
    //@Deprecated
    PURCHASED: "fb_mobile_purchase",
    // Gaming related
    /** Log this event when the user has achieved a level in the app. */
    ACHIEVED_LEVEL: "fb_mobile_level_achieved",
    /** Log this event when the user has unlocked an achievement in the app. */
    UNLOCKED_ACHIEVEMENT: "fb_mobile_achievement_unlocked",
    /**
     * Log this event when the user has spent app credits.
     * The valueToSum passed to logEvent should be the number of credits spent.
     */
    SPENT_CREDITS: "fb_mobile_spent_credits",
	

	/** A telephone/SMS, email, chat or other type of contact between a customer and your business. */
	CONTACT: "Contact",

	/**
	 * The customization of products through a configuration tool or other application your business
	 * owns.
	 */
	CUSTOMIZE_PRODUCT: "CustomizeProduct",

	/** The donation of funds to your organization or cause. */
	DONATE: "Donate",

	/**
	 * When a person finds one of your locations via web or application, with an intention to visit
	 * (example: find product at a local store).
	 */
	FIND_LOCATION: "FindLocation",

	/** The booking of an appointment to visit one of your locations. */
	SCHEDULE: "Schedule",

	/** The start of a free trial of a product or service you offer (example: trial subscription). */
	START_TRIAL: "StartTrial",

	/**
	 * The submission of an application for a product, service or program you offer (example: credit
	 * card, educational program or job).
	 */
	SUBMIT_APPLICATION: "SubmitApplication",

	/** The start of a paid subscription for a product or service you offer. */
	SUBSCRIBE: "Subscribe",

	/** Log this event when the user views an ad. */
	AD_IMPRESSION: "AdImpression",

	/** Log this event when the user clicks an ad. */
	AD_CLICK: "AdClick",

	/** Log the live streaming events from sdk */
	LIVE_STREAMING_START: "fb_sdk_live_streaming_start",
	LIVE_STREAMING_STOP: "fb_sdk_live_streaming_stop",
	LIVE_STREAMING_PAUSE: "fb_sdk_live_streaming_pause",
	LIVE_STREAMING_RESUME: "fb_sdk_live_streaming_resume",
	LIVE_STREAMING_ERROR: "fb_sdk_live_streaming_error",
	LIVE_STREAMING_UPDATE_STATUS: "fb_sdk_live_streaming_update_status",

	/** Product Catalog related events */
	PRODUCT_CATALOG_UPDATE: "fb_mobile_catalog_update",
}





#macro FACEBOOK_EVENT_PARAM global.__FACEBOOK_EVENT_PARAM

global.__FACEBOOK_EVENT_PARAM =
{
    // Event parameters

    /**
     * Parameter key used to specify currency used with logged event.  E.g. "USD", "EUR", "GBP". See
     * <a href="http://en.wikipedia.org/wiki/ISO_4217">ISO-4217</a>
     * for specific values.
     */
    CURRENCY: "fb_currency",
    /**
     * Parameter key used to specify the method the user has used to register for the app, e.g.,
     * "Facebook", "email", "Twitter", etc.
     */
    REGISTRATION_METHOD: "fb_registration_method",
    /**
     * Parameter key used to specify a generic content type/family for the logged event, e.g.
     * "music", "photo", "video".  Options to use will vary depending on the nature of the app.
     */
    CONTENT_TYPE: "fb_content_type",
    /**
     * Parameter key used to specify an ID for the specific piece of content being logged about.
     * This could be an EAN, article identifier, etc., depending on the nature of the app.
     */
    CONTENT_ID: "fb_content_id",
    /** Parameter key used to specify the string provided by the user for a search operation. */
    SEARCH_STRING: "fb_search_string",
    /**
     * Parameter key used to specify whether the activity being logged about was successful or not.
     * EVENT_PARAM_VALUE_YES and EVENT_PARAM_VALUE_NO are good canonical values to use for this
     * parameter.
     */
    SUCCESS: "fb_success",
    /**
     * Parameter key used to specify the maximum rating available for the EVENT_NAME_RATE event.
     * E.g., "5" or "10".
     */
    MAX_RATING_VALUE: "fb_max_rating_value",
    /**
     * Parameter key used to specify whether payment info is available for the
     * EVENT_NAME_INITIATED_CHECKOUT event. EVENT_PARAM_VALUE_YES and EVENT_PARAM_VALUE_NO are good
     * canonical values to use for this parameter.
     */
    PAYMENT_INFO_AVAILABLE: "fb_payment_info_available",
    /**
     * Parameter key used to specify how many items are being processed for an
     * EVENT_NAME_INITIATED_CHECKOUT or EVENT_NAME_PURCHASE event.
     */
    NUM_ITEMS: "fb_num_items",
    /** Parameter key used to specify the level achieved in an EVENT_NAME_LEVEL_ACHIEVED event. */
    LEVEL: "fb_level",
    /**
     * Parameter key used to specify a description appropriate to the event being logged.
     * E.g., the name of the achievement unlocked in the EVENT_NAME_ACHIEVEMENT_UNLOCKED event.
     */
    DESCRIPTION: "fb_description",
    /**
     * Parameter key used to specify source application package.
     */
    SOURCE_APPLICATION: "fb_mobile_launch_source",
    // Parameter values
    /** Yes-valued parameter value to be used with parameter keys that need a Yes/No value */
    VALUE_YES: "1",
    /** No-valued parameter value to be used with parameter keys that need a Yes/No value */
    VALUE_NO: "0",	
	


    /** Product Catalog related events */
    PRODUCT_CATALOG_UPDATE: "fb_mobile_catalog_update",
    // Event parameters
    /** Paramete keys for live streaming events */
    LIVE_STREAMING_PREV_STATUS: "live_streaming_prev_status",
    LIVE_STREAMING_STATUS: "live_streaming_status",
    LIVE_STREAMING_ERROR: "live_streaming_error",


    /**
     * Parameter key used to specify the type of ad in an EVENT_NAME_AD_IMPRESSION or
     * EVENT_NAME_AD_CLICK event. E.g. "banner", "interstitial", "rewarded_video", "native"
     */
    AD_TYPE: "ad_type",

    /**
     * Parameter key used to specify the unique ID for all events within a subscription in an
     * EVENT_NAME_SUBSCRIBE or EVENT_NAME_START_TRIAL event.
     */
    ORDER_ID: "fb_order_id",
    VALUE_TO_SUM: "_valueToSum",

    /**
     * Parameter keys used to specify additional information about item for
     * EVENT_NAME_PRODUCT_CATALOG_UPDATE event.
     */
    PRODUCT_CUSTOM_LABEL_0: "fb_product_custom_label_0",
    PRODUCT_CUSTOM_LABEL_1: "fb_product_custom_label_1",
    PRODUCT_CUSTOM_LABEL_2: "fb_product_custom_label_2",
    PRODUCT_CUSTOM_LABEL_3: "fb_product_custom_label_3",
    PRODUCT_CUSTOM_LABEL_4: "fb_product_custom_label_4",

    // Optional field "google_product_category"
    PRODUCT_CATEGORY: "fb_product_category",

    /**
     * Parameter keys used to specify the product deep links for EVENT_NAME_PRODUCT_CATALOG_UPDATE
     * event.
     */
    PRODUCT_APPLINK_IOS_URL: "fb_product_applink_ios_url",
    PRODUCT_APPLINK_IOS_APP_STORE_ID: "fb_product_applink_ios_app_store_id",
    PRODUCT_APPLINK_IOS_APP_NAME: "fb_product_applink_ios_app_name",
    PRODUCT_APPLINK_IPHONE_URL: "fb_product_applink_iphone_url",
    PRODUCT_APPLINK_IPHONE_APP_STORE_ID: "fb_product_applink_iphone_app_store_id",
    PRODUCT_APPLINK_IPHONE_APP_NAME: "fb_product_applink_iphone_app_name",
    PRODUCT_APPLINK_IPAD_URL: "fb_product_applink_ipad_url",
    PRODUCT_APPLINK_IPAD_APP_STORE_ID: "fb_product_applink_ipad_app_store_id",
    PRODUCT_APPLINK_IPAD_APP_NAME: "fb_product_applink_ipad_app_name",
    PRODUCT_APPLINK_ANDROID_URL: "fb_product_applink_android_url",
    PRODUCT_APPLINK_ANDROID_PACKAGE: "fb_product_applink_android_package",
    PRODUCT_APPLINK_ANDROID_APP_NAME: "fb_product_applink_android_app_name",
    PRODUCT_APPLINK_WINDOWS_PHONE_URL: "fb_product_applink_windows_phone_url",
    PRODUCT_APPLINK_WINDOWS_PHONE_APP_ID: "fb_product_applink_windows_phone_app_id",
    PRODUCT_APPLINK_WINDOWS_PHONE_APP_NAME: "fb_product_applink_windows_phone_app_name",
}

