-- level.lua
-- =========

level = {
	coords = {},
	off_x = 0,
	off_y = 0,
	lock      = {x = 0, y = 0, flip_h = false, flip_v = false, sprite = spr_lock},
	door      = {x = 0, y = 0, flip_h = false, flip_v = false, sprite = spr_locked_door_up},
	exit_text = {x = 0, y = 0, flip_h = false, flip_v = false, sprite = spr_exit_text_h, w = 1, h = 1}
}
	
level.show = function(this, number)
	local x, y
	for enemy in all(enemies) do del(enemies, enemy) end
	this:load_coords(number)
	this.off_x = 8-(this.coords.w/2)
	this.off_y = 7-(this.coords.h/2)
	if this.coords.h <= 9 then this.off_y -= 1 end
	for x = 0,this.coords.w-1 do
		for y = 0,this.coords.h-1 do
			local spr_idx = 
			this:spawn_entities(x, y, this:get_pos_xy(x, y))
		end
	end
	sort_enemies()
	turn:start_level()
	menuitem(1, "restart level", restart_level)
	menuitem(2, "quit level", quit_level)
	screen = this
	play_music(-1)
end

level.update = function(this)
	if turn.player or player.is_dead then
		player:update()
	else
		local enemy = turn.enemy
		enemy:update()
	end
end

level.draw = function(this)
	local base = calc_base(level.coords.i)
	cls()
	
	-- controls
	if this.coords.h <= 9 then print_controls() end
	
	-- level
	pal(palettes.map)
	set_wall_colors(base)
	map(this.coords.x, this.coords.y, this.off_x*8, 6 + this.off_y*8, this.coords.w, this.coords.h)
	pal(0)
	
	-- player and enemies
	player:draw()
	for enemy in all(enemies) do
		enemy:draw()
	end
	
	-- lock / exit
	this:draw_lock_exit(base)
	if player.is_dead then player:draw() end -- redraw player dead anim over enemies and lock / exit

	-- title bar
	local l = level.coords.i%9
	if l == 0 then l = 9 end
	rectfill(0,0,127,6,c_dark_gray)
	print("level "..base.."-"..l..": "..level.coords.name, 1, 1, c_gray)
	
	-- status bar
	rectfill(0,121,127,127,c_dark_gray)
	print("turn "..turn.counter, 1, 122, c_gray)

	-- turn
	if turn.player then print_line("player turn", 20, c_blue, k_right)
	else print_line("enemy turn", 20, c_gray, k_right) end
end

level.get_pos = function(this, obj)
	return this:get_pos_xy(obj.x, obj.y)
end

-- "private" methods
level.get_pos_xy = function(this, x, y)
	return mget(x + this.coords.x, y + this.coords.y)
end

level.spawn_entities = function(this, x, y, spr_idx)
	-- player
	if spr_idx == spr_blue_left   then player:spawn(x, y, k_left)  end
	if spr_idx == spr_blue_left+1 then player:spawn(x, y, k_right) end
	if spr_idx == spr_blue_left+2 then player:spawn(x, y, k_up)    end
	if spr_idx == spr_blue_left+3 then player:spawn(x, y, k_down)  end
	-- enemies
	spawn_enemies(x, y, spr_idx, spr_walker_left,   palettes.walker)
	spawn_enemies(x, y, spr_idx, spr_camper_left,   palettes.camper)
	spawn_enemies(x, y, spr_idx, spr_listener_left, palettes.listener)
	spawn_enemies(x, y, spr_idx, spr_soldier_left,  palettes.soldier)
	spawn_enemies(x, y, spr_idx, spr_sniper_left,   palettes.sniper)
	spawn_enemies(x, y, spr_idx, spr_merc_left,     palettes.merc)
	spawn_enemies(x, y, spr_idx, spr_blond_left,    palettes.blond)
	spawn_enemies(x, y, spr_idx, spr_bloldier_left, palettes.bloldier)
	spawn_enemies(x, y, spr_idx, spr_blerc_left,    palettes.blerc)
	-- exit
	if spr_idx == spr_exit_left   then this:spawn_exit(x, y, x+0.5, y    , k_left)  end
	if spr_idx == spr_exit_left+1 then this:spawn_exit(x, y, x-0.5, y    , k_right) end
	if spr_idx == spr_exit_left+2 then this:spawn_exit(x, y, x,     y+0.5, k_up)    end
	if spr_idx == spr_exit_left+3 then this:spawn_exit(x, y, x,     y-0.5, k_down)  end	
end

level.spawn_exit = function(this, x_door, y_door, x_lock, y_lock, dir)
	this.door.x, this.door.y, this.lock.x, this.lock.y = x_door, y_door, x_lock, y_lock
	if dir == k_left or dir == k_right then 
		this.door.sprite = spr_locked_door_left
		this.door.flip_h = dir == k_right
		this.exit_text.x = x_lock
		this.exit_text.y = y_lock-0.5
		this.exit_text.w = 1
		this.exit_text.h = 2
		this.exit_text.sprite = spr_exit_text_v
	elseif dir == k_up or dir == k_down then 
		this.door.sprite = spr_locked_door_up
		this.door.flip_v = dir == k_down
		this.exit_text.x = x_lock-0.5
		this.exit_text.y = y_lock
		this.exit_text.w = 2
		this.exit_text.h = 1
		this.exit_text.sprite = spr_exit_text_h
	end
	if dir == k_down then this.off_y += 0.5 end
end

level.draw_lock_exit = function(this, base)
	if #enemies <= 0 then
		if this.door.sprite == spr_locked_door_up   then this.door.sprite = spr_open_door_up   end
		if this.door.sprite == spr_locked_door_left then this.door.sprite = spr_open_door_left end
		set_wall_colors(base)
		palt(14, true)
	end
	draw_object(this.door)
	palt(14, false)
	pal(0)
	if #enemies > 0 then draw_object(this.lock)
	else draw_object_wh(this.exit_text)	end
end

level.load_coords = function(this, n)
	this.coords.i = n
	this.coords.x = coords:x(n)
	this.coords.y = coords:y(n)
	this.coords.w = coords:w(n)
	this.coords.h = coords:h(n)
	this.coords.devs_record = coords:devs_record(n)
	this.coords.name = coords.names[n]
end

-- level helper functions
spawn_enemies = function(x, y, spr_idx, spr_color_left, rank)
	if spr_idx == spr_color_left   then enemy_class:spawn(x, y, k_left,  rank) end
	if spr_idx == spr_color_left+1 then enemy_class:spawn(x, y, k_right, rank) end
	if spr_idx == spr_color_left+2 then enemy_class:spawn(x, y, k_up,    rank) end
	if spr_idx == spr_color_left+3 then enemy_class:spawn(x, y, k_down,  rank) end
end

sort_enemies = function()
	local walkers, campers, listeners, soldiers, snipers, mercs, blonds, bloldiers, blercs = {}, {}, {}, {}, {}, {}, {}, {}, {}
	while #enemies > 0 do
		local enemy = enemies[1]
		if     enemy.palette == palettes.walker   then add(walkers,   enemy)
		elseif enemy.palette == palettes.camper   then add(campers,   enemy)
		elseif enemy.palette == palettes.listener then add(listeners, enemy)
		elseif enemy.palette == palettes.soldier  then add(soldiers,  enemy)
		elseif enemy.palette == palettes.sniper   then add(snipers,   enemy)
		elseif enemy.palette == palettes.merc     then add(mercs,     enemy)
		elseif enemy.palette == palettes.blond    then add(blonds,    enemy)
		elseif enemy.palette == palettes.bloldier then add(bloldiers, enemy)
		elseif enemy.palette == palettes.blerc    then add(blercs,    enemy)
		end
		del(enemies, enemy)
	end
	-- red-haired act first
	add_rank(walkers); add_rank(soldiers)
	-- blonds go after red-haired
	add_rank(blercs);  add_rank(blonds);    add_rank(bloldiers)
	-- dark-haired act last
	add_rank(mercs) -- mercs are the first to act among enemies with the same hair color
	add_rank(campers); add_rank(listeners); add_rank(snipers)
end

add_rank = function(rank)
	while #rank > 0 do
		enemy = rank[1]
		add(enemies, enemy)
		del(rank, enemy)
	end
end

set_wall_colors = function(base)
	pal(14,wall_colors[base*2-1])
	pal(2, wall_colors[base*2])
end
