ul_shrines = {}

local S = core.get_translator"ul_shrines"
local path = core.get_modpath"ul_shrines"

ul_shrines.get_translator = S
ul_shrines.get_modpath = path

dofile(path.."/register.lua")
dofile(path.."/shrines.lua")

dofile(path.."/data.lua")
dofile(path.."/sfinv.lua")