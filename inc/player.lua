-- player.lua
-- ==========

player = {}

player.spawn = function(this, x, y, dir)
	this.x = x
	this.y = y
	this.off_x = 0
	this.off_y = 0
	this.dir = dir
	this.next = nil
	this.target = nil
	reset_state(this)
	this.frame = 0
	adjust_sprite(this, dir)
end
	
player.update = function(this)
	if animate(this) then return end

	local key = get_key_pressed()
	if key == nil then return end
	if key_is_dir(key) then 
		this.next = get_next_coords(this, key)
		local tile = level:get_pos(this.next)
		if can_move(this.next) or is_exit(tile) then start_move_anim(this) 
		else play_sfx(1) end
	else 
		if     key == k_shoot then start_shoot_anim(this)
		elseif key == k_skip  then start_idle_anim(this)  end
	end
end
	
player.draw = function(this)
	if options.boss_skin then set_pal_swap(palettes.boss) end
	draw_object(this)
	pal(0)
end

player.kill = function(this)
	reset_state(this)
	this.is_dead  = true
	play_pseudo_music(8)
end

-- player helper functions
function is_exit(tile)
	if tile >= spr_exit_left and tile <= spr_exit_left+3 then return true
	else return false end
end

function get_key_pressed()
	if btnp(k_left)  then return k_left  end
	if btnp(k_right) then return k_right end
	if btnp(k_up)    then return k_up    end
	if btnp(k_down)  then return k_down  end
	if btnp(k_shoot) then return k_shoot end
	if btnp(k_skip)  then return k_skip  end
	return nil
end

function key_is_dir(key)
	if key == k_left or key == k_right or key == k_up or key == k_down then return true
	else return false end
end

function get_next_coords(coords, key)
	local next_coords = {x = coords.x, y = coords.y}
	if key == k_left  then next_coords.x  -= 1 end
	if key == k_right then next_coords.x  += 1 end
	if key == k_up    then next_coords.y  -= 1 end
	if key == k_down  then next_coords.y  += 1 end
	next_coords.dir = key
	return next_coords
end
