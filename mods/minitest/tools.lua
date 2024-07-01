local S = minitest.get_translator

minetest.register_tool("minitest:pick", {
    description = S"Pickaxe",
    
})

lootblocks.register_drop("minitest:pick", 0.125)