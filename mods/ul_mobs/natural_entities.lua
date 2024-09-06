local function light_check(pos)
	-- this wasn't working and I'm too lazy to fix.
	return true
end

natural_entities.register_spawn("ul_mobs:surface_monsters", {
	
	spawn_rate = 0.1,
	
	min_y = 0,
	max_y = 64,
	
	entities = {
				-- monsters
		["ul_mobs:eye"] = 0.8,
		["ul_mobs:big_eye"] = 0.1,
		["ul_mobs:ghost"] = 0.5,
		["ul_mobs:zombie"] = 0.5,
		["ul_mobs:vampire"] = 0.25,
		["ul_mobs:stalker"] = 0.5,
		["ul_mobs:kobold"] = 0.1,
				-- arcanoids
		["ul_mobs:shadow"] = 0.5,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:caves_monsters", {
	
	spawn_rate = 0.2,
	
	min_y = -100,
	max_y = 0,
	
	entities = {
				-- monsters
		["ul_mobs:eye"] = 1.0,
		["ul_mobs:big_eye"] = 0.3,
		["ul_mobs:zombie"] = 0.75,
		["ul_mobs:vampire"] = 0.5,
		["ul_mobs:skeleton"] = 0.25,
		["ul_mobs:stalker"] = 0.25,
		["ul_mobs:kobold"] = 1.0,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:deep_caves_monsters", {
	
	spawn_rate = 0.3,
	
	min_y = -31000,
	max_y = -100,
	
	entities = {
				-- monsters
		["ul_mobs:eye"] = 1.0,
		["ul_mobs:big_eye"] = 0.3,
		["ul_mobs:zombie"] = 0.2,
		["ul_mobs:vampire"] = 1.0,
		["ul_mobs:lich"] = 0.5,
		["ul_mobs:skeleton"] = 0.5,
		["ul_mobs:kobold"] = 1.0,
		["ul_mobs:horbold"] = 0.1,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:deeper_caves_monsters", {
	
	spawn_rate = 1.0,
	
	min_y = -31000,
	max_y = -200,
	
	entities = {
				-- monsters
		["ul_mobs:horbold"] = 0.5,
		["ul_mobs:lich"] = 0.5,
		["ul_mobs:vampire"] = 0.25,
		["ul_mobs:skeleton"] = 1.0,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:surface_animals", {
	
	spawn_rate = 0.1,
	
	min_y = 0,
	max_y = 64,
	
	entities = {
				-- animals
		["ul_mobs:gull"] = 0.5,
		["ul_mobs:rgull"] = 0.1,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:caves_animals", {
	
	spawn_rate = 0.2,
	
	min_y = -100,
	max_y = 0,
	
	entities = {
				-- animals
		["ul_mobs:rgull"] = 0.5,
		["ul_mobs:mgull"] = 0.05,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:deep_caves_animals", {
	
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = -100,
	
	entities = {
				-- animals
		["ul_mobs:rgull"] = 0.5,
		["ul_mobs:mgull"] = 0.2,
	},
	
	check = light_check
	
})

natural_entities.register_spawn("ul_mobs:arcanoids", {
	
	spawn_rate = 2.0,
	
	min_y = -31000,
	max_y = -300,
	
	entities = {
				-- arcanoids
		["ul_mobs:alien"] = 0.125,
		["ul_mobs:lootglob"] = 0.5,
		["ul_mobs:shadow"] = 0.5,
		["ul_mobs:eeltig"] = 1.0,
	},
	
	check = light_check
	
})