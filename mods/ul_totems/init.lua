ul_totems = {}

local path = core.get_modpath"ul_totems"
local S = core.get_translator"ul_totems"

ul_totems.get_modpath = path
ul_totems.get_translator = S

local storage = core.get_mod_storage()

local rune_levels = core.deserialize(storage:get_string("totems")) or {}


function ul_totems.get_rune_bonus(name)
	return rune_levels[name] or 0
end

core.register_node("ul_totems:totem", {
	description = S"Totem",
	diggable = false,
	tiles = {"ul_totems_totem.png"},
	light_source = 8,
	on_rightclick = function(pos, node, puncher, pointed_thing)
		local wielded_item = puncher:get_wielded_item()
		local rune = wielded_item and ul_magic.registered_runes[wielded_item:get_name()]

		if rune then
			ul_basic.possound(pos, "ul_magic_cast")
			core.set_node(pos, {name = "ul_totems:totem_active", param2 = rune.index + 1})
			rune_levels[wielded_item:get_name()] = ul_totems.get_rune_bonus(wielded_item:get_name()) + 1
			storage:set_string("totems", core.serialize(rune_levels))
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
})

-- https://github.com/BlockMen/dungeon_loot/blob/master/init.lua

local function place_spawner(tab)
	if tab == nil or #tab < 1 then
		return
	end
	local pos = tab[math.random(1, #tab)]
	pos.y = pos.y - 1
	local below = core.get_node_or_nil(pos)
	if below and below.name ~= "air" then
		pos.y = pos.y + 1
		core.set_node(pos, {name = "ul_totems:totem"})
		core.log(vector.to_string(pos))
	end
end

core.set_gen_notify("dungeon")
core.register_on_generated(function(minp, maxp, blockseed)
	local mgo = core.get_mapgen_object("gennotify")
	if mgo and mgo.dungeon then
		core.after(3, place_spawner, table.copy(mgo.dungeon))
	end
end)