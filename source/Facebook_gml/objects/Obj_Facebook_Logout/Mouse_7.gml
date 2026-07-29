event_inherited();

if (os_type != os_android && os_type != os_ios)
{
    show_message_async("GMFacebook supports Android and iOS only.");
    exit;
}

if (!fb_is_logged_in())
{
    show_debug_message("No Facebook user is currently logged in.");
    exit;
}

fb_logout();
show_debug_message("Facebook user logged out.");
