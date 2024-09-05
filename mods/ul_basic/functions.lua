
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