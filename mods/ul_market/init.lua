ul_market = {}

local path = core.get_modpath"ul_market"
local S = core.get_translator"ul_market"

ul_market.get_modpath = path
ul_market.get_translator = S

local storage = core.get_mod_storage()

if storage:get("reset") then
	storage:from_table{}
end

dofile(path.."/game_items.lua")
dofile(path.."/npcs.lua")
dofile(path.."/news.lua")

dofile(path.."/register.lua")

dofile(path.."/data.lua")

dofile(path.."/market.lua")
dofile(path.."/tradeinator.lua")
dofile(path.."/portfolios.lua")
dofile(path.."/trade.lua")
dofile(path.."/events.lua")
dofile(path.."/government.lua")

dofile(path.."/commands.lua")
dofile(path.."/sfinv.lua")
