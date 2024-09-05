-- from mobkit
local function exists(thing)
	if not thing then return false end
	if type(thing) == 'table' then thing=thing.object end
	if type(thing) == 'userdata' then 
		if thing:is_player() then
			if thing:get_look_horizontal() then return true end 
		else
			if thing:get_yaw() then return true end
		end
	end
end

ul_statfx = {}

ul_statfx.registered = {}

function ul_statfx.register(name, func)
	ul_statfx.registered[name] = func
	
	minetest.register_entity(name, {
		is_visible = false,
		on_activate = function (self, staticdata, dtime_s)
			local sdat = staticdata and minetest.deserialize(staticdata)
			
			if sdat and type(sdat._ul_statfx_timer) == "number" then
				self._ul_statfx_timer = sdat._ul_statfx_timer
			end
		end,
		on_step = function (self, dtime)
			if not self or not exists(self.object) then
				return
			end
			
			local def = ul_statfx.registered[self.name]
			
			if not def or type(self._ul_statfx_timer) ~= "number" or self._ul_statfx_timer <= 0 then
				self.object:remove()
				return
			end
			
			self._ul_statfx_timer = self._ul_statfx_timer - dtime
			if def.on_step then
				local timer = def.on_step(self._ul_statfx_timer, dtime, self.object:get_attach())
				self._ul_statfx_timer = type(timer) == "number" and timer or self._ul_statfx_timer
			end
		end,
		get_staticdata = function(self)
			return minetest.serialize({_ul_statfx_timer=self._ul_statfx_timer})
		end,
		_ul_statfx_timer = 0
	})
end

-- from mobkit
function ul_statfx.timer(timer, dtime,s) -- returns true approx every s seconds
	local t1 = math.floor(timer)
	local t2 = math.floor(timer + dtime)
	if t2>t1 and t2%s==0 then return true end
end

function ul_statfx.apply(obj, name, length)
	if type(name) ~= "string" then
		error("string expected, got type "..type(name).." instead.", 1)
	end
	
	local fx = ul_statfx.registered[name]
	local ent = minetest.registered_entities[name]
	
	if not fx then
		minetest.log("error", "undefined stat effect \""..name.."\"")
		return
	end
	if not ent then
		error("attempt to apply improperly defined stat effect \""..name.."\"", 1)
	end
	
	local o2 = minetest.add_entity({x=0,y=0,z=0}, name, minetest.serialize({_ul_statfx_timer = length}))
	
	if o2 then
		o2:set_attach(obj)
		return o2
	end
end