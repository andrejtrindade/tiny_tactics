-- select.lua
-- ==========

sel = {
	selected = 1,
	max_base = coords.num_levels\9,
	show_records = false,
	max_cleared = 0,
	max_unlocked = 1,
	clears,
	silvers,
	golds,
	
init = function(this)
	this:update_max_unlocked()
	this.selected = min(this.max_cleared + 1, this.max_unlocked)
end,
	
show = function(this, show_records, selected)
	if show_records ~= nil then this.show_records = show_records end
	if selected ~= nil then this.selected = selected end
	this:update_max_unlocked()
	this:count_records()
	screen = this
	if not title.music then play_music(0) end
end,
	
update = function(this)
	if     btnp(k_up)    and  this.selected%9 ~= 1                                       then this.selected = mid(1, this.selected - 1, coords.num_levels); play_sfx(0)
	elseif btnp(k_down)  and  this.selected%9 ~= 0 and this.selected < this.max_unlocked then this.selected = mid(1, this.selected + 1, coords.num_levels); play_sfx(0)
	elseif btnp(k_left)  and  this.selected > 9    then this.selected -= 9; play_sfx(3)
	elseif btnp(k_right) and  this:right_enabled() then this.selected = min (this.selected + 9, this.max_unlocked); play_sfx(3)
	elseif btnp(k_skip)  then title:show(); play_sfx(2)
	elseif btnp(k_shoot) then story:show(this.selected, true); play_sfx(2)
	end
end,
	
draw = function(this)
	cls()
	
	-- base
	local base = calc_base(this.selected)
	local color_base = this:right_enabled() and c_blue or c_dark_gray
	if base > 1 then print_line_off(s_left, 0, c_blue, 6) end
	print_line_off("secret base "..base, 0, c_white, 9)
	if base < this.max_base then print_line_off(s_right, 0, color_base, 23) end
	
	-- guards
	for i=1,base do
		local p
		if     i == 1 then p = palettes.walker
		elseif i == 2 then p = palettes.camper
		elseif i == 3 then p = palettes.listener
		elseif i == 4 then p = palettes.soldier
		elseif i == 5 then p = palettes.sniper
		elseif i == 6 then p = palettes.merc
		elseif i == 7 then p = palettes.blond
		elseif i == 8 then p = palettes.bloldier
		else               p = palettes.blerc    end
		local x = (62-base*4)+(i-1)*8
		draw_rect_swap(x, 11, p)
	end
		
	-- header
	if this.show_records then 
		print_line("lvl    your record  dev's record", 5, c_gray)
	else print_line("lvl name                  status", 5, c_gray) end
	
	local j = (base-1)*9
	for i = j+1, j+9 do
		local row = 5+i-j
		local color = c_dark_blue
		if     i == this.selected     then color = c_blue
		elseif i >  this.max_unlocked then color = c_dark_gray end		
		
		-- level number / name
		local text = tostr(base).."-"..(i-j)
		if not this.show_records then text = text.." "..coords.names[i] end
		print_line(text, row, color)
		
		-- cleared / unplayed / records
		local status_text = "unplayed"
		if this.show_records then
			local plus = records[i] == 1000 and "+" or ""
			if records[i] > 0 then status_text = ""..records[i]..plus.." turns" end
			print_line(status_text, row, color, k_right, 14)
			local devs_record = coords:devs_record(i)
			local devs_text = ""..devs_record.." turns"
			print_line(devs_text, row, color, k_right)
			if records[i]>0 and records[i] <  devs_record then     spr(spr_trophy,16,row*6) end
			if                  records[i] == devs_record then draw_silver_trophy(16,row*6) end
		else 
			if records[i] > 0 then status_text = "cleared" end
			print_line(status_text, row, color, k_right)
		end
	end
	
	-- totals
	if this.show_records then
		draw_silver_trophy(120,96)
		spr(spr_trophy,120,102)
		print_line("     tied  dev's record: "..pad_left(this.silvers,              2).." x", 16, c_dark_gray)
		print_line("     broke dev's record: "..pad_left(this.golds,                2).." x", 17, c_dark_gray)
		print_line("                  total: "..pad_left(this.silvers + this.golds, 2), 18, c_dark_gray)
	else
		print_line("               total cleared: "..pad_left(this.clears,          2), 16, c_dark_gray)
	end
	
	-- buttons
	local l_comm = this.show_records and "play level" or "play"
	print_menu_commands(l_comm, "back")
end,

-- "private" methods
update_max_unlocked = function(this)
	this.max_unlocked = options.unlock_progress and coords.num_levels or min(this.max_cleared + 1, coords.num_levels)
end,

right_enabled = function(this)
	return this.selected <= (this.max_base-1)*9 and this.max_unlocked > calc_base(this.selected)*9
end,

count_records = function(this)
	this.clears, this.silvers, this.golds = 0, 0, 0
	for i=1,#records do
		local record = records[i]
		if record > 0 then
			local devs_record = coords:devs_record(i)
			this.clears += 1
			if     record == devs_record then this.silvers += 1
			elseif record <  devs_record then this.golds   += 1 end
		end
	end
end

}
