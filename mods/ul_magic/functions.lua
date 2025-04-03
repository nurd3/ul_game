local S = ul_magic.get_translator

function ul_magic.get_runes_by_group(groups)
	if type(groups) ~= "table"
	then error(
		string.format("ul_magic.get_runes_by_group(): bad argument #1 (table expected, got %s)",
			type(name)
	)) else
		local runes = {}

		for name,def in pairs(ul_magic.registered_runes)
		do
			local include = true
			local rune_groups = def.groups or {}

			for k,v in pairs(groups)
			do include = include
				and groups[k] == (rune_groups[k] and true or false)
			end

			if include then table.insert(runes, name) end
		end

		return runes
	end
end

function ul_magic.rand_rune(runes)

	if not runes
	then
		for name,def in pairs(ul_magic.registered_runes)
		do table.insert(runes, name)
		end
	end

	return #runes > 0
		and runes[math.random(#runes)]
end

function ul_magic.wear_spell(itemstack, plyr)
	itemstack:add_wear(65536 / 10)
	return itemstack
end

function ul_magic.get_rune_by_index(index)
	for k,v in pairs(ul_magic.registered_runes) do
		if v.index == index then
			return k
		end
	end
	return nil
end

function ul_magic.get_wear_levels(list)
	local lvls = {}
	
	if list then
		for _,stack in ipairs(list) do
			lvls[stack:get_name()] = (lvls[stack:get_name()] or 0) + 1 or 1
		end
	end

	return lvls
end

function ul_magic.get_rune_levels(list, lvls)
	lvls = lvls and table.copy(lvls) or {}
	
	if list then
		for _,stack in ipairs(list) do
			local enc = stack:get_meta():get("_enchantment")
			if enc then
				local lvl = stack:get_definition() and stack:get_definition().on_wear and stack:get_definition().on_wear("enchantment") or 1
				lvls[enc] = (lvls[enc] or 0) + lvl
			end
		end
	end

	return lvls
end

function ul_magic.get_purpose_level(obj, purpose, inv)
	local lvl = 0
	
	inv = inv or obj.get_inventory and obj:get_inventory()
	
	if not inv or inv:is_empty"outfit" then
		return 0
	end

	local lvls = ul_magic.get_rune_levels(inv:get_list"outfit", obj:is_player() and ul_totems.get_active_rune_bonuses())

	for k,v in pairs(lvls) do
		local rune = ul_magic.registered_runes[k]
		if rune and rune.on_wear then
			lvl = lvl + (rune.on_wear(purpose, v) or 0)
		end
	end

	local wearlvls = ul_magic.get_wear_levels(inv:get_list"outfit")

	for k,v in pairs(wearlvls) do
		local item = core.registered_items[k]
		if item and item.on_wear then
			lvl = lvl + (item.on_wear(purpose, v) or 0)
		end
	end

	return lvl
end

function ul_magic.get_rune_level(obj, rune)
	local inv = obj.get_inventory and obj:get_inventory()
	local lvl = 1
	
	if inv and not inv:is_empty"outfit" then
		lvl = lvl + (ul_magic.get_rune_levels(inv:get_list"outfit")[rune] or 0)
	end

	if obj:is_player() then
		lvl = lvl + ul_totems.get_rune_bonus(rune)
	end

	return lvl
end

function ul_magic.wear_level(obj, rune)
	local inv = obj.get_inventory and obj:get_inventory()
	
	if inv then
		local lvl = 0
		
		local list = inv:get_list"outfit"
		
		for i,stack in ipairs(list) do
			if stack:get_name() == rune.."_ring" then
				stack:add_wear(65536 / 10)
				lvl = lvl + 1
			end
			inv:set_stack("outfit", i, stack)
		end
		
		return lvl + 1
	end
end

function ul_magic.enchant(itemname, rune)
	if not itemname or not rune then return end
	local def = core.registered_items[itemname]
	return (def and def.on_enchant and def.on_enchant(itemname, rune)) or ul_magic.on_enchant_fallback(itemname, rune)
end

function ul_magic.on_enchant_fallback(itemname, rune)
	local stack = ItemStack(itemname)
	local def = core.registered_items[itemname]
	local runedef = ul_magic.registered_runes[rune]
	local imgmod = (runedef.color and ("^[multiply:"..runedef.color)) or ""
	stack:get_meta():set_string("_enchantment", rune)
	stack:get_meta():set_string("description", S("@1 of @2", def.description, runedef.description))
	stack:get_meta():set_string("inventory_image", def.inventory_image..imgmod)
	return stack
end

function ul_magic.shoot(object, target, rune, level)
	-- handle luaentities
	if type(object) == "table"
	and object.object
	then object = object.object end
	-- handle invalid objectrefs
	if object
	and not (object.is_valid and object:is_valid())
	or target
	and not (target.is_valid and target:is_valid())
	then return end
	-- handle bad input
	if type(object) ~= "userdata"
	then error(string.format(
		"ul_magic.shoot(): bad argument #1 (userdata expected, got %s)",
		type(object)
	)) elseif type(target) ~= "userdata"
	then error(string.format(
		"ul_magic.shoot(): bad argument #2 (userdata expected, got %s)",
		type(target)
	)) end

	local pos = object:get_pos()
	local tpos = target:get_pos()
	tpos.y = tpos.y + (
		target:get_luaentity() and 0
		or 1.0
	)

	return ul_magic.shoot_ball(object, vector.direction(pos, tpos), rune, level)
end

function ul_magic.shoot_ball(object, direction, rune, level, offset)

	-- handle luaentities
	if type(object) == "table"
	and object.object
	then object = object.object end
	-- handle invalid objectrefs
	if object
	and not (object.is_valid and object:is_valid())
	then return end
	-- handle bad input
	if type(object) ~= "userdata"
	then error(string.format(
		"ul_magic.shoot_ball(): bad argument #1 (userdata expected, got %s)",
		type(object)
	)) elseif type(direction) ~= "table"
	then error(string.format(
		"ul_magic.shoot_ball(): bad argument #2 (vector expected, got %s)",
		type(direction)
	)) elseif type(offset) ~= "table" and offset
	then error(string.format(
		"ul_magic.shoot_ball(): bad argument #5 (vector or nil expected, got %s)",
		type(offset)
	)) end

	-- get rune definition
	local def = ul_magic.registered_runes[rune]
	-- do not shoot undefined runes
	if not def
	then return core.log("warning", string.format(
		"ul_magic.shoot(): attempt to shoot undefined rune (%s)",
		rune
	)) end
	if not def.disable_primary
	then
		local o = core.add_entity(object:get_pos() + (offset or vector.zero()), "ul_magic:ball", core.serialize {
			_velocity = direction * 16,
			_level = level,
			_rune = rune
		})
		o:get_luaentity():set_shooter(object)
		
		ul_basic.objsound(object, "ul_magic_attack")
		return true
	else
		ul_basic.objsound(object, "ul_fail")
		return false
	end
end