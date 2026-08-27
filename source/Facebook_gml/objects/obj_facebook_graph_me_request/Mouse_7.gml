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

// Generated extension records use an empty constructor. Set each field
// explicitly, then pass the record inside the parameter array.
var parameter = new FacebookNamedValue();
parameter.name = "fields";
parameter.string_value = "id,name,picture";
parameter.number_value = 0;
parameter.use_number = false;

var parameters = [parameter];

var _error = fb_graph_request(
    "me",
    FacebookHttpMethod.Get,
    parameters,
    function(result, response_text)
    {
        if (result.success)
        {
            show_debug_message("Facebook /me response: " + response_text);
        }
        else
        {
            // sdk_error_code is Meta's own Graph error number when the failure
            // came back from the API, and undefined otherwise.
            show_message_async(
                "Facebook /me request failed:\n"
                + (result.error_message ?? "Unknown Facebook error.")
                + (is_undefined(result.sdk_error_code)
                    ? ""
                    : "\nGraph error code: "
                        + string(result.sdk_error_code))
            );
        }
    }
);

if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook /me request could not be started (error "
        + string(_error)
        + ")."
    );
}
