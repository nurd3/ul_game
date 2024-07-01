minitest = {}

local S = minetest.get_translator"minitest"
local path = minetest.get_modpath"minitest"

minitest.get_translator = S
minitest.get_modpath = path

dofile(path.."/nodes.lua")