-- reward.lua
-- ==========

reward = {}

reward.show = function(this)
	options.all_trophies = true
	persistence:save_configs()
	screen = this
	play_pseudo_music(7)
end
	
reward.update = function(this)
	if btnp(k_shoot) then options:show(5); play_sfx(2) end
end
	
reward.draw = function(this)
	cls()
	print_line("reward", 0, c_orange)
	print_lines_color(this.gray_text)
	print_lines_color(this.white_text, c_white)
	print_lines_color(this.blue_text, c_blue)
	draw_rect_swap(72, 64, palettes.boss)
	print_menu_commands("options")
end

reward.gray_text = split("4;by earning trophies for all;0 ; 5;levels, you have unlocked...;0 ; 9;you can now play as...;0 ;"..
	"13;to change the current skin, ;0 ; 14;select;0 ; 14;on the;15 ; 15;...;12", ";")

reward.white_text = split("2,congratulations!,0 , 7,an alternative skin!,0 , 11,'s boss!,9 , 15,title screen,0")

reward.blue_text = split("11,agent 101,0 , 14,options,7")
