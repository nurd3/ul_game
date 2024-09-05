local S = ul_mobs.get_translator

local function arcanoid_check_prey(self, obj)
	local luaent = obj:get_luaentity()
	return not luaent or luaent.category ~= "arcanoid" and luaent.category ~= "neutral"
end

ul_mobs.register_mob("ul_mobs:alien", {
					-- engine values
	description = S"Alien",
	visual = "upright_sprite",
	egg_colors = {"#ff8000", "#ffff00", "#ff0000"},
	textures = {"ul_mobs_monster_alien.png", "ul_mobs_monster_alien_back.png"},
	visual_size = {x = 2.5, y = 2.5},
	collisionbox = {-0.4, -1.25, -0.4, 0.4, 0.75, 0.4},
	
					-- stats
	max_speed = 5,
	jump_height = 20,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 25,
	ranged = {
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5},
		range = 96
	},
	melee = {dmg = 10, range = 5},
	disable_fall_damage = true,
	disable_taming = true,
	
					-- behaviour
	on_check_prey = arcanoid_check_prey,
	on_die = ul_mobs.death_drops({1.0, "ul_magic:runestone"}),
	type = "monster",
	category = "arcanoid"
})

ul_mobs.register_mob("ul_mobs:lootglob", {
					-- engine values
	description = S"Lootglob",
	visual = "cube",
	textures = {"ul_mobs_monster_lootglob.png", "ul_mobs_monster_lootglob.png", "ul_mobs_monster_lootglob.png", "ul_mobs_monster_lootglob.png", "ul_mobs_monster_lootglob.png", "ul_mobs_monster_lootglob.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.4, 0.4},
	
					-- stats
	max_speed = 20,
	jump_height = 2,
	view_range = 128,
	vision = 1,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 25,
	melee = {dmg = 10, range = 5},
	disable_fall_damage = true,
	disable_taming = true,
	
					-- behaviour
	on_check_prey = function(self, obj)
		return vector.distance(self.object:get_pos(), obj:get_pos()) < 3 and arcanoid_check_prey(self, obj)
	end,
	on_die = ul_mobs.death_drops({1.0, "lootblocks:lootblock"}),
	type = "monster",
	category = "arcanoid"
})

ul_mobs.register_mob("ul_mobs:shadow", {
					-- engine values
	description = S"Shadow",
	visual = "upright_sprite",
	textures = {"ul_mobs_monster_shadow.png", "ul_mobs_monster_shadow_back.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.4, 0.4},
	
					-- stats
	max_speed = 20,
	jump_height = 20,
	view_range = 256,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 1,
	ranged = {
		rate = 0.2,
		range = 128,
		func = ul_magic.shoot,
		args = {"ul_magic:poison", 5}
	},
	melee = {dmg = 10, range = 5},
	disable_fall_damage = true,
	disable_taming = true,
	
					-- behaviour
	on_check_prey = function(self, obj)
		return vector.distance(self.object:get_pos(), obj:get_pos()) < 3 and arcanoid_check_prey(self, obj)
	end,
	on_die = ul_mobs.death_drops({1.0, "lootblocks:lootblock"}),
	type = "monster",
	category = "arcanoid"
})

ul_mobs.register_mob("ul_mobs:eeltig", {
					-- engine values
	description = S"Eeltig",
	visual = "sprite",
	textures = {"ul_mobs_monster_eeltig.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.4, 0.4},
	
					-- stats
	max_speed = 20,
	jump_height = 20,
	view_range = 256,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	melee = {dmg = 10, range = 10},
	disable_fall_damage = true,
	disable_taming = true,
	
					-- behaviour
	on_check_prey = arcanoid_check_prey,
	on_die = ul_mobs.death_drops({1.0, "lootblocks:lootblock_super"}),
	type = "monster",
	category = "arcanoid"
})

lootblocks.register_spawn("ul_mobs:lootglob", 0.02)
lootblocks.register_spawn("ul_mobs:alien", 0.02)
lootblocks.register_spawn("ul_mobs:eeltig", 0.05)
