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
