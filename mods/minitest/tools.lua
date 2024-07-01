local S = minitest.get_translator

minetest.register_tool("minitest:pick", {
    description = S"Pickaxe",
    inventory_image = "minitest_pick",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            cracky = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 1},
    },
})
minetest.register_tool("minitest:knife", {
    description = S"Knife",
    inventory_image = "minitest_knife",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 3},
    },
})
minetest.register_tool("minitest:sword", {
    description = S"Sword",
    inventory_image = "minitest_sword",

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = {times = {2.50, 1.40, 1.00}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 5},
    },
})

lootblocks.register_drop("minitest:pick", 0.125)
lootblocks.register_drop("minitest:knife", 0.25)
lootblocks.register_drop("minitest:sword", 0.125)