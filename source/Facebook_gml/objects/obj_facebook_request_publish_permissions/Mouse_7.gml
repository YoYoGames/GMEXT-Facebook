event_inherited();

fb_request_publish_permissions(
    ["publish_actions"],
    function(result)
    {
        // The current GMFacebook implementation keeps this function only
        // for source compatibility. Meta no longer supports publish_actions.
        if (result.success)
        {
            show_debug_message(
                "Facebook publish permission granted."
            );
        }
        else
        {
            show_message_async(
                "Facebook publish permissions are unavailable:\n"
                + result.error_message
            );
        }
    }
);
