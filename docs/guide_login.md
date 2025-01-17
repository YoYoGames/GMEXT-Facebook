@title Login Guide

This guide contains information on how to use [Facebook Login](https://developers.facebook.com/docs/facebook-login/).

The Login functionality of the Facebook extension is supported on all platforms by the extension. On [Android](https://developers.facebook.com/docs/facebook-login/android), [iOS](https://developers.facebook.com/docs/facebook-login/ios) and [HTML5](https://developers.facebook.com/docs/facebook-login/web) it makes use of the SDK, on other platforms OAuth can be used.

## Login Flow

### Android, iOS and HTML5

The following page of the Facebook developer documentation describes how to create a Facebook app and set it up to use the login functionality:

> [Facebook Login Use Case](https://developers.facebook.com/docs/development/create-an-app/facebook-login-for-games-use-case)

Once you've set up the app in the App Dashboard you can add code to your project for the login functionality. On the platforms supported by the SDK, you can use the function ${function.fb_login}:

```gml
var _permissions = ds_list_create();
ds_list_add(perms, "public_profile", "user_friends");
fb_login(real(_permissions));
ds_list_destroy(_permissions);
```

This function will bring up a login dialog. A ${event.social} is then triggered which provides information about the result.

### OAuth

For browser-based login for a web or desktop app without using the SDKs, or a login flow using entirely server-side code, Facebook has the option to build a login flow for yourself by using browser redirects. An overview of how to do this is provided on the following page:

> [Manually Build a Login Flow](https://developers.facebook.com/docs/facebook-login/guides/advanced/manual-flow)

[[Note: Before you can start using this login method, you need to set the **App ID** and the **OAuth Redirect URL** in the [Extension Options](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Extensions.htm#extension_options).]]

The Facebook extension provides the ${function.fb_login_oauth} function which starts this OAuth login flow by invoking the login dialog in a browser window:
```gml
/// Create Event
search_request = undefined;
search_tries = 50;

state = __facebook_signin_state_create(32, "123456789");

fb_login_oauth(state);
```

In the browser window the user can grant permissions to the scopes requested in the function call.
If the user grants the app permission for the requested scopes on their behalf, the Facebook server sends a code to the **OAuth Redirect URL** on your own server, which then exchanges it for the actual access token.

The ${function.fb_login_oauth} triggers a ${event.social} when it finishes:
```gml
/// Async Social Event
if (async_load[? "type"] == "fb_login_oauth") {
	// Start polling our own server at regular intervals for the token
	alarm[0] = game_get_speed(gamespeed_fps);
}
```

The ${event.social} indicates that the dialog has been invoked. From here on, you can check with your own server periodically to see if it has the token.
This can be done by, e.g., triggering a ${var.alarm} after a second. In the alarm an HTTP `"POST"` request is made using ${function.http_request}. The state number from the original call to ${function.fb_login_oauth} can be used to let the server know which login request this request is for. The code for this may look as follows: 
```gml
/// Alarm 0 Event
var _headers = ds_map_create();
ds_map_add(_headers, "Content-Type", "application/json");

var _body = json_stringify({ state: state });

search_request = http_request(search_url, "POST", _headers, _body);
ds_map_destroy(_headers);
```

The HTTP request will trigger a ${event.http} in which you can check if the token is present: 
```gml
/// Async HTTP Event
if(async_load[?"status"] != 0) { exit; }
if(async_load[? "id"] != search_request) { exit; }

var _data;
try {
    // This should always be a JSON encoded string unless the
    // server couldn't be reached for some reason.
    _data = json_parse(async_load[? "result"]);
}
catch (_error) {
    _data = { errorCode: 503, errorMessage: "Server couldn't be reached." };
    show_debug_message(_data);
}

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
```

In this event the result is parsed into a struct using ${function.json_parse}. If an error occurred, a new HTTP request is sent after a 1 second wait. The number of tries is limited.
If no error occurred, the token is read from the struct and a ${event.social} is triggered.