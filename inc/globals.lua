-- globals.lua
-- ===========

-- optimization note: many tables are created with split() to save tokens throughout the code

-- color constants
c_black      = 0
c_dark_blue  = 1
c_dark_red   = 2
c_dark_green = 3
c_brown      = 4
c_dark_gray  = 5
c_gray       = 6
c_white      = 7
c_red        = 8
c_orange     = 9
c_yellow     = 10
c_green      = 11
c_blue       = 12
c_indigo     = 13
c_pink       = 14
c_peach      = 15
	
-- key / button constants
k_left  = 0
k_right = 1
k_up    = 2
k_down  = 3
k_skip  = 4
k_shoot = 5

-- string constants
s_left  = chr(139)
s_right = chr(145)
s_up    = chr(148)
s_down  = chr(131)
s_o     = chr(142)
s_x     = chr(151)

-- sprite flags
sprf_floor = 0

-- sprite constants
spr_player_up        = 32
spr_player_right     = 48
spr_player_dead      = 60
spr_side_floor       = 12
spr_lock             = 71
spr_trophy           = 87
-- commented the constants below to save some tokens
--[[
spr_side_agent       = 13
spr_side_boss        = 29
spr_scientist        = 45
spr_couple           = 44
]]
spr_exit_text_h      = 14
spr_exit_text_v      = 31
spr_locked_door_up   = 30
spr_locked_door_left = 46
spr_open_door_up     = 62
spr_open_door_left   = 63
spr_exit_left        = 66
spr_blue_left        = 72
spr_walker_left      = 88
spr_camper_left      = 104
spr_listener_left    = 120
spr_soldier_left     = 76
spr_sniper_left      = 92
spr_merc_left        = 108
spr_blond_left		 = 124
spr_bloldier_left    = 100 -- blond soldier
spr_blerc_left       = 116 -- blond merc

-- sfx constants
-- commented the constants below to save some tokens
--[[
sfx_ui_up_down     = 0
sfx_walk_wall      = 1
sfx_ui_select      = 2
sfx_ui_left_right  = 3
sfx_step           = 4
sfx_shot           = 5
sfx_idle           = 6
sfx_pm_level_clear = 7
sfx_pm_game_over   = 8
sfx_pm_boss        = 9
sfx_pm_the_end     = 10
]]

-- palettes
palettes = {
	map       = split("7,7,7,7,5,6,7,7,7,7,7,7,7,7,4,0"),
	walker    = {c_green,     c_red,    c_peach},
	camper    = {c_green,     c_black,  c_peach},
	listener  = {c_yellow,    c_black,  c_brown},
	soldier   = {c_indigo,    c_red,    c_peach},
	sniper    = {c_indigo,    c_black,  c_peach},
	merc      = {c_black,     c_black,  c_brown},
	blond     = {c_green,     c_yellow, c_peach},
	bloldier  = {c_indigo,    c_yellow, c_peach},
	blerc     = {c_black,     c_yellow, c_peach},
	boss      = {c_dark_gray, c_orange, c_peach}
}

wall_colors = split("2,13 , 3,7 , 10,13 , 13,7 , 6,13 , 5,7 , 9,5 , 1,13 , 0,13")

-- inheritance
inheritance = { __index = function(self, key) return self.base[key] end }

-- global variables
screen  = nil
sound   = true
enemies = {}
records = {}
