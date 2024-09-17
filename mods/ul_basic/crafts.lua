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
	recipe = {"ul_basic:lantern", "ul_basic:stone 3"}
})

minetest.register_craft({
	output = "ul_basic:lantern",
	type = "shapeless",
	recipe = {"ul_basic:stone", "ul_magic:shard"}
})

minetest.register_craft({
	output = "ul_basic:rod 2",
	type = "shapeless",
	recipe = {"ul_basic:bone", "ul_basic:stone"}
})

minetest.register_craft({
	output = "ul_basic:ladder 3",
	type = "shapeless",
	recipe = {"ul_basic:rod 4"}
})

minetest.register_craft({
	output = "ul_basic:pick",
	type = "shapeless",
	recipe = {"ul_basic:bone 2", "ul_basic:rod"}
})

minetest.register_craft({
	output = "ul_basic:sword",
	type = "shapeless",
	recipe = {"ul_basic:bone 2", "ul_basic:rod"}
})

minetest.register_craft({
	output = "ul_basic:knife",
	type = "shapeless",
	recipe = {"ul_basic:bone", "ul_basic:rod"}
})