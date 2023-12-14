-- globals.lua
-- ===========

-- optimization note: many tables are created with split() to save tokens throughout the code

-- color constants
c_black,c_dark_blue,c_dark_red,c_dark_green,c_brown,c_dark_gray,c_gray,c_white,c_red,c_orange,c_yellow,c_green,c_blue,c_indigo,c_pink,c_peach = 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	
-- key / button constants
k_left, k_right, k_up, k_down, k_skip, k_shoot  = 0, 1, 2, 3, 4, 5

-- string constants
s_left, s_right, s_up, s_down, s_o, s_x  = chr(139), chr(145), chr(148), chr(131), chr(142), chr(151)

-- sprite flags
sprf_floor = 0

-- sprite constants
spr_player_up, spr_player_right, spr_player_dead = 32, 48, 60
-- commented the constants below to save some tokens
--[[
spr_lock             = 71
spr_side_floor       = 12
spr_side_agent       = 13
spr_side_boss        = 29
spr_scientist        = 45
spr_couple           = 44
]]
spr_trophy           = 87
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
