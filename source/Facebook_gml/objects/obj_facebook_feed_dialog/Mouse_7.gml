event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

var _error = fb_dialog(
    "https://developers.facebook.com/docs/sharing/",
    function(result, post_id)
    {
        if (result.success)
        {
            show_debug_message("Facebook share dialog completed.");

            // Meta only returns a post id when the app holds publish
            // permissions, so undefined here is the normal case.
            if (!is_undefined(post_id))
            {
                show_debug_message("Facebook post ID: " + post_id);
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
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

if (_error == FacebookError.ShareInProgress)
{
    show_debug_message("A Facebook share dialog is already open.");
}
else if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook share dialog could not be opened (error "
        + string(_error)
        + ")."
    );
}
