/// @description Hover and press feedback, and the locked (disabled) state

// Locked buttons show the greyed-out sprite frame and ignore the mouse. The
// Mouse events still fire, so each handler exits on `locked` as well.
if (locked)
{
    image_index = 2;
    exit;
}

var _hovered = point_in_rectangle(
    mouse_x,
    mouse_y,
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom
);

// Frame 1 is the hover state; frame 0 is both the normal state and the
// one-frame flicker on press.
image_index = (_hovered && !mouse_check_button_pressed(mb_left)) ? 1 : 0;

// Touch devices have no hover, so the button would stay lit after a tap.
var _mobile = (os_type == os_android) || (os_type == os_ios);
if (_mobile && !mouse_check_button(mb_left)) image_index = 0;
