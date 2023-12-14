-- title.lua
-- =========

title = {
	selected  = 1,
	options   = split("play,controls,options,tips,records"),
	music = false,

show = function(this)
	screen = this
	if not this.music then play_music(0) end
end,
	
update = function(this)
	if     btnp(k_up)    and this.selected > 1             then this.selected -= 1; play_sfx(0)
	elseif btnp(k_down)  and this.selected < #this.options then this.selected += 1; play_sfx(0)
	elseif btnp(k_skip)  then
		if sound then play_music(-1) end
		sound = not sound
		if sound then play_music(0) end
	elseif btnp(k_shoot) then 
		if     this.selected == 1 then sel:show(false)
		elseif this.selected == 2 then controls:show()
		elseif this.selected == 3 then options:show()
		elseif this.selected == 4 then tips:show()
		elseif this.selected == 5 then sel:show(true)
		end
		play_sfx(2)
	end
end,
	
draw = function(this)
	cls()
	print("tiny", 4, 0, c_orange) -- 66, 113
	map(53,61,0,6,16,3)
	print("by andrejtrindade", 61, 33, c_dark_gray)
	map(53,57,0,36,4,4)
	for i = 1,#this.options do 
		local color = (i == this.selected and c_blue) or c_dark_blue
		print_line(this.options[i], 12+i, color, k_up)
	end
	print_menu_commands("select", "sound "..(sound and "off" or "on"))
end

}
