
randomize()

// This file will not exist in your project so you might want to hardcode the
// search_url manually to match the url you are using for retrieving the token
// back to the application (explanation below)
var _buff = buffer_load(".env");
var _data_str = buffer_read(_buff, buffer_string);
buffer_delete(_buff);

var _data = json_parse(_data_str);

search_url = _data.oauth_search_url;

// The following call will initialize the oauth process with the facebook oauth endpoint
// The oauth code will then be sent to the redirect url provided in the extensions options
// this token needs to then be exchanged into a token using GET method on the exchange endpoint:
// 
// - https://graph.facebook.com/v21.0/oauth/access_token
// 
// passing the following query parameters:
//
// - code: <the code that provided by the Facebook API>
// - redirect_uri: <the same url used in the extension options>
// - client_secret: <the client secret can be obtained from the Facebook dashboard>
// - client_id: <the app id from the extension options>
//
// the response from the server will be a json object containing the oauth token.
//
// For demo purposes and in order to simulate what a server side authentication might look like
// we are using two Firebase Cloud functions:
// 
// - 'redirect_url' is responsible for receiving the code from Facebook API and exchange it for 
//                  the actual auth token (url is placed in the redirect URL of the extension options) 
// - 'search_url' used to query the token given a state code, this is an example and doesn't need
//                need to follow these exact steps (the url is read from a '.env' file for privacy reasons)
//

// This state code will be shared across to the redirect url so is the ideal way to 
// create a match between the request and obtained code|token in the server side.
state = __facebook_signin_state_create(32, "123456789");

fb_login_oauth(state);

search_request = undefined;
search_tries = 10;