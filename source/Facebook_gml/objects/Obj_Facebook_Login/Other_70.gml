
event_inherited()

if(async_load[?"type"] == "facebook_login_result")
{
	var status = async_load[?"status"]
    if(status == "success")
    {
		show_debug_message("Facebook Token: " + fb_accesstoken())
    }
    else if(status == "cancelled")
    {
		
    }
    else if(status == "error")
    {
        var exception = ds_map_find_value(async_load,"exception");
		show_message_async(exception);
    }
}

