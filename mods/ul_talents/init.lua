ul_talents = {}

local S = core.get_translator"ul_talents"
local path = core.get_modpath"ul_talents"

ul_talents.get_translator = S
ul_talents.get_modpath = path

dofile(path.."/register.lua")
dofile(path.."/functions.lua")
dofile(path.."/menu.lua")

-- optional depends, required for built-in talents
if ul_basic
and ul_lives
and ul_magic
and ul_shrines
and ul_statfx
and ul_tower
then
	dofile(path.."/data.lua")
	dofile(path.."/talents.lua")
	core.override_item("ul_tower:tower", {
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			if clicker and clicker:is_player()
			then core.show_formspec(clicker:get_player_name(), "ul_talents:formspec", ul_talents.get_formspec(clicker:get_player_name()))
			end
		end
	})
	ul_tower.register_on_towerupdate(function()
		core.chat_send_all(core.colorize("#ffff00", "Right-click tower to access the talents menu"))
	end)
end


dofile(path.."/commands.lua")