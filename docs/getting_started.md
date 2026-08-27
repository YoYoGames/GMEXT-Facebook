@title Getting Started

# Getting Started

This guide walks through the recommended call order for the Facebook extension, from initialization to
your first Graph API request. See ${page.setup} first if you have not yet created your app on Meta's
dashboard or installed the extension, and ${page.extension_options} for what each option does.

## Prerequisites

* An app on the Meta developer dashboard, with the Android and/or iOS platform registered against it
(${page.setup}).
* The extension's **App ID**, **Display Name** and **Client Token** options filled in
(${page.extension_options}).
* An Android or iOS build. The SDK is native, so none of this works in the IDE.

## 0. Guard for unsupported targets

This extension is Android and iOS only. If your project also builds for other targets, gate every call
behind an `os_type` check:

```gml
facebook_supported = (os_type == os_android || os_type == os_ios);
```

## 1. Set your privacy switches (optional, before initialization)

If your consent flow requires the player to opt in before anything is reported to Meta, turn the
automatic logging off *before* initializing - the SDK logs an activation event as soon as it starts up:

```gml
fb_set_auto_log_app_events_enabled(false);
fb_set_advertiser_id_collection_enabled(false);
```

Turn them back on once the player has consented. See ${module.settings} for the full set, including
Meta's Limited Data Use options.

## 2. Initialize

Do this once, from a persistent controller object created in the very first room. Most of this
extension is asynchronous, so a single long-lived object that owns the callbacks is much easier to
reason about than callbacks scattered across the buttons that started them.

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

Nothing that needs a user - the Graph API, the token, the user ID - works until the player has logged
in. Do this from a button the player presses, not automatically on startup.

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

Ask for the smallest set of permissions you actually need, and ask for extra ones later - at the point
where the player does the thing that requires them - rather than all at once on the first login. Check
what you already hold with ${function.fb_check_permission}, and note that the player can decline: a
permission you asked for appearing in `declined_permissions` is a normal outcome, not an error.

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

The other things you can do with a session are ${function.fb_dialog} (open Meta's share dialog on a
link) and the App Events in ${module.app_events} - which, unlike everything else here, do **not**
require a login.

## 5. Handling responses

Every asynchronous function in this extension reports failure in one of two places, and they are not
interchangeable:

1. **The synchronous return value.** Anything rejected before Meta's SDK is reached - the SDK is not
initialized, no user is logged in, an argument is empty, a request of the same kind is already in
flight - comes back immediately as a ${constant.FacebookError}. **When this is not `Ok`, your callback
never runs**, so if you only handle the callback you will never hear about these at all.
2. **The callback's `result` argument.** Everything Meta itself reports arrives here as a
${struct.FacebookResult}. Check `result.success` first. On a failure, `result.status` separates a user
cancellation (${constant.FacebookOperationStatus}.Cancelled, which is not an error and carries no
message) from a real failure, `result.error_message` carries Meta's text, and `result.sdk_error_code`
carries Meta's own numeric code when there was one.

Where a callback has a payload it always arrives as a **second** argument, and it is only present on
success. Guard it with `is_undefined` if you use it outside the `result.success` branch - a successful
${function.fb_dialog} legitimately has no `post_id` unless your app holds publish permissions.

## 6. Cleanup

There is nothing to destroy or free - the extension holds no handles. Two functions matter at the end
of a session:

* ${function.fb_logout} clears the access token when the player signs out. It does not sign them out of
the Facebook app itself.
* ${function.fb_reset_pending} is a recovery hatch, not part of the normal flow. Call it if a login or
share screen was dismissed in a way Meta's SDK never reported, leaving every later call rejected with
`LoginInProgress` or `ShareInProgress`. It fires the stuck callbacks with a `Cancelled` result.

If you use App Events, consider a ${function.fb_flush_events} at a point where the app may be killed,
so queued events are not lost.

## Testing notes

* Until your app passes App Review, only accounts with a role on the app can log in, and only with
`public_profile`, `email` and `user_friends` - see ${page.dashboard}.
* A login that fails immediately on Android with no visible dialog almost always means the **Key Hash**
on the dashboard does not match the keystore that signed the build. Both the debug and the release
keystore hash need to be registered.
* A login that fails on iOS almost always means the **Bundle ID** on the dashboard does not match the
one in the iOS Game Options.
* App Events are batched. Call ${function.fb_flush_events} to see them in the Events Manager within
seconds instead of minutes.
