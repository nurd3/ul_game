local S = ul_magic.get_translator

local index = 0

ul_magic.registered_runes = {}

function ul_magic.register_rune(name, def)
	index = index + 1
	def.index = index
	
	ul_magic.registered_runes[name] = def
	
	local imgmod = def.color and ("^[multiply:"..def.color) or ""
	
	minetest.register_craftitem(name, {
		description = S("Rune of @1", def.description or name),
		inventory_image = "ul_magic_rune.png"..imgmod,
	})
	
	minetest.register_node(name.."_runestone", {
		description = S("@1 Runestone", def.description or name),
		sounds = ul_basic.node_sound_defaults(),
		drawtype = "normal",
		tiles = {"ul_basic_stone.png^[hsl:0:-100:0^(ul_magic_shard.png"..imgmod..")"},
		sunlight_propagates = true,
		is_ground_content = true,
		paramtype = "none",
		paramtype2 = "none",
		diggable = false,
		on_rightclick = function (pos, node, puncher)
			minetest.set_node(pos, {name="ul_magic:runestone_active"})
			local timer = minetest.get_node_timer(pos)
			timer:set(1, 0)
			minetest.add_item(pos, ItemStack(name))
			ul_basic.possound(pos, "ul_take")
		end,
		light_source = 14
	})
	
	minetest.register_entity(name.."_ball", {
		visual = "sprite",
		textures = {"ul_magic_ball.png"..imgmod.."^[brighten"},
		visual_size = {x=1.0,y=1.0},
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		physical = true,
		glow = 14,
		_ignore_balls = true,
		on_activate = function(self, staticdata)
			local sdat = minetest.deserialize(staticdata)
			
			if sdat then
				
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
			
			for _,col in ipairs(moveresult.collisions) do
			
				local ignore = false
				local result
				
				if col.type == "node" then
					ignore = minetest.registered_nodes[col.node_pos]
						and not minetest.registered_nodes[col.node_pos].walkable
					result = not ignore
						and def.on_hitnode
						and def.on_hitnode(self._shooter, col.node_pos, self._level)
				elseif col.type == "object" and col.object:is_valid() then
					if self._attack then
						ul_basic.punch(col.object, self._shooter, nil, {is_magic = true})
					end
					ignore = col.object:get_luaentity()
						and col.object:get_luaentity()._ignore_balls
					result = not ignore
						and def.on_hitobj
						and def.on_hitobj(self._shooter, col.object, self._level)
				end
				
				if not ignore then
					
					disappear = def.on_hit
						and def.on_hit(self._shooter, col.type, self._level, result, col.node_pos or col.object)
					disappear = disappear == nil or disappear
					
				end
			end
			if disappear or self._timer > 30 then
				core.after(0.05, self.object.remove, self.object)
			end
		end,
		get_staticdata = function(self)
			return "return nil"
		end
	})
	
	minetest.register_tool(name.."_spell", {
		description = S("@1 Spell", def.description or name),
		inventory_image = "ul_magic_spell.png"..imgmod,
		on_use = function(itemstack, user, pointed_thing)
			if not def.disable_primary
			then
				local hvel = vector.multiply(vector.normalize(user:get_rotation() or user:get_look_dir()),8)
				local pos = user:get_pos()
				pos.y = pos.y + 1.5
				local o = minetest.add_entity(pos, name.."_ball", minetest.serialize {
					_velocity = hvel,
					_level = ul_magic.get_level(user, name)
				})
				o:get_luaentity():set_shooter(user)
				
				ul_magic.wear_level(user, name)
				itemstack:add_wear(65536 / 10)
				ul_basic.objsound(user, "ul_magic_attack")
			else
				ul_basic.objsound(user, "ul_fail")
			end
			return itemstack
		end,
		
		on_secondary_use = function(itemstack, user, pointed_thing)
			if def.on_cast
			and def.on_cast(user, pointed_thing.ref, ul_magic.get_level(user, name))
			then
				ul_magic.wear_level(user, name)
				itemstack:add_wear(65536 / 10)
				ul_basic.objsound(user, "ul_magic_cast")
			else
				ul_basic.objsound(user, "ul_fail")
			end
			return itemstack
		end,
		
		on_place = function(itemstack, user, pointed_thing)
			if def.on_cast
			and def.on_cast(user, pointed_thing.ref, ul_magic.get_level(user, name))
			then
				ul_magic.wear_level(user, name)
				itemstack:add_wear(65536 / 10)
				ul_basic.objsound(user, "ul_magic_cast")
			else
				ul_basic.objsound(user, "ul_fail")
			end
			return itemstack
		end,
		
		groups = {spell = 1}
	})
	
	if not def.disable_ring then
		ul_inv.register_wearable(name.."_ring", {
			description = S("@1 Ring", def.description or name),
			inventory_image = "ul_magic_ring.png^[fill:2x2:7,3:"..(def.color or "#ffffff"),
			
			groups = {ring = 1}
		})
		
		minetest.register_craft({
			output = name.."_ring",
			type = "shapeless",
			recipe = {"ul_magic:ring", name}
		})
	end
	
	minetest.register_craft({
		output = name.."_spell",
		type = "shapeless",
		recipe = {"ul_magic:spell", name}
	})
	
end