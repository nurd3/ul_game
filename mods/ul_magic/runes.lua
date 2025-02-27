local S = ul_magic.get_translator

ul_magic.register_rune("ul_magic:heal", {
	type = "support",
	description = S"Health",
	color = "#ff00ff",

	on_hitobj = function (user, victim, level)
		if victim then
			ul_basic.set_hp(victim, level * 2)
			return true
		end
	end,
	on_cast = function (user, victim, level)
		if user then
			ul_basic.set_hp(user, level * 2)
			return true
		end
	end,

	groups = {healing = 1}
})
ul_magic.register_rune("ul_magic:regen", {
	type = "support",
	description = S"Regeneration",
	color = "#ff0077",

	on_hitobj = function (user, victim, level)
		if victim then
			ul_statfx.apply(victim, "ul_magic:regen", 3 * level)
			return true
		end
	end,
	on_cast = function (user, victim, level)
		if user then
			ul_statfx.apply(user, "ul_magic:regen", 3 * level)
			return true
		end
	end,

	groups = {healing = 1}
})
ul_magic.register_rune("ul_magic:fireball", {
	type = "attack",
	description = S"Fireball",
	color = "#ff8000",

	on_hitobj = function (user, victim, level)
		if victim then
			ul_basic.punch(victim, user, nil, level * 2)
			ul_statfx.apply(victim, "ul_magic:burning", 5)
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:launch", {
	type = "attack",
	description = S"Launching",
	color = "#0080ff",
	disable_ring = true,

	on_hitobj = function (user, victim, level)
		if victim then
			victim:add_velocity({x=0,y=20,z=0})
			return true
		end
	end,
	on_cast = function (user, victim, level)
		if user then
			user:add_velocity({x=0,y=20,z=0})
			return true
		end
	end,
	on_melee = function (user, victim, level, stats)
		if victim and user then
			victim:add_velocity({x=0,y=20,z=0})
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:levitate", {
	type = "prank",
	description = S"Levitation",
	color = "#00ffff",

	on_hitobj = function (user, victim, level)
		if victim then
			ul_statfx.apply(victim, "ul_magic:levitate", 2 * level)
			return true
		end
	end,
	on_cast = function (user, victim, level)
		if user then
			ul_statfx.apply(user, "ul_magic:levitate", 2 * level)
			return true
		end
	end,
	on_melee = function (user, victim, level, stats)
		if victim and user then
			ul_statfx.apply(victim, "ul_magic:levitate", 2 * level)
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:teleport", {
	type = "movement",
	description = S"Teleportation",
	color = "#0000ff",
	disable_ring = true,

	on_hitnode = function (user, pos, level)
		if user then
			user:set_pos(pos)
		end
	end
})
ul_magic.register_rune("ul_magic:vampirism", {
	type = "attack",
	description = S"Vampirism",
	color = "#ff0000",

	on_hitobj = function (user, victim, level)
		if victim and user
		and ul_basic.punch(victim, user, nil, level * 2)
		then
			ul_basic.set_hp(user, level * 2)
			return true
		end
	end,
	on_melee = function (user, victim, level, stats)
		if victim and user
		and ul_basic.punch(victim, user, nil, level * 2)
		then
			ul_basic.set_hp(user, level * 2)
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:poison", {
	type = "attack",
	description = S"Poison",
	color = "#00ff00",

	on_hitobj = function (user, victim, level)
		if victim then
			ul_statfx.apply(victim, "ul_magic:poison", 3 * level)
			return true
		end
	end,
	on_melee = function (user, victim, level, stats)
		if victim then
			ul_statfx.apply(victim, "ul_magic:poison", 3 * level)
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:darkness", {
	type = "attack",
	description = S"Darkness",
	color = "#000001",
	disable_spell = true,

	on_melee = function (user, victim, level, stats)
		if victim and user then
			if core.get_node_light(vector.round(user:get_pos()), 0) < 5 
			and ul_basic.punch(victim, user, 1, level * 3)
			then
				ul_basic.objsound(user, "ul_activate")
			else
				ul_basic.set_hp(victim, 1)
			end
			return true
		end
	end
})
ul_magic.register_rune("ul_magic:defense", {
	type = "wear",
	description = S"Defense",
	color = "#00107a",
	disable_spell = true,

	on_wear = function (purpose, level)
		if purpose == "defense" then
			return 2 * level
		end
	end
})
ul_magic.register_rune("ul_magic:iridescence", {
	type = "complex",
	description = S"Iridescence",
	color = "#2a335e",
	disable_spell = true,

	on_melee = function (user, victim, level)
		if victim then
			ul_basic.punch(victim, user, 1, level)
			return true
		end
	end,
	on_wear = function (purpose, level)
		if purpose == "stealth" then
			return level * 5
		end
		if purpose == "defense" then
			return -level * 5
		end
		if purpose == "darkness" then
			return -2
		end
	end
})
ul_magic.register_rune("ul_magic:light", {
	type = "complex",
	description = S"Light",
	color = "#ffe16b",
	disable_spell = true,

	on_melee = function (user, victim, level)
		if victim then
			ul_basic.punch(victim, user, 1, level * 2)
			ul_basic.set_hp(user, 1)
			return true
		end
	end,
	on_wear = function (purpose, level)
		if purpose == "stealth" then
			return -15
		end
		if purpose == "defense" then
			return 4
		end
		if purpose == "darkness" then
			return -2
		end
	end
})
ul_magic.register_rune("ul_magic:moon", {
	type = "complex",
	description = S"Moon",
	color = "#8c00ff",
	disable_spell = true,

	on_melee = function (user, victim, level)
		if victim and user then
			ul_basic.set_hp(user, -level)
			ul_basic.punch(victim, user, 1, level * 3)
			return true
		end
	end,
	on_wear = function (purpose, level)
		if purpose == "stealth" then
			return 2
		end
		if purpose == "defense" then
			return -level * 2
		end
		if purpose == "darkness" then
			return level
		end
	end
})
ul_magic.register_rune("ul_magic:sun", {
	type = "complex",
	description = S"Sun",
	color = "#ffff00",
	disable_spell = true,

	on_melee = function (user, victim, level)
		if victim then
			ul_basic.punch(victim, user, 1, level)
			return true
		end
	end,
	on_wear = function (purpose, level)
		if purpose == "stealth" then
			return -level * 5
		end
		if purpose == "defense" then
			return level * 2
		end
		if purpose == "darkness" then
			return level
		end
	end
})
ul_magic.register_rune("ul_magic:blood", {
	type = "complex",
	description = S"Blood",
	color = "#660202",
	disable_spell = true,
	
	on_melee = function (user, victim, level)
		if victim then
			ul_basic.punch(victim, user, 1, (level - 1) * 5)
			ul_basic.set_hp(user, -1)
			return true
		end
	end,
	on_wear = function (purpose, level)
		if purpose == "stealth" then
			return level * 2
		end
		if purpose == "defense" then
			return -level * 4
		end
		if purpose == "darkness" then
			return -level
		end
	end
})

lootblocks.register_drop("ul_magic:spell", 0.5)
lootblocks.register_drop("ul_magic:fireball", 0.5)
lootblocks.register_drop("ul_magic:levitate", 0.3)
lootblocks.register_drop("ul_magic:defense", 0.3)
lootblocks.register_drop("ul_magic:heal", 0.2)
lootblocks.register_drop("ul_magic:vampirism", 0.2)
lootblocks.register_drop("ul_magic:darkness", 0.2)
lootblocks.register_drop("ul_magic:regen", 0.1)
lootblocks.register_drop("ul_magic:poison", 0.1)
lootblocks.register_drop("ul_magic:launch", 0.1)
lootblocks.register_drop("ul_magic:teleport", 0.1)
lootblocks.register_drop("ul_magic:iridescence", 0.1)
lootblocks.register_drop("ul_magic:light", 0.1)