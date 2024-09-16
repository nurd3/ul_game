mobkit_plus = {}

function mobkit_plus.pathfind(self, tpos, max_dist)
	max_dist = max_dist or 128
	
	local max_drop = max_dist
	
	if not self.disable_fall_damage then
		max_drop = 1 + (0.1 * self.hp)
	end
	
	
	local path = minetest.find_path(
		vector.round(mobkit.get_stand_pos(self)), 
		tpos, 
		max_dist,
		self.jump_height,
		max_drop,
		"A*_noprefetch"
	)
	
	return path
end

local function printpath(path)
	if not path then
		return minetest.chat_send_all"nil"
	end
	for i,v in ipairs(path) do
		minetest.chat_send_all(tostring(i).." "..vector.to_string(v))
	end
end

function mobkit_plus.lq_dumbwalk(self,dest,speed_factor)
	local timer = 3			-- failsafe
	speed_factor = speed_factor or 1
	local func=function(self)
		mobkit.animate(self,'walk')
		timer = timer - self.dtime
		if timer < 0 then return true end
		
		local pos = mobkit.get_stand_pos(self)
		local y = self.object:get_velocity().y

		if mobkit.isnear2d(pos,dest,0.25) then
			local new_pos = self.object:get_pos()
			new_pos.x, new_pos.z = math.round(dest.x), math.round(dest.z)
			self.object:set_pos(new_pos)
			if not self.isonground or math.abs(dest.y-pos.y) > 0.1 then		-- prevent uncontrolled fall when velocity too high
--			if abs(dest.y-pos.y) > 0.1 then	-- isonground too slow for speeds > 4
				self.object:set_velocity({x=0,y=y,z=0})
			end
			return true 
		end

		if self.isonground then
			local dir = vector.normalize(vector.direction({x=pos.x,y=0,z=pos.z},
														{x=dest.x,y=0,z=dest.z}))
			dir = vector.multiply(dir,self.max_speed*speed_factor)
			self.object:set_yaw(minetest.dir_to_yaw(dir))
			dir.y = y
			self.object:set_velocity(dir)
		end
	end
	mobkit.queue_low(self,func)
end

function mobkit_plus.lq_goto(self, tpos)

	local height = tpos.y - mobkit.get_stand_pos(self).y
	
	if height <= 0.5 then
		self.object:set_yaw(minetest.dir_to_yaw(vector.direction(self.object:get_pos(),tpos)))
		mobkit_plus.lq_dumbwalk(self,tpos)
	else
		self.object:set_yaw(minetest.dir_to_yaw(vector.direction(self.object:get_pos(),tpos)))
		mobkit.lq_dumbjump(self,height)
	end
	
	return true
end

function mobkit_plus.hq_follow(self,prty,tgtobj)

	local melee_range = self.melee and self.melee.range or 3
	
	local index = 2
	local path = mobkit_plus.pathfind(self, tgtobj:get_pos(), self.view_range)

	local func = function(self)
		if not mobkit.is_alive(tgtobj) then return true end
		if mobkit.is_queue_empty_low(self) then
			local pos = mobkit.get_stand_pos(self)
			local opos = tgtobj:get_pos()
			local dist = vector.distance(pos,opos)
			if path and index > #path then
				path = mobkit_plus.pathfind(self, tgtobj:get_pos(), self.view_range)
				index = 2
			end
			
			if path then
				if dist > melee_range and path[index] then
					mobkit_plus.lq_goto(self, path[index])
					index = index + 1
				end
			else return true end
		end
	end
	mobkit.queue_high(self,func,prty)
end

-- 
function mobkit_plus.hq_hunt(self,prty,tgtobj)
	
	local melee_range = self.melee and self.melee.range or 3
	local range = self.ranged and self.ranged.range or self.view_range
	local firerate = self.ranged and self.ranged.rate or 1
	
	local path = mobkit_plus.pathfind(self, tgtobj:get_pos(), self.view_range)
	local index = 2

	local func = function(self)
		if not mobkit.is_alive(tgtobj) then return true end
		if mobkit.is_queue_empty_low(self) then
			local pos = mobkit.get_stand_pos(self)
			local opos = tgtobj:get_pos()
			local dist = vector.distance(pos,opos)
			local can_see = ul_mobs.can_see(self, opos)
			if can_see then
				path = mobkit_plus.pathfind(self, opos, self.view_range)
				index = 2
			end
			
			if not can_see and (not path or index > #path) then
				return true
			end
			
			if path then
				if self.ranged then
					if dist > self.ranged.range and path[index] then
						mobkit_plus.lq_goto(self, path[index])
						index = index + 1
					elseif mobkit.timer(self, firerate) then
						self.ranged.func(self, tgtobj, table.unpack(self.ranged.args))
					end
				end
				if self.melee then
					if dist > melee_range and not self.ranged and path[index] then
						mobkit_plus.lq_goto(self, path[index])
						index = index + 1
					else
						mobkit.hq_attack(self,prty+1,tgtobj)
					end
				end
			else return true end
		end
	end
	mobkit.queue_high(self,func,prty)
end

-- util drop function
function mobkit_plus.drop(pos, chance, item, amount)

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

function mobkit_plus.hurt_animation(self)
	mobkit.make_sound(self, "hurt")
	-- stolen from mobs redo
	core.after(0.1, function()
		self.object:set_texture_mod("^[invert:rgb")

		core.after(0.3, function()
			self.object:set_texture_mod("")
		end)
	end)
end

function mobkit_plus.calculate_dmg(dtime, tool_capabilities)
	if not tool_capabilities or not tool_capabilities.damage_groups.fleshy then return 1 end
	if not tool_capabilities.full_punch_interval then return tool_capabilities.damage_groups.fleshy end
	local mult = math.min(1, dtime / (tool_capabilities.full_punch_interval))
	
	return math.floor(tool_capabilities.damage_groups.fleshy * mult + 0.25)
end

function mobkit_plus.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)

	local dmg = mobkit_plus.calculate_dmg(time_from_last_punch, tool_capabilities)

	local is_alive = mobkit.is_alive(self)
	if dmg == 0 then
		ul_basic.objsound(self.object, "ul_miss")
		return
	end
	mobkit.hurt(self, dmg)
	mobkit_plus.hurt_animation(self)
	if not self.disable_knockback and dir then
		local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
		self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
	end
	
	local weapon = puncher and puncher:get_wielded_item()
	
	if weapon and is_alive then
	
		-- add weapon wear
		local punch_interval = tool_capabilities.full_punch_interval or 1.4
		
		local punch_attack_uses = tool_capabilities.punch_attack_uses or 20
		
		local wear = 0

		-- check for punch_attack_uses being 0 to negate wear
		if punch_attack_uses and punch_attack_uses ~= 0 then
			wear = 65536 / punch_attack_uses
		end
		
		weapon:add_wear(wear)

		puncher:set_wielded_item(weapon)
	
	end
	
end

-- handle nodes that cause damage
function mobkit_plus.node_dps_dmg(self)
	local pos = self.object:get_pos()
	local box = self.object:get_properties().collisionbox
	local pos1 = {x = pos.x + box[1], y = pos.y + box[2], z = pos.z + box[3]}
	local pos2 = {x = pos.x + box[4], y = pos.y + box[5], z = pos.z + box[6]}
	local nodes_overlap = mobkit.get_nodes_in_area(pos1, pos2)
	local total_damage = 0

	for node_def, _ in pairs(nodes_overlap) do
		local dps = node_def.damage_per_second
		if dps then
			total_damage = math.max(total_damage, dps)
		end
	end

	if total_damage ~= 0 then
		mobkit.make_sound(self, "hurt")
		mobkit.hurt(self, total_damage)
	end
end

-- get a random destination within a cube range of max_offset
function mobkit_plus.random_destination(self, max_offset)
	local ret = vector.copy(mobkit.get_stand_pos(self))
	vector.offset(ret,
		math.random(-max_offset,max_offset),
		math.random(-max_offset,max_offset),
		math.random(-max_offset,max_offset)
	)
	return ret
end

function mobkit_plus.vitals(self)
	-- vitals: fall damage
	if not self.disable_fall_damage then
		local vel = self.object:get_velocity()
		local velocity_delta = math.abs(self.lastvelocity.y - vel.y)
		if velocity_delta > mobkit.safe_velocity then
			self.hp = self.hp - math.floor(self.max_hp * math.min(1, velocity_delta/mobkit.terminal_velocity))
			mobkit_plus.hurt_animation(self)
		end
	end
	
	-- vitals: oxygen
	if self.lung_capacity then
		local colbox = self.object:get_properties().collisionbox
		local headnode = mobkit.nodeatpos(mobkit.pos_shift(self.object:get_pos(),{y=colbox[5]})) -- node at hitbox top
		if headnode and headnode.drawtype == 'liquid' then 
			self.oxygen = self.oxygen - self.dtime
		else
			self.oxygen = self.lung_capacity
		end
			
		if self.oxygen <= 0 then self.hp=0 end	-- drown
	end
end