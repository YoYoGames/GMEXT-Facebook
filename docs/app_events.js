/**
 * @struct FacebookEventParameterValue
 * @desc A single parameter attached to a standard App Event that is sent with
 * ${function.fb_send_event}. It has the same shape as ${struct.FacebookNamedValue}, except that the
 * name is not free text but a ${constant.FacebookAppEventParameter} value, so that the parameter
 * lands on one of Meta's own recognised parameter names and can be used in the breakdowns of the
 * Events Manager.
 *
 * The struct has both a string slot and a number slot, and `use_number` decides which of the two is
 * actually sent. This is a generated extension record, so it is created with an empty constructor
 * and every field is assigned afterwards.
 * @member {Enum.FacebookAppEventParameter} key Which standard parameter this value is for.
 * @member {String} string_value The value to send when `use_number` is `false`.
 * @member {Real} number_value The value to send when `use_number` is `true`.
 * @member {Bool} use_number Whether to send `number_value` (`true`) or `string_value` (`false`).
 * @struct_end
 */

/**
 * @function fb_send_event
 * @desc This function logs one of Meta's
 * [standard App Events](https://developers.facebook.com/docs/app-events), which is what makes it
 * show up in the built-in reports of the Events Manager and become usable for ad optimisation and
 * audience building. For anything that Meta has no standard name for you should use
 * ${function.fb_send_custom_event} instead.
 *
 * Events are batched by the SDK and uploaded on its own schedule, so see ${function.fb_flush_events}
 * if you need one sent immediately. Nothing is returned, as Meta's own logging API has no result,
 * and an invalid request (an unrecognised event, or a `value` that is not finite) is dropped with a
 * warning in the native log rather than being reported back to you.
 * @param {Enum.FacebookAppEvent} event Which standard event to log.
 * @param {Real} value The numeric value to associate with the event. This is typically a currency
 * amount, or `0` where the event has no natural value.
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
 * @desc This function logs an App Event under a name of your own, for those things that Meta has no
 * standard event for, such as a level restart, a tutorial skip, or a shop screen being opened.
 * Custom events still appear in the Events Manager and can still be used to build audiences, but
 * they do not feed Meta's built-in optimisation the way that the standard events in
 * ${function.fb_send_event} do.
 *
 * As with the standard events, nothing is returned, and an invalid request (an empty name, or a
 * `value` that is not finite) is dropped with a warning in the native log.
 * [[Note: You should keep the set of event names small and stable. Meta caps how many distinct
 * custom event names an app can report, and a name that is built from a variable will burn through
 * that cap very quickly, so the variable part should go in a parameter instead.]]
 * @param {String} event_name The event name. Any surrounding whitespace is trimmed before it is
 * sent.
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
 * @desc This function logs a purchase. It is the event that Meta's purchase reporting and
 * value-optimised ad campaigns are built on, which is why it goes through Meta's dedicated purchase
 * API rather than being a standard event that you would send with ${function.fb_send_event}.
 *
 * Nothing is returned. An `amount` that is negative or not finite, or a currency that is not exactly
 * three letters, is dropped with a warning in the native log.
 * [[Warning: This only *reports* a purchase and it does not verify one. It should be called after
 * your store of record (Google Play Billing, StoreKit) has confirmed the transaction, and never
 * before.]]
 * @param {Real} amount The amount paid, in the units of `currency` (so `4.99`, and not `499`).
 * @param {String} currency The ISO 4217 currency code, for example `"USD"`. Case is not significant.
 * @param {Array[Struct.FacebookNamedValue]} parameters Any extra parameters to attach, such as the
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
 * @desc This function sends every queued App Event to Meta right now, instead of waiting for the
 * SDK's own upload schedule.
 *
 * You normally should not need to call this. The SDK batches events deliberately, to save the
 * player's battery and data, and flushing after every event throws that away. It is useful while you
 * are testing, so that an event shows up in the Events Manager within seconds rather than minutes,
 * and just before a point where the app may be killed.
 * @function_end
 */

/**
 * @function fb_set_event_user_id
 * @desc This function attaches an identifier of your own to every App Event that is logged from this
 * point on, so that events from the same player can be tied together across devices and reinstalls.
 * The value persists across app launches until it is changed, or until it is cleared with
 * ${function.fb_clear_event_user_id}.
 *
 * Passing in an empty string clears the identifier, exactly as ${function.fb_clear_event_user_id}
 * does.
 * [[Warning: You should use an opaque identifier of your own. Never pass in an email address, a
 * phone number, a name, or anything else that identifies a real person, as Meta's terms forbid
 * it.]]
 * @param {String} user_id Your own identifier for the current player.
 * @function_end
 */

/**
 * @function fb_get_event_user_id
 * @desc This function returns the identifier that was previously set with
 * ${function.fb_set_event_user_id}.
 * @returns {String} The current App Events user ID, or an empty string if none is set.
 * @function_end
 */

/**
 * @function fb_clear_event_user_id
 * @desc This function clears the identifier that was set with ${function.fb_set_event_user_id}, so
 * that subsequent App Events carry no user ID. You should call this when the player signs out of
 * your own account system.
 * @function_end
 */

/**
 * @const FacebookAppEvent
 * @desc Meta's standard App Events, as accepted by ${function.fb_send_event}. Using a standard event
 * rather than a custom one is what lets Meta's built-in reporting and ad optimisation understand
 * what happened. The full definitions can be found in Meta's
 * [App Events reference](https://developers.facebook.com/docs/app-events).
 * @member AchievedLevel The player reached a new level.
 * @member AddedPaymentInfo The player entered payment details.
 * @member AddedToCart The player added an item to a cart.
 * @member AddedToWishlist The player added an item to a wishlist.
 * @member CompletedRegistration The player finished creating an account.
 * @member CompletedTutorial The player finished the tutorial.
 * @member InitiatedCheckout The player started a checkout flow.
 * @member Rated The player rated something. This should be paired with MaxRatingValue.
 * @member Searched The player ran a search. This should be paired with SearchString.
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
 * ${struct.FacebookEventParameterValue}. A parameter that is sent under one of these names is
 * understood by the breakdowns of the Events Manager, and anything else needs a custom event
 * (${function.fb_send_custom_event}) with a free-text name.
 * @member Content A description of the content involved, often a JSON string.
 * @member AdType The type of ad, for the AdImpression and AdClick events.
 * @member ContentId The identifier of the content or product involved.
 * @member ContentType The category of the content or product involved.
 * @member Currency The ISO 4217 currency code that the event's value is expressed in.
 * @member Description A free-text description of the event.
 * @member Level The level that the player reached, for the AchievedLevel event.
 * @member MaxRatingValue The top of the rating scale, for the Rated event. This is numeric.
 * @member NumItems How many items the event covers. This is numeric.
 * @member PaymentInfoAvailable Whether payment details are already on file. This is numeric, either
 * `1` or `0`.
 * @member RegistrationMethod How the player registered, for example `"Facebook"` or `"Email"`.
 * @member SearchString What the player searched for, for the Searched event.
 * @member Success Whether the action succeeded. This is numeric, either `1` or `0`.
 * @member OrderId The order identifier for a transaction.
 * @const_end
 */

/**
 * @module app_events
 * @title App Events
 * @desc Reporting what your players do back to Meta, for analytics in the Events Manager and for ad
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
 * @desc The standard event and parameter names that Meta recognises.
 * @ref FacebookAppEvent
 * @ref FacebookAppEventParameter
 * @section_end
 *
 * @module_end
 */
