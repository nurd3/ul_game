minetest.register_craft({
	output = "lootblocks:lootblock",
	type = "shaped",
	recipe = {
		{"ul_basic:ore","ul_basic:ore"},
		{"ul_basic:ore","ul_basic:ore"},
	}
})
minetest.register_craft({
	output = "lootblocks:lootblock_rare",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_rare","ul_basic:ore_rare"},
		{"ul_basic:ore_rare","ul_basic:ore_rare"},
	}
})

minetest.register_craft({
	output = "lootblocks:lootblock_super",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_super","ul_basic:ore_super"},
		{"ul_basic:ore_super","ul_basic:ore_super"},
	}
})

minetest.register_craft({
	output = "ul_basic:lamp",
	type = "shapeless",
	recipe = {"ul_basic:lantern", "ul_basic:lantern", "ul_basic:lantern"}
})


minetest.register_craft({
	output = "ul_basic:lantern",
	type = "shapeless",
	recipe = {"ul_basic:stone", "ul_basic:ore_super"}
})