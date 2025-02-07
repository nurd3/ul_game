-- traditional luanti items. think craftitems, tools, and nodes.

local S = ul_market.get_translator

-----------------
-- CRAFT ITEMS --
-----------------

core.register_craftitem("ul_market:hp_vial", {
	description = S"Vial of Health",
	inventory_image = "ul_market_hp_vial.png",
	on_use = function(stack, user, pointed_thing)
		stack:take_item()
		ul_basic.set_hp(user, 4)
		return stack
	end
})

-----------
-- NODES --
-----------

core.register_node("ul_market:tradeinator", {
	description = S"Tradeinator",
	tiles = {"ul_market_tradeinator.png"},
	light_source = 14,
	on_place = function (stack, placer, pointed_thing)
		core.set_node(pointed_thing.above, {name="ul_market:tradeinator"})
		
		local node_meta = core.get_meta(pointed_thing.above)
		local invref = node_meta:get_inventory()

		invref:set_size("fuel", 1)
		
		stack:take_item()
		
		return stack
	end,
	on_punch = function (pos, puncher)
		local inv = core.get_meta(pos):get_inventory()

		if inv:is_empty("fuel") then
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_market:tradeinator")
		end
	end,
	on_rightclick = function (pos, node, puncher)
		local plyrname = puncher:get_player_name()
		if plyrname then
			core.show_formspec(
				plyrname,
				"ul_market:formspec_tradeinator", 
				ul_market.get_formspec_tradeinator(plyrname, pos)
			)
		end
	end
})

core.register_node("ul_market:tradeinator_rare", {
	description = S"Rare Tradeinator",
	tiles = {"ul_market_tradeinator.png^[hsl:120"},
	light_source = 14,
	on_place = function (stack, placer, pointed_thing)
		core.set_node(pointed_thing.above, {name="ul_market:tradeinator_rare"})
		
		local node_meta = core.get_meta(pointed_thing.above)
		local invref = node_meta:get_inventory()

		invref:set_size("fuel", 2)
		
		stack:take_item()
		
		return stack
	end,
	on_punch = function (pos, puncher)
		local inv = core.get_meta(pos):get_inventory()

		if inv:is_empty("fuel") then
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_market:tradeinator_rare")
		end
	end,
	on_rightclick = function (pos, node, puncher)
		local plyrname = puncher:get_player_name()
		if plyrname then
			core.show_formspec(
				plyrname,
				"ul_market:formspec_tradeinator", 
				ul_market.get_formspec_tradeinator(plyrname, pos)
			)
		end
	end
})

core.register_node("ul_market:tradeinator_super", {
	description = S"Super Tradeinator",
	tiles = {"ul_market_tradeinator.png^[hsl:180"},
	light_source = 14,
	on_place = function (stack, placer, pointed_thing)
		core.set_node(pointed_thing.above, {name="ul_market:tradeinator_super"})
		
		local node_meta = core.get_meta(pointed_thing.above)
		local invref = node_meta:get_inventory()

		invref:set_size("fuel", 4)
		
		stack:take_item()
		
		return stack
	end,
	on_punch = function (pos, puncher)
		local inv = core.get_meta(pos):get_inventory()

		if inv:is_empty("fuel") then
			core.set_node(pos, {name="air"})
			core.add_item(pos, ItemStack"ul_market:tradeinator_super")
		end
	end,
	on_rightclick = function (pos, node, puncher)
		local plyrname = puncher:get_player_name()
		if plyrname then
			core.show_formspec(
				plyrname,
				"ul_market:formspec_tradeinator", 
				ul_market.get_formspec_tradeinator(plyrname, pos)
			)
		end
	end
})

-------------
-- RECIPES --
-------------

core.register_craft({
	output = "ul_market:tradeinator",
	type = "shaped",
	recipe = {
		{"ul_basic:ore 7", "ul_portal:portal", "ul_storage:crate"}
	}
})

core.register_craft({
	output = "ul_market:tradeinator_rare",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_rare 7", "ul_portal:portal", "ul_storage:crate"}
	}
})

core.register_craft({
	output = "ul_market:tradeinator_super",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_super 7", "ul_portal:portal", "ul_storage:crate"}
	}
})