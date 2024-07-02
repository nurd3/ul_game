ul_basic = {}

local S = minetest.get_translator"ul_basic"
local path = minetest.get_modpath"ul_basic"

ul_basic.get_translator = S
ul_basic.get_modpath = path

dofile(path.."/nodes.lua")