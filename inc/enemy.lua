-- enemy.lua
-- =========

enemy_class = {

-- factory / constructor
spawn = function(class, x, y, dir, p)
	local enemy = {
		base = class,
		x = x,
		y = y,
		off_x = 0,
		off_y = 0,
		dir = dir,
		next = nil,
		target = nil,
		frame = 0,
		palette = p,
		checks_flanks  = p == palettes.sniper or p == palettes.soldier or p == palettes.bloldier,                                               -- indigo jacket
		hears_shots    = p == palettes.listener,                                                                                                -- yellow jacket
		moves          = p == palettes.walker or p == palettes.soldier or p == palettes.blond or p == palettes.bloldier or p == palettes.blerc, -- red-haired or blond
		moves_caution  = p == palettes.blond or p == palettes.bloldier or p == palettes.blerc,                                                  -- blond
		shoots_through = p == palettes.merc or p == palettes.blerc                                                                              -- black jacket
	}
	setmetatable(enemy, inheritance)
	reset_state(enemy)
	adjust_sprite(enemy, enemy.dir)
	add(enemies,enemy)
end,
	
-- "public" methods
update = function(enemy)
	if animate(enemy) then return end

	if can_shoot(enemy.x, enemy.y, enemy.dir, enemy.shoots_through) == player then start_shoot_anim(enemy)
	else enemy:move() end
end,

draw = function(enemy)
	set_pal_swap(enemy.palette)
	draw_object(enemy)
	pal(0)
end,

-- "private" methods
move = function(enemy)
	local go_dir, go_right, go_left, go_back = enemy:relative_moves()
	enemy.moved = false
	if enemy.checks_flanks then
		if     can_move(go_left)  and can_shoot(go_left.x,  go_left.y,  go_left.dir,  enemy.shoots_through) == player then start_move_anim(enemy, go_left)  
		elseif can_move(go_right) and can_shoot(go_right.x, go_right.y, go_right.dir, enemy.shoots_through) == player then start_move_anim(enemy, go_right)
		end
	end
	if (not enemy.moved) and enemy.hears_shots and player.is_shooting then enemy:hear() end
	if (not enemy.moved) and enemy.moves_caution then
		if enemy:can_move_caution(go_dir) then start_move_anim(enemy, go_dir)
		else enemy:must_turn_caution(go_right, go_left, go_back) end
	end
	if (not enemy.moved) and enemy.moves then
		if can_move(go_dir) then start_move_anim(enemy, go_dir)
		else enemy:must_turn(go_right, go_left, go_back) end
	end
	if not enemy.moved then start_idle_anim(enemy, enemy.dir) end
end,

can_move_caution = function(enemy, pos)
	return can_move(pos) and (not (can_shoot(pos.x, pos.y, reverse_dir(player.dir), false, enemy) == player))
end,

hear = function(enemy)
	local hear_left = enemy.x - player.x
	local hear_up = enemy.y - player.y
	local left, right, up, down = enemy:possible_moves()
	if can_move(left)  and not (enemy.dir == k_left)  and   hear_left  >= abs(hear_up)   then start_move_anim(enemy, left)  end
	if can_move(right) and not (enemy.dir == k_right) and (-hear_left) >= abs(hear_up)   then start_move_anim(enemy, right) end
	if can_move(up)    and not (enemy.dir == k_up)    and   hear_up    >  abs(hear_left) then start_move_anim(enemy, up)    end
	if can_move(down)  and not (enemy.dir == k_down)  and (-hear_up)   >  abs(hear_left) then start_move_anim(enemy, down)  end
end,

must_turn = function(enemy, go_right, go_left, go_back)
	local primary, secondary = get_primary_secondary(go_right, go_left)
	if     can_move(primary)   then start_move_anim(enemy, primary)
	elseif can_move(secondary) then start_move_anim(enemy, secondary)
	elseif can_move(go_back)   then start_move_anim(enemy, go_back)
	-- else skip turn
	end
end,

must_turn_caution = function(enemy, go_right, go_left, go_back)
	local primary, secondary = get_primary_secondary(go_right, go_left)
	if     enemy:can_move_caution(primary)   then start_move_anim(enemy, primary)
	elseif enemy:can_move_caution(secondary) then start_move_anim(enemy, secondary)
	elseif enemy:can_move_caution(go_back)   then start_move_anim(enemy, go_back)
	-- else skip turn
	end
end,

relative_moves = function(enemy)
	local left, right, up, down = enemy:possible_moves()
	local go_dir, go_right, go_left, go_back
	if enemy.dir == k_left then
		go_dir   = left
		go_right = up
		go_left  = down
		go_back  = right
	elseif enemy.dir == k_right then
		go_dir   = right
		go_right = down
		go_left  = up
		go_back  = left
	elseif enemy.dir == k_up then
		go_dir   = up
		go_right = right
		go_left  = left
		go_back  = down
	elseif enemy.dir == k_down then
		go_dir   = down
		go_right = left
		go_left  = right
		go_back  = up
	end
	return go_dir, go_right, go_left, go_back
end,

possible_moves = function(enemy)
	local left  = {x = enemy.x-1, y = enemy.y,   dir = k_left}
	local right = {x = enemy.x+1, y = enemy.y,   dir = k_right}
	local up    = {x = enemy.x,   y = enemy.y-1, dir = k_up}
	local down  = {x = enemy.x,   y = enemy.y+1, dir = k_down}
	return left, right, up, down
end

}

-- enemy helper functions
function get_player_distance(coords)
	return abs(player.x - coords.x) + abs(player.y - coords.y)
end

function get_primary_secondary(go_right, go_left)
	local primary   = go_right
	local secondary = go_left
	if get_player_distance(go_left) < get_player_distance(go_right) then
		primary   = go_left
		secondary = go_right
	end
	return primary, secondary
end
