ul_totems = {}

local path = core.get_modpath"ul_totems"
local S = core.get_translator"ul_totems"
local storage = core.get_mod_storage()

ul_totems.get_modpath = path
ul_totems.get_translator = S


local rune_levels = {}

local active_totems = core.deserialize(storage:get_string("active_totems")) or {}

function ul_totems.get_rune_bonus(name)
	return rune_levels[name] or 0
end

function ul_totems.get_active_rune_bonuses()
	return rune_levels
end

for _,v in pairs(active_totems) do
	rune_levels[v] = ul_totems.get_rune_bonus(v) + 1
end

core.register_node("ul_totems:totem", {
	description = S"Totem",
	diggable = false,
	tiles = {"ul_totems_totem.png"},
	light_source = 8,
	on_rightclick = function(pos, node, puncher, stack, pointed_thing)
		local wielded_item = puncher:get_wielded_item():get_name()

		if active_totems[vector.to_string(pos)] and ul_magic.registered_runes[active_totems[vector.to_string(pos)]] then
			wielded_item = active_totems[vector.to_string(pos)]
		end

		local rune = wielded_item and ul_magic.registered_runes[wielded_item]

		if rune then
			stack:take_item()
			ul_basic.possound(pos, "ul_magic_cast")
			core.set_node(pos, {name = "ul_totems:totem_active", param2 = rune.index + 1})
			active_totems[vector.to_string(pos)] = wielded_item
			rune_levels[wielded_item] = ul_totems.get_rune_bonus(wielded_item) + 1
			storage:set_string("active_totems", core.serialize(active_totems))
		else
			ul_basic.possound(pos, "ul_fail")
		end
	end
})

core.register_node("ul_totems:totem_active", {
	description = S"Active Totem",
	diggable = false,
	tiles = {"ul_totems_totem_active.png"},
	palette = ul_magic.rune_palette,
	light_source = 15,
	paramtype2 = "color",
	on_rightclick = function(pos, node, puncher, stack, pointed_thing)
		local rune = ul_magic.get_rune_by_index(node.param2 - 1)
		if not rune then
			core.set_node(pos, {name = "ul_totems:totem"})
			active_totems[vector.to_string(pos)] = nil
			storage:set_string("active_totems", core.serialize(active_totems))
			return
		end

		if not active_totems[vector.to_string(pos)] then
			core.log("totem unregistered")
			active_totems[vector.to_string(pos)] = rune
			rune_levels[rune] = ul_totems.get_rune_bonus(rune) + 1
			storage:set_string("active_totems", core.serialize(active_totems))
			return
		end


		ul_basic.drop(pos, 1.0, rune, 1)
		active_totems[vector.to_string(pos)] = nil
		storage:set_string("active_totems", core.serialize(active_totems))
		core.set_node(pos, {name = "ul_totems:totem"})
	end
})

-- https://github.com/BlockMen/dungeon_loot/blob/master/init.lua

local function place_totem(tab)
	if tab == nil or #tab < 1 then
		return
	end
	local pos = tab[math.random(1, #tab)]
	pos.y = pos.y - 1
	local below = core.get_node_or_nil(pos)
	if below and below.name ~= "air" then
		pos.y = pos.y + 1
		core.set_node(pos, {name = "ul_totems:totem"})
	end
end

core.set_gen_notify("dungeon")
core.register_on_generated(function(minp, maxp, blockseed)
	local mgo = core.get_mapgen_object("gennotify")
	if mgo and mgo.dungeon then
		core.after(3, place_totem, table.copy(mgo.dungeon))
	end
end)