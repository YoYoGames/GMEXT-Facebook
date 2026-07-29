event_inherited();

// A successful request invalidates the current user access token.
// The user must log in again afterward.
fb_graph_request(
    "me/permissions",
    FacebookHttpMethod.Delete,
    [],
    function(result)
    {
        if (result.success)
        {
            show_debug_message(
                "Facebook permissions deleted."
            );

            fb_logout();
        }
        else
        {
            show_message_async(
                "Could not delete Facebook permissions:\n"
                + result.error_message
            );
        }
    }
);
