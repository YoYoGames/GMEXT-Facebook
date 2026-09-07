event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

if (!fb_is_logged_in())
{
    show_message_async("Log in before refreshing the access token.");
    exit;
}

var _error = fb_refresh_access_token(
    function(result, login_info)
    {
        if (result.success)
        {
            show_debug_message("Facebook access token refreshed.");
            show_debug_message("Facebook user: " + login_info.user_id);
            show_debug_message(
                "Access token received: "
                + string(login_info.access_token != "")
            );
        }
        else
        {
            show_message_async(
                "Facebook token refresh failed:\n"
                + (result.error_message ?? "Unknown Facebook error.")
            );
        }
    }
);

if (_error != FacebookError.Ok)
{
    show_message_async(
        "Facebook token refresh could not be started (error "
        + string(_error)
        + ")."
    );
}
