local S = ul_basic.get_translator

minetest.register_item(':', {
    type = 'none',
    wield_image = 'blank.png',
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            crumbly = {
                times = {[2] = 3.00, [3] = 0.70},
                uses = 0,
                maxlevel = 1,
            },
            snappy = {
                times = {[3] = 0.40},
                uses = 0,
                maxlevel = 1,
            },
            oddly_breakable_by_hand = {
                times = {[1] = 3.50, [2] = 2.00, [3] = 0.70},
                uses = 0,
            },
            cracky = {
                times = {[3] = 3.50},
                uses = 0,
            },
        },
        damage_groups = {fleshy = 1},
    }
})


minetest.register_tool("ul_basic:pick", {
    description = S"Pickaxe",
    inventory_image = "ul_basic_pick.png",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            cracky = {times = {1.50, 1.00, 0.50}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 1},
    },
	
	groups = {weapon = 1, tool = 1}
})
minetest.register_tool("ul_basic:knife", {
    description = S"Knife",
    inventory_image = "ul_basic_knife.png",
	
	on_use = ul_basic.on_melee {
		dmg = 3,						-- amount of damage to deal
		uses = 10,						-- how many times it can be used before breaking
	},
	
	enchantable = "melee",
	
	groups = {weapon = 1, tool = 1}
})
minetest.register_tool("ul_basic:sword", {
    description = S"Sword",
    inventory_image = "ul_basic_sword.png",
	
	tool_capabilities = {},

    on_use = ul_basic.on_melee {
		dmg = 5,						-- amount of damage to deal
		uses = 20,						-- how many times it can be used before breaking
	},
	
	enchantable = "melee",
	
	groups = {weapon = 1, tool = 1}
})

minetest.register_tool("ul_basic:lantern", {
    description = S"Lantern",
    inventory_image = "ul_basic_lantern.png",
	
	tool_capabilities = {},

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        damage_groups = {fleshy = 2},
    },
	light_source = 10,
	
	groups = {weapon = 1, tool = 1},
	offhandable = true
})

lootblocks.register_drop("ul_basic:pick", 0.125)
lootblocks.register_drop("ul_basic:knife", 0.125)
lootblocks.register_drop("ul_basic:sword", 0.125)
lootblocks.register_drop("ul_basic:lantern", 0.5)