-- controls.lua
-- ============

controls = {
	labels_selected = false, 
	key_labels      = false,

show = function(this)
	screen = this
end,
	
update = function(this)
	local key_pressed = false
	if btnp(k_skip) then
		this.key_labels = false
		key_pressed = true
	elseif btnp(k_shoot) then
		this.key_labels = true
		key_pressed = true
	end
	if key_pressed then
		this.labels_selected = true
		persistence:save_configs()
		title:show()
		play_sfx(2)
	end
end,
	
draw = function(this)
	cls()
	print("gamepad", 98, 12, c_gray)
	print_lines_color(this.orange_text, c_orange)
	print_lines_color(this.gray_text)
	print_lines_color(this.blue_text, c_blue)
	line(31, 32, 51, 32, c_dark_gray)
	line(74, 32, 95, 32, c_dark_gray)
	line(30, 50, 51, 50, c_dark_gray)
	line(78, 50, 104, 50, c_dark_gray)
	line(23, 62, 51, 62, c_dark_gray)
	line(74, 62, 104, 62, c_dark_gray)
	line(23, 74, 51, 74, c_dark_gray)
	line(78, 74, 104, 74, c_dark_gray)
	print_pause_button(5, 47, c_blue, true)
	print_pause_button(108, 48, c_blue, false)
	print_o_button(12, 60, c_blue, true)
	print_o_button(108, 60, c_blue, false)
	print_menu_commands("yes", "no", c_gray, false)
end,

orange_text = split("0,controls,0 , 18,are you using a keyboard?,0"),

gray_text   = split("2,keyboard,0 , 5,move,14 , 8,pause,14 , 10,skip,14 , 12,shoot,14"),

blue_text   = split("4,"..s_up..",3 , 4,"..s_up..",27 , 5,"..s_left..s_down..s_right..",1 , 5,"..s_left.."  "..s_right..",25 , 6,"..s_down..",27 , 12,"..s_x..",3 , 12,"..s_x..",27")

}
