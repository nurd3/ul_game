local S = ul_tower.get_translator

local function check_prey(self, obj)
	if not ul_basic.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	if luaent and luaent.type == "neutral" then
		return false
	end
	
	return luaent and luaent._owner or obj:is_player()
end

ul_mobs.register_mob("ul_tower:babylon_eye", {
					-- engine values
	description = S"Eye",
	visual = "sprite",
	egg_colors = {"#ffffff", "#000000"},
	textures = {"ul_tower_babylon_eye.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	
					-- stats
	max_speed = 8,
	jump_height = 5,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 5,
	melee = {dmg = 5, range = 5},
	disable_fall_damage = true,
	disable_taming = true,
	
						-- behaviour
	range_power = 0,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:heal"}),
	type = "monster",
	category = "babylon"
})

ul_mobs.register_mob("ul_tower:babylonian", {
					-- engine values
	description = S"Babylonian",
	visual = "upright_sprite",
	egg_colors = {"#00ffff", "#ff0000"},
	textures = {"ul_tower_babylonian.png", "ul_tower_babylonian_back.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 8,
	jump_height = 5,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	ranged = {
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5},
		range = 5
	},
	melee = {dmg = 5, range = 5},
	disable_taming = true,
	
					-- behaviour
	range_power = 5,
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:light"}, {0.2, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})