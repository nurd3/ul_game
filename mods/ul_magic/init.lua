ul_magic = {}

local path = core.get_modpath"ul_magic"
local S = core.get_translator"ul_magic"

ul_magic.get_modpath = path
ul_magic.get_translator = S

core.register_craftitem("ul_magic:spell", {
	description = S"Blank Spell",
	inventory_image = "ul_magic_spell.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "object" and user:is_player() then
			local tool_capabilities = user:get_wielded_item():get_tool_capabilities()
			ul_basic.punch(
				pointed_thing.ref,
				user,
				ul_basic.get_attackdtime(user:get_player_name(),
				tool_capabilities.full_punch_interval, false),
				tool_capabilities,
				user:get_look_dir()
			)
		else
			ul_basic.objsound(user, "ul_fail")
		end
	end,
	on_secondary_use = function(itemstack, user)		
		ul_basic.objsound(user, "ul_fail")
	end,
	groups = {spell = 1}
})

dofile(path.."/functions.lua")
dofile(path.."/commands.lua")
dofile(path.."/register.lua")
dofile(path.."/crystals.lua")
dofile(path.."/runestones.lua")
dofile(path.."/wearables.lua")
dofile(path.."/statfx.lua")
dofile(path.."/runes.lua")
dofile(path.."/balls.lua")