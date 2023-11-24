-- levelclear.lua
-- ==============

level_clear = {}

level_clear.show = function(this)
	menuitem(1)
	menuitem(2)
	this.is_record = persistence:update(level.coords.i, turn.counter)
	sel.max_cleared = max(sel.max_cleared, level.coords.i)
	this.display_reward = options:check_all_trophies()
	screen = this
	play_pseudo_music(7)
end

level_clear.update = function(this)
	if level.coords.i%9 == 0 then
		if btnp(k_shoot)     then story:show(level.coords.i, false);            play_sfx(2) end
	elseif this.display_reward then
		if btnp(k_shoot)     then sel.selected = level.coords.i; reward:show(); play_sfx(2) end
	else
		if btnp(k_skip)      then sel:show(nil, level.coords.i);                play_sfx(2)
		elseif btnp(k_shoot) then level:show(level.coords.i+1);                 play_sfx(2)
		end
	end
end

level_clear.draw = function(this)
	local plus = records[level.coords.i] == 1000 and "+" or ""
	local record_text = pad_left(tostr(records[level.coords.i])..plus, 5)
	local devs_text = pad_left(tostr(level.coords.devs_record), 5)
	cls()
	print_line("level clear", 7, c_blue, k_up)
	print_line(""..turn.counter.." turns", 9, c_gray, k_right, 3)
	if this.is_record then print_line("new record!", 11, c_white, k_right, 3) 
	else                   print_line(" your record: "..record_text.." turns", 11, c_dark_gray, k_right, 3)
	end
	if turn.counter == level.coords.devs_record then 
		print_line("you tied the dev's record!", 13, c_white, k_right, 3)
		draw_silver_trophy(120,78)
	elseif turn.counter <  level.coords.devs_record then 
		print_line("you broke the dev's record!", 13, c_white, k_right, 3)
		spr(spr_trophy,120,78)
	else print_line("dev's record: "..devs_text.." turns", 13, c_dark_gray, k_right, 3) end
	if level.coords.i%9 == 0 then print_menu_commands("next")
	elseif this.display_reward then print_menu_commands("reward")
	else print_menu_commands("next level", "select level") end
end
