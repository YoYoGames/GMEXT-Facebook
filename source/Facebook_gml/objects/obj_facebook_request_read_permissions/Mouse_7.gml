event_inherited();

var permsList = ds_list_create();

if(!fb_check_permission("user_likes"))
    ds_list_add(permsList, "user_likes");

if(!fb_check_permission("email"))
    ds_list_add(permsList, "email");

if(ds_list_size(permsList))
   fb_request_read_permissions(permsList);
else
	show_debug_message("Read not requested")

ds_list_destroy(permsList);
