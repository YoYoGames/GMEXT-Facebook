event_inherited();

var permission = "publish_actions"
if(fb_check_permission(permission))
{
	show_debug_message("Permission already granted")
}
else
{
    var permsList = ds_list_create();
    ds_list_add(permsList,permission);
    fb_request_publish_permissions(permsList);
    ds_list_destroy(permsList);
}

