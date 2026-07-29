event_inherited();

var permissions = [];

if (!fb_check_permission("user_likes"))
{
    array_push(permissions, "user_likes");
}

if (!fb_check_permission("email"))
{
    array_push(permissions, "email");
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
            show_debug_message(
                "Facebook read permissions updated."
            );

            show_debug_message(
                "Granted: "
                + json_stringify(result.granted_permissions)
            );

            show_debug_message(
                "Declined: "
                + json_stringify(result.declined_permissions)
            );
        }
        else if (
            result.status
            == FacebookOperationStatus.Cancelled
        )
        {
            show_debug_message(
                "Facebook permission request cancelled."
            );
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
