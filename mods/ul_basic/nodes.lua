local S = ul_basic.get_translator

minetest.register_node("ul_basic:stone", {
    description = S"Stone",
    drawtype = "normal",
    tiles = {"ul_basic_stone.png"},
    groups = {cracky = 3},
	sunlight_propagates = true,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:ore", {
    description = S"Stone",
    drawtype = "normal",
    tiles = {"ul_basic_ore.png"},
    groups = {cracky = 3},
	sunlight_propagates = true,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("ul_basic:lamp", {
    description = S"Lamp",
    drawtype = "normal",
    tiles = {"ul_basic_lamp.png"},
    groups = {cracky = 3},
	sunlight_propagates = true,
	is_ground_content = false,
	paramtype = "none",
	paramtype2 = "none",
    light_source = 14,
})

lootblocks.register_drop("ul_basic:lamp", 0.125)
lootblocks.register_drop("ul_basic:ore", 0.125)