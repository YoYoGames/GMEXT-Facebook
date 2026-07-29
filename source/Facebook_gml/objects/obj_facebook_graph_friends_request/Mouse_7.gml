event_inherited();

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
