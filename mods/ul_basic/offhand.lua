local function can_be_offhanded(itemname)
	if itemname and minetest.registered_items[itemname] and minetest.registered_items[itemname].disable_offhand then
		return false
	end
	return true
end

local function offhand(plyr)
	local inv = plyr:get_inventory()
	local offhand = inv:get_stack("offhand", 1)
	local hand = plyr:get_wielded_item()
	
	if not can_be_offhanded(hand:get_name()) then
		return
	end
	
	inv:set_stack("offhand", 1, hand)
	plyr:set_wielded_item(offhand)
	return
end

minetest.register_on_joinplayer(function(plyr)
    local inv = plyr:get_inventory()
    inv:set_size("offhand", 1)
	plyr:hud_add({
		type = "inventory",
		hud_elem_type = "inventory",
		position = {x=0.25, y=1.0},
		name = "offhand",
		scale = {x = 1, y = 1},
		text = "offhand",
		number = 1,
		direction = 0,
		offset = {x = 10, y= -(48 + 24 + 16)},
	})
end)

if wielded_light then
    wielded_light.register_player_lightstep(function(plyr)
        wielded_light.track_user_entity(plyr, "offhand", plyr:get_inventory():get_stack("offhand", 1))
    end)
end

local pressed = {}

local timer = 0

local function wear_lantern(stack)
	if stack:get_name() == "ul_basic:lantern" and timer >= 1 then
		stack:add_wear(65536 / 300)
	end
	return stack
end

minetest.register_globalstep(function (dtime)
	timer = timer + dtime
	for _,plyr in ipairs(minetest.get_connected_players()) do
		local controls = plyr:get_player_control()
		if not controls.aux1 then 
			pressed[plyr:get_player_name()] = false
		elseif not pressed[plyr:get_player_name()]  then
			pressed[plyr:get_player_name()] = true
			offhand(plyr)
		end
		local inv = plyr:get_inventory()
		if inv then
			inv:set_stack("offhand", 1, 
				wear_lantern(inv:get_stack("offhand", 1))
			)
			plyr:set_wielded_item( 
				wear_lantern(plyr:get_wielded_item())
			)
		end
	end
	if timer >= 1 then
		timer = 0
	end
end)