local function check_pred(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	if self._owner then
		
		local lowner = luaent and luaent._owner or obj:get_player_name()
		
		if self._owner == lowner or obj:is_player() then
			return false
		end
		
	end
	
	if luaent then
		
		if luaent.type == "monster" then
			return true
		end
		
	end
	
	if obj:is_player() and self.avoid_players then
		return true
	end
	
	return false
end

local function raging_gull_check(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	
	if luaent then
		
		if luaent.type == "monster" then
			return true
		end
		
	end
	
	if self._owner then
		
		local lowner = luaent and luaent._owner or obj:get_player_name()
		
		if self._owner == lowner or obj:is_player() then
			return false
		end
		
	end
	
	return false
end

local S = ul_mobs.get_translator

		-- avioids
ul_mobs.register_mob("ul_mobs:gull", {
					-- engine values
	description = S"Plain 'Gull",
	visual = "upright_sprite",
	egg_colors = {"#ffffff", "#ff8000", "#000000"},
	textures = {"ul_mobs_animal_gull.png", "ul_mobs_animal_gull_back.png^[transformFX"},
	visual_size = {x = 0.75*1.5, y = 0.75},
	collisionbox = {-0.1, -0.4, -0.1, 0.1, 0.2, 0.1},
	
					-- stats
	max_speed = 4,
	jump_height = 10,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 1,
	disable_fall_damage = true,
	runaway = true,
	
	sounds = {
		flee = "ul_mobs_animal_flee"
	},
	
						-- behaviour
	on_check_pred = check_pred,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:levitation"}),
	type = "animal",
	category = "avioid"
})
ul_mobs.register_mob("ul_mobs:mgull", {
					-- engine values
	description = S"Magic 'Gull",
	visual = "upright_sprite",
	egg_colors = {"#0000ff", "#00ffff", "#ff00ff"},
	textures = {"ul_mobs_animal_mgull.png", "ul_mobs_animal_mgull_back.png^[transformFX"},
	visual_size = {x = 0.75*1.5, y = 0.75},
	collisionbox = {-0.1, -0.4, -0.1, 0.1, 0.2, 0.1},
	glow = 14,
	
					-- stats
	max_speed = 4,
	jump_height = 10,
	view_range = 4,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 1,
	disable_fall_damage = true,
	disable_hunting = true,		-- will not be hunted
	on_punch = function (self)
		ul_basic.drop(self.object:get_pos(), 1.0, self.name, 1)
		self.object:remove()
	end,
	on_rightclick = function (self)
		if self._dry then
			ul_basic.objsound(self.object, "ul_fail")
		else
			ul_basic.objsound(self.object, "ul_take")
			self._dry = true
			ul_basic.drop(self.object:get_pos(), 1.0, "ul_magic:shard")
			core.after(math.random(5, 30), function (self)
				if not mobkit.is_alive(self) then return end
				ul_basic.objsound(self.object, "ul_activate")
				self._dry = false
			end, self)
		end
	end,
	
						-- behaviour
	type = "animal",
	category = "avioid",
})
ul_mobs.register_mob("ul_mobs:rgull", {
					-- engine values
	description = S"Raging 'Gull",
	egg_colors = {"#ffffff", "#ff8000", "#ff0000"},
	visual = "sprite",
	textures = {"ul_mobs_animal_rgull.png", "ul_mobs_animal_rgull_back.png^[transformFX"},
	visual_size = {x = 0.75*1.5, y = 0.75*1.5},
	collisionbox = {-0.1, -0.4, -0.1, 0.1, 0.2, 0.1},
	glow = 10,
	
					-- stats
	max_speed = 15,
	jump_height = 10,
	view_range = 16,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	melee = {dmg = 10},
	disable_fall_damage = true,
	on_punch = function (self, puncher)
		local playername = puncher:get_player_name()
		if self._owner and playername and self._owner ~= playername then
			return
		end
		ul_basic.drop(self.object:get_pos(), 1.0, self.name, 1)
		self.object:remove()
	end,
	
						-- behaviour
	on_check_prey = raging_gull_check,
	type = "animal",
	category = "avioid"
})
		-- hybrids
ul_mobs.register_mob("ul_mobs:cowpig", {
					-- engine values
	description = S"Cowpig",
	visual = "sprite",
	textures = {"ul_mobs_animal_cowpig.png"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	
					-- stats
	max_speed = 15,
	jump_height = 10,
	view_range = 64,
	lung_capacity = nil,
	max_hp = 10,
	disable_on_punch = true,
	disable_fall_damage = false,
	
						-- behaviour
	on_check_pred = check_pred,
	type = "animal",
	category = "hybrid"
})

lootblocks.register_drop("ul_mobs:mgull", 0.01)