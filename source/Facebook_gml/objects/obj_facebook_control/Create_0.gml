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

var _error = fb_initialize(
    function(result)
    {
        facebook_initialized = result.success;

        if (result.success)
        {
            facebook_initialization_error = "";
            show_debug_message("Facebook SDK initialized.");
        }
        else
        {
            // error_message is only present on a failure, and is absent even
            // then when the user simply cancelled.
            facebook_initialization_error =
                result.error_message ?? "Unknown Facebook error.";

            show_debug_message(
                "Facebook initialization failed: "
                + facebook_initialization_error
            );
        }
    }
);

// Anything that fails before Meta's SDK is reached is reported here instead,
// and the callback above never runs.
if (_error != FacebookError.Ok)
{
    facebook_initialization_error =
        "Facebook initialization rejected: " + string(_error);

    show_debug_message(facebook_initialization_error);
}
