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

// fb_login is also how additional read permissions are requested on an
// existing session - Meta's SDK handles both cases through the same call.
var _error = fb_login(
    permissions,
    function(result, login_info)
    {
        if (result.success)
        {
            // These are the token's full permission sets, not just what this
            // one request changed.
            show_debug_message("Facebook read permissions updated.");
            show_debug_message(
                "Permissions: "
                + json_stringify(login_info.permissions)
            );
            show_debug_message(
                "Declined: "
                + json_stringify(login_info.declined_permissions)
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
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

if (_error == FacebookError.LoginInProgress)
{
    show_debug_message("A Facebook login request is already running.");
}
else if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook permission request could not be started (error "
        + string(_error)
        + ")."
    );
}
