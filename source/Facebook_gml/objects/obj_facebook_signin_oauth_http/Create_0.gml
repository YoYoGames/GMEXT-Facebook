
#macro FACEBOOK_OAUTH_ENDPOINT "https://www.facebook.com/v21.0/dialog/oauth"

client_id = extension_get_option_value("FacebookExtension2", "oauthClientId");
redirect_uri = extension_get_option_value("FacebookExtension2", "oauthRedirectUrl");

auth_url = FACEBOOK_OAUTH_ENDPOINT +
           "?redirect_uri=" + __facebook_signin_url_encode(redirect_uri) +
           "&client_id=" + __facebook_signin_url_encode(client_id) +
		   "&state=" + state;

url_open(auth_url);