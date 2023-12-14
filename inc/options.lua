-- options.lua
-- ===========

options = {
	selected        = 1,
	speed           = 2,
	speed_text      = split(" high, mid, low"),
	anim_move       = true,
	anim_idle       = true,
	unlock_progress = false,
	boss_skin       = false,
	all_trophies    = false,
	max_selected    = 4,
	show_fps        = false,

show = function(this, selected)
	if this.all_trophies then this.max_selected = 5 end
	if selected ~= nil then this.selected = selected end
	screen = this
	if not title.music then play_music(0) end
end,
	
update = function(this)
	if     btnp(k_up)    then this.selected = max(1,                 this.selected-1); play_sfx(0)
	elseif btnp(k_down)  then this.selected = min(this.max_selected, this.selected+1); play_sfx(0)
	elseif btnp(k_left)  then 
		if     this.selected == 1 then this.speed           = min(3, this.speed+1)
		elseif this.selected == 2 then this.anim_move       = false
		elseif this.selected == 3 then this.anim_idle       = false
		elseif this.selected == 4 then this.unlock_progress = false
		else                           this.boss_skin       = false end
		play_sfx(3)
	elseif btnp(k_right) then 
		if     this.selected == 1 then this.speed           = max(1, this.speed-1)
		elseif this.selected == 2 then this.anim_move       = true
		elseif this.selected == 3 then this.anim_idle       = true
		elseif this.selected == 4 then this.unlock_progress = true
		else                           this.boss_skin       = true  end
		play_sfx(3)
	elseif btnp(k_shoot) then
		persistence:save_configs()
		title.selected = 3
		title:show()
		play_sfx(2)
	elseif btnp(k_skip) then
		this.show_fps = not this.show_fps
		play_sfx(2)
	end
end,

draw = function(this)
	cls()
	print_line("options", 0, c_orange)
	local buttons_text = (this.speed < 3 and s_left or "  ").."     "..(this.speed > 1 and s_right or "  ")
	draw_option(nil,                  this.selected == 1, "animation speed:      ", 2,  true, this.speed_text[this.speed], buttons_text)
	draw_option(this.anim_move,       this.selected == 2, "movement animation:   ", 4,  true)
	draw_option(this.anim_idle,       this.selected == 3, "idle animation:       ", 6,  true)
	draw_option(this.unlock_progress, this.selected == 4, "unlock all levels:    ", 8,  true)
	draw_option(this.boss_skin,       this.selected == 5, "alternative skin:     ", 10, this.all_trophies)
	if this.all_trophies then
		local p = this.boss_skin and palettes.boss or nil
		local s = this.boss_skin and "boss"        or "agent 101"
		local c = this.boss_skin and c_white       or c_blue
		print_line("current skin:", 12, c_dark_gray)
		draw_rect_swap(62, 70, p)
		print_line_off(s, 12, c, 20)
	else
		print_lines_color(this.explanation_dark_gray, c_dark_gray)
		print_line("records", 16, c_dark_blue)
		print_line_off("title screen", 16, c_gray, 15)
	end
	print_menu_commands("title screen", (this.show_fps and "hide fps" or "show fps"))
end,

check_all_trophies = function(this)
	if this.all_trophies then return false end
	this.all_trophies = true
	for i=1,#records do
		if records[i] <= 0 or records[i] > coords:devs_record(i) then this.all_trophies = false end
	end
	return this.all_trophies
end,

explanation_dark_gray = split("12;earn trophies for all levels;0 ; 13;to unlock an alternative skin!;0 ; 15;to track your trophies, select;0 ; 16;on the;8", ";")

}

-- helper functions
draw_option = function(boolean, selected, text, line, enabled, sel_text, buttons_text)
	local s = (boolean == nil) and sel_text or (boolean and " on" or " off")
	local c = selected and c_blue or c_dark_blue
	if not enabled then c = c_dark_gray end
	print_line(text..s, line, c)
	draw_outline(80, line*6-2, 114, c)
	s = (boolean == nil) and buttons_text or (boolean and s_left or ("       "..s_right))
	c = selected and c_white or c_dark_gray
	print_line_off(s, line, c, 20)
end

draw_outline = function(x1, y1, x2, color)
	line(x1,   y1,   x2,   y1,   color)
	line(x1,   y1+8, x2,   y1+8, color)
	line(x1,   y1,   x1-2, y1+2, color)
	line(x1,   y1+8, x1-2, y1+6, color)
	line(x1-2, y1+2, x1-2, y1+6, color)
	line(x2,   y1,   x2+2, y1+2, color)
	line(x2,   y1+8, x2+2, y1+6, color)
	line(x2+2, y1+2, x2+2, y1+6, color)
end
