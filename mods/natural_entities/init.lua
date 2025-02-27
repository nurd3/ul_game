natural_entities = {}

local S = core.get_translator"natural_entities"
local path = core.get_modpath"natural_entities"

natural_entities.get_translator = S
natural_entities.get_modpath = path

local MAX_ENTS = minetest.settings:get("natural_entities_maximum") or 64

local function generate_ent(entities)
	local temp = {}

	for name,chance in pairs(entities) do
		table.insert(temp, {name, chance})
	end

	table.sort(temp, function(a,b)
		return a[2] > b[2]
	end)
	
	return temp[1][1]
end

local function adjust(pos, min, max)
	local pos = vector.copy(pos)
	local radius = 16
	local offset = vector.new(-radius,-radius,-radius)
	
	local count = 1
	
	local nodename = core.get_node(vector.add(pos, offset)).name
	local node = core.registered_nodes[nodename]
	local spawn = nodename ~= "ignore" and not node.walkable
	
	while not spawn do
		offset.x = offset.x + 1
		if offset.x > radius then
			offset.x = -radius
			offset.z = offset.z + 1
		end
		if offset.z > radius then
			offset.y = offset.y + 1
			offset.z = -radius
		end
		if offset.y > radius then
			break
		end
		nodename = core.get_node(vector.add(pos, offset)).name
		node = core.registered_nodes[nodename]
		spawn = nodename ~= "ignore" and not node.walkable
		count = count + 1
	end
	
	return spawn, vector.add(pos, offset)
end

local function do_spawns(plyr)
	local spawns = natural_entities.registered_spawns
	for name,def in pairs(spawns) do
		
		if math.random() * (def.spawn_rate or 1.0) > math.random() then
			
			-- get position
			local min, max = 
				math.min(def.min_y or 0, def.max_y or 0),
				math.max(def.min_y or 0, def.max_y or 0)
			
			local pos = vector.round(plyr:get_pos())
			if not (pos.y > min - 32 and pos.y < max + 32) then
				return 
			end
			local count = 0
			for _ in core.objects_in_area(vector.offset(pos, -256, min, -256), vector.offset(pos, 256, max, 256)) do
				count = count + 1
			end

			if count < MAX_ENTS then

				min = math.max(min, pos.y - 32)
				max = math.min(max, pos.y + 32)
				pos = vector.offset(pos,
					math.random(4, 256) * math.random(-1, 1),
					math.random(min, max),
					math.random(4, 256) * math.random(-1, 1)
				)
			
				-- get entity
				local entities = def.entities or {}
				
				local ent_name = generate_ent(entities)
				
				if ent_name then
					
					local spawn, pos2 = adjust(pos, min, max)
					
					local repeats = 1
					
					while repeats < 4 and not spawn do
						spawn, pos2 = adjust(pos2, min, max)
						repeats = repeats + 1
						if def.check and not def.check(pos2, ent_name) then
							spawn = false
						end
					end
					
					if spawn and (not def.check or def.check(pos2, ent_name)) then
						core.add_entity(pos2, ent_name)
					end
				end

			end
		end
	end
end

local paused = false

function natural_entities.spawnstep()
	if paused then return end
	for index,plyr in ipairs(core.get_connected_players()) do
		core.after(index * 0.05, do_spawns, plyr)
	end
end

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 1.0 then
		natural_entities.spawnstep()
		timer = 0
	end
end)

dofile(path.."/register.lua")

core.register_chatcommand("pause_natural_entities", {
	params = "",
	description = S"Pause the spawning of natural entities",
	func = function()
		paused = true
	end
})

core.register_chatcommand("unpause_natural_entities", {
	params = "",
	description = S"Unpause the spawning of natural entities",
	func = function()
		paused = false
	end
})