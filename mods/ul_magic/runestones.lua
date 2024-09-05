local S = ul_magic.get_translator

function ul_magic.gen_rune()
	local t = {}
	for name,_ in pairs(ul_magic.registered_runes) do
		table.insert(t, name)
	end
	if #t > 0 then
		return t[math.random(#t)]
	end
end

minetest.register_node("ul_magic:runestone", {
    description = S"Runestone",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
	tiles = {"ul_basic_stone.png^[hsl:0:-100:0^(ul_magic_shard.png^[hsl:0:0:-100)"},
	sunlight_propagates = true,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
	groups = {cracky = 1},
	on_dig = function (pos, node, digger)
		local stack = digger:get_wielded_item()
		stack:set_count(stack:get_count() - 1)
		digger:set_wielded_item(stack)
		minetest.remove_node(pos)
		minetest.add_item(pos, ItemStack"ul_magic:runestone")
		return true
	end,
	on_rightclick = function (pos, node, puncher)
		minetest.set_node(pos, {name="ul_magic:runestone_active"})
		local timer = minetest.get_node_timer(pos)
		timer:set(1, 0)
		ul_basic.possound(pos, "ul_magic_cast")
	end
})


minetest.register_node("ul_magic:runestone_active", {
    description = S"Active Runestone",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
	tiles = {"ul_basic_stone.png^[hsl:0:-100:0^ul_magic_shard.png"},
	sunlight_propagates = true,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
	light_source = 14,
	on_timer = function (pos, elapsed)
		if math.random() * elapsed > 10 then
			minetest.set_node(pos, {name = ul_magic.gen_rune().."_runestone"})
			ul_basic.possound(pos, "ul_activate")
		else
			local timer = minetest.get_node_timer(pos)
			timer:set(1, elapsed)
		end
	end,
	groups = {cracky = 1},
	on_dig = function (pos, node, digger)
		local stack = digger:get_wielded_item()
		stack:set_count(stack:get_count() - 1)
		digger:set_wielded_item(stack)
		minetest.remove_node(pos)
		minetest.add_item(pos, ItemStack"ul_magic:runestone")
		return true
	end,
	on_rightclick = function (pos, node, puncher)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:set(1, 0)
			ul_basic.possound(pos, "ul_magic_cast")
		end
	end
})


minetest.register_craft({
	output = "ul_magic:runestone",
	type = "shaped",
	recipe = {
		{"ul_magic:crystal","ul_magic:crystal","ul_magic:crystal"},
		{"ul_magic:crystal","ul_magic:crystal","ul_magic:crystal"},
		{"ul_magic:crystal","ul_magic:crystal","ul_magic:crystal"},
	}
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_magic:runestone",
	wherein        = "mapgen_stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = -200,
	y_min          = -31000,
})
