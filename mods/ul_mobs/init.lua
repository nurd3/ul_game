ul_mobs = {}

local S = core.get_translator"ul_mobs"
local path = core.get_modpath"ul_mobs"

ul_mobs.get_translator = S
ul_mobs.get_modpath = path
ul_mobs.reaction_time = core.settings:get("ul_mobs_reaction_time") or 0.25

if not table.unpack then
    table.unpack = unpack
end

dofile(path.."/mobkit_plus.lua")

dofile(path.."/functions.lua")
dofile(path.."/register.lua")

dofile(path.."/soul.lua")

dofile(path.."/monsters.lua")
dofile(path.."/animals.lua")
dofile(path.."/arcanoids.lua")
dofile(path.."/races.lua")

if natural_entities then
	dofile(path.."/natural_entities.lua")
end
