local S = ul_magic.get_translator

minetest.register_craftitem("ul_magic:ring", {
	description = S"Ring",
	inventory_image = "ul_magic_ring.png",
	groups = {ring = 1}
})

minetest.register_craft({
	output = "ul_magic:ring",
	type = "shapeless",
	recipe = {"ul_basic:ore_super","ul_basic:ore_super","ul_basic:ore_super","ul_magic:crystal"}
})