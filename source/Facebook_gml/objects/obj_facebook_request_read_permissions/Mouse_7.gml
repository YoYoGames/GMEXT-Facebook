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
    show_message_async("Log in before requesting more permissions.");
    exit;
}

// Only request permissions that your Meta app actually uses and is approved
// to request. Add reviewed permissions to this array when needed.
var desired_permissions = ["email"];
var permissions = [];

for (var i = 0; i < array_length(desired_permissions); ++i)
{
    var permission = desired_permissions[i];

    if (!fb_check_permission(permission))
    {
        array_push(permissions, permission);
    }
}

if (array_length(permissions) == 0)
{
    show_debug_message(
        "All requested Facebook permissions are already granted."
    );
    exit;
}

fb_request_read_permissions(
    permissions,
    function(result)
    {
        if (result.success)
        {
            // These arrays describe this permission request, not the token's
            // complete historical permission set.
            show_debug_message("Facebook read permissions updated.");
            show_debug_message(
                "Granted: "
                + json_stringify(result.granted_permissions)
            );
            show_debug_message(
                "Declined: "
                + json_stringify(result.declined_permissions)
            );
        }
        else if (result.status == FacebookOperationStatus.Cancelled)
        {
            show_debug_message("Facebook permission request cancelled.");
        }
        else
        {
            show_message_async(
                "Facebook permission request failed:\n"
                + result.error_message
            );
        }
    }
);
