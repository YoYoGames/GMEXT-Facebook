
if(os_browser != browser_not_a_browser)
if(async_load[?"type"] == "facebook_login_result")
{
	var status = async_load[?"status"]
    if(status == "success")
    {
		string_send = fb_accesstoken()
		
		client_auth_socket = network_create_socket(network_socket_type);
		network_connect_raw_async(client_auth_socket,"localhost",port);
    }
}

