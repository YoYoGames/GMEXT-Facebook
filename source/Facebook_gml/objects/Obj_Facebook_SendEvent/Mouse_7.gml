event_inherited();


///////////////OLD WAY... (still working)

//// Set up parameters list
//var paramList = ds_list_create();
//ds_list_add(paramList, 
//			FacebookExtension2_PARAM_CONTENT_ID, "ContentIdTest",
//			FacebookExtension2_PARAM_CURRENCY, "GBP",
//			FacebookExtension2_PARAM_NUM_ITEMS, 3);

//// Send our event
//fb_send_event(FacebookExtension2_EVENT_ADDED_TO_WISHLIST, 123, real(paramList));

//// Destroy parameters list
//ds_list_destroy(paramList);



///////////////NEW WAY!!! more events! check a///////////////NEW WAY!!! (more events! check FACEBOOK_EVENT_PARAM and and FACEBOOK_EVENT_PARAM

var paramList = ds_list_create();
ds_list_add(paramList, 
			FACEBOOK_EVENT_PARAM.CONTENT_ID, "ContentIdTest",
			FACEBOOK_EVENT_PARAM.CURRENCY, "GBP",
			FACEBOOK_EVENT_PARAM.NUM_ITEMS, 3);

// Send our event
fb_send_event_string(FACEBOOK_EVENT_NAME.ADDED_TO_WISHLIST, 123, real(paramList));

// Destroy parameters list
ds_list_destroy(paramList);

