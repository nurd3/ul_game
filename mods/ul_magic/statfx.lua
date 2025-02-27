ul_statfx.register("ul_magic:poison", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2)
		then
			ul_basic.punch(obj, nil, 2, 1, {x=0,y=1,z=0})
		end
	end
})

ul_statfx.register("ul_magic:burning", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 0.5)
		then
			ul_basic.punch(obj, nil, 0.5, 1, {x=0,y=1,z=0})
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
			y = (8 - vel.y) * dtime * 1.5,
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

ul_statfx.register("ul_magic:darkness", {
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 1) and ul_basic.set_hp(obj, -1) then
			obj:set_properties{_ul_sealthiness = 15}
		end
	end
})