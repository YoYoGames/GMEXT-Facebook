
show_debug_message("ASYNC SOCIAL: " + json_encode(async_load));

switch(async_load[?"type"])
{

	//This may still be returned by html5, it won't be by the iOS or Android extensions
	case "facebook_permission_request":

	    var requestId = async_load[?"requestId"];
	    var result = async_load[?"result"];
	    var msg = "Permission request result:";
	    msg += "#result: " + string(result);
	    msg += "#requestId: " + string(requestId);
    
	    if(string(result) = "error")
	    {
	        var errorMsg = async_load[?"error"];
	        var errorCode = async_load[?"error_code"];
	        msg += "#Error: " + string(errorMsg);
	        //msg += "#ErrorCode: " + string(errorCode);
	    }
	    show_message_async(msg);
		
	break
	

	case "facebook_login_result":

	    var msg = "Login request result:\n";
	    msg += "#status: " + async_load[?"status"] + "\n"
	    msg += "#requestId: " + string(async_load[?"requestId"]) + "\n"
    
	    if(async_load[?"status"] == "success")
	    {
	        if(ds_map_exists(async_load,"publish_actions"))
	            msg += "#publish_actions:" + async_load[?"publish_actions"] + "\n"
		
			if(ds_map_exists(async_load,"email"))
	            msg += "#email permission:" + async_load[?"email"] + "\n"
        
			if(ds_map_exists(async_load,"user_likes"))
	            msg += "#user_likes permission:" + async_load[?"user_likes"] + "\n"
		
			if(ds_map_exists(async_load,"public_profile"))
	            msg += "#public_profile permission:" + async_load[?"public_profile"] + "\n"
		
			if(ds_map_exists(async_load,"user_friends"))
	            msg += "#user_friends permission:" + async_load[?"user_friends"] + "\n"
	    }
	    else if(async_load[?"status"] == "cancelled")
	    {
			msg += "#User Cancelled \n"
	    }
	    else if(async_load[?"status"] == "error")
	    {
	        var exception = async_load[?"exception"]
	        msg += "#exception : " + exception  + "\n"
	    }
	
	    show_message_async(msg);
		
	break
	
	case "fb_graph_request":
	case "fb_dialog":
		
	break
}
