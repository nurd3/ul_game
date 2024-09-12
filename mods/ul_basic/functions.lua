
-- util drop function
function ul_basic.drop(pos, chance, item, amount)

	-- amount handling
	local amt = amount or 1

	-- range handling
	if amount and type(amount) == "table" then
		local a, b = amount[1] or amount.x or 1, amount[2] or amount.y or nil

		-- correct odd ranges
		if not a then
			a = 1
		end
		if not b then
			b = default_stack_max
		end
		if a > b then
			local c = a
			a = b
			b = c
		end

		if a == b then
			amt = a
			minetest.log("warning", "mobkit_plus.drop: 0 distance range")
		elseif 											-- catch erroneous ranges
			a <= 0 or b <= 0 or							-- must be over 0
			a ~= math.floor(a) or b ~= math.floor(b)	-- must be integers
		then
			amt = 1
			minetest.log("error", "mobkit_plus.drop: range must be integers over 0")
		else
			amt = math.random(a, b)
		end
	end

	-- catch erroneous inputs
	if amt <= 0 or amt ~= math.floor(amt) then
		amt = 1
		minetest.log("warning", "mobkit_plus.drop: amount must be an integer over 0")
	end

	-- positioning
	local pos = vector.copy(pos)
	pos.y = pos.y + 2

	if math.random() < chance then
		-- drop the item
		minetest.add_item(
			pos, 
			ItemStack(item.." "..tostring(amt))
		)
	end
	
end

-- util on_melee function, generates an on_use function
function ul_basic.on_melee(stats)
	local dmg = stats.dmg or 0
	local enc_ovr = stats.enchanting_override or false
	local func = stats.func or function() return end
	
	return function(itemstack, user, pointed_thing, level)
		if pointed_thing.type == "node" then
		
			local ref = minetest.get_node(pointed_thing.under)
			local def = minetest.registered_nodes[ref.name]
			
			if def then
				def.on_punch(pointed_thing.under, ref, user)
			end
		
		elseif pointed_thing.type == "object" then
		
			local obj = pointed_thing.ref
			local meta = itemstack:get_meta()
			local luaent = obj:get_luaentity()
			
			if luaent and luaent.on_punch then
				luaent:on_punch(user, 0, {damage_groups = {fleshy = dmg, punch_attack_uses = stats.uses}}, user:get_look_dir())
			end
			
			if obj:is_valid() and meta and meta:contains("_enchantment") then
				local enc = meta:get("_enchantment")
				local lvl = user and ul_magic.get_level(user, enc) or level or 1
				local rune = ul_magic.registered_runes[enc]
				
				if rune and rune.on_melee then
					rune.on_melee(user, obj, lvl, stats)
					ul_magic.wear_level(user, enc)
					if enc_ovr then
					end
				end
			end
		end
	end
	
end

function ul_basic.node_sound_defaults(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "ul_basic_footstep", gain = 0.1, pitch = 0.375}
	tbl.dig = tbl.dig or
			{name = "ul_basic_dig", gain = 0.4}
	tbl.dug = tbl.dug or
			{name = "ul_basic_dug", gain = 0.25}
	tbl.place = tbl.place or
			{name = "ul_basic_place", gain = 1.0}
	return tbl
end

function ul_basic.objsound(obj, name)
	minetest.sound_play(name, {object=obj, gain = 1.0})
end


function ul_basic.possound(pos, name)
	minetest.sound_play(name, {pos=pos, gain = 1.0})
end

function ul_basic.is_alive(thing)		-- thing can be luaentity or objectref.
--	if not thing then return false end
	if not mobkit.exists(thing) then return false end
	if type(thing) == 'table' then return (thing.hp or thing.health) > 0 end
	if thing:is_player() then return thing:get_hp() > 0
	else 
		local lua = thing:get_luaentity()
		local hp = lua and (lua.hp or lua.health) or nil
		return hp and hp > 0
	end
end

function ul_basic.set_hp(obj, add)
	local luaent = obj:get_luaentity()
	
	local hp = (luaent and (luaent.hp or luaent.health)) or obj:get_hp()
	local hp_max = obj:get_properties().hp_max or 0
	
	new_hp = math.min(hp_max, 
		math.max(hp + add, 0)
	)
	
	if luaent then
		if luaent.health then
			luaent.health = new_hp
		else
			luaent.hp = new_hp
		end
	else
		obj:set_hp(new_hp)
	end
	
	return hp ~= new_hp
end