local storage = core.get_mod_storage()

local tower_pos = core.deserialize(storage:get_string("pos"))
function ul_tower.update() end

function ul_tower.spawn_check(min)
	return function() return math.random() < math.random() * (math.max(ul_tower.get_height(), min - 1) - min + 1) * 0.25 end
end

function ul_tower.reset()
	tower_pos = nil
	storage:set_string("pos", "")
	storage:set_int("height", 0)
	ul_tower.update()
end

function ul_tower.get_height()
	return storage:get_int("height") or 0
end

function ul_tower.set_height(val)
	storage:set_int("height", val)
	ul_tower.update()
end

function ul_tower.add_height(val)
	storage:set_int("height", ul_tower.get_height() + (val or 1))
	ul_tower.update()
end

function ul_tower.get_pos()
	return tower_pos
end

function ul_tower.set_pos(val)
	tower_pos = val
	storage:set_string("pos", core.serialize(tower_pos))
	ul_tower.update()
end

function ul_tower.register_on_towerupdate(func)
	local prev = ul_tower.update
	ul_tower.update = function()
		prev()
		func()
	end
end

ul_tower.pickable_items = {}

function ul_tower.register_pickable_item(itemname, max)
	table.insert(ul_tower.pickable_items, {name = itemname, max = max})
end

function ul_tower.register_pickable_items(items)
	for itemname,max in pairs(items) do
		table.insert(ul_tower.pickable_items, {name = itemname, max = max})
	end
end

function ul_tower.get_random_stack()
	local x = ul_tower.pickable_items[math.random(#ul_tower.pickable_items)]
	if not x then return end
	return x.name .. " " .. tostring(math.random(x.max))
end
