event_inherited();

if (os_type != os_android && os_type != os_ios)
{
    show_message_async("GMFacebook supports Android and iOS only.");
    exit;
}

// Kept only to demonstrate the compatibility API. Meta removed legacy
// publish permissions such as publish_actions.
fb_request_publish_permissions(
    ["publish_actions"],
    function(result)
    {
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
