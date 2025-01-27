ul_boss = {}

local path = core.get_modpath"ul_boss"
local S = core.get_translator"ul_boss"

ul_boss.get_modpath = path
ul_boss.get_translator = S

core.register_node("ul_boss:boss", {
	description = S"Boss"
})