local function offhand(plyr)
	local inv = plyr:get_inventory()
	local offhand = inv:get_stack("offhand", 1)
	local hand = plyr:get_wielded_item()
	inv:set_stack("offhand", 1, hand)
	plyr:set_wielded_item(offhand)
	return
end

minetest.register_on_joinplayer(function(plyr)
    local inv = plyr:get_inventory()
    inv:set_size("offhand", 1)
end)

if wielded_light then
    wielded_light.register_player_lightstep(function(plyr)
        wielded_light.track_user_entity(plyr, "offhand", plyr:get_inventory():get_stack("offhand", 1))
    end)
end

local pressed = {}

minetest.register_globalstep(function (dtime)
	for _,plyr in ipairs(minetest.get_connected_players()) do
		local controls = plyr:get_player_control()
		if controls.aux1 then 
			pressed[plyr:get_player_name()] = false
		elseif not pressed[plyr:get_player_name()] then
			pressed[plyr:get_player_name()] = true
			offhand(plyr)
		end
	end
end)