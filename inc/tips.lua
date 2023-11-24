-- tips.lua
-- ========

tips = {}

tips.show = function(this, number, before_level)
	this.scr = 1
	screen = this
end
	
tips.update = function(this)
	if not btnp(k_shoot) then return end
	play_sfx(2)
	if this.scr == 1 then this.scr = 2
	else title:show() end
end
	
tips.draw = function(this)
	cls()
	print_line("tips", 0, c_orange)
	if this.scr == 1 then
		line(0,18,78,18,c_white)
		line(0,48,38,48,c_white)
		draw_rect_swap(0,54,palettes.walker)
		draw_rect_swap(0,72,palettes.camper)
		draw_rect_swap(0,90,palettes.blond)
		print_lines_color(this.screen_1_white, c_white)
		print_lines_color(this.screen_1_gray)
		print_menu_commands("more tips")
	else
		line(0,18,46,18,c_white)
		draw_rect_swap(0,24,palettes.listener)
		draw_rect_swap(0,42,palettes.sniper)
		draw_rect_swap(0,60,palettes.merc)
		line(0,84,38,84,c_white)
		for i=1,9 do
			local p
			if     i == 1 then p = palettes.walker
			elseif i == 2 then p = palettes.soldier
			elseif i == 3 then p = palettes.blerc
			elseif i == 4 then p = palettes.blond
			elseif i == 5 then p = palettes.bloldier
			elseif i == 6 then p = palettes.merc
			elseif i == 7 then p = palettes.camper
			elseif i == 8 then p = palettes.listener
			else               p = palettes.sniper end
			local x = 2+(i-1)*12
			draw_rect_swap(x, 98, p)
		end
		print_lines_color(this.screen_2_white, c_white)
		print_lines_color(this.screen_2_gray)
		print_menu_commands("title screen")
	end
end

tips.screen_1_white = split("2,when playing a level,0 , 7,hair color,0")

tips.screen_1_gray = split("4,you can quit or restart the,0 , 5,level from the pause menu,0 , 9,   red-haired enemies,0 , 10,   keep moving forward,0 ,"..
	"12,   dark-haired enemies tend,0 , 13,   to skip their turn,0 , 15,   blond enemies will avoid your,0 , 16,   line of sight by moving away,0")

tips.screen_2_white = split("2,jacket color,0 , 13,turn order,0")

tips.screen_2_gray = split("4,   enemies in yellow jackets,0 , 5,   turn when they hear you shoot,0 , 7,   enemies in indigo jackets,0 , 8,   turn when they see you flank,0 ,"..
	"10,   enemies in black jackets,0 , 11,   shoot others to aim at you,0 , 15, 1  2  3  4  5  6  7  8  9,0")
