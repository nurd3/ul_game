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

local index = 1
for _,name in ipairs(ul_market.party_order) do
	if string.sub(name, 1,9) == "ul_market" then
		core.register_craftitem("ul_market:card_" .. index, {
			short_description = S"Old Card",
			description = S"Old Card\nSeems to be dusty...\nUse to undust",
			inventory_image = "ul_market_card.png",
			on_use = function(stack, user, pointed_thing)
				ul_basic.give_or_drop(user:get_inventory(), "main", pointed_thing.above, 2, ItemStack(name.."_card "..stack:get_count()))
				stack:set_count(0)
				return stack
			end
		})
		index = index + 1
	end
end

local function random_card()
	local temp = {}
	for _,v in ipairs(ul_market.party_order) do
		table.insert(temp, {v.."_card", ul_market.get_party_seats(v) * math.random()})
	end
	table.sort(temp, function(a,b)
		return a[2] > b[2]
	end)
	return temp[1][1]
end

core.register_craftitem("ul_market:card_pack", {
	short_description = S"Sexonland Political Trading Cards Card Pack",
	description = S"Sexonland Political Trading Cards Card Pack\nUse to open",
	inventory_image = "ul_market_card_pack.png",
	on_use = function(stack, user, pointed_thing)
		stack:take_item()
		for i = 1, #ul_market.party_order do
			ul_basic.give_or_drop(user:get_inventory(), "main", pointed_thing.above or user:get_pos(), 2, ItemStack(random_card()))
		end
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