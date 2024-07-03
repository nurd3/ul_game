lootblocks = {}

local S = minetest.get_translator"lootblocks"

lootblocks.get_translator = S
lootblocks.get_modpath = minetest.get_modpath"lootblocks"

lootblocks.registered_drops = {}

function lootblocks.register_drop(stacks, chance)
	if type(stacks) == "string" then stacks = {stacks} end
    table.insert(lootblocks.registered_drops, {stacks=stacks, chance=chance})
end

function lootblocks.gen_drop(pos)
	local t = {{"lootblocks:lootblock"}}
    for _,v in ipairs(lootblocks.registered_drops) do
        if math.random() < v.chance then
            table.insert(t, v.stacks)
        end
    end
    local stacks = t[math.random(#t)]
    for _,w in ipairs(stacks) do
        minetest.add_item(pos, ItemStack(w))
    end
end

minetest.register_node("lootblocks:lootblock", {
    description = S"Lootblock",
    groups = {lootblock = 1},
    drawtype = "normal",
    tiles = {"lootblocks_lootblock.png"},
    on_punch = function(pos, node, puncher)
        minetest.set_node(pos, {name="air"})
        local inv = puncher:get_inventory()
        lootblocks.gen_drop(pos)
    end,
})

minetest.register_decoration({
	name = "lootblocks:lootblock",
	deco_type = "simple",
	place_on = {"mapgen_stone"},
	sidelen = 1,
	noise_params = {
		offset = -0.25,
		scale = 0.25,
		spread = {x = 16, y = 16, z = 16},
		seed = 230,
		octaves = 3,
		persist = 0.6
	},
	y_max = 30,
	y_min = -50,
	decoration = "lootblocks:lootblock",
})