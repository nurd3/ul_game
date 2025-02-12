local storage = core.get_mod_storage()
local S = ul_mobs.get_translator

local civ_count = 3
local civ_relations = {}

local C = function(x,y)
	return string.format("%i:%i", math.min(x, y), math.max(x, y))
end

for i = 0, civ_count do
	for j = 0, i do
		civ_relations[C(i,j)] = storage:get_int(C(i,j))
	end
end

local function get_relations(civ1, civ2)
	if not civ1 or not civ2 then return 0 end
	return civ_relations[C(civ1,civ2)] or 0
end

local function set_relations(civ1, civ2, val)
	if not civ1 or not civ2 then return end
	civ_relations[C(civ1,civ2)] = val
	storage:set_int(C(civ1,civ2), val)
	return val
end

local function add_relations(civ1, civ2, val)
	if not civ1 or not civ2 then return end
	if not val then val = 1 end
	return set_relations(civ1, civ2, get_relations(civ1, civ2) + val)
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

local function punched(self, puncher, time_from_last_punch, tool_capabilities, dir)
	local sciv = self.civ
	if mobkit.is_alive(puncher) then				-- is puncher a living and alive thing
		mobkit.hq_hunt(self, 12, puncher)			-- get revenge
	end

	mobkit_plus.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if self.hp <= 0 and puncher:is_player() then
		add_relations(0, sciv, -1)
	end
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
	vision = 7,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	ranged = {
		rate = 0.5,
		range = 128,
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 3}
	},
	melee = {dmg = 2},
	disable_fall_damage = false,
	disable_taming = true,
	
						-- behaviour
	on_check_prey = monster_check,
	on_punch = punched,
	type = "race",
	category = "cult",
	civ = 1
})
ul_mobs.register_mob("ul_mobs:anocula", {
					-- engine values
	description = S"Anocula",
	egg_colors = {"#808080", "#ffff00"},
	visual = "upright_sprite",
	textures = {"ul_mobs_race_anocula.png", "ul_mobs_race_anocula_back.png^[transformFX"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
	
					-- stats
	max_speed = 12,
	jump_height = 2,
	view_range = 128,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	melee = {dmg = 3},
	disable_fall_damage = true,
	disable_taming = true,
	
						-- behaviour
	on_check_prey = monster_check,
	on_punch = punched,
	type = "race",
	category = "alien",
	civ = 2
})

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1.0 then
		for k,v in pairs(civ_relations) do
			-- civ_relations slowly approach 0
			civ_relations[k] = (v == 0 and 0) or (v > 0 and v - 1) or (v + 1)
		end
	end
end)