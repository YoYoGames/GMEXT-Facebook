
show_debug_message(json_encode(async_load))
if(search_request == async_load[?"id"])
{
	if(async_load[?"result"] == "NO_EXISTS")
	{
		alarm[0] = room_speed
		exit
	}
	
	var _code = async_load[?"result"]
	show_debug_message("_code: " + _code)
}

