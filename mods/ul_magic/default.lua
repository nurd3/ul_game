local S = ul_magic.get_translator

ul_magic.register_rune("ul_magic:heal", {
	type = "support",
	description = S"Health",
	color = "#ff00ff",
	on_hitobj = function (user, victim, level)
		if victim then
			victim:set_hp(victim:get_hp() + level * 2)
			return true
		end
	end,
	on_cast = function (user, victim, level)
		if user then
			user:set_hp(user:get_hp() + level * 2)
			return true
		end
	end
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
	end
})
ul_magic.register_rune("ul_magic:fireball", {
	type = "attack",
	description = S"Fireball",
	color = "#ff8000",
	on_hitobj = function (user, victim, level)
		if victim then
			victim:set_hp(victim:get_hp() - (level * 2))
			ul_statfx.apply(victim, "ul_magic:burning", 5)
			return true
		end
	end,
})
ul_magic.register_rune("ul_magic:launch", {
	type = "attack",
	description = S"Launching",
	color = "#0080ff",
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
	end
})
ul_magic.register_rune("ul_magic:teleport", {
	type = "movement",
	description = S"Teleportation",
	color = "#0000ff",
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
		if victim and user then
			user:set_hp(user:get_hp() + level * 2)
			victim:set_hp(victim:get_hp() - level * 2)
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
	end
})

lootblocks.register_drop("ul_magic:spell", 0.5)
lootblocks.register_drop("ul_magic:fireball", 0.5)
lootblocks.register_drop("ul_magic:levitation", 0.3)
lootblocks.register_drop("ul_magic:heal", 0.2)
lootblocks.register_drop("ul_magic:vampirism", 0.2)
lootblocks.register_drop("ul_magic:regen", 0.1)
lootblocks.register_drop("ul_magic:poison", 0.1)
lootblocks.register_drop("ul_magic:launch", 0.1)
lootblocks.register_drop("ul_magic:teleport", 0.1)
