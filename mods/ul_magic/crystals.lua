local S = ul_magic.get_translator

minetest.register_node("ul_magic:crystal", {
	description = S"Magic Crystal",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
	tiles = {"ul_basic_ore.png^[hsl:0:-100:0^ul_magic_rune.png"},
	groups = {crystal = 1, cracky = 1},
	light_source = 12
})

minetest.register_craftitem("ul_magic:shard", {
	description = S"Magic Shard",
	inventory_image = "ul_magic_shard.png",
	groups = {magic = 1, shard = 1},
	light_source = 12
})

minetest.register_craft({
	output = "ul_magic:crystal",
	type = "shaped",
	recipe = {
		{"ul_magic:shard","ul_magic:shard"},
		{"ul_magic:shard","ul_magic:shard"}
	}
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_magic:crystal",
	wherein        = "mapgen_stone",
	clust_scarcity = 64 * 64 * 64,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = 31000,
	y_min          = 0,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_magic:crystal",
	wherein        = "mapgen_stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 27,
	clust_size     = 2,
	y_max          = 0,
	y_min          = -100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_magic:crystal",
	wherein        = "mapgen_stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 27,
	clust_size     = 3,
	y_max          = -100,
	y_min          = -31000,
})