event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

if (fb_status() == FacebookLoginStatus.Processing)
{
    show_debug_message("A Facebook login request is already running.");
    exit;
}

if (fb_is_logged_in())
{
    show_debug_message(
        "A Facebook user is already logged in: " + fb_user_id()
    );
    exit;
}

var _error = fb_login(
    ["public_profile"],
    function(result, login_info)
    {
        if (result.success)
        {
            show_debug_message("Facebook login successful.");
            show_debug_message("Facebook user: " + login_info.user_id);
            show_debug_message(
                "Access token received: "
                + string(login_info.access_token != "")
            );
            show_debug_message(
                "Permissions: "
                + json_stringify(login_info.permissions)
            );
            show_debug_message(
                "Declined permissions: "
                + json_stringify(login_info.declined_permissions)
            );
        }
        else if (result.status == FacebookOperationStatus.Cancelled)
        {
            show_debug_message("Facebook login cancelled.");
        }
        else
        {
            show_message_async(
                "Facebook login failed:\n"
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

// The callback never runs when the call is rejected up front, so this is the
// only place a pre-flight failure can be reported.
if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook login could not be started (error "
        + string(_error)
        + ")."
    );
}
