event_inherited();

//If the call is successful, 
//any user access token for the person will be invalidated and they will have to log in again
fb_graph_request(string("me/permissions"), "DELETE", -1);
