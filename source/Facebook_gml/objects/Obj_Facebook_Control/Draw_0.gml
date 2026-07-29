draw_set_font(fnt_gm_15);
draw_set_valign(fa_left);
draw_set_halign(fa_left);

draw_text(x, y, $"fb_ready: {fb_ready()}");
draw_text(x, y + 30, $"fb_status: {fb_status()}");
draw_text(x, y + 60, $"fb_access_token: {fb_access_token()}");
draw_text(x, y + 90, $"fb_user_id: {fb_user_id()}");
