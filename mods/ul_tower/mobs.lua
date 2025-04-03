local S = ul_tower.get_translator

------------------
-- HOSTILE MOBS --
------------------

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
	description = S"Babylon Eye",
	visual = "sprite",
	egg_colors = {"#777777", "#ffffff"},
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
	xp_worth = 10,
	melee = {dmg = 5, range = 5},
	disable_fall_damage = true,
	disable_taming = true,
	
						-- behaviour
	range_power = 0,
	melee_power = 5,
	scare_dmg = 1,	-- if this much damage is dealt in a singleblow, the entity becomes scared
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:heal"}, {0.2, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})
ul_mobs.register_mob("ul_tower:big_eye", {
					-- engine values
	description = S"Big Babylon Eye",
	visual = "sprite",
	egg_colors = {"#ffffff", "#ff0000", "#000000"},
	textures = {"ul_tower_babylon_eye.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.5, -1.0, -0.5, 0.5, 1.0, 0.5},
	
					-- stats
	max_speed = 7,
	jump_height = 5,
	view_range = 48,
	vision = 10,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	xp_worth = 25,
	melee = {dmg = 10},
	
					-- behaviour
	range_power = 0,
	melee_power = 10,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:heal"}, {0.2, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})
ul_mobs.register_mob("ul_tower:babylonian", {
					-- engine values
	description = S"Babylonian",
	visual = "upright_sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_tower_babylonian.png", "ul_tower_babylonian_back.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 7,
	jump_height = 5,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 15,
	xp_worth = 25,
	ranged = {
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5},
		range = 10
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
ul_mobs.register_mob("ul_tower:ranger", {
					-- engine values
	description = S"Ranger",
	visual = "upright_sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_tower_ranger.png", "ul_tower_ranger_back.png"},
	visual_size = {x = 2.0, y = 2.0},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 1.0, 0.3},
	
					-- stats
	max_speed = 8,
	jump_height = 5,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	xp_worth = 10,
	melee = {dmg = 3},
	disable_taming = true,
	
					-- behaviour
	range_power = 5,
	melee_power = 5,
	comfortable_hp = 5,
	scare_dmg = 3,	-- if this much damage is dealt in a singleblow, the entity becomes scared
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:light"}, {0.2, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})
ul_mobs.register_mob("ul_tower:snail", {
					-- engine values
	description = S"Snail",
	visual = "sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_tower_snail.png"},
	visual_size = {x = 0.5, y = 0.5},
	collisionbox = {-0.2, -0.3, -0.2, 0.2, 0.3, 0.2},
	
					-- stats
	max_speed = 1,
	jump_height = 2,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	xp_worth = 50,
	melee = {dmg = 10},
	disable_taming = true,
	
					-- behaviour
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.1, "ul_magic:light"}, {0.2, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})
ul_mobs.register_mob("ul_tower:big_snail", {
					-- engine values
	description = S"Big Snail",
	visual = "upright_sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_tower_snail.png", "ul_tower_snail_back.png^[transformFX"},
	visual_size = {x = 1.0, y = 1.0},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3},
	
					-- stats
	max_speed = 1,
	jump_height = 2,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 40,
	xp_worth = 100,
	melee = {dmg = 10},
	disable_taming = true,
	
					-- behaviour
	melee_power = 5,
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:light"}, {0.5, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})
ul_mobs.register_mob("ul_tower:guard", {
					-- engine values
	description = S"Guardian",
	visual = "upright_sprite",
	egg_colors = {"#777777", "#ffffff"},
	textures = {"ul_tower_guard.png", "ul_tower_guard_back.png^[transformFX"},
	visual_size = {x = 1.0, y = 3.0},
	collisionbox = {-0.3, -1.5, -0.3, 0.3, 1.3, 0.3},
	
					-- stats
	max_speed = 1,
	jump_height = 2,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 40,
	xp_worth = 100,
	ranged = {
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5},
		range = 20
	},
	melee = {dmg = 10},
	disable_taming = true,
	
	sounds = {
		hunt = "ul_tower_guard_hunt"
	},
					-- behaviour
	melee_power = 5,
	scare_dmg = 5,	-- if this much damage is dealt in a singleblow, the entity becomes scared
	on_check_prey = check_prey,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:light"}, {0.5, "ul_basic:rod"}),
	type = "monster",
	category = "babylon"
})

-----------------
-- DOCILE MOBS --
-----------------

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
		
		if luaent.type == "monster"
		or luaent.category ~= "tower"
		then
			return not luaent.disable_hunting
		end
		
	end
	
	if obj:is_player()
	and self.avoid_players
	then
		return true
	end
	
	return false
end

ul_mobs.register_mob("ul_tower:gull", {
		-- engine values
	description = S"Babylon 'Gull",
	visual = "upright_sprite",
	egg_colors = {"#404040", "#bfbfbf", "#ffffff"},
	textures = {"ul_tower_gull.png", "ul_tower_gull_back.png^[transformFX"},
	visual_size = {x = 0.75*1.5, y = 0.75},
	collisionbox = {-0.1, -0.4, -0.1, 0.1, 0.2, 0.1},

		-- stats
	max_speed = 4,
	jump_height = 10,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 1,
	disable_hunting = true,
	disable_fall_damage = true,
	runaway = true,

			-- behaviour
	on_punch = function (self)
		ul_basic.drop(self.object:get_pos(), 1.0, self.name, 1)
		self.object:remove()
	end,
	type = "animal",
	category = "tower"
})

ul_mobs.register_mob("ul_tower:goober", {
		-- engine values
	description = S"Goober",
	visual = "upright_sprite",
	egg_colors = {"#00ff00", "#9800ff"},
	textures = {"ul_tower_goober.png", "ul_tower_goober_back.png^[transformFX"},
	visual_size = {x = 1, y = 1},
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.4, 0.3},

		-- stats
	max_speed = 4,
	jump_height = 10,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	disable_fall_damage = true,
	runaway = true,

	sounds = {
		flee = "ul_tower_goober_flee",
		idle = "ul_tower_goober_idle",
	},

			-- behaviour
	avoid_players = true,
	on_check_pred = check_pred,
	on_die = ul_mobs.death_drops({0.5, "ul_magic:poison"}),
	type = "animal",
	category = "tower"
})

ul_mobs.register_mob("ul_tower:butterfly", {
	
	-- engine values
	description = S"Butterfly",
	visual = "sprite",
	egg_colors = {"#ffffff", "#777777", "#ff0000"},
	textures = {"ul_tower_butterfly.png"},
	visual_size = {x = 0.5, y = 0.5},
	collisionbox = {-0.1, -0.2, -0.1, 0.1, 0.1, 0.1},

		-- stats
	max_speed = 20,
	jump_height = 10,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 10,
	disable_hunting = true,
	disable_fall_damage = true,

			-- behaviour
	avoid_players = true,
	on_check_pred = check_pred,
	on_activate = function(self, staticdata, dtime_s)
		ul_mobs.actfunc(self, staticdata, dtime_s)

		self._rune = ul_magic.rand_rune()

		local sdat = core.deserialize(staticdata)
		if sdat
		then
			self._rune = sdat._rune or self._rune
		end

		local color = ul_magic.registered_runes[self._rune]
			and ul_magic.registered_runes[self._rune].color
			or "#ffffff"
		core.after(0.1, function()
			self.object:set_properties{textures = {"ul_tower_butterfly.png^[multiply:"..color..":255^"}}
		end)
	end,
	get_staticdata = function(self)
		local sdat = ul_mobs.statfunc(self)
		local temp = core.deserialize(sdat)

		if not temp
		then
			return
		elseif temp.remove
		then
			return "return {remove=true}"
		end

		temp._rune = self._rune
		return core.serialize(temp)
	end,
	on_die = function (self, pos)
		if self._rune
		then
			ul_basic.drop(pos, 2, self._rune)
		end
	end,
	type = "animal",
	category = "tower"
})

ul_mobs.register_mob("ul_tower:bob", {
	
	-- engine values
	description = S"Bob",
	visual = "upright_sprite",
	egg_colors = {"#bfbfbf", "#777777", "#ff0000"},
	textures = {"ul_tower_bob.png", "ul_tower_bob_back.png"},
	visual_size = {x = 1, y = 2},
	collisionbox = {-0.4, -1.0, -0.4, 0.4, 1.0, 0.4},

		-- stats
	max_speed = 10,
	jump_height = 10,
	view_range = 64,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,

	sounds = {
		hunt = "ul_tower_bob_hunt",
		idle = "ul_tower_bob_idle",
	},

			-- behaviour
	ranged = {
		rate = 2.0,
		range = 128,
		func = function(self, target)
			if self._rune
			then
				ul_magic.shoot(self, target, self._rune, 3)
			end
		end,
		args = {}
	},
	on_check_prey = check_pred,
	on_activate = function(self, staticdata, dtime_s)
		local sdat = core.deserialize(staticdata)

		ul_mobs.actfunc(self, staticdata, dtime_s)

		self._rune = ul_magic.rand_rune(ul_magic.get_runes_by_group {attack = true, shoot = true})

		if sdat
		then
			self._rune = sdat._rune or self._rune
		end

		-- core.log(dump(self))

		local color = ul_magic.registered_runes[self._rune]
			and ul_magic.registered_runes[self._rune].color
			or "#ffffff"
		self.object:set_properties {textures = {"ul_tower_bob.png^[fill:8x8:4,8:#000000^[fill:6x6:5,9:"..color, "ul_tower_bob_back.png"}}
	end,
	get_staticdata = function(self)
		local sdat = ul_mobs.statfunc(self)
		local temp = core.deserialize(sdat)

		if not temp
		then
			return
		elseif temp._remove
		then
			return "return {_remove=true}"
		end

		temp._rune = self._rune
		return core.serialize(temp)
	end,
	on_die = function (self, pos)
		if self._rune
		then
			ul_basic.drop(pos, 2, self._rune)
		end
	end,
	type = "animal",
	category = "tower"
})