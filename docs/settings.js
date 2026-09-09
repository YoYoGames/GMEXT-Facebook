/**
 * @function fb_set_auto_log_app_events_enabled
 * @desc This function turns Meta's automatic App Event logging on or off. When it is on, which is
 * the SDK's default, the SDK reports app installs, app launches and in-app purchases by itself,
 * without you having to call anything.
 *
 * You should turn it off if your privacy policy or your consent flow requires the player to opt in
 * first, and then turn it back on once they have. It has no effect on the events that you send
 * yourself with ${function.fb_send_event} and the like.
 * [[Note: This can be called before ${function.fb_initialize}, and it should be if you need logging
 * to be off from the very first launch, as the SDK logs the activation event as soon as it starts
 * up.]]
 * @param {Bool} enabled `true` to let the SDK log automatically, `false` to stop it.
 * @function_end
 */

/**
 * @function fb_auto_log_app_events_enabled
 * @desc This function returns whether Meta's automatic App Event logging is currently on. See
 * ${function.fb_set_auto_log_app_events_enabled} for more details.
 * @returns {Bool} `true` if the SDK is logging automatically, `false` otherwise.
 * @function_end
 */

/**
 * @function fb_set_advertiser_id_collection_enabled
 * @desc This function controls whether the SDK collects the device's advertising identifier (the
 * Google Advertising ID on Android, and the IDFA on iOS) and attaches it to the events that it
 * sends. With it off, events are still reported but they cannot be tied to an advertising profile,
 * which will cost you some attribution accuracy.
 *
 * You should turn it off until the player has consented to advertising tracking, and back on once
 * they have.
 * [[Important: On iOS this is not the whole story. Apple's App Tracking Transparency prompt governs
 * whether the IDFA is available at all, so enabling collection here does nothing if the player has
 * not granted tracking permission through ATT.]]
 * @param {Bool} enabled `true` to allow collection, `false` to prevent it.
 * @function_end
 */

/**
 * @function fb_advertiser_id_collection_enabled
 * @desc This function returns whether advertising identifier collection is currently allowed. See
 * ${function.fb_set_advertiser_id_collection_enabled} for more details.
 * @returns {Bool} `true` if collection is allowed, `false` otherwise.
 * @function_end
 */

/**
 * @function fb_set_event_data_usage_limited
 * @desc This function marks every App Event that is sent from this point on as limited-use, which
 * tells Meta that it may use the data for measurement and analytics but not for ad targeting or
 * audience building.
 *
 * This is the coarse switch. For the finer-grained, per-region control that
 * [Limited Data Use](https://developers.facebook.com/docs/marketing-apis/data-processing-options)
 * defines, you should use ${function.fb_set_data_processing_options} instead.
 * @param {Bool} enabled `true` to limit how Meta may use the event data, `false` for the default.
 * @returns {Enum.FacebookError} ${constant.FacebookError}.Ok on success, or
 * ${constant.FacebookError}.NotInitialized on Android if ${function.fb_initialize} has not completed
 * yet. On iOS the setting applies whatever state the SDK is in, so Ok is always returned.
 * @function_end
 */

/**
 * @function fb_event_data_usage_limited
 * @desc This function returns whether App Event data is currently marked as limited-use. See
 * ${function.fb_set_event_data_usage_limited} for more details.
 * @returns {Bool} `true` if event data usage is limited, `false` otherwise. Note that it returns
 * `false` on Android when the SDK has not been initialised yet.
 * @function_end
 */

/**
 * @function fb_set_data_processing_options
 * @desc This function sets Meta's
 * [Data Processing Options](https://developers.facebook.com/docs/marketing-apis/data-processing-options),
 * which are the mechanism used to comply with the CCPA and with similar regional privacy laws.
 * Passing in `["LDU"]` puts the player into Limited Data Use, where Meta processes their data as a
 * service provider instead of using it for its own advertising purposes.
 *
 * The `country` and `state` arguments are Meta's own numeric geography codes. You can pass `0` for
 * both to have Meta infer the location from the request's IP address, which is the usual choice.
 * Passing in an **empty** options array turns Limited Data Use back off.
 * [[Note: This should be called before ${function.fb_initialize} if the player is already known to
 * require Limited Data Use, so that it applies to the SDK's own automatic events as well.]]
 * @param {Array[String]} options The data processing options, for example `["LDU"]`. An empty array
 * clears them.
 * @param {Real} country Meta's country code, or `0` to let Meta infer it. `1` is the United States.
 * @param {Real} state Meta's state code, or `0` to let Meta infer it. `1000` is California.
 * @example
 * ```gml
 * // Enable Limited Data Use, letting Meta infer the geography.
 * fb_set_data_processing_options(["LDU"], 0, 0);
 *
 * // Enable it explicitly for California, USA.
 * fb_set_data_processing_options(["LDU"], 1, 1000);
 *
 * // Turn it back off.
 * fb_set_data_processing_options([], 0, 0);
 * ```
 * @function_end
 */

/**
 * @module settings
 * @title Privacy Settings
 * @desc The switches that control what Meta's SDK collects and how Meta may use it. Everything here
 * is about consent and regional privacy law rather than about gameplay, and several of these are
 * worth setting **before** you call ${function.fb_initialize}.
 *
 * @section_func
 * @desc Privacy and data-usage settings.
 * @ref fb_set_auto_log_app_events_enabled
 * @ref fb_auto_log_app_events_enabled
 * @ref fb_set_advertiser_id_collection_enabled
 * @ref fb_advertiser_id_collection_enabled
 * @ref fb_set_event_data_usage_limited
 * @ref fb_event_data_usage_limited
 * @ref fb_set_data_processing_options
 * @section_end
 *
 * @module_end
 */
