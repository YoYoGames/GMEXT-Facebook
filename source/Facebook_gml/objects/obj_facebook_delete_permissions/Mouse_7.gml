event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

if (!fb_is_logged_in())
{
    show_message_async("Log in before deleting Facebook permissions.");
    exit;
}

// A successful DELETE /me/permissions request invalidates the current token.
// The user must log in again afterward.
var _error = fb_graph_request(
    "me/permissions",
    FacebookHttpMethod.Delete,
    [],
    function(result, response_text)
    {
        if (result.success)
        {
            show_debug_message("Facebook permissions deleted.");
            fb_logout();
        }
        else
        {
            show_message_async(
                "Could not delete Facebook permissions:\n"
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook permission delete could not be started (error "
        + string(_error)
        + ")."
    );
}
