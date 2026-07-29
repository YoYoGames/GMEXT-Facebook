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

fb_dialog(
    "https://developers.facebook.com/docs/sharing/",
    function(result)
    {
        if (result.success)
        {
            show_debug_message("Facebook share dialog completed.");

            if (result.post_id != "")
            {
                show_debug_message(
                    "Facebook post ID: " + result.post_id
                );
            }
        }
        else if (result.status == FacebookOperationStatus.Cancelled)
        {
            show_debug_message("Facebook share dialog cancelled.");
        }
        else
        {
            show_message_async(
                "Facebook share dialog failed:\n"
                + result.error_message
            );
        }
    }
);
