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
    "me",
    FacebookHttpMethod.Get,
    parameters,
    function(result)
    {
        if (result.success)
        {
            show_debug_message(
                "Facebook /me response: "
                + result.response_text
            );
        }
        else
        {
            show_message_async(
                "Facebook /me request failed:\n"
                + result.error_message
            );
        }
    }
);
