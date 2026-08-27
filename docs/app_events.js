/**
 * @struct FacebookEventParameterValue
 * @desc A single parameter attached to a standard App Event sent with ${function.fb_send_event}. It
 * is the same shape as ${struct.FacebookNamedValue} except that the name is not free text - it is a
 * ${constant.FacebookAppEventParameter} value, so the parameter lands on one of Meta's own recognised
 * parameter names and is usable in the Events Manager's breakdowns.
 *
 * The struct carries both a string and a number slot, and `use_number` selects which one is actually
 * sent. This is a generated extension record, so it is created with an empty constructor and every
 * field is assigned afterwards.
 * @member {Enum.FacebookAppEventParameter} key Which standard parameter this value is for.
 * @member {String} string_value The value to send when `use_number` is `false`.
 * @member {Real} number_value The value to send when `use_number` is `true`.
 * @member {Bool} use_number Whether to send `number_value` (`true`) or `string_value` (`false`).
 * @struct_end
 */

/**
 * @function fb_send_event
 * @desc Logs one of Meta's [standard App Events](https://developers.facebook.com/docs/app-events),
 * which is what makes it show up in the Events Manager's built-in reports and become usable for ad
 * optimisation and audience building. For anything Meta has no standard name for, use
 * ${function.fb_send_custom_event} instead.
 *
 * Events are batched by the SDK and uploaded on its own schedule - see ${function.fb_flush_events} if
 * you need one sent immediately. Nothing is returned: Meta's own logging API has no result, and an
 * invalid request (an unrecognised event, or a non-finite `value`) is dropped with a warning in the
 * native log rather than reported back.
 * @param {Enum.FacebookAppEvent} event Which standard event to log.
 * @param {Real} value The numeric value to associate with the event - typically a currency amount, or
 * `0` where the event has no natural value.
 * @param {Array[Struct.FacebookEventParameterValue]} parameters The standard parameters to attach.
 * Pass an empty array for none.
 * @example
 * ```gml
 * var _content_id = new FacebookEventParameterValue();
 * _content_id.key = FacebookAppEventParameter.ContentId;
 * _content_id.string_value = "wishlist_item_001";
 * _content_id.number_value = 0;
 * _content_id.use_number = false;
 *
 * var _num_items = new FacebookEventParameterValue();
 * _num_items.key = FacebookAppEventParameter.NumItems;
 * _num_items.string_value = "";
 * _num_items.number_value = 1;
 * _num_items.use_number = true;
 *
 * fb_send_event(FacebookAppEvent.AddedToWishlist, 123.00, [_content_id, _num_items]);
 * ```
 * @function_end
 */

/**
 * @function fb_send_custom_event
 * @desc Logs an App Event under a name of your own, for the things Meta has no standard event for -
 * a level restart, a tutorial skip, a shop screen opened. Custom events still appear in the Events
 * Manager and can still be used to build audiences; they just do not feed Meta's built-in
 * optimisation the way the standard events in ${function.fb_send_event} do.
 *
 * As with the standard events, nothing is returned and an invalid request (an empty name, a
 * non-finite `value`) is dropped with a warning in the native log.
 * [[Note: Keep the set of event names small and stable. Meta caps how many distinct custom event
 * names an app can report, and a name built from a variable will burn through that cap - put the
 * variable part in a parameter instead.]]
 * @param {String} event_name The event name. Trimmed of surrounding whitespace before it is sent.
 * @param {Real} value The numeric value to associate with the event, or `0` if it has none.
 * @param {Array[Struct.FacebookNamedValue]} parameters The parameters to attach, with names of your
 * own choosing. Pass an empty array for none.
 * @example
 * ```gml
 * var _level = new FacebookNamedValue();
 * _level.name = "level_name";
 * _level.string_value = "forest_02";
 * _level.number_value = 0;
 * _level.use_number = false;
 *
 * fb_send_custom_event("level_restarted", 1, [_level]);
 * ```
 * @function_end
 */

/**
 * @function fb_send_purchase
 * @desc Logs a purchase. This is the event Meta's purchase reporting and value-optimised ad campaigns
 * are built on, so it goes through Meta's dedicated purchase API rather than being a standard event
 * you would send with ${function.fb_send_event}.
 *
 * Nothing is returned. A negative or non-finite `amount`, or a currency that is not exactly three
 * letters, is dropped with a warning in the native log.
 * [[Warning: This only *reports* a purchase - it does not verify one. Call it after your store of
 * record (Google Play Billing, StoreKit) has confirmed the transaction, never before.]]
 * @param {Real} amount The amount paid, in the units of `currency` (so `4.99`, not `499`).
 * @param {String} currency The ISO 4217 currency code, e.g. `"USD"`. Case is not significant.
 * @param {Array[Struct.FacebookNamedValue]} parameters Extra parameters to attach, such as the
 * product identifier. Pass an empty array for none.
 * @example
 * ```gml
 * var _product = new FacebookNamedValue();
 * _product.name = "product_id";
 * _product.string_value = "com.example.game.gems_100";
 * _product.number_value = 0;
 * _product.use_number = false;
 *
 * fb_send_purchase(4.99, "USD", [_product]);
 * ```
 * @function_end
 */

/**
 * @function fb_flush_events
 * @desc Sends every queued App Event to Meta right now, instead of waiting for the SDK's own upload
 * schedule.
 *
 * You normally should not call this. The SDK batches deliberately, to save the player's battery and
 * data, and flushing after every event throws that away. It is useful while testing (so an event
 * shows up in the Events Manager within seconds rather than minutes) and just before a point where
 * the app may be killed.
 * @function_end
 */

/**
 * @function fb_set_event_user_id
 * @desc Attaches your own user identifier to every App Event logged from this point on, so events
 * from the same player can be tied together across devices and reinstalls. The value persists across
 * app launches until it is changed or cleared with ${function.fb_clear_event_user_id}.
 *
 * Passing an empty string clears the identifier, exactly as ${function.fb_clear_event_user_id} does.
 * [[Warning: Use an opaque identifier of your own. Never pass an email address, a phone number, a
 * name, or anything else that identifies a real person - Meta's terms forbid it.]]
 * @param {String} user_id Your own identifier for the current player.
 * @function_end
 */

/**
 * @function fb_get_event_user_id
 * @desc Returns the identifier previously set with ${function.fb_set_event_user_id}.
 * @returns {String} The current App Events user ID, or an empty string if none is set.
 * @function_end
 */

/**
 * @function fb_clear_event_user_id
 * @desc Clears the identifier set with ${function.fb_set_event_user_id}, so subsequent App Events
 * carry no user ID. Call this when the player signs out of your own account system.
 * @function_end
 */

/**
 * @const FacebookAppEvent
 * @desc Meta's standard App Events, as accepted by ${function.fb_send_event}. Using a standard event
 * rather than a custom one is what lets Meta's built-in reporting and ad optimisation understand what
 * happened. Full definitions are in Meta's
 * [App Events reference](https://developers.facebook.com/docs/app-events).
 * @member AchievedLevel The player reached a new level.
 * @member AddedPaymentInfo The player entered payment details.
 * @member AddedToCart The player added an item to a cart.
 * @member AddedToWishlist The player added an item to a wishlist.
 * @member CompletedRegistration The player finished creating an account.
 * @member CompletedTutorial The player finished the tutorial.
 * @member InitiatedCheckout The player started a checkout flow.
 * @member Rated The player rated something. Pair with MaxRatingValue.
 * @member Searched The player ran a search. Pair with SearchString.
 * @member SpentCredits The player spent in-game currency.
 * @member UnlockedAchievement The player unlocked an achievement.
 * @member ViewedContent The player viewed a piece of content.
 * @member Contact The player contacted your business.
 * @member CustomizeProduct The player customised a product.
 * @member Donate The player made a donation.
 * @member FindLocation The player looked up a physical location.
 * @member Schedule The player booked an appointment.
 * @member StartTrial The player started a free trial.
 * @member SubmitApplication The player submitted an application.
 * @member Subscribe The player started a paid subscription.
 * @member AdImpression An ad was shown to the player.
 * @member AdClick The player clicked an ad.
 * @const_end
 */

/**
 * @const FacebookAppEventParameter
 * @desc Meta's standard App Event parameter names, used as the `key` of a
 * ${struct.FacebookEventParameterValue}. A parameter sent under one of these names is understood by
 * the Events Manager's breakdowns; anything else needs a custom event
 * (${function.fb_send_custom_event}) with a free-text name.
 * @member Content A description of the content involved, often a JSON string.
 * @member AdType The type of ad, for the AdImpression and AdClick events.
 * @member ContentId The identifier of the content or product involved.
 * @member ContentType The category of the content or product involved.
 * @member Currency The ISO 4217 currency code the event's value is expressed in.
 * @member Description A free-text description of the event.
 * @member Level The level the player reached, for the AchievedLevel event.
 * @member MaxRatingValue The top of the rating scale, for the Rated event. Numeric.
 * @member NumItems How many items the event covers. Numeric.
 * @member PaymentInfoAvailable Whether payment details are already on file. Numeric, `1` or `0`.
 * @member RegistrationMethod How the player registered, e.g. `"Facebook"` or `"Email"`.
 * @member SearchString What the player searched for, for the Searched event.
 * @member Success Whether the action succeeded. Numeric, `1` or `0`.
 * @member OrderId The order identifier for a transaction.
 * @const_end
 */

/**
 * @module app_events
 * @title App Events
 * @desc Reporting what players do back to Meta, for analytics in the Events Manager and for ad
 * optimisation.
 *
 * @section_func
 * @desc App Events functions.
 * @ref fb_send_event
 * @ref fb_send_custom_event
 * @ref fb_send_purchase
 * @ref fb_flush_events
 * @ref fb_set_event_user_id
 * @ref fb_get_event_user_id
 * @ref fb_clear_event_user_id
 * @section_end
 *
 * @section_struct
 * @desc App Events data types.
 * @ref FacebookEventParameterValue
 * @section_end
 *
 * @section_const
 * @desc The standard event and parameter names Meta recognises.
 * @ref FacebookAppEvent
 * @ref FacebookAppEventParameter
 * @section_end
 *
 * @module_end
 */
