local last_break = {}

function ul_basic.node_breakable(drops)
	local stack = ItemStack(drops)
	return function(pos, node, puncher)
		if not puncher then
			return
		end
		
		local plyr = puncher:get_player_name()
		
		if plyr then
			last_break[plyr] = last_break[plyr] or -1
			local delta = minetest.get_server_uptime() - last_break[plyr]
			if delta <= 0.1 then
				return
			end
			last_break[plyr] = minetest.get_server_uptime()
		end
		
		local inv = puncher:get_inventory()
		
		ul_basic.give_or_drop(inv, "main", pos, 2, stack)
		
		ul_basic.nodesound(pos, "dug")

		minetest.swap_node(pos, {name="air"})
	end
end

--------------------
-- ITEM/INVENTORY --
--------------------

local function handle_amount(amount)
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
			minetest.log("warning", "ul_basic.handle_amount: 0 distance range")
		elseif 											-- catch erroneous ranges
			a <= 0 or b <= 0 or							-- must be over 0
			a ~= math.floor(a) or b ~= math.floor(b)	-- must be integers
		then
			amt = 1
			minetest.log("error", "ul_basic.handle_amount: range must be integers over 0")
		else
			amt = math.random(a, b)
		end
	end

	-- catch erroneous inputs
	if amt <= 0 or amt ~= math.floor(amt) then
		amt = 1
		minetest.log("warning", "ul_basic.handle_amount: amount must be an integer over 0")
	end
	
	return amt
end

function ul_basic.give_or_drop(inv, listname, pos, chance, stack, amount)

	local lst = listname or "main"
	if amount then
		stack:set_amount(
			handle_amount(amount)
		)
	end

	-- positioning
	local pos = vector.copy(pos)
	pos.y = pos.y + 1

	if math.random() < chance then
		if inv and inv:room_for_item(lst, stack) then
			inv:add_item(lst, stack)
		else
			minetest.add_item(
				pos, stack
			)
		end
	end
	
end

-- util drop function
function ul_basic.drop(pos, chance, item, amount)

	local amt = handle_amount(amount)

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

------------
-- COMBAT --
------------

local last_punch = {}

function ul_basic.get_attackdtime(plyrname, fallback, update)
	if not plyrname then
		return fallback
	end
	local currtime = minetest.get_server_uptime()
	local ret = last_punch[plyrname] and currtime - last_punch[plyrname] or fallback
	if update then
		last_punch[plyrname] = currtime
	end
	return ret
end

-- util on_melee function
function ul_basic.on_melee(itemstack, user, pointed_thing, level)
	local tool_capabilities = itemstack:get_tool_capabilities()
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
		
		local delta = ul_basic.get_attackdtime(user:get_player_name(), tool_capabilities.full_punch_interval, true)
		
		ul_basic.punch(obj, user, delta, tool_capabilities, user:get_look_dir())
		
		if obj:is_valid() and meta and meta:contains("_enchantment") then
			local enc = meta:get("_enchantment")
			local lvl = user and ul_magic.get_level(user, enc) or level or 1
			local rune = ul_magic.registered_runes[enc]
			
			if rune and rune.on_melee then
				rune.on_melee(user, obj, lvl)
				ul_magic.wear_level(user, enc)
				if enc_ovr then
				end
			end
		end
	end
end

------------
-- SOUNDS --
------------

function ul_basic.possound(pos, name)
	minetest.sound_play(name, {pos=pos, gain = 1.0})
end

function ul_basic.objsound(obj, name)
	minetest.sound_play(name, {object=obj, gain = 1.0})
end

function ul_basic.nodesound(pos, name)
	local def = minetest.registered_nodes[
		minetest.get_node(pos).name
	]
	local spec = def
		and def.sounds
		and def.sounds[name]
	ul_basic.possound(pos, spec)
end

function ul_basic.entsound(ent, name)
	if type(ent) == "userdata" then 
		return ul_basic.entsound(ent:get_luaentity(), name)
	end
	local spec = ent
		and ent.sounds
		and ent.sounds[name]
	ul_basic.objsound(ent.object, spec)
end

-- SOUND TEMPLATES --

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

function ul_basic.interactable_sound_defaults(tbl)
	tbl = tbl or {}
	tbl.dig = tbl.dig or
			{name = "ul_basic_dig", gain = 0.4}
	tbl.dug = tbl.dug or
			{name = "ul_basic_dug", gain = 0.25}
	tbl.place = tbl.place or
			{name = "ul_basic_place", gain = 1.0}
	tbl.interact = tbl.interact or
			{name = "ul_interact", gain = 0.2}
	tbl.fail = tbl.fail or
			{name = "ul_fail", gain = 0.4}
	return tbl
end

-------------------------
-- LUAENTITIES/PLAYERS --
-------------------------

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

-- punches something
function ul_basic.punch(obj, puncher, time_from_last_punch, tool_capabilities, dir)
	tool_capabilities = tool_capabilities or {damage_groups = {fleshy = 0}}
	dir = dir or vector.zero()
	if obj == nil then
		return
	elseif type(obj) == "table" then
		return ul_basic.punch(obj.object, puncher, time_from_last_punch, tool_capabilities, dir)
	elseif type(obj) == "userdata" then
		return obj:punch(puncher, time_from_last_punch, tool_capabilities, dir)
	end
end