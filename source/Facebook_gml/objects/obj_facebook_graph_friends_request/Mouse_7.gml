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

if (!fb_is_logged_in())
{
    show_message_async("Log in before making a Graph API request.");
    exit;
}

var parameters = [
    new FacebookNamedValue(
        "fields",
        "id,name,picture",
        0,
        false
    )
];

fb_graph_request(
    "me/friends",
    FacebookHttpMethod.Get,
    parameters,
    function(result)
    {
        if (result.success)
        {
            // The endpoint only returns friends who also use this app.
            show_debug_message(
                "Facebook friends response: "
                + result.response_text
            );
        }
        else
        {
            show_message_async(
                "Facebook friends request failed:\n"
                + result.error_message
            );
        }
    }
);
