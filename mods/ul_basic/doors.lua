local S = ul_basic.get_translator

ul_basic.doors = {}

function ul_basic.doors.register(name, def)
	
	minetest.register_entity(name, {
		
		sounds = def.sounds,
		visual = "upright_sprite",
		visual_size = {x = 2.0, y = 2.0},
		_textures = def.textures,
		
		collisionbox = {-0.5, -1.0, -0.5, 0.5, 1.0, 0.5},
		collide_with_objects = true,
		physical = true,
		on_activate = function(self, staticdata)
			local sdat = minetest.deserialize(staticdata)
			
			self._door_opened = false
			self._facing = 0
			
			if sdat then
			
				self._door_opened = sdat._door_opened or self._door_opened
				self._facing = sdat._facing or self._facing
				self._origin = sdat._origin
			
			end
			
			local ref = self.object
			
			if ref then
				
				local pos = vector.round(self._origin or ref:get_pos())
				self._origin = vector.copy(self._origin or ref:get_pos())
				pos.y = pos.y + 0.5
				
				ref:set_pos(
					pos
				)
				ul_basic.doors.update(self)
			
			end
		end,
		get_staticdata = function(self)
			return minetest.serialize {
				_door_opened = self._door_opened,
				_facing = self._facing,
				_origin = self._origin,
			}
		end,
		
		on_rightclick = function(self, clicker)
			self._door_opened = not self._door_opened
			ul_basic.doors.update(self)
			ul_basic.entsound(self, "interact")
		end,
		
		on_punch = function(self, puncher)
			local pos = self.object:get_pos()
			local stack = ItemStack(name)
			
			ul_basic.possound(pos, self.sounds and self.sounds.dug)
			
			self.object:remove()
			
			ul_basic.give_or_drop(puncher:get_inventory(), "main", pos, 2, stack)
		end
	})
	
	local inv_img = def.inventory_image or def.textures.closed[1]
	
	minetest.register_craftitem(name, {
		short_description = def.short_description or def.description or name,
		description = def.description,
		inventory_image = inv_img,
		wield_image = inv_img,
		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then return end
			
			local pos = vector.round(pointed_thing.above)
			
			if minetest.get_node(pos).name ~= "air" 
			or minetest.get_node(pos + vector.new(0,1,0)).name ~= "air"
			then
				return
			end
			
			ul_basic.doors.place(pos, name, placer:get_look_dir(), false)
			
			itemstack:set_count(itemstack:get_count() - 1)
			
			return itemstack
		end
	})
end

function ul_basic.doors.update(self)
	local ref = self.object
	
	if not ref or not ref:is_valid() then return false end
	
	local textures = self._textures and (self._door_opened and self._textures.opened or self._textures.closed)
	
	ref:set_rotation(
		vector.dir_to_rotation(
			vector.new(
				self._facing,
				0,
				0
			) * 90
		)
	)
	
	ref:set_properties {
		textures = textures,
		collide_with_objects = not self._door_opened
	}

	return true
end

function ul_basic.doors.place(pos, door, dir, opened)
	local facing = 0

	if dir then
		local dir = vector.round(vector.rotate(vector.new(0, 0, 1), dir))
		if math.abs(dir.y) >= 0.5 then
			facing = 1
		end
	end
	
	return minetest.add_entity(
		vector.round(pos),
		door,
		minetest.serialize {_door_opened = opened or false, _facing = facing}
	)
end

ul_basic.doors.register("ul_basic:door", {
	description = S"Door",
	sounds = ul_basic.interactable_sound_defaults(),
	textures = {
		closed = {"ul_basic_door.png", "ul_basic_door.png^[transformFX"},
		opened = {"ul_basic_door_open.png", "ul_basic_door_open.png^[transformFX"},
	}
})