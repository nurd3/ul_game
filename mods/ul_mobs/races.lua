local S = ul_mobs.get_translator

local civ_count = 3
local civ_relations = {}
local civ_resources = {}

for i = 0, civ_count do
	for j = 0, i do
		local x, y = math.min(i, j), math.max(i, j)
		
		civ_relations[tostring(x)..tostring(y)] = 0
	end
	if i >= 1 then
		civ_resources[i] = {}
	end
end

local function get_relations(civ1, civ2)
	if not civ1 or not civ2 then return 0 end
	return civ_relations[math.min(civ1, civ2) .. math.max(civ1, civ2)]
end

local function set_relations(civ1, civ2, val)
	if not civ1 or not civ2 then return end
	civ_relations[math.min(civ1, civ2) .. math.max(civ1, civ2)] = val
	return val
end

local function dialogue(self, plyr)
	
end

local function monster_check(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	local sciv = self.civ
	
	if luaent then
		
		local lciv = luaent.civ
		
		if sciv and lciv then
			return get_relations(sciv, lciv) <= -2
		end
		
		if luaent.type == "monster" then
			return not luaent._owner or get_relations(0, sciv) <= -2
		end
		
	end
	
	return obj:is_player() and get_relations(0, sciv) <= -2
end

ul_mobs.register_mob("ul_mobs:cult", {
					-- engine values
	description = S"Cult",
	egg_colors = {"#808080", "#000000"},
	visual = "upright_sprite",
	textures = {"ul_mobs_race_cult.png", "ul_mobs_race_cult_back.png^[transformFX"},
	visual_size = {x = 2, y = 2},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 0.8, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 1,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	ranged = {
		rate = 0.2,
		range = 128,
		func = ul_magic.shoot,
		args = {"ul_magic:poison", 5}
	},
	melee = {dmg = 2},
	disable_fall_damage = true,
	disable_taming = true,
	
						-- behaviour
	on_check_prey = monster_check,
	type = "race",
	category = "cult",
	civ = 1
})

ul_mobs.register_mob("ul_mobs:anocula", {
					-- engine values
	description = S"Anocula",
	egg_colors = {"#ffffff", "#800000"},
	visual = "upright_sprite",
	textures = {"ul_mobs_race_anocula.png", "ul_mobs_race_anocula_back.png^[transformFX"},
	visual_size = {x = 1, y = 1.5},
	collisionbox = {-0.3, -0.75, -0.3, 0.3, 0.75, 0.3},
	
					-- stats
	max_speed = 15,
	jump_height = 2,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	ranged = {
		rate = 0.2,
		range = 128,
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5}
	},
	melee = {dmg = 4},
	disable_fall_damage = true,
	disable_taming = true,
	
						-- behaviour
	on_check_prey = monster_check,
	type = "race",
	category = "alien",
	civ = 2
})

