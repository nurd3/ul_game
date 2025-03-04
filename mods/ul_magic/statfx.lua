ul_statfx.register("ul_magic:poison", {
	on_activate = function(self)
		self.object:set_nametag_attributes {
			text = "poisoned!",
			bgcolor = "#00ff00",
			color = "#000000"
		}
	end,
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2)
		and ul_basic.set_hp(obj, -1)
		then
			ul_basic.punch(obj, obj, 2, {is_magic = true}, vector.new(0,1,0))
		end
	end
})

ul_statfx.register("ul_magic:burning", {
	on_activate = function(self)
		self.object:set_nametag_attributes {
			text = "burning!",
			bgcolor = "#ff7700",
			color = "#ffffff"
		}
	end,
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 0.5)
		and ul_basic.set_hp(obj, -1)
		then
			ul_basic.punch(obj, obj, 0.5, {is_magic = true}, vector.new(0,1,0))
		end
	end
})

ul_statfx.register("ul_magic:levitate", {
	on_activate = function(self)
		self.object:set_nametag_attributes {
			text = "levitating!",
			bgcolor = "#00ffff",
			color = "#000000"
		}
	end,
	on_step = function (timer, dtime, obj)
		if not obj then
			return 0
		end
		local vel = obj:get_velocity()
		obj:add_velocity {
			x = 0,
			y = (8 - vel.y) * dtime * 1.5,
			z = 0
		}
	end
})

ul_statfx.register("ul_magic:stun", {
	on_activate = function(self)
		self.object:set_nametag_attributes {
			text = "stunned!",
			bgcolor = "#ffff00",
			color = "#000000"
		}
	end,
	on_step = function (timer, dtime, obj)
		if not obj then
			return 0
		end
		local vel = obj:get_velocity()
		obj:add_velocity {
			x = -vel.x,
			y = 0,
			z = -vel.z
		}
	end
})

ul_statfx.register("ul_magic:regen", {
	on_activate = function(self)
		self.object:set_nametag_attributes {
			text = "regen!",
			bgcolor = "#ff00ff",
			color = "#ffffff"
		}
	end,
	on_step = function (timer, dtime, obj)
		if not ul_basic.is_alive(obj) then
			return 0
		end
		
		if ul_statfx.timer(timer, dtime, 2) and ul_basic.set_hp(obj, 1) then
			ul_basic.objsound(obj, "ul_heal")
		end
	end
})