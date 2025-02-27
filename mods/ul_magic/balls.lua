local S = ul_magic.get_translator

core.register_entity("ul_magic:ball", {
	visual = "sprite",
	textures = {"ul_magic_ball.png"},
	visual_size = {x=1.0,y=1.0},
	collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
	physical = true,
	glow = 14,
	_ignore_balls = true,
	on_activate = function(self, staticdata)
		local sdat = core.deserialize(staticdata)
		
		if sdat then

			local def = sdat._rune and ul_magic.registered_runes[sdat._rune]

			if def then
				self._rune = sdat._rune
				self.object:set_texture_mod("^[multiply:"..def.color)
			end

			self.object:set_velocity(sdat._velocity)
			self._velocity = sdat._velocity
			self._shooter = sdat._shooter
			self._level = sdat._level
			self._timer = sdat._timer or 0
			self._ignore_balls = true
			self._attack = def.type == "attack"
			
		end
	end,
	set_shooter = function(self, shooter)
		self._shooter = shooter
	end,
	on_step = function(self, dtime, moveresult)
		if not self._timer then return self.object:remove() end
		self._timer = self._timer + dtime
		
		self.object:set_velocity(self._velocity)
		
		local disappear = false
		local def = self._rune and ul_magic.registered_runes[self._rune]
		
		for _,col in ipairs(moveresult.collisions) do
		
			local ignore = false
			local result
			
			if col.type == "node" then
				ignore = core.registered_nodes[col.node_pos]
					and not core.registered_nodes[col.node_pos].walkable
				result = not ignore
					and def
					and def.on_hitnode
					and def.on_hitnode(self._shooter, col.node_pos, self._level)
			elseif col.type == "object" then
				if self._shooter == col.object then
					ignore = true
				else
					if self._attack then
						ul_basic.punch(col.object, self._shooter, nil, {is_magic = true})
					end
					ignore = col.object:get_luaentity()
						and col.object:get_luaentity()._ignore_balls
					result = not ignore
						and def
						and def.on_hitobj
						and def.on_hitobj(self._shooter, col.object, self._level)
				end
			end
			
			if not ignore then
				
				disappear = def.on_hit
					and def.on_hit(self._shooter, col.type, self._level, result, col.node_pos or col.object)
				disappear = disappear == nil or disappear
				
			end
		end
		if disappear or self._timer > 30 then
			core.after(dtime, self.object.remove, self.object)
		end
	end,
	get_staticdata = function(self)
		return "return nil"
	end
})