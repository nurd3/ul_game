natural_entities = {}

local S = minetest.get_translator"natural_entities"
local path = minetest.get_modpath"natural_entities"

natural_entities.get_translator = S
natural_entities.get_modpath = path

local function generate_ent(entities)
	local temp = {}
	for name,chance in pairs(entities) do
		if math.random() < chance then
			table.insert(temp, name)
		end
	end
	
	if temp then
		return temp[math.random(#temp)]
	end
end

local function adjust(pos, min, max)
	local pos = vector.copy(pos)
	local max_sqr = 16
	local offset = vector.new(-max_sqr,0,-max_sqr)
	
	local count = 1
	
	local nodename = minetest.get_node(vector.add(pos, offset)).name
	local node = minetest.registered_nodes[nodename]
	local spawn = nodename ~= "ignore" and not node.walkable
	
	while not spawn do
		offset.x = offset.x + 1
		if offset.x > max_sqr then
			offset.x = -max_sqr
			offset.z = offset.z + 1
		end
		if offset.z > max_sqr then
			break
		end
		nodename = minetest.get_node(vector.add(pos, offset)).name
		node = minetest.registered_nodes[nodename]
		spawn = nodename ~= "ignore" and not node.walkable
		count = count + 1
	end
	
	pos = vector.add(pos, offset)
	
	local delta = -1
	
	offset.x = 0
	offset.y = 0
	offset.z = 0
	
	--[[ !!!BROKEN!!! FREEZES THE SERVER.
	while not spawn do
		offset.y = offset.y + delta
		if pos.y + offset.y < min then
			delta = 1
			offset.y = 0
		end
		if pos.y + offset.y > max then
			return false, vector.add(pos, offset)
		end
		nodename = minetest.get_node(vector.add(pos, offset)).name
		node = minetest.registered_nodes[nodename]
		spawn = nodename ~= "ignore" and not node.walkable
		count = count + 1
	end
	--]]
	return spawn, vector.add(pos, offset)
end

local function do_spawns(dtime, plyr)
	local spawns = natural_entities.registered_spawns
	for name,def in pairs(spawns) do
		
		if math.random() * 2 < dtime * (def.spawn_rate or 1.0) then
			
			-- get position
			local min, max = 
				math.min(def.min_y or 0, def.max_y or 0),
				math.max(def.min_y or 0, def.max_y or 0)
			
			local pos = vector.round(plyr:get_pos())
			if not (pos.y > min - 32 and pos.y < max + 32) then
				return 
			end
			min = math.max(min, pos.y - 32)
			max = math.min(min, pos.y + 32)
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
					minetest.add_entity(pos2, ent_name)
				end
			end
		end
	end
end

function natural_entities.spawnstep(dtime)
	for _,plyr in ipairs(minetest.get_connected_players()) do
		do_spawns(dtime, plyr)
	end
end

minetest.register_globalstep(function(dtime)
	return natural_entities.spawnstep(dtime)
end)

dofile(path.."/register.lua")