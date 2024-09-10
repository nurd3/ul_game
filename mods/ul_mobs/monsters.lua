local abr = minetest.get_mapgen_setting('active_block_range')

local S = ul_mobs.get_translator

local player_enemies = {}

local infighting_chance = 1 - ((minetest.settings:get('ul_mobs_monsters_loyalty')) or 0.2)
infighting_chance = infighting_chance * infighting_chance

-- check_prey function
local function check_prey(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	if luaent and luaent.type == "neutral" then
		return false
	end
	
	if self.monstertype and luaent then
		
		local mtype = luaent.monstertype
		
		if mtype and mtype == self.monstertype and math.random() < infighting_chance and not self.owner then
			return false
		end
		
	end
	
	if self._owner then
		
		if luaent and luaent.type == "animal" then
			return false
		end
		
		local lowner = luaent and luaent._owner or obj:get_player_name()
		
		if self._owner == lowner or obj:is_player() then
			return false
		end
		
	end
	
	return true
end

		-- disembodieds
ul_mobs.register_mob("ul_mobs:eye", {
					-- engine values
	description = S"Eye",
	visual = "sprite",
	egg_colors = {"#ffffff", "#000000"},
	textures = {"ul_mobs_monster_eye.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	
					-- stats
	max_speed = 8,
	jump_height = 5,
	view_range = 24,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 8,
	melee = {dmg = 3},
	disable_fall_damage = true,
	
						-- behaviour
	range_power = 0,
	melee_power = 3,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:heal"}),
	type = "monster",
	category = "disembodied"
})
ul_mobs.register_mob("ul_mobs:big_eye", {
					-- engine values
	description = S"Big Eye",
	visual = "sprite",
	egg_colors = {"#ffffff", "#ff0000", "#000000"},
	textures = {"ul_mobs_monster_eye.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.5, -1.0, -0.5, 0.5, 1.0, 0.5},
	
					-- stats
	max_speed = 7,
	jump_height = 5,
	view_range = 48,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	melee = {dmg = 10},
	
					-- behaviour
	range_power = 0,
	melee_power = 10,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:heal"}),
	type = "monster",
	category = "disembodied"
})
		-- undeads
ul_mobs.register_mob("ul_mobs:ghost", {
					-- engine values
	description = S"Ghost",
	visual = "sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_mobs_monster_ghost.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 5,
	view_range = 48,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	melee = {dmg = 5},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 0,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:levitate"}),
	type = "monster",
	category = "undead"
})
ul_mobs.register_mob("ul_mobs:zombie", {
					-- engine values
	description = S"Zombie",
	visual = "upright_sprite",
	egg_colors = {"#00ff00", "#ff0000"},
	textures = {"ul_mobs_monster_zombie.png", "ul_mobs_monster_zombie_back.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 5,
	jump_height = 1.5,
	view_range = 24,
	vision = 5,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	melee = {dmg = 5},
	
					-- behaviour
	range_power = 0,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:poison"}),
	type = "monster",
	category = "undead"
})
ul_mobs.register_mob("ul_mobs:vampire", {
					-- engine values
	description = S"Vampire",
	visual = "upright_sprite",
	egg_colors = {"#00ffff", "#ff0000"},
	textures = {"ul_mobs_monster_vampire.png", "ul_mobs_monster_vampire_back.png"},
	visual_size = {x = 1.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 5,
	jump_height = 2.5,
	view_range = 24,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	ranged = {
		func = ul_magic.shoot,
		args = {"ul_magic:vampirism", 3},
		range = 5
	},
	melee = {dmg = 5, range = 5},
	
					-- behaviour
	range_power = 3,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:vampirism"}),
	type = "monster",
	category = "undead"
})
ul_mobs.register_mob("ul_mobs:lich", {
					-- engine values
	description = S"Lich",
	visual = "upright_sprite",
	egg_colors = {"#000000", "#800000"},
	textures = {"ul_mobs_monster_lich.png", "ul_mobs_monster_lich_back.png^[transformFX"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 10,
	view_range = 48,
	vision = 7,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 25,
	melee = {dmg = 10},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 0,
	melee_power = 10,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({1.0, "ul_magic:regen"}),
	type = "monster",
	category = "undead"
})
ul_mobs.register_mob("ul_mobs:skeleton", {
					-- engine values
	description = S"Skeleton",
	visual = "upright_sprite",
	egg_colors = {"#808080", "#ffffff", "#ff0000"},
	textures = {"ul_mobs_monster_skeleton.png", "ul_mobs_monster_skeleton_back.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 2,
	view_range = 48,
	vision = 7,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	melee = {dmg = 10},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 0,
	melee_power = 10,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({1.0, "ul_magic:sword"}),
	type = "monster",
	category = "undead"
})
ul_mobs.register_mob("ul_mobs:stalker", {
					-- engine values
	description = S"Stalker",
	visual = "upright_sprite",
	egg_colors = {"#000000", "#ffffff"},
	textures = {"ul_mobs_monster_stalker.png", "ul_mobs_monster_stalker.png^[transformFX"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	glow = 14,
	
					-- stats
	max_speed = 2,
	jump_height = 6.5,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 5,
	ranged = {
		func = ul_magic.shoot, 
		args = {"ul_magic:launch", 3},
		range = 48
	},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 3,
	melee_power = 0,
	on_check_prey = check_prey,
	on_check_pred = function(self, obj)
		if obj:get_luaentity() and obj:get_luaentity().name == "ul_mobs:rgull" then
			return true
		end
	end,
	on_die = ul_mobs.death_drops({1.0, "ul_magic:launch"}),
	type = "monster",
	category = "undead"
})
		-- draconic
ul_mobs.register_mob("ul_mobs:kobold", {
					-- engine values
	description = S"Kobold",
	visual = "upright_sprite",
	egg_colors = {"#ff8000", "#ffff00", "#ff0000"},
	textures = {"ul_mobs_monster_kobold.png", "ul_mobs_monster_kobold_back.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 5,
	view_range = 48,
	vision = 7,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	melee = {dmg = 5},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 0,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({1.0, "ul_basic:pick"}, {0.5, "ul_magic:fireball"}),
	type = "monster",
	category = "draconic"
})
ul_mobs.register_mob("ul_mobs:horbold", {
					-- engine values
	description = S"Horbold",
	visual = "upright_sprite",
	egg_colors = {"#ff8000", "#ffff00", "#ff0000"},
	textures = {"ul_mobs_monster_kobold.png", "ul_mobs_monster_kobold_back.png"},
	visual_size = {x = 1.5, y = 1.5},
	collisionbox = {-0.4, -0.75, -0.4, 0.4, 0.5, 0.75},
	
					-- stats
	max_speed = 5,
	jump_height = 5,
	view_range = 48,
	vision = 7,		-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	ranged = {
		func = ul_magic.shoot, 
		args = {"ul_magic:fireball", 3},
		range = 20
	},
	melee = {dmg = 5},
	disable_fall_damage = true,
	
					-- behaviour
	range_power = 5,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({1.0, "ul_basic:pick"}, {1.0, "ul_magic:fireball"}),
	type = "monster",
	category = "draconic"
})

lootblocks.register_drop("ul_mobs:eye", 0.5)
lootblocks.register_drop("ul_mobs:big_eye", 0.1)