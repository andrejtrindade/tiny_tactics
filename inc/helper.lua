-- helper.lua
-- ==========

-- sound effects
function play_music(pattern)
	if not sound then return end
	sfx(-1,1)
	music(pattern)
	title.music = pattern ~= -1
end

function play_pseudo_music(effect)
	if not sound then return end
	music(-1)
	sfx(effect, 1)
end

function play_sfx(effect)
	if not sound then return end
	sfx(effect, 0)
end

-- sprites helper functions
function adjust_sprite(entity, dir)
	if dir == k_left then entity.flip_h = true else entity.flip_h = false end
	if dir == k_down then entity.flip_v = true else entity.flip_v = false end
	if dir == k_up   or dir == k_down  then entity.sprite = spr_player_up    end
	if dir == k_left or dir == k_right then entity.sprite = spr_player_right end

	if     entity.is_moving   then entity.sprite += 1
	elseif entity.is_shooting then entity.sprite += 3
	--     entity.is_idle
	elseif entity.is_dying    then entity.sprite += 4
	elseif entity.is_dead     then entity.sprite = spr_player_dead end
end

function draw_object(obj)
	local off_x = obj.off_x or 0
	local off_y = obj.off_y or 0
	spr(obj.sprite, (level.off_x + obj.x)*8+off_x, 6 + (level.off_y + obj.y)*8+off_y, 1, 1, obj.flip_h, obj.flip_v)
end

function draw_object_wh(obj)
	spr(obj.sprite, (level.off_x + obj.x)*8, 6 + (level.off_y + obj.y)*8, obj.w, obj.h, obj.flip_h, obj.flip_v)
end

function draw_silver_trophy(x, y)
	pal(10,6)
	pal(9,13)
	spr(spr_trophy, x, y)
	pal(0)
end

function draw_rect_swap(x, y, p)
	rectfill(x, y, x+7, y+8, c_gray)
	if p ~= nil then set_pal_swap(p) end
	spr(spr_player_up,x,y,1,1,false,true)
	pal(0)
end

function set_pal_swap(p)
	pal(12, p[1])
	pal(4,  p[2])
	pal(15, p[3])
end

-- coordinates helper functions
function set_xydir(entity, coords)
	entity.x           = coords.x
	entity.y           = coords.y
	entity.dir         = coords.dir
	entity.off_x       = 0
	entity.off_y       = 0
	reset_state(entity)
end

function reverse_dir(dir)
	if dir == k_left  then return k_right end
	if dir == k_right then return k_left  end
	if dir == k_up    then return k_down  end
	if dir == k_down  then return k_up    end
end

function reset_state(entity)
	entity.is_moving   = false
	entity.is_shooting = false
	entity.is_idle     = false
	entity.is_dying    = false
	entity.is_dead     = false
end

function can_move(pos)
	return fget(level:get_pos(pos), sprf_floor) and someone(pos) == nil
end	


function can_shoot(shooter_x, shooter_y, dir, shoots_through, ignored)
	local look = {x = shooter_x, y = shooter_y}
	local who
	repeat
		if dir == k_left  then look.x -= 1 end
		if dir == k_right then look.x += 1 end
		if dir == k_up    then look.y -= 1 end
		if dir == k_down  then look.y += 1 end
		who = someone(look)
		if who ~= player and shoots_through then who = nil end
		if ignored ~= nil and who == ignored then who = nil end
	until (not fget(level:get_pos(look), sprf_floor)) or who ~= nil
	return who
end

function someone(coords)
	if player.x == coords.x and player.y == coords.y then
		return player
	else
		for enemy in all(enemies) do
			if enemy.x == coords.x and enemy.y == coords.y then return enemy end
		end
	end
	return nil
end

function calc_base(i)
	return (i-1)\9+1
end

function calc_level(i)
	local l = i%9
	if l == 0 then l = 9 end
	return l
end

-- solution helper functions
function add_dir_to_solution(k)
	if     k == k_left  then add_to_solution("l")
	elseif k == k_right then add_to_solution("r")
	elseif k == k_up    then add_to_solution("u")
	elseif k == k_down  then add_to_solution("d")
	end
end

function add_to_solution(c)
	solution = solution..c
end

-- padding helper functions
pad_left = function(str, n)
	if type(str) ~= "string" then str = tostr(str) end
	while #str < n do str = " "..str end
	return str
end

-- pause menu callbacks (also used by game over screen)
function quit_level()
	menuitem(1)
	menuitem(2)
	sel:show(nil, level.coords.i)
end

function restart_level()
	play_pseudo_music(-1)
	level:show(level.coords.i)
end
