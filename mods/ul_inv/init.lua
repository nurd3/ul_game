ul_inv = {}

local path = minetest.get_modpath"ul_inv"
local S = minetest.get_translator"ul_inv"

ul_inv.get_modpath = path
ul_inv.get_translator = S

dofile(path.."/offhand.lua")
dofile(path.."/outfit.lua")