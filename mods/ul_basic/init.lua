ul_basic = {}

local S = minetest.get_translator"ul_basic"
local path = minetest.get_modpath"ul_basic"

ul_basic.get_translator = S
ul_basic.get_modpath = path

-- perma-dark
minetest.set_timeofday(0)
minetest.settings:set("time_speed", 0)
minetest.settings:set("movement_speed_walk", 8.0)

minetest.register_on_joinplayer(function(plyr, last_login)
	plyr:set_moon({visible = false})
	plyr:set_stars({visible = false})
	plyr:set_sun({texture="ul_basic_lamp.png"})
	plyr:override_day_night_ratio(0)
	plyr:set_sky({
		type = "plain",
		clouds = false,
		base_color = "#000000",
		sky_color = {
			day_sky = "#000000",
			night_sky = "#000000",
			dawn_sky = "#000000"
		}
	})
end)

-- starting item
minetest.register_on_newplayer(function(plyr)
	plyr:get_inventory():add_item("main", ItemStack"ul_basic:lantern")
end)

dofile(path.."/functions.lua")
dofile(path.."/darkness.lua")
dofile(path.."/nodes.lua")
dofile(path.."/tools.lua")
dofile(path.."/crafts.lua")