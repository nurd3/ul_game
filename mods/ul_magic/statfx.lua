local function hp(obj, add)
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

ul_statfx.register("ul_magic:poison", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2) and hp(obj, -1) then
			ul_basic.objsound(obj, "player_damage")
		end
	end
})

ul_statfx.register("ul_magic:burning", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 0.5) and hp(obj, -1) then
			ul_basic.objsound(obj, "player_damage")
		end
	end
})

ul_statfx.register("ul_magic:levitate", {
	on_step = function (timer, dtime, obj)
		if not obj then
			return 0
		end
		local vel = obj:get_velocity()
		obj:add_velocity({
			x = 0,
			y = (16 - vel.y) * dtime * 1.5,
			z = 0
		})
	end
})

ul_statfx.register("ul_magic:regen", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2) and hp(obj, 1) then
			ul_basic.objsound(obj, "ul_heal")
		end
	end
})
