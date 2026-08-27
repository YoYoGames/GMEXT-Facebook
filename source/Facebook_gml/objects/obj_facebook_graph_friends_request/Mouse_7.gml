event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

if (!fb_is_logged_in())
{
    show_message_async("Log in before making a Graph API request.");
    exit;
}

var parameter = new FacebookNamedValue();
parameter.name = "fields";
parameter.string_value = "id,name,picture";
parameter.number_value = 0;
parameter.use_number = false;

var parameters = [parameter];

var _error = fb_graph_request(
    "me/friends",
    FacebookHttpMethod.Get,
    parameters,
    function(result, response_text)
    {
        if (result.success)
        {
            // Only returns friends who also use this app
            // and have granted the required permissions.
            show_debug_message(
                "Facebook friends response: " + response_text
            );
        }
        else
        {
            show_message_async(
                "Facebook friends request failed:\n"
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook friends request could not be started (error "
        + string(_error)
        + ")."
    );
}