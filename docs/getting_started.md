@title Getting Started

# Getting Started

This guide walks you through the recommended order in which to call the functions of the Facebook
extension, from initialisation through to your first Graph API request. You should read
${page.setup} first if you have not yet created your app on Meta's dashboard or installed the
extension, and ${page.extension_options} for what each of the options does.

## Prerequisites

* An app on the Meta developer dashboard, with the Android and/or the iOS platform registered against
it (${page.setup}).
* The extension's **App ID**, **Display Name** and **Client Token** options filled in
(${page.extension_options}).
* An Android or iOS build, as the SDK is native and so none of this will work in the IDE.

## 0. Guard for unsupported targets

This extension is for Android and iOS only. If your project also builds for other targets then you
should gate every call behind an `os_type` check:

```gml
facebook_supported = (os_type == os_android || os_type == os_ios);
```

## 1. Set your privacy switches (optional, before initialisation)

If your consent flow requires the player to opt in before anything at all is reported to Meta, then
you should turn the automatic logging off *before* you initialise, as the SDK logs an activation
event as soon as it starts up:

```gml
fb_set_auto_log_app_events_enabled(false);
fb_set_advertiser_id_collection_enabled(false);
```

You can then turn them back on once the player has consented. See ${module.settings} for the full
set, including Meta's Limited Data Use options.

## 2. Initialise

This should be done once, from a persistent controller object that is created in the very first room.
Most of this extension is asynchronous, and a single long-lived object that owns the callbacks is far
easier to reason about than callbacks scattered across the buttons that started them.

```gml
/// Create event of a persistent controller object
facebook_initialized = false;

var _error = fb_initialize(function(_result)
{
    facebook_initialized = _result.success;

    if (!_result.success)
        show_debug_message("Facebook initialization failed: " + (_result.error_message ?? "Unknown error."));
});

if (_error != FacebookError.Ok)
    show_debug_message("Facebook initialization rejected: " + string(_error));
```

You can also poll ${function.fb_ready} at any time instead of tracking the flag yourself.

## 3. Log the player in

Nothing that needs a user, which means the Graph API, the token and the user ID, will work until the
player has logged in. This should be done from a button that the player presses, and not
automatically on startup.

```gml
if (!fb_ready())
    exit;

var _error = fb_login(["public_profile"], function(_result, _login_info)
{
    if (_result.success)
    {
        show_debug_message("Logged in as " + _login_info.user_id);
        show_debug_message("Granted: " + json_stringify(_login_info.permissions));
        show_debug_message("Declined: " + json_stringify(_login_info.declined_permissions));
    }
    else if (_result.status == FacebookOperationStatus.Cancelled)
    {
        show_debug_message("Facebook login cancelled.");
    }
    else
    {
        show_debug_message("Facebook login failed: " + (_result.error_message ?? "Unknown error."));
    }
});

if (_error == FacebookError.LoginInProgress)
    show_debug_message("A Facebook login is already running.");
```

You should ask for the smallest set of permissions that you actually need, and then ask for any extra
ones later, at the point where the player does the thing that requires them, rather than asking for
all of them at once on the first login. You can check what you already hold with
${function.fb_check_permission}, and note that the player is free to decline, so a permission that
you asked for turning up in `declined_permissions` is a perfectly normal outcome and not an error.

## 4. Do something with the session

```gml
var _parameter = new FacebookNamedValue();
_parameter.name = "fields";
_parameter.string_value = "id,name";
_parameter.number_value = 0;
_parameter.use_number = false;

fb_graph_request("me", FacebookHttpMethod.Get, [_parameter], function(_result, _response_text)
{
    if (!_result.success)
        return;

    var _profile = json_parse(_response_text);
    show_debug_message("Hello, " + _profile.name);
});
```

The other things that you can do with a session are ${function.fb_dialog}, which opens Meta's share
dialog on a link, and the App Events in ${module.app_events}, which, unlike everything else here, do
**not** require a login.

## 5. Handling responses

Every asynchronous function in this extension reports failure in one of two places, and the two are
not interchangeable:

1. **The synchronous return value.** Anything that is rejected before Meta's SDK is reached comes back
immediately as a ${constant.FacebookError}, which covers the SDK not being initialised, no user being
logged in, an argument being empty, or a request of the same kind already being in flight. **When
this is not `Ok`, your callback is never called**, so if you only handle the callback then you will
never hear about any of these at all.
2. **The callback's `result` argument.** Everything that Meta itself reports arrives here as a
${struct.FacebookResult}. You should check `result.success` first. On a failure, `result.status`
separates a user cancellation (${constant.FacebookOperationStatus}.Cancelled, which is not an error
and carries no message) from a real failure, `result.error_message` carries Meta's text, and
`result.sdk_error_code` carries Meta's own numeric code when there was one.

Where a callback has a payload it always arrives as a **second** argument, and it is only present on
success. You should guard it with `is_undefined` if you use it outside the `result.success` branch,
as a successful ${function.fb_dialog} legitimately has no `post_id` unless your app holds publish
permissions.

## 6. Cleanup

There is nothing to destroy or free, as the extension holds no handles. There are two functions that
matter at the end of a session:

* ${function.fb_logout} clears the access token when the player signs out. It does not sign them out
of the Facebook app itself.
* ${function.fb_reset_pending} is a recovery hatch rather than a part of the normal flow. You should
call it if a login or share screen was dismissed in a way that Meta's SDK never reported, leaving
every later call rejected with `LoginInProgress` or `ShareInProgress`. It calls the stuck callbacks
with a `Cancelled` result.

If you use App Events then it is worth calling ${function.fb_flush_events} at a point where the app
may be killed, so that queued events are not lost.

## Testing notes

* Until your app passes App Review, only accounts with a role on the app can log in, and only with
`public_profile`, `email` and `user_friends`. See ${page.dashboard} for more details.
* A login that fails immediately on Android with no visible dialog almost always means that the **Key
Hash** on the dashboard does not match the keystore that signed the build. Both the debug and the
release keystore hash need to be registered.
* A login that fails on iOS almost always means that the **Bundle ID** on the dashboard does not
match the one in the iOS Game Options.
* App Events are batched, so you can call ${function.fb_flush_events} to see them in the Events
Manager within seconds rather than minutes.
