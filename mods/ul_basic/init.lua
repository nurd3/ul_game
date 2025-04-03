ul_basic = {}

local S = core.get_translator"ul_basic"
local path = core.get_modpath"ul_basic"

ul_basic.get_translator = S
ul_basic.get_modpath = path

-- perma-dark
core.settings:set("world_start_time", 12000)
core.settings:set("time_speed", 72)

core.settings:set("movement_speed_walk", 8.0)

core.register_on_joinplayer(function(plyr, last_login)
	plyr:set_moon {texture="ul_basic_lamp.png", scale = 1.57}
	plyr:set_stars {visible = false}
	plyr:set_sun {texture="ul_basic_lamp.png"}
	plyr:override_day_night_ratio(0)
	plyr:set_sky {
		type = "plain",
		clouds = false,
		base_color = "#000000",
		sky_color = {
			dawn_sky = "#000000",
			dawn_horizon = "#000000",
			day_sky = "#000000",
			day_horizon = "#000000",
			night_sky = "#000000",
			night_horizon = "#000000",
			indoors = "#000000",
			fog_sun_tint = "#000000",
			fog_moon_tint = "#000000",
		}
	}
end)

-- starting item
core.register_on_newplayer(function(plyr)
	plyr:get_inventory():add_item("main", ItemStack"ul_basic:lantern")
end)

xplib.register_on_update(function(plyrname, reason, xp, lvl, total)
	if reason.lvlchange >= 1 then
		core.chat_send_player(plyrname, core.colorize("#ffff00", S("Level up! You are now level @1!", lvl)))
		ul_basic.objsound(core.get_player_by_name(plyrname), "ul_activate")
	elseif reason.xpchange then
		ul_basic.objsound(core.get_player_by_name(plyrname), "ul_basic_equip")
	end
end)

dofile(path.."/functions.lua")
dofile(path.."/darkness.lua")
dofile(path.."/nodes.lua")
dofile(path.."/tools.lua")
dofile(path.."/items.lua")
dofile(path.."/doors.lua")
dofile(path.."/crafts.lua")
dofile(path.."/attackbar.lua")

-- replace light functions so that they return accurate values

local old_get_node_light = core.get_node_light
local old_get_natural_light = core.get_natural_light

core.get_node_light = function (pos)
	return old_get_node_light(pos, 0)
end

core.get_natural_light = function (pos)
	return old_get_natural_light(pos, 0)
end