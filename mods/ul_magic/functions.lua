local S = ul_magic.get_translator

function ul_magic.get_rune_by_index(index)
	for k,v in ipairs(ul_magic.registered_runes) do
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

function ul_magic.get_rune_levels(list)
	local lvls = {}
	
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

function ul_magic.get_purpose_level(obj, purpose)
	local inv = obj.get_inventory and obj:get_inventory()
	local lvl = 0
	
	if not inv or inv:is_empty"outfit" then
		return 0
	end

	local lvls = ul_magic.get_rune_levels(inv:get_list"outfit")

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
	return def and def.on_enchant and def.on_enchant(itemname, rune) or ul_magic.on_enchant_fallback(itemname, rune)
end

function ul_magic.on_enchant_fallback(itemname, rune)
	local stack = ItemStack(itemname)
	local def = core.registered_items[itemname]
	local runedef = ul_magic.registered_runes[rune]
	local imgmod = (runedef.color and ("^[multiply:"..runedef.color)) or ""
	stack:get_meta():set_string("_enchantment", rune)
	stack:get_meta():set_string("description", S("@1 of @2", def.description, def.description))
	stack:get_meta():set_string("inventory_image", def.inventory_image..imgmod)
	return stack
end

function ul_magic.shoot(self, target, name, level)
	local def = ul_magic.registered_runes[name]
	if not def then error("undefined rune: "..tostring(name), 2) end
	if not def.disable_primary
	then
		local pos = self.object:get_pos()
		local tpos = target:get_pos()
		tpos.y = tpos.y + (
			target:get_luaentity() and 0
			or 1.0
		)
		local hvel = vector.multiply(vector.direction(pos, tpos),8)
		local o = core.add_entity(pos, name.."_ball", core.serialize {
			_velocity = hvel,
			_level = level,
		})
		o:get_luaentity():set_shooter(self.object)
		
		ul_basic.objsound(self.object, "ul_magic_attack")
	else
		ul_basic.objsound(self.object, "ul_fail")
	end
end