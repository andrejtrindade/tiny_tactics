-- gameover.lua
-- ============

game_over = {

show = function(this)
	menuitem(1)
	menuitem(2)
	screen = this
end,

update = function(this)
	-- using pause menu callbacks
	if btnp(k_skip) then 
		quit_level(32) -- like pressing X on pause menu
		play_sfx(2)
	elseif btnp(k_shoot) then
		restart_level(32) -- like pressing X on pause menu
		play_sfx(2)
	end
end,

draw = function(this)
	cls()
	print_line("level failed", 10, c_red, k_up)
	print_menu_commands("try again", "select level")
end

}
