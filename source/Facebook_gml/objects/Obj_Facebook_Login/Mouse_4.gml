
event_inherited();


if(os_type == os_android or os_type == os_ios or os_browser != browser_not_a_browser)
{
	var perms = ds_list_create();
	ds_list_add(perms, "public_profile"/*, "user_friends"*/);
	fb_login(perms, FacebookExtension2_LOGIN_TYPE_SYSTEM_ACCOUNT);
	ds_list_destroy(perms);
}
else
{
	instance_create_depth(0, 0, 0, Obj_Facebook_OAuth)
}

