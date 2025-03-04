local storage = core.get_mod_storage()

function ul_talents.using_talent(plyrname, talent)
	
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.using_talent(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talent) ~= "string"
	then error(string.format(
		"ul_talents.using_talent(): bad argument #2 (string expected, got %s)",
		type(talent)
	)) elseif not ul_talents.registered_talents[talent]
	then core.log("warning", string.format(
		"ul_talents.using_talent(): unknown talent \"%s\"",
		talent
	)); return end

	local def = ul_talents.registered_talents[talent]
	return
		ul_talents.get_slot(plyrname, def.slot) == talent
end

function ul_talents.equip_talent(plyrname, talent)
	
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.using_talent(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talent) ~= "string"
	then error(string.format(
		"ul_talents.using_talent(): bad argument #2 (string expected, got %s)",
		type(talent)
	)) elseif not ul_talents.registered_talents[talent]
	or not ul_talents.registered_talents[talent].slot
	then core.log("warning", string.format(
		"ul_talents.equip_talent(): unknown talent \"%s\"",
		talent
	)); return end

	local def = ul_talents.registered_talents[talent]
	ul_talents.set_slot(plyrname, def.slot, talent)
end

function ul_talents.knows_talent(plyrname, talent)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.knows_talent(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talent) ~= "string"
	then error(string.format(
		"ul_talents.knows_talent(): bad argument #2 (string expected, got %s)",
		type(talent)
	)) end

	return
		storage:get("talent "..plyrname.." "..talent) ~= nil
end

function ul_talents.discover_talent(plyrname, talent)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.discover_talent(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talent) ~= "string"
	then error(string.format(
		"ul_talents.discover_talent(): bad argument #2 (string expected, got %s)",
		type(talent)
	)) end

	storage:set_string("talent "..plyrname.." "..talent, "t")
end

function ul_talents.forget_talent(plyrname, talent)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.forget_talent(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talent) ~= "string"
	then error(string.format(
		"ul_talents.forget_talent(): bad argument #2 (string expected, got %s)",
		type(talent)
	)) end

	storage:set_string("talent "..plyrname.." "..talent, "")
end

function ul_talents.get_talents(plyrname)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_talents(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end

	local temp = {}

	for _,name in ipairs(ul_talents.talents_order) do
		temp[name] = storage:get("talent "..plyrname.." "..name)
	end

	return temp
end

function ul_talents.set_talents(plyrname, talents)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.set_talents(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end
	if type(talents) ~= "table"
	then error(string.format(
		"ul_talents.set_talents(): bad argument #2 (table expected, got %s)",
		type(talents)
	)) end

	for _,name in ipairs(ul_talents.talents_order) do
		if not talents[name]
		then storage:set_string("talent "..plyrname.." "..name, "")
		elseif tostring(talents[name]) ~= "false"
		then storage:set_string("talent "..plyrname.." "..name, "t") end
	end

	return
end

function ul_talents.get_slot(plyrname, slot)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_slot(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(slot) ~= "string"
	then error(string.format(
		"ul_talents.get_slot(): bad argument #2 (string expected, got %s)",
		type(slot)
	)) end

	return storage:get_string("slot "..plyrname.." "..slot)
end

function ul_talents.set_slot(plyrname, slot, val)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.set_slot(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(slot) ~= "string"
	then error(string.format(
		"ul_talents.set_slot(): bad argument #2 (string expected, got %s)",
		type(slot)
	)) elseif type(val) ~= "string"
	then error(string.format(
		"ul_talents.set_slot(): bad argument #3 (string expected, got %s)",
		type(val)
	)) end

	storage:set_string("slot "..plyrname.." "..slot, val)
end

function ul_talents.get_slots(plyrname)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_slots(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end

	local temp = {}

	for _,name in ipairs(ul_talents.slots_order) do
		temp[name] = storage:get("slot "..plyrname.." "..name)
	end

	return temp
end

function ul_talents.set_slots(plyrname, talents)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.set_slots(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(talents) ~= "table"
	then error(string.format(
		"ul_talents.set_slots(): bad argument #2 (table expected, got %s)",
		type(plyrname)
	)) end

	for _,name in ipairs(ul_talents.slots_order) do
		if talents[name]
		then storage:set_string("slot "..plyrname.." "..name, talents[name]) end
	end
end

function ul_talents.get_classes(plyrname)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_classes(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end

	local class_scores = {}
	local slots = ul_talents.get_slots()

	for slot,talent in pairs(slots) do
		local def = ul_talents.registered_talents[talent]
		if def and def.class
		then class_scores[def.class] = (class_scores[def.class] or 0) + 1 end
	end

	return class_scores
end

function ul_talents.get_class(plyrname)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_class(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end

	local class_scores = ul_talents.get_classes(plyrname)
	local temp = {}

	for class,score in pairs(class_scores) do
		table.insert(temp, {class, score})
	end
	table.sort(temp, function(a,b)
		return a[2] > b[2]
	end)

	return temp[1][1]
end

function ul_talents.get_used_levels(plyrname)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.get_used_levels(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) end
	
	return storage:get_int("levels "..plyrname)
end

function ul_talents.set_used_levels(plyrname, value)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.set_used_levels(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(value) ~= "number"
	then error(string.format(
		"ul_talents.set_used_levels(): bad argument #2 (number expected, got %s)",
		type(plyrname)
	)) end
	
	return storage:set_int("levels "..plyrname, value)
end

function ul_talents.add_used_levels(plyrname, value)
	-- handle bad input
	if type(plyrname) ~= "string"
	then error(string.format(
		"ul_talents.add_used_levels(): bad argument #1 (string expected, got %s)",
		type(plyrname)
	)) elseif type(value) ~= "number" and value
	then error(string.format(
		"ul_talents.add_used_levels(): bad argument #2 (number or nil expected, got %s)",
		type(plyrname)
	)) end
	
	return storage:set_int("levels "..plyrname, ul_talents.get_used_levels(plyrname) + (value or 1))
end

function ul_talents.register_talentstep(interval, talent, func, notfunc)
	local timer = 0
	core.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer > interval
		then
			for _,plyr in ipairs(core.get_connected_players())
			do
				local plyrname = plyr:get_player_name()
				if ul_talents.using_talent(plyrname, talent)
				then if func then func(plyr, plyrname) end
				elseif notfunc
				then notfunc(plyr, plyrname)
				end
			end
			timer = 0
		end
	end)
end

local physics_overrides = {}

function ul_talents.register_talentphysics(talent, physics)
	table.insert(physics_overrides, {talent = talent, physics = physics})
end

local physics_timer = 0

core.register_globalstep(function(dtime)
	physics_timer = physics_timer + dtime
	if physics_timer > 0.25
	then
		for _,plyr in ipairs(core.get_connected_players())
		do
			local plyrname = plyr:get_player_name()
			local phy = {}
			for _,t in ipairs(physics_overrides)
			do
				if t.talent
				and t.physics
				and ul_talents.using_talent(plyrname, t.talent)
				then
					for k,v in pairs(t.physics)
					do phy[k] = (phy[k] or 1) * v
					end
				else
					for k,v in pairs(t.physics)
					do phy[k] = phy[k] or 1
					end
				end
			end
			plyr:set_physics_override(phy)
		end
		timer = 0
	end
end)