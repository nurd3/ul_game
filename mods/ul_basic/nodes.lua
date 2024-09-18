local S = ul_basic.get_translator

minetest.register_node("ul_basic:stone", {
    description = S"Stone",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
    tiles = {"ul_basic_stone.png"},
    groups = {cracky = 3},
	sunlight_propagates = false,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:building", {
    description = S"Building",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "glasslike_framed",
    tiles = {"ul_basic_building.png", "ul_basic_building_detail.png"},
    groups = {oddly_breakable_by_hand = 3},
	sunlight_propagates = false,
	is_ground_content = false,
	paramtype = "light",
	paramtype2 = "none",
	use_texture_alpha = "clip"
})

minetest.register_node("ul_basic:window", {
    description = S"Window",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "glasslike_framed_optional",
    tiles = {"ul_basic_window.png", "ul_basic_window_detail.png"},
    groups = {oddly_breakable_by_hand = 3},
	sunlight_propagates = true,
	is_ground_content = false,
	paramtype = "light",
	paramtype2 = "none",
	use_texture_alpha = "clip",
})

minetest.register_node("ul_basic:ore", {
    description = S"Ore",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
    tiles = {"ul_basic_ore.png"},
    groups = {cracky = 2},
	sunlight_propagates = false,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:ore_rare", {
    description = S"Rare Ore",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
    tiles = {"ul_basic_ore.png^[hsl:120"},
    groups = {cracky = 2},
	sunlight_propagates = false,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:ore_super", {
    description = S"Super Ore",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
    tiles = {"ul_basic_ore.png^[hsl:180"},
    groups = {cracky = 2},
	sunlight_propagates = false,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:lamp", {
    description = S"Lamp",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "normal",
    tiles = {"ul_basic_lamp.png"},
    groups = {oddly_breakable_by_hand = 3},
	sunlight_propagates = true,
	is_ground_content = false,
	paramtype = "none",
	paramtype2 = "none",
    light_source = 14
})

minetest.register_node("ul_basic:ladder", {
    description = S"Ladder",
	sounds = ul_basic.node_sound_defaults(),
    drawtype = "signlike",
	inventory_image = "ul_basic_ladder.png",
    tiles = {"ul_basic_ladder.png"},
	on_punch = ul_basic.node_breakable("ul_basic:ladder"),
    groups = {snappy = 1},
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	climbable = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	
	selection_box = {
		type = "wallmounted",
		wall_side = {-0.5,-0.4,-0.4,-0.4,0.4,0.4},
	},
})

lootblocks.register_drop("ul_basic:lamp", 0.25)
lootblocks.register_drop("ul_basic:ore", 0.125)

minetest.register_alias("mapgen_stone", "ul_basic:stone")
minetest.register_alias("mapgen_water_source", "air")

minetest.register_decoration({
	name = "ul_basic:lamp",
	deco_type = "simple",
	place_on = {"mapgen_stone"},
	sidelen = 4,
	noise_params = {
		offset = -0.35,
		scale = 0.25,
		spread = {x = 16, y = 16, z = 16},
		seed = 3,
		octaves = 3,
		persist = 0.6
	},
	y_max = 31000,
	y_min = -31000,
	decoration = "ul_basic:lamp",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore",
	wherein        = "mapgen_stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 9,
	clust_size     = 3,
	y_max          = 31000,
	y_min          = 1025,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore",
	wherein        = "mapgen_stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 8,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -31000,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore",
	wherein        = "mapgen_stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 8,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore_rare",
	wherein        = "mapgen_stone",
	clust_scarcity = 24 * 24 * 24,
	clust_num_ores = 27,
	clust_size     = 3,
	y_max          = 0,
	y_min          = -100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore",
	wherein        = "mapgen_stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = 0,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore_super",
	wherein        = "mapgen_stone",
	clust_scarcity = 24 * 24 * 24,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = -20,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore_rare",
	wherein        = "mapgen_stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = -100,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ul_basic:ore_rare",
	wherein        = "mapgen_stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = 64,
	y_min          = 0,
})