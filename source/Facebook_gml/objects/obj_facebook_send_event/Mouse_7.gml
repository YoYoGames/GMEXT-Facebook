event_inherited();

var parameters = [
    new FacebookEventParameterValue(
        FacebookAppEventParameter.ContentId,
        "ContentIdTest",
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
        3,
        true
    )
];

// The current generated Android interface transports the enum as a list.
var sent = fb_send_event(
    [FacebookAppEvent.AddedToWishlist],
    123,
    parameters
);

if (sent)
{
    show_debug_message(
        "Facebook App Event sent."
    );
}
else
{
    show_message_async(
        "Facebook App Event could not be sent."
    );
}
