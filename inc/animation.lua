-- animation.lua
-- =============

function start_move_anim(entity, next_pos, key)
	if next_pos ~= nil then entity.next = next_pos end
	start_anim(entity)
	entity.is_moving = true
	entity.moved     = true
	if entity == player then add_dir_to_solution(key) end
end

function start_shoot_anim(entity)
	start_anim(entity)
	entity.is_shooting = true
	if entity == player then add_to_solution("x") end
end

function start_idle_anim(entity)
	start_anim(entity)
	entity.is_idle = true
	if entity == player then add_to_solution("s") end
end

function start_anim(entity)
	entity.frame = options.speed*8
	reset_state(entity)
end

function animate(entity)
	local s = options.speed
	if entity.frame <= 0 and (not entity.is_dead) then 
		reset_state(entity)
		return false 
	end
	
	if  ((not options.anim_move) and entity.is_moving) or 
		((not options.anim_idle) and entity.is_idle)   then entity.frame = 1
	end
	
	if     entity.is_moving   then animate_move(entity,s)
	elseif entity.is_shooting then animate_shoot(entity,s)
	elseif entity.is_idle     then animate_idle(entity,s)
	elseif entity.is_dead     then animate_dead(entity,s)
	end

	if entity.frame == 1 and screen == level and (not player.is_dead) then turn:finished() end
	
	entity.frame -= 1
	return true
end

function animate_move(entity, s)
	offset_xy(entity, entity.next.dir, 1)
	if check_frames(entity, "8") then adjust_sprite(entity, entity.next.dir) end
	walk_sprite(entity, entity.next.dir)
	if entity.frame == 1 then
		local tile = level:get_pos(entity.next)
		if can_move(entity.next) then
			set_xydir(entity, entity.next)
			adjust_sprite(entity, entity.dir)
		elseif is_exit(tile) and #enemies == 0 then
			level_clear:show()
		end
	end
end

function animate_shoot(entity, s)
	if check_frames(entity, "8") then
		adjust_sprite(entity, entity.dir)
		entity.target = can_shoot(entity.x, entity.y, entity.dir, false) -- shoots_through also hit first target
		if entity.target ~= nil then
			entity.target.dir = reverse_dir(entity.dir)
			reset_state(entity.target)
			entity.target.is_dying = true
			adjust_sprite(entity.target, entity.target.dir)
		end
		play_sfx(5)
	end
	if check_frames(entity, "6,2") then entity.sprite -= 3 end
	if check_frames(entity, "4")   then entity.sprite += 3; play_sfx(5) end
	if check_frames(entity, "4,2") then flip_sprite_dir(entity, entity.dir) end
	if check_frames(entity, "4") and entity.target ~= nil then entity.target.sprite += 1 end
	if entity.frame == 1 then
		if entity.target ~= nil then
			if entity.target == player then player:kill()
			else del(enemies,entity.target) end
		end
	end
end

function animate_idle(entity, s)
	if check_frames(entity, "7,4") then entity.sprite += 6; play_sfx(6) end
	if check_frames(entity, "6,3") then entity.sprite += 1 end
	if check_frames(entity, "5,2") then entity.sprite -= 7 end
	if check_frames(entity, "4,1") then flip_sprite_dir(entity, entity.dir) end
end

function animate_dead(entity, s)
	offset_xy(entity, k_up, 1)
	if entity.frame <= 0       then entity.frame = s*4 end
	
	if     check_frames(entity, "4") then adjust_sprite(entity, k_up)
	elseif check_frames(entity, "2") then entity.sprite += 1 end
	
	if (level.off_y + entity.y)*8+entity.off_y <= 1 then game_over:show() end
end

function offset_xy(entity, dir, speed)
	if entity.frame%options.speed == 0 then
		if dir == k_left  then entity.off_x -= speed end
		if dir == k_right then entity.off_x += speed end
		if dir == k_up    then entity.off_y -= speed end
		if dir == k_down  then entity.off_y += speed end
	end
end

function walk_sprite(entity, dir)
	local s = options.speed
	if     check_frames(entity, "7,4") then entity.sprite += 1; play_sfx(4)
	elseif check_frames(entity, "5,2") then entity.sprite -= 1 end
	
	if check_frames(entity, "4,2") then flip_sprite_dir(entity, dir) end
end

function flip_sprite_dir(entity, dir)
	if dir == k_up or dir == k_down then entity.flip_h = not entity.flip_h
	else entity.flip_v = not entity.flip_v end
end

function check_frames(entity, frames_string)
	local frames = split(frames_string)
	for i=1,#frames do
		if entity.frame == options.speed*frames[i] then return true end
	end
	return false
end
