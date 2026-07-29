event_inherited();

if (os_type == os_android || os_type == os_ios)
{
    fb_login(
        ["public_profile"],
        function(result)
        {
            if (result.success)
            {
                show_debug_message(
                    "Facebook login successful."
                );

                show_debug_message(
                    "Facebook user: " + result.user_id
                );

                show_debug_message(
                    "Facebook token: " + result.access_token
                );

                show_debug_message(
                    "Granted permissions: "
                    + json_stringify(result.granted_permissions)
                );

                show_debug_message(
                    "Declined permissions: "
                    + json_stringify(result.declined_permissions)
                );
            }
            else if (
                result.status
                == FacebookOperationStatus.Cancelled
            )
            {
                show_debug_message(
                    "Facebook login cancelled."
                );
            }
            else
            {
                show_message_async(
                    "Facebook login failed:\n"
                    + result.error_message
                );
            }
        }
    );
}
else
{
    show_message_async(
        "The GMFacebook native extension supports Android and iOS."
    );
}
