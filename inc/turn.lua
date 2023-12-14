-- turn.lua
-- ========

turn = {

start_level = function(this)
	this.player = true
	this.counter = 1
end,
	
finished = function(this)
	if this.player then
		if #enemies > 0 then
			this.player = false
			this.enemy = enemies[1]
		else
			this.counter += 1
		end
	else
		this.enemy = get_next_enemy(this.enemy)
		if this.enemy == nil then
			this.player = true
			this.counter += 1
		else -- update more than one enemy if anim is resolved on the same frame, important if move / idle anim is off
			this.enemy:update()
		end
	end
end

}

-- turn helper functions
function get_next_enemy(enemy)
	-- mercs can kill other enemies, so we don't just save the index:
	-- we save a pointer to the current enemy and search the enemies array to find him every time.
	local index = 1
	while (enemy ~= enemies[index]) do index += 1 end
	return enemies[index+1]
end
