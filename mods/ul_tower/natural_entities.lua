natural_entities.register_spawn("ul_tower:babylonoids_1", {
	
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = 31000,
	
	entities = {
		["ul_tower:babylon_eye"] = 0.8,
		["ul_tower:butterfly"] = 0.8
	},
	
	check = ul_tower.spawn_check(1)
	
})
natural_entities.register_spawn("ul_tower:babylonoids_2", {
	
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = 31000,
	
	entities = {
		["ul_tower:snail"] = 0.8,
		["ul_tower:gull"] = 0.8
	},
	
	check = ul_tower.spawn_check(8)
	
})
natural_entities.register_spawn("ul_tower:babylonoids_3", {
	
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = 31000,
	
	entities = {
		["ul_tower:ranger"] = 0.8,
		["ul_tower:big_eye"] = 0.8,
		["ul_tower:big_snail"] = 0.8,
		["ul_tower:goober"] = 0.8,
		["ul_tower:bob"] = 0.5
	},
	
	check = ul_tower.spawn_check(16)
	
})
natural_entities.register_spawn("ul_tower:babylonoids_4", {
	
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = 31000,
	
	entities = {
		["ul_tower:babylonian"] = 0.8,
		["ul_tower:guard"] = 0.8,
		["ul_tower:bob"] = 0.1
	},
	
	check = ul_tower.spawn_check(24)
	
})

natural_entities.register_spawn("ul_tower:surface_monsters", {
	
	spawn_rate = 0.2,
	
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
				-- races
		["ul_mobs:cult"] = 0.05,
		["ul_mobs:anocula"] = 0.05
	},
	
	check = ul_tower.spawn_check
	
})

natural_entities.register_spawn("ul_tower:caves_monsters", {
	
	spawn_rate = 0.4,
	
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
	
	check = ul_tower.spawn_check
	
})

natural_entities.register_spawn("ul_tower:deep_caves_monsters", {
	
	spawn_rate = 0.6,
	
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
	
	check = ul_tower.spawn_check
	
})

natural_entities.register_spawn("ul_tower:deeper_caves_monsters", {
	
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
	
	check = ul_tower.spawn_check
	
})