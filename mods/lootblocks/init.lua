local S = minetest.get_translator"lootblocks"

lootblocks = {}

lootblocks.get_translator = S
lootblocks.get_modpath = minetest.get_modpath"lootblocks"

lootblocks.registered_drops = {}

function lootblocks.register_drop(stacks, chance)
    table.insert(lootblocks.registered_drops, {stacks=stacks, chance})
end

function lootblocks.gen_drop(pos)
    for _,v in ipairs(lootblocks.registered_drops) do
        if math.random() < v.chance then
            for _,w in ipairs(v.stacks) do
                minetest.add_item(pos, w)
            end
        end
    end
end

minetest.register_node("lootblocks:lootblock", {
    title = S"Lootblock",
    groups = {lootblock = 1},
    drawtype = "normal",
    tiles = {"lootblocks_lootblock.png"},
    on_punch = function(pos, node, puncher)
        minetest.set_node(pos, "air")
        local inv = puncher:get_inventory()
        lootblocks.gen_drop(pos)
    end
})