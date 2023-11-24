-- gameover.lua
-- ============

game_over = {}

game_over.show = function(this)
	menuitem(1)
	menuitem(2)
	screen = this
end

game_over.update = function(this)
	-- using pause menu callbacks
	if btnp(k_skip) then 
		quit_level()
		play_sfx(2)
	elseif btnp(k_shoot) then
		restart_level()
		play_sfx(2)
	end
end

game_over.draw = function(this)
	cls()
	print_line("level failed", 10, c_red, k_up)
	print_menu_commands("try again", "select level")
end
