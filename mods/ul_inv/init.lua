ul_inv = {}

local path = core.get_modpath"ul_inv"
local S = core.get_translator"ul_inv"

ul_inv.get_modpath = path
ul_inv.get_translator = S

dofile(path.."/offhand.lua")
dofile(path.."/outfit.lua")
dofile(path.."/crafting.lua")
dofile(path.."/enchanting.lua")