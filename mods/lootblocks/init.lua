lootblocks = {}

local S = minetest.get_translator"lootblocks"

lootblocks.get_translator = S
lootblocks.get_modpath = minetest.get_modpath"lootblocks"

lootblocks.registered_drops = {}
lootblocks.registered_spawns = {}

function lootblocks.register_drop(stacks, chance)
	if type(stacks) == "string" then stacks = {stacks} end
    table.insert(lootblocks.registered_drops, {stacks=stacks, chance=chance})
end

function lootblocks.register_spawn(ents, chance)
	if type(ents) == "string" then ents = {ents} end
    table.insert(lootblocks.registered_spawns, {ents=ents, chance=chance})
end

lootblocks.defaultdrop = {"lootblocks:lootblock"}

function lootblocks.register_defaultdrop(stacks)
	if type(stacks) == "string" then stacks = {stacks} end
    lootblocks.defaultdrop = stacks
end

function lootblocks.gen_spawn(pos)
	local t = {}
    for _,v in ipairs(lootblocks.registered_spawns) do
        if math.random() < v.chance then
            table.insert(t, v.ents)
        end
    end
    local ents = t[math.random(#t)]
	if not ents then return end
    for _,w in ipairs(ents) do
        minetest.add_entity(pos, w)
    end
end

function lootblocks.gen_drop(pos)
	local t = {lootblocks.defaultdrop}
    for _,v in ipairs(lootblocks.registered_drops) do
        if math.random() < v.chance then
            table.insert(t, v.stacks)
        end
    end
    local stacks = t[math.random(#t)]
	if not stacks or #stacks <= 0 then stacks = lootblocks.defaultdrop end
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
		if math.random() > 0.75 and lootblocks.gen_spawn(pos) then
			return
		end
        lootblocks.gen_drop(pos)
		while math.random() > 0.95 do
			lootblocks.gen_drop(pos)
		end
    end,
})

minetest.register_node("lootblocks:lootblock_rare", {
    description = S"Rare Lootblock",
    groups = {lootblock = 1},
    drawtype = "normal",
    tiles = {"lootblocks_lootblock.png^[hsl:120"},
    on_punch = function(pos, node, puncher)
        minetest.set_node(pos, {name="air"})
        local inv = puncher:get_inventory()
        lootblocks.gen_drop(pos)
		if math.random() > 0.75 and lootblocks.gen_spawn(pos) then
			return
		end
		while math.random() > 0.5 do
			lootblocks.gen_drop(pos)
		end
    end,
	light_source = 4
})


minetest.register_node("lootblocks:lootblock_super", {
    description = S"Super Lootblock",
    groups = {lootblock = 1},
    drawtype = "normal",
    tiles = {"lootblocks_lootblock.png^[hsl:180"},
    on_punch = function(pos, node, puncher)
        minetest.set_node(pos, {name="air"})
        local inv = puncher:get_inventory()
		if math.random() > 0.75 and lootblocks.gen_spawn(pos) then
			return
		end
        lootblocks.gen_drop(pos)
        lootblocks.gen_drop(pos)
		while math.random() > 0.25 do
			lootblocks.gen_drop(pos)
		end
    end,
	light_source = 8
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
minetest.register_decoration({
	name = "lootblocks:lootblock_rare",
	deco_type = "simple",
	place_on = {"mapgen_stone"},
	sidelen = 1,
	noise_params = {
		offset = -0.5,
		scale = 0.25,
		spread = {x = 16, y = 16, z = 16},
		seed = 230,
		octaves = 3,
		persist = 0.5
	},
	y_max = -50,
	y_min = -31000,
	decoration = "lootblocks:lootblock_rare",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lootblocks:lootblock_rare",
	wherein        = "mapgen_stone",
	clust_scarcity = 24 * 24 * 24,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = 0,
	y_min          = -100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lootblocks:lootblock_super",
	wherein        = "mapgen_stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = -20,
	y_min          = -100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lootblocks:lootblock_rare",
	wherein        = "mapgen_stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = -100,
	y_min          = -31000,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lootblocks:lootblock_super",
	wherein        = "mapgen_stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 27,
	clust_size     = 1,
	y_max          = -100,
	y_min          = -31000,
})
lootblocks.register_drop("lootblocks:lootblock_rare", 0.1)
lootblocks.register_drop("lootblocks:lootblock_super", 0.01)