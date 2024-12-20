
draw_set_font(Font_YoYo_15)
draw_set_valign(fa_left)
draw_set_halign(fa_left)
draw_text(x,y,$"fb_ready:  {fb_ready()}")
draw_text(x,y+30,$"fb_status: {fb_status()}")
draw_text(x,y+60,$"fb_accesstoken: {fb_accesstoken()}")
draw_text(x,y+90,$"fb_user_id: {fb_user_id()}")

