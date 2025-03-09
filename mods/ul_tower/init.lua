ul_tower = {}

local S = core.get_translator"ul_tower"
local path = core.get_modpath"ul_tower"

ul_tower.get_translator = S
ul_tower.get_modpath = path

dofile(path.."/functions.lua")
dofile(path.."/commands.lua")
dofile(path.."/nodes.lua")
dofile(path.."/mobs.lua")
dofile(path.."/natural_entities.lua")
dofile(path.."/sfinv.lua")
dofile(path.."/levels.lua")
dofile(path.."/events.lua")

ul_tower.register_pickable_items {
	["ul_basic:stone"] = 128,

	["ul_basic:building"] = 48,
	["ul_basic:door"] = 48,
	["ul_basic:ore"] = 48,
	["ul_magic:fireball"] = 48,

	["lootblocks:lootblock"] = 32,
	["ul_basic:ore_rare"] = 32,
	["ul_lives:life"] = 32,
	["ul_magic:crystal"] = 32,
	["ul_mobs:eye"] = 32,

	["ul_basic:lamp"] = 16,
	["ul_basic:ore_super"] = 16,
	["ul_magic:sun"] = 16,
	["ul_market:hp_vial"] = 16,
	["ul_mobs:ghost"] = 16,
	["ul_mobs:mgull"] = 16,
	["ul_mobs:rgull"] = 16,
	["ul_mobs:zombie"] = 16,
	["ul_storage:crate"] = 16,

	["ul_basic:lantern"] = 8,
	["ul_basic:pick"] = 8,
	["ul_basic:sword"] = 8,
	["ul_magic:runestone"] = 8,

	["ul_market:tradeinator"] = 2,
	["ul_market:tradeinator_rare"] = 2,

	["ul_magic:heal_spell"] = 1,
	["ul_magic:teleport_spell"] = 1,
	["ul_market:tradeinator_super"] = 1,
}

ul_market.register_on_eventbonuscalc(function(event_bonuses)
	local hgt = ul_tower.get_height() * 0.25
	ul_market.add_event_bonus(event_bonuses, "overall", {chance = hgt, intensity = hgt})
	return event_bonuses
end)