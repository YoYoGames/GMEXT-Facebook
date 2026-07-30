event_inherited();

if (os_type != os_android && os_type != os_ios)
{
    show_message_async("GMFacebook supports Android and iOS only.");
    exit;
}

if (!fb_ready())
{
    show_message_async("Facebook SDK is not initialized yet.");
    exit;
}

var parameters = [];

var parameter = new FacebookEventParameterValue();
parameter.key = FacebookAppEventParameter.ContentId;
parameter.string_value = "wishlist_item_001";
parameter.number_value = 0;
parameter.use_number = false;
array_push(parameters, parameter);

parameter = new FacebookEventParameterValue();
parameter.key = FacebookAppEventParameter.ContentType;
parameter.string_value = "product";
parameter.number_value = 0;
parameter.use_number = false;
array_push(parameters, parameter);

parameter = new FacebookEventParameterValue();
parameter.key = FacebookAppEventParameter.Currency;
parameter.string_value = "GBP";
parameter.number_value = 0;
parameter.use_number = false;
array_push(parameters, parameter);

parameter = new FacebookEventParameterValue();
parameter.key = FacebookAppEventParameter.NumItems;
parameter.string_value = "";
parameter.number_value = 1;
parameter.use_number = true;
array_push(parameters, parameter);

// Meta's native logEvent APIs return void. The wrapper now follows that
// behavior instead of inventing a Boolean result.
fb_send_event(
    FacebookAppEvent.AddedToWishlist,
    123.00,
    parameters
);

// Useful in a test object. Production code normally lets the SDK batch.
fb_flush_events();
show_debug_message(
    "Facebook App Event queued; an immediate flush was requested."
);
