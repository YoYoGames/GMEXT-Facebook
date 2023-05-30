event_inherited();

// Set up parameters list
var paramList = ds_list_create();
ds_list_add(paramList, 
			FacebookExtension2_PARAM_CONTENT_ID, "ContentIdTest",
			FacebookExtension2_PARAM_CURRENCY, "GBP",
			FacebookExtension2_PARAM_NUM_ITEMS, 3);

// Send our event
fb_send_event(FacebookExtension2_EVENT_ADDED_TO_WISHLIST, 123, paramList);

// Destroy parameters list
ds_list_destroy(paramList);