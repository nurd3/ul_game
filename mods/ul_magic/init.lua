ul_magic = {}

local path = core.get_modpath"ul_magic"
local S = core.get_translator"ul_magic"

ul_magic.get_modpath = path
ul_magic.get_translator = S

core.register_craftitem("ul_magic:spell", {
	description = S"Blank Spell",
	inventory_image = "ul_magic_spell.png",
	on_use = function(itemstack, user)
		ul_basic.objsound(user, "ul_fail")
	end,
	on_secondary_use = function(itemstack, user)		
		ul_basic.objsound(user, "ul_fail")
	end,
	groups = {spell = 1}
})

dofile(path.."/functions.lua")
dofile(path.."/register.lua")
dofile(path.."/crystals.lua")
dofile(path.."/runestones.lua")
dofile(path.."/wearables.lua")
dofile(path.."/statfx.lua")
dofile(path.."/runes.lua")