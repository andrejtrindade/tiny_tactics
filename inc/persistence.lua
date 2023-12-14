-- persistence.lua
-- ===============

persistence = {
	tenbit_mask          = 0x03ff,
	labels_selected_bit  =         0b1,
	key_labels_bit       =        0b10,
	animation_speed_mask =      0b1100,
	unlock_progress_bit  =     0b10000,
	anim_move_bit        =    0b100000,
	anim_idle_bit        =   0b1000000,
	boss_skin_bit        =  0b10000000,
	all_trophies_bit     = 0b100000000,
	frame                = 0,
	settings_saved       = false,

init = function(this)
	if not cartdata("ajt_tinytactics_1") then
		for i=0,63 do dset(i, 0) end
	end
	for i=0, coords.num_levels do
		records[i] = this:get_record(i)
		if records[i] > 0 then sel.max_cleared = i end
	end
	this:load_configs()
end,
	
update = function(this, index, record)
	record = mid(1, record, 1000)
	if records[index] == 0 or records[index] > record then
		records[index] = record
		this:set_record(index, record)
		return true
	else return false end
end,

draw = function(this)
	local y = 121
	local s = (this.settings_saved and "settings" or "record").." saved"
	if this.frame > 0 then
		if this.frame > 23 then y += this.frame - 23 end
		if this.frame < 7  then y +=  7 - this.frame end
		rectfill(0, y, 127, 127, c_red)
		print(s, 1, y+1, c_white)
		this.frame -= 1
	end
end,

load_configs = function(this)
	local configs = this:get_record(0)
	controls.labels_selected = check_bit(configs, this.labels_selected_bit)
	if controls.labels_selected then
		options.speed           = rotr(band(configs, this.animation_speed_mask), 2)
		controls.key_labels     = check_bit(configs, this.key_labels_bit)
		options.unlock_progress = check_bit(configs, this.unlock_progress_bit)
		options.anim_move       = check_bit(configs, this.anim_move_bit)
		options.anim_idle       = check_bit(configs, this.anim_idle_bit)
		options.boss_skin       = check_bit(configs, this.boss_skin_bit)
		options.all_trophies    = check_bit(configs, this.all_trophies_bit)
	end
end,

save_configs = function(this)
	local configs = 0
	if controls.labels_selected then configs = bor(configs, this.labels_selected_bit) end
	if controls.key_labels      then configs = bor(configs, this.key_labels_bit)      end
	if options.unlock_progress  then configs = bor(configs, this.unlock_progress_bit) end
	if options.anim_move        then configs = bor(configs, this.anim_move_bit)       end
	if options.anim_idle        then configs = bor(configs, this.anim_idle_bit)       end
	if options.boss_skin        then configs = bor(configs, this.boss_skin_bit)       end
	if options.all_trophies     then configs = bor(configs, this.all_trophies_bit)    end
	configs = bor(configs, band(rotl(options.speed, 2), this.animation_speed_mask))
	configs = bor(configs, band(rotl(options.skin,  7), this.skin_mask))
	this:set_record(0, configs)
end

}
	
-- "private" methods
persistence.get_record = function(this, index)
	local q = index \ 3
	local r = index % 3
	local t = lshr(shl(dget(q), r*10), 4)
	return band(t, this.tenbit_mask)
end

persistence.set_record = function(this, index, value)
	local q = index \ 3
	local r = index % 3
	local t = rotr(rotl(dget(q), r*10), 4)
	t = band(t, bnot(this.tenbit_mask))
	t = bor(t, band(value, this.tenbit_mask))
	dset(q, rotr(rotl(t,4), r*10))
	
	this.frame = 30
	this.settings_saved = index == 0
end

-- persistence helper functions
check_bit = function(configs, bitmask)
	return (band(configs, bitmask) == bitmask)
end
