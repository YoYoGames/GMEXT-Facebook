draw_set_font(fnt_gm_15);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

if (!facebook_supported)
{
    draw_text(x, y, facebook_initialization_error);
    exit;
}

var _ready = fb_ready();
var _status = fb_status();
var _logged_in = fb_is_logged_in();
var _user_id = _logged_in ? fb_user_id() : "";
var _has_token = _logged_in && fb_access_token() != "";

draw_text(x, y, $"fb_ready: {_ready}");
draw_text(
    x,
    y + 30,
    $"fb_status: {facebook_status_text(_status)} ({_status})"
);
draw_text(x, y + 60, $"fb_is_logged_in: {_logged_in}");
draw_text(x, y + 90, $"fb_user_id: {_user_id}");
draw_text(x, y + 120, $"access token available: {_has_token}");

if (_ready)
{
    draw_text(
        x,
        y + 150,
        $"auto app events: {fb_auto_log_app_events_enabled()}"
    );
    draw_text(
        x,
        y + 180,
        $"advertiser ID collection: {fb_advertiser_id_collection_enabled()}"
    );
    draw_text(
        x,
        y + 210,
        $"event data usage limited: {fb_event_data_usage_limited()}"
    );
}

if (facebook_initialization_error != "")
{
    draw_text(
        x,
        y + 240,
        "Initialization error: " + facebook_initialization_error
    );
}
