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

var parameters = [
    new FacebookEventParameterValue(
        FacebookAppEventParameter.ContentId,
        "wishlist_item_001",
        0,
        false
    ),

    new FacebookEventParameterValue(
        FacebookAppEventParameter.ContentType,
        "product",
        0,
        false
    ),

    new FacebookEventParameterValue(
        FacebookAppEventParameter.Currency,
        "GBP",
        0,
        false
    ),

    new FacebookEventParameterValue(
        FacebookAppEventParameter.NumItems,
        "",
        1,
        true
    )
];

// FacebookAppEvent is now passed directly, not inside a one-element array.
var sent = fb_send_event(
    FacebookAppEvent.AddedToWishlist,
    123.00,
    parameters
);

if (sent)
{
    // Useful in a test object. Production code normally lets the SDK batch.
    fb_flush_events();
    show_debug_message(
        "Facebook App Event queued; an immediate flush was requested."
    );
}
else
{
    show_message_async(
        "Facebook App Event could not be sent."
    );
}
