event_inherited();

fb_refresh_access_token(
    function(result)
    {
        if (result.success)
        {
            show_debug_message(
                "Facebook access token refreshed."
            );

            show_debug_message(
                "Token: " + result.access_token
            );
        }
        else
        {
            show_message_async(
                "Facebook token refresh failed:\n"
                + result.error_message
            );
        }
    }
);
