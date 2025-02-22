-- default registered shrines n stuff

local S = ul_shrines.get_translator

local function tower_level_range(min, max, mult)
	local level = ul_tower.get_height()
	level = min and math.max(level, min - 1) or level
	level = max and math.min(level, max) or level
	return (level - min + 1) * (mult or 1)
end

local wrath_murder = 0
local envy_murder = 0
ul_mobs.register_on_death(function(ent)
	if ent._killer and ent._killer:is_player() then
		if ent.groups and ent.groups.market then
			envy_murder = envy_murder + 1
			core.after(30, function() envy_murder = envy_murder - 1 end)
		else
			wrath_murder = wrath_murder + 1
			core.after(30, function() wrath_murder = wrath_murder - 1 end)
		end
	end
end)

-------------
-- SHRINES --
-------------

-- lust:
	-- too many pets
ul_shrines.register_shrine("ul_shrines:lust", {
	title = S"Lust",
	description = S"To ruin with the sanctity of intimacy.\nRepentance required.",
	repentable = true,
	on_step = function(value)
		local count = 0

		for _,plyr in ipairs(core.get_connected_players()) do
			for obj in core.objects_inside_radius(plyr:get_pos(), 128) do
				local luaent = obj:get_luaentity()
				if luaent and luaent._owner and luaent._owner == plyr:get_player_name() then
					count = count + 1
				end
			end
		end

		return value + tower_level_range(8, nil, 0.025) * count * 0.25
	end
})
-- gluttony:
	-- too many healing items
	-- too many lives/revives
ul_shrines.register_shrine("ul_shrines:gluttony", {
	title = S"Gluttony",
	description = S"To hoard beyond necessity.\nGoes down naturally.",
	on_step = function(value)
		local count = 0
		local excess = 0

		for _,plyr in ipairs(core.get_connected_players()) do
			excess = excess + (math.max(ul_lives.get_life(plyr:get_player_name()), 3) - 3)
			for _,stack in ipairs(plyr:get_inventory():get_list"main") do
				local groups = stack:is_known() and stack:get_definition().groups
				if groups and groups.healing then
					count = count + 1
				end
			end
		end

		return value + tower_level_range(4, 8, 0.125) * (excess * 0.05 + (count * 0.125 * 0.125) - 2)
	end
})
-- greed:
	-- too much money
ul_shrines.register_shrine("ul_shrines:greed", {
	title = S"Greed",
	description = S"To enslave oneself to power.\nGoes down naturally.",
	on_step = function(value)
		local excess = 0

		for _,plyr in ipairs(core.get_connected_players()) do
			excess = excess + (ul_market.get_wallet(plyr:get_player_name()) - 10000) / 1000000
		end

		return excess * tower_level_range(4, 20, 0.125)
	end
})
-- sloth:
	-- too many portals
ul_shrines.register_shrine("ul_shrines:sloth", {
	title = S"Sloth",
	description = S"To vegetate excessively.\nRepentance required.",
	repentable = true,
	on_step = function(value)
		return value + tower_level_range(8, nil, 0.05) * ul_portal.get_portal_count() * 0.25
	end,
	on_repent = function(value)
		return value - tower_level_range(8, nil, 0.05)
	end
})
-- wrath:
	-- killing too many mobs
ul_shrines.register_shrine("ul_shrines:wrath", {
	title = S"Wrath",
	description = S"To attack excessively.\nGoes down naturally.",
	on_step = function(value)
		return value + tower_level_range(8, nil, 0.025) * (wrath_murder - 4)
	end
})
-- envy:
	-- killing too many market mobs
	-- having too many eggs
ul_shrines.register_shrine("ul_shrines:envy", {
	title = S"Envy",
	description = S"To want what you can't have.\nGoes down naturally.",
	on_step = function(value)
		local total = 0

		for _,plyr in ipairs(core.get_connected_players()) do
			local count = 0

			for _,stack in ipairs(plyr:get_inventory():get_list"main") do

				local groups = stack:is_known() and stack:get_definition().groups
				if groups and groups.egg then
					count = count + stack:get_count()
				end

			end

			total = count - 3
		end

		return value +
			tower_level_range(8, nil, 0.025) * (envy_murder - 2) * 0.125 +
			tower_level_range(4, 8, 0.125) * ((total) * 0.125 * 0.125) * 0.25
	end
})
-- pride:
	-- gets faster as the tower goes up
ul_shrines.register_shrine("ul_shrines:pride", {
	title = S"Pride",
	description = S"To neglect one's world in the belief of superiority.\nRepentance required.",
	repentable = true,
	on_step = function(value)
		return value + tower_level_range(1, nil, 0.125 * 0.125)
	end,
	on_repent = function(value)
		return value - tower_level_range(1, nil, 0.125)
	end
})

-----------
-- PIETY --
-----------

core.register_craftitem("ul_shrines:piety_vial", {
	short_description = S"Vial of Piety",
	description = S"Vial of Piety\nGives drinker 10 piety",
	inventory_image = "ul_shrines_piety_vial.png",
	on_use = function(stack, user, pointed_thing)
		stack:take_item()
		ul_shrines.add_piety_level(user:get_player_name(), 10)
		ul_basic.objsound(user, "ul_magic_cast")
		core.chat_send_player(user:get_player_name(), core.colorize("#ffff00", "You got 10 Piety!"))
		return stack
	end,
	groups = {piety = 1}
})

core.register_craftitem("ul_shrines:piety_heart", {
	short_description = S"Heart of Piety",
	description = S"Heart of Piety\nGives eater 100 piety",
	inventory_image = "ul_shrines_piety_heart.png",
	on_use = function(stack, user, pointed_thing)
		stack:take_item()
		ul_shrines.add_piety_level(user:get_player_name(), 100)
		ul_basic.objsound(user, "ul_magic_cast")
		core.chat_send_player(user:get_player_name(), core.colorize("#ffff00", "You got 100 Piety!"))
		return stack
	end,
	groups = {piety = 1}
})

ul_market.register_goods {
	industry = "ul_market:industry_religion",
	items = {
		["ul_shrines:piety_vial"] = {supply = 3.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_breeding",
	items = {
		["ul_shrines:piety_vial"] = {demand = 6.0}
	}
}

core.register_on_dieplayer(function (plyr)
	local plyrname = plyr:get_player_name()
	if ul_lives.get_life(plyrname) ~= 0 then
		return
	end
	
	ul_basic.drop(
		plyr:get_pos(), 0.001, "ul_shrines:piety_heart", 1
	)
end)

xplib.register_on_update(function(plyrname, reason, xp, lvl, total)
	if reason.lvlchange >= 1 then
		ul_shrines.add_piety_level(plyrname, 10)
	end
end)

--------------------
-- SHRINE EFFECTS --
--------------------

-- EVENT BONUSES --

ul_market.register_on_eventbonuscalc(function(event_bonuses)
	local m = ul_shrines.get_shrine_mults()

	-- subsidies
	ul_market.add_event_bonus(event_bonuses, "ul_market:event_inflation", {
		chance = m["ul_shrines:greed"] * 5, m["ul_shrines:greed"] * 10
	})
	-- famine
	ul_market.add_event_bonus(event_bonuses, "ul_market:event_famine", {
		chance = m["ul_shrines:gluttony"], intensity = m["ul_shrines:gluttony"] * 4
	})
	-- epidemic
	ul_market.add_event_bonus(event_bonuses, "ul_market:event_epidemic", {
		chance = m["ul_shrines:lust"], intensity = m["ul_shrines:lust"] * 4
	})
	-- subsidies
	ul_market.add_event_bonus(event_bonuses, "ul_market:event_subsidies", {
		chance = -m["ul_shrines:greed"], -m["ul_shrines:greed"] * 4
	})

	return event_bonuses
end)

-- NATURAL ENTITIES --

natural_entities.register_spawn("ul_shrines:spawn", {
		
	spawn_rate = 0.5,
	
	min_y = -31000,
	max_y = 31000,
	
	entities = {
				-- monsters
		["ul_mobs:eye"] = 0.8,
		["ul_mobs:big_eye"] = 0.1,
		["ul_mobs:ghost"] = 0.5,
		["ul_mobs:zombie"] = 0.5,
		["ul_mobs:vampire"] = 0.25,
		["ul_mobs:lich"] = 0.5,
		["ul_mobs:skeleton"] = 0.25,
		["ul_mobs:stalker"] = 0.5,
		["ul_mobs:kobold"] = 0.1,
		["ul_mobs:horbold"] = 0.1,
				-- arcanoids
		["ul_mobs:shadow"] = 0.5,
				-- races
		["ul_mobs:cult"] = 0.05,
		["ul_mobs:anocula"] = 0.05,
				-- arcanoids
		["ul_mobs:eeltig"] = 0.1,
		["ul_mobs:lootglob"] = 0.05,
		["ul_mobs:shadow"] = 0.05,
		["ul_mobs:alien"] = 0.0125
	},
	
	check = function()
		local chance = 0
		local mults = ul_shrines.get_shrine_mults()

		for _,value in pairs(mults) do
			chance = chance * value
		end

		return chance > math.random()
	end
	
})