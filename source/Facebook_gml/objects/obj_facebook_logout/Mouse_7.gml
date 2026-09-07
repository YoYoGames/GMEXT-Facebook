event_inherited();

// obj_facebook_control locks every button until the SDK is usable.
if (locked) exit;

if (!fb_is_logged_in())
{
    show_debug_message("No Facebook user is currently logged in.");
    exit;
}

fb_logout();
show_debug_message("Facebook user logged out.");
