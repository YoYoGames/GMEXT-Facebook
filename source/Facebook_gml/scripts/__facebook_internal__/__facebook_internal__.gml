
/// @ignore
function __facebook_internal__() {
	throw "__facebook_internal__ :: cannnot be call as a function";
}

/// @ignore
function __facebook_signin_url_encode(_orig) {
    
	static _output_buffer = buffer_create(1, buffer_grow, 1);
	
    static _hex = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];

	buffer_seek(_output_buffer, buffer_seek_start, 0);
	
	var _i = 1;
    repeat (string_length(_orig)) {
        //var _code = buffer_read(_input_buffer, buffer_u8);
		var _char = string_char_at(_orig, _i++);
		var _code = ord(_char);

        // Check if character is unreserved (ALPHA / DIGIT / "-" / "." / "_" / "~")
        if ((_code >= 65 && _code <= 90) ||    // A-Z
            (_code >= 97 && _code <= 122) ||   // a-z
            (_code >= 48 && _code <= 57) ||    // 0-9
            _code == 45 ||                    // -
            _code == 46 ||                    // .
            _code == 95 ||                    // _
            _code == 126) {                   // ~
			// Write directly to the output buffer
            buffer_write(_output_buffer, buffer_u8, _code);
        } else {
            // Use bitwise operations to get high and low nibbles
            var _high = (_code & $F0) >> 4;
            var _low = _code & $0F;
			buffer_write(_output_buffer, buffer_text, "%" + _hex[_high] + _hex[_low]);
        }
    }
	buffer_write(_output_buffer, buffer_u8, 0);
	
    return buffer_peek(_output_buffer, 0, buffer_string);
}

function __facebook_signin_state_create(_digits = 32, _allowed_chars = "0123456789")
{	
	var _length = string_length(_allowed_chars);
	if (_length != string_byte_length(_allowed_chars)) {
		show_debug_message(_GMFUNCTION_ + " :: only ASCII characters are allowed.");
		return "";
	}
	
	if (_length == 0) {
		show_debug_message(_GMFUNCTION_ + " :: allowed characters is an empty string");
		return "";
	}
	
	var _out_buff = buffer_create(_digits, buffer_fixed, 1);
	var _input_buff = buffer_create(1, buffer_grow, 1);
	
	buffer_write(_input_buff, buffer_text, _allowed_chars); // don't write ending byte
	
	var _input_size = buffer_tell(_input_buff);
	repeat(_digits) {
		buffer_write(_out_buff, buffer_u8, buffer_peek(_input_buff, irandom(_input_size - 1), buffer_u8));
	}
	
	var _code = buffer_peek(_out_buff, 0, buffer_string);
	buffer_delete(_out_buff);
	buffer_delete(_input_buff);
	
	return _code;
}

function fb_login_oauth(_state) {
	with(instance_create_depth(0, 0, 0, obj_facebook_signin_oauth_http, { state: _state })) {
		
		var _async_load = ds_map_create();
		_async_load[? "type"] = "fb_login_oauth";
		_async_load[? "redirect_uri"] = redirect_uri;
		_async_load[? "cliend_id"] = client_id;
		_async_load[? "state"] = _state;
	
		event_perform_async(ev_async_social, _async_load);
	}
}

