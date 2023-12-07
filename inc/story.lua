-- story.lua
-- =========

story = {}

story.show = function(this, number, before_level)
	this.before_level = before_level
	this.scr = 1
	if before_level then
		if number == 1 then
			screen = this
			play_pseudo_music(9)
			return
		else
			level:show(number)
		end
	else
		if number %9 == 0 then
			screen = this
			play_pseudo_music(9)
			return
		else
			level_clear:show()
		end
	end
end
	
story.update = function(this)
	if not btnp(k_shoot) then return end
	play_sfx(2)
	if this.before_level then level:show(1) -- level 1
	else
		if this:is_last_level() and this.scr == 1 then this.scr = 2; play_pseudo_music(10)
		elseif level_clear.display_reward then reward:show()
		elseif this:is_last_level() then title:show()
		else sel:show(nil, level.coords.i+1) end
	end
end
	
story.draw = function(this)
	cls()
	this:draw_graphics()
	if this.before_level then -- level 1
		print_line("mission briefing", 0, c_orange)
		print_line("agent 101", 2, c_blue)
		print_line_off("scientist", 5, c_pink, 5)
		print_line_off("secret base 1", 8, c_white, 15)
		print_lines_color(this.mission_briefing_gray)
		print_menu_commands("start")
	else
		if this:is_last_level() then
			print_line("the end", 0, c_orange)
			print_thank_you()
			print_line_off("mission", 4, c_white, 5)
			print_line_off("mission", 6, c_white, 21)
			print_line_off("records", 11, c_blue, 7)
			print_lines_color(this.the_end_gray)
			if this.scr == 1 then print_menu_commands("see the sunset")
			else
				if level_clear.display_reward then print_menu_commands("reward")
				else print_menu_commands("title screen") end
			end

		else
			local base = (level.coords.i\9)
			print_line("secret base "..base.." cleared", 0, c_orange)
			print_thank_you()
			print_line_off("scientist", 4, c_pink, 8)
			print_line_off("secret base", 5, c_white, 8)
			print_line_off("secret base "..(base+1), 8, c_white, 15)
			print_lines_color(this.base_cleared_gray)
			if level_clear.display_reward then print_menu_commands("reward")
			else print_menu_commands("secret base "..(base+1)) end
		end
	end
end

story.mission_briefing_gray = split("2;!;9 ; 4;the enemy has kidnapped our;0 ; 5;best;0 ; 5;!;14 ; 7;we have intel she's being kept;0 ; 8;at the enemy's;0 ; 8;.;28 ;"..
	"10;your mission, should you choose;0 ; 11;to accept it, is to rescue her!;0 ; 13;good luck!;0", ";")

story.base_cleared_gray = split("4,but our,0 , 4,is in,18 , 5,another,0 , 5,!,19 , 7,we have intel she's being kept,0 , 8,at the enemy's,0 , 8,.,28 , 10,go rescue her!,0")

story.the_end_gray = split("4;your;0 ; 4;is over.;13 ; 6;we present you a new;0 ; 6;:;28 ; 7;can you get trophies on all;0 ; 8;levels?;0 ; 10;to track your trophies,;0 ;"..
	"11;choose;0 ; 11;from;15 ; 12;the title screen...;0 ; 14;thank you for playing!;0", ";")

-- "private" methods
story.is_last_level = function(this)
	if this.before_level then return false end
	return level.coords.i == coords.num_levels
end

story.draw_graphics = function(this)
	if this:is_last_level() and this.scr == 2 then
		clip(    0, 96, 128, 16)
		rectfill(0, 96, 128, 111, c_dark_blue)
		circfill(64, 112, 48, c_dark_red)
		circfill(64, 112, 36, c_red)
		circfill(64, 112, 24, c_orange)
		circfill(64, 112, 12, c_yellow)
		clip()
	else
		for i=0,15 do
			rectfill(i*8, 96, i*8+8, 104, c_gray)
			spr(spr_side_floor, i*8, 104)
		end
	end
	if this:is_last_level() then
		if this.scr == 1 then
			spr(13, 56, 102) -- spr_side_agent = 13
			spr(45, 64, 102) -- spr_scientist  = 45
		else
			spr(44, 61, 104) -- spr_couple     = 44
		end
	else
		spr(13, 48, 102) -- spr_side_agent = 13
		spr(29, 72, 102) -- spr_side_boss  = 29
	end
end

-- helper functions
print_thank_you = function()
	print_line("thank you,", 2, c_gray)
	print_line_off("agent 101", 2, c_blue, 11)
	print_line_off("!", 2, c_gray, 20)
end
