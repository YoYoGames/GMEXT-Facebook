
//show_debug_message(json_encode(async_load))
if(async_load[?"status"] != 0) exit

if(search_request == async_load[? "id"])
{
	// This is always a json encoded string
	var _data = json_parse(async_load[?"result"])

	if (struct_exists(_data, "errorCode"))
	{
		if (--search_tries > 0) {
			alarm[0] = game_get_speed(gamespeed_fps);
		}
		else {
			var _map = ds_map_create();
			_map[? "type"] = "fb_login_oauth_token";
			_map[? "success"] = false;
			event_perform_async(ev_async_social, _map);
			instance_destroy();
		}
		return;
	}

	var _map = ds_map_create();
	_map[? "token"] = _data.access_token;
	_map[? "type"] = "fb_login_oauth_token";
	_map[? "success"] = true;
	event_perform_async(ev_async_social, _map);
	instance_destroy();
}
