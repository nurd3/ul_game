local storage = core.get_mod_storage()

function ul_shrines.set_shrine_level(name, val)
	if not name then return end
	storage:set_float("shrine:"..name, math.max(0, math.min(100, val or 0)))
	return true
end

function ul_shrines.add_shrine_level(name, amount)
	if not name then return end
	storage:set_float("shrine:"..name, math.max(0, math.min(100, storage:get_int("shrine:"..name) + (amount or 1))))
	return true
end

function ul_shrines.get_shrine_level(name)
	if not name then return end
	return math.max(0, math.min(100, storage:get_float("shrine:"..name)))
end

function ul_shrines.get_shrine_mult(name)
	if not name then return end
	return ul_shrines.get_shrine_level(name) * 0.01
end

function ul_shrines.repent_shrine(name)
	if not name then return end

	local def = ul_shrines.registered_shrines[name]

	if ul_shrines.get_shrine_level(name) == 0 then
		return false
	elseif def and def.on_repent then
		ul_shrines.set_shrine_level(name, def.on_repent(ul_shrines.get_shrine_level(name)))
	elseif def and def.repentable then
		ul_shrines.add_shrine_level(name, -1)
	else
		core.log("warning", string.format("ul_shrines.repent: Attempt to repent %s shrine (%s)",
			def and "unrepentable" or "undefined",
			name
		))
	end
	return true
end

function ul_shrines.get_shrine_levels(...)
	local names = {...}

	if #names == 0 then
		names = ul_shrines.shrine_order
			or error("ul_shrines.get_shrine_levels: Something went very very wrong (ul_shrines.shrine_order not defined)")
	elseif type(shrines[1]) == "table" then
		names = table.unpack(shrines[1])
	end
	
	local levels = {}

	for _,name in ipairs(names) do
		levels[name] = ul_shrines.get_shrine_level(name)
	end

	return levels
end

function ul_shrines.get_shrine_mults(...)
	local names = {...}

	if #names == 0 then
		names = ul_shrines.shrine_order
			or error("ul_shrines.get_shrine_mults: Something went very very wrong (ul_shrines.shrine_order not defined)")
	elseif type(shrines[1]) == "table" then
		names = table.unpack(shrines[1])
	end
	
	local mults = {}

	for _,name in ipairs(names) do
		mults[name] = ul_shrines.get_shrine_mult(name)
	end

	return mults
end

function ul_shrines.set_piety_level(plyrname, val)
	if not plyrname then return end
	storage:set_int("piety:"..plyrname, val or 0)
	return true
end

function ul_shrines.add_piety_level(plyrname, amount)
	if not plyrname then return end
	storage:set_int("piety:"..plyrname, storage:get_int("piety:"..plyrname) + (amount or 1))
	return true
end

function ul_shrines.get_piety_level(plyrname)
	if not plyrname then return end
	return storage:get_int("piety:"..plyrname)
end

local function on_step(levels)
	return levels
end

function ul_shrines.on_step(levels)
	levels = levels or {}

	for name,def in pairs(ul_shrines.registered_shrines) do
		levels[name] = ul_shrines.get_shrine_level(name)
		if def.on_step then
			levels[name] = def.on_step(levels[name])
		end
	end

	levels = on_step(levels)

	for name,val in pairs(levels) do
		ul_shrines.set_shrine_level(name, val)
	end
end

function ul_shrines.register_on_step(func)
	local prev = on_step
	on_step = function(levels) return func(prev(levels)) or levels end
end

local timer = 0

core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 5.0 then
		ul_shrines.on_step()
		timer = 0
	end
end)