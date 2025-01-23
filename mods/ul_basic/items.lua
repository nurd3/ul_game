local S = ul_basic.get_translator

core.register_craftitem("ul_basic:bone", {
    description = S"Bone",
    inventory_image = "ul_basic_bone.png"
})

core.register_craftitem("ul_basic:rod", {
    description = S"Rod",
    inventory_image = "ul_basic_rod.png"
})

lootblocks.register_drop("ul_basic:rod", 0.25)
lootblocks.register_drop("ul_basic:bone", 0.5)