core.register_craft({
	output = "lootblocks:lootblock",
	type = "shaped",
	recipe = {
		{"ul_basic:ore","ul_basic:ore"},
		{"ul_basic:ore","ul_basic:ore"},
	}
})
core.register_craft({
	output = "lootblocks:lootblock_rare",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_rare","ul_basic:ore_rare"},
		{"ul_basic:ore_rare","ul_basic:ore_rare"},
	}
})

core.register_craft({
	output = "lootblocks:lootblock_super",
	type = "shaped",
	recipe = {
		{"ul_basic:ore_super","ul_basic:ore_super"},
		{"ul_basic:ore_super","ul_basic:ore_super"},
	}
})

core.register_craft({
	output = "ul_basic:lamp",
	type = "shapeless",
	recipe = {"ul_basic:lantern", "ul_basic:stone 3"}
})

core.register_craft({
	output = "ul_basic:lantern",
	type = "shapeless",
	recipe = {"ul_basic:stone", "ul_magic:shard"}
})

core.register_craft({
	output = "ul_basic:rod 2",
	type = "shapeless",
	recipe = {"ul_basic:bone", "ul_basic:stone"}
})

core.register_craft({
	output = "ul_basic:building 9",
	type = "shapeless",
	recipe = {"ul_basic:rod", "ul_basic:stone"}
})

core.register_craft({
	output = "ul_basic:door",
	type = "shapeless",
	recipe = {"ul_basic:building 2"}
})

core.register_craft({
	output = "ul_basic:window 4",
	type = "shapeless",
	recipe = {"ul_basic:bone 2"}
})

core.register_craft({
	output = "ul_basic:ladder 3",
	type = "shapeless",
	recipe = {"ul_basic:rod 4"}
})

core.register_craft({
	output = "ul_basic:pick",
	type = "shapeless",
	recipe = {"ul_basic:bone 2", "ul_basic:rod"}
})

core.register_craft({
	output = "ul_basic:sword",
	type = "shapeless",
	recipe = {"ul_basic:bone 2", "ul_basic:rod"}
})

core.register_craft({
	output = "ul_basic:knife",
	type = "shapeless",
	recipe = {"ul_basic:bone", "ul_basic:rod"}
})