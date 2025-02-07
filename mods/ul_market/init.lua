ul_market = {}

local path = core.get_modpath"ul_market"
local S = core.get_translator"ul_market"

ul_market.get_modpath = path
ul_market.get_translator = S

dofile(path.."/game_items.lua")
dofile(path.."/npcs.lua")
dofile(path.."/news.lua")

dofile(path.."/register.lua")

dofile(path.."/data.lua")

dofile(path.."/market.lua")
dofile(path.."/tradeinator.lua")
dofile(path.."/portfolios.lua")
dofile(path.."/government.lua")
dofile(path.."/trade.lua")
dofile(path.."/events.lua")

dofile(path.."/commands.lua")
dofile(path.."/sfinv.lua")
