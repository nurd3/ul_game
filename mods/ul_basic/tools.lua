local S = ul_basic.get_translator

minetest.register_tool("ul_basic:pick", {
    description = S"Pickaxe",
    inventory_image = "ul_basic_pick.png",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            cracky = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 1},
    },
})
minetest.register_tool("ul_basic:knife", {
    description = S"Knife",
    inventory_image = "ul_basic_knife.png",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 3},
    },
})
minetest.register_tool("ul_basic:sword", {
    description = S"Sword",
    inventory_image = "ul_basic_sword.png",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 5},
    },
})

lootblocks.register_drop("ul_basic:pick", 0.125)
lootblocks.register_drop("ul_basic:knife", 0.25)
lootblocks.register_drop("ul_basic:sword", 0.125)