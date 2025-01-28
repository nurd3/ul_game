local S = ul_magic.get_translator

core.register_craftitem("ul_magic:ring", {
	description = S"Ring",
	inventory_image = "ul_magic_ring.png",
	groups = {ring = 1},
	enchantable = "wear",
	on_enchant = function(itemname, rune)
		return ul_magic.on_enchant_fallback("ul_magic:enchanted_ring", rune)
	end
})

ul_inv.register_wearable("ul_magic:enchanted_ring", {
	description = S"Enchanted Ring",
	inventory_image = "ul_magic_ring.png",
	groups = {ring = 1}
})

core.register_craftitem("ul_magic:cloak", {
	description = S"Cloak",
	inventory_image = "ul_magic_cloak.png",
	groups = {cloak = 1},
	enchantable = "wear",
	on_enchant = function(itemname, rune)
		return ul_magic.on_enchant_fallback("ul_magic:enchanted_cloak", rune)
	end
})

ul_inv.register_wearable("ul_magic:enchanted_cloak", {
	description = S"Cloak",
	inventory_image = "ul_magic_cloak.png",
	groups = {cloak = 1},
	on_wear = function(purpose, level)
		if purpose == "enchantment" then
			return 2
		elseif purpose == "defense" then
			return level
		end
	end
})

core.register_craft({
	output = "ul_magic:ring",
	type = "shapeless",
	recipe = {"ul_basic:ore_super","ul_basic:ore_super","ul_basic:ore_super","ul_magic:crystal"}
})

lootblocks.register_drop("ul_magic:cloak", 0.1)