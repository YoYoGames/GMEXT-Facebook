/// @description Initialize GMFacebook and expose demo state

facebook_supported = (os_type == os_android || os_type == os_ios);
facebook_initialized = false;
facebook_initialization_error = "";

facebook_status_text = function(_status)
{
    switch (_status)
    {
        case FacebookLoginStatus.Idle:
            return "Idle";

        case FacebookLoginStatus.Processing:
            return "Processing";

        case FacebookLoginStatus.Failed:
            return "Failed";

        case FacebookLoginStatus.Authorised:
            return "Authorised";
    }

    return "Unknown";
};

if (!facebook_supported)
{
    facebook_initialization_error =
        "GMFacebook supports Android and iOS only.";

    show_debug_message(facebook_initialization_error);
    exit;
}

fb_initialize(
    function(result)
    {
        facebook_initialized = result.success;
        facebook_initialization_error = result.error_message;

        if (result.success)
        {
            show_debug_message("Facebook SDK initialized.");
        }
        else
        {
            show_debug_message(
                "Facebook initialization failed: "
                + result.error_message
            );
        }
    }
);
