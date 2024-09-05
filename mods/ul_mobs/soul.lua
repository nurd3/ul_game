local S = ul_mobs.get_translator

minetest.register_craftitem("ul_mobs:soul", {
	description = S"Soul",
	inventory_image = "ul_magic_soul.png",
	groups = {soul = 1},
	light_source = 14
})

minetest.register_craftitem("ul_mobs:foul_soul", {
	description = S"Foul Soul",
	inventory_image = "ul_magic_soul.png",
	groups = {soul = 1},
	light_source = 14
})

minetest.register_craftitem("ul_mobs:raging_soul", {
	description = S"Raging Soul",
	inventory_image = "ul_magic_soul.png",
	groups = {soul = 1},
	light_source = 14
})