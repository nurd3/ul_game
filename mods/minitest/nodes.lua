local S = minitest.get_translator

minetest.register_node("minitest:stone", {
    description = S"Stone",
    drawtype = "normal",
    tiles = {"minitest_stone.png"},
    groups = {cracky = 3},
	sunlight_propagates = true,
	is_ground_content = true,
	paramtype = "none",
	paramtype2 = "none",
})

minetest.register_node("minitest:lamp", {
    description = S"Lamp",
    drawtype = "normal",
    tiles = {"minitest_lamp.png"},
    groups = {cracky = 3},
	sunlight_propagates = true,
	is_ground_content = false,
	paramtype = "none",
	paramtype2 = "none",
    light_source = 14,
})

lootblocks.register_drop("minitest:lamp", 0.125)