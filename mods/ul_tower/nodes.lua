local S = ul_tower.get_translator

local tower_max_level = 48

core.register_node("ul_tower:tower", {
	short_description = S"Tower",
	description = S"Tower\nBuild up to the sky.",
	tiles = {"ul_tower_tower.png"},
	light_source = 15,
	on_place = function(stack, plyr, pointed_thing)
		local tpos = ul_tower.get_pos()
		local pos = pointed_thing.above

		if not tpos then
			stack:take_item()
			ul_tower.set_pos(pos)
			ul_tower.add_height()
			core.set_node(pos, {name = "ul_tower:tower"})
			core.chat_send_all(core.colorize("#ffff00", S("Tower has been started at @1. Tower must go up. Tower must be pure.", vector.to_string(pos))))
			return stack
		end

		if pos.x ~= tpos.x or pos.z ~= tpos.z then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Tower must only go up."))
			return
		end

		local thgt = ul_tower.get_height()

		if tpos.y + thgt ~= pos.y then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Tower must be pure."))
			return
		end

		if thgt >= tower_max_level then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#00ff00", S"Tower is complete."))
			return
		end

		ul_tower.add_height()
		stack:take_item()
		core.set_node(pos, {name = "ul_tower:tower"})
		if thgt + 1 >= tower_max_level then
			core.chat_send_all(core.colorize("#00ff00", S"Tower is complete."))
		else
			core.chat_send_all(core.colorize("#ffff00", S("Tower has risen to level @1.", thgt + 1)))
		end
		return stack
	end,
	on_punch = function(pos, node, plyr)
		local tpos = ul_tower.get_pos()

		if not tpos then
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_tower:tower")
			return
		end

		if not tpos then
			ul_tower.set_pos(pos)
			ul_tower.add_height()
			core.chat_send_all(core.colorize("#ffff00", S("Tower has been started at @1. Tower must go up. Tower must be pure.", vector.to_string(pos))))
			return stack
		end

		if pos.x ~= tpos.x or pos.z ~= tpos.z then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Tower must only go up."))
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_tower:tower")
			return
		end

		local thgt = ul_tower.get_height()

		if tpos.y + thgt < pos.y then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Tower must be pure."))
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_tower:tower")
			return
		end

		if tpos.y + tower_max_level < pos.y then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#00ff00", S"Tower is complete."))
			if tower_max_level + tpos.y then
				core.set_node(pos, {name="air"})
				core.add_item(pos, ItemStack"ul_tower:tower")
			end
			return
		end
	end
})