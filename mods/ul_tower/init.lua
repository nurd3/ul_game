ul_tower = {}

local S = core.get_translator"ul_tower"
local path = core.get_modpath"ul_tower"

ul_tower.get_translator = S
ul_tower.get_modpath = path

dofile(path.."/functions.lua")
dofile(path.."/nodes.lua")
dofile(path.."/mobs.lua")
dofile(path.."/natural_entities.lua")
dofile(path.."/sfinv.lua")

ul_tower.register_pickable_items {
	["ul_basic:stone"] = 256,
	["ul_market:hp_vial"] = 256,

	["ul_mobs:eye"] = 128,

	["lootblocks:lootblock"] = 96,
	["ul_basic:building"] = 96,
	["ul_basic:door"] = 96,
	["ul_basic:lamp"] = 96,
	["ul_basic:lantern"] = 96,
	["ul_basic:ore"] = 96,

	["ul_basic:ore_rare"] = 64,
	["ul_magic:fireball"] = 64,

	["ul_basic:ore_super"] = 32,
	["ul_lives:life"] = 32,
	["ul_magic:crystal"] = 32,
	["ul_mobs:zombie"] = 32,
	["ul_mobs:ghost"] = 32,

	["ul_magic:sun"] = 16,
	["ul_mobs:mgull"] = 16,
	["ul_mobs:rgull"] = 16,
	["ul_storage:crate"] = 16,

	["ul_basic:pick"] = 8,
	["ul_basic:sword"] = 8,
	["ul_magic:runestone"] = 8,

	["ul_market:tradeinator"] = 4,

	["ul_market:tradeinator_rare"] = 2,

	["ul_magic:heal_spell"] = 1,
	["ul_magic:teleport_spell"] = 1,
	["ul_market:tradeinator_super"] = 1,
}

ul_market.register_on_eventbonuscalc(function(event_bonuses)
	local hgt = ul_tower.get_height() * 0.125
	ul_market.add_event_bonus(event_bonuses, "overall", {chance = hgt, intensity = hgt})
	return event_bonuses
end)