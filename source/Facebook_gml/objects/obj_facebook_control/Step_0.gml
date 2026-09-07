/// @description Enable the demo buttons only once the SDK can actually be used

// This is the only platform and readiness check in the demo. Every button
// inherits from obj_gm_button, so locking them here greys them out and stops
// their Mouse events from doing anything - the handlers do not repeat the
// test. fb_ready() is safe to call on an unsupported target: the extension is
// excluded there, so the compiler substitutes a stub that returns false.
var _usable = facebook_supported && fb_ready();

with (obj_gm_button)
{
    locked = !_usable;
}
