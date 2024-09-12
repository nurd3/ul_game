ul_statfx.register("ul_magic:poison", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2) and ul_basic.set_hp(obj, -1) then
			ul_basic.objsound(obj, "player_damage")
		end
	end
})

ul_statfx.register("ul_magic:burning", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 0.5) and ul_basic.set_hp(obj, -1) then
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
		
		if ul_statfx.timer(timer, dtime, 2) and ul_basic.set_hp(obj, 1) then
			ul_basic.objsound(obj, "ul_heal")
		end
	end
})
