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
}

