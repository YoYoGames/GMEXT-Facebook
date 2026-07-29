/// @description Initialize GMFacebook

facebook_initialized = false;
facebook_initialization_error = "";

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
