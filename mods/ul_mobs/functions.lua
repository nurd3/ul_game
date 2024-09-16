local active_block_range = minetest.get_mapgen_setting('active_block_range') or 3
local modifier = {}

function ul_mobs.incmod(entname)
	modifier[entname] = (modifier[entname] or 0) + 1
end

function ul_mobs.decmod(entname, val)
	modifier[entname] = (modifier[entname] or 0) - 1
end

function ul_mobs.set_mod(entname, val)
	population[entname] = val
end

function ul_mobs.check(pos, entname)
	local light = minetest.get_node_light(pos, 0)
	modifier[entname] = modifier[entname] or 0
	if light and light < 7 then
		return modifier[entname] - math.random(1, 20) < 0
	end
end

function ul_mobs.quick_battle(dist, hp1, sp1, ml1, rg1, hp2, sp2, ml2, rg2)
	local midpoint = sp1 / (sp1 + sp2) 
	if rg1 then
		
	end
end

function ul_mobs.death_drops(...)
	local drops = {...}
	local func = function (self, pos)
		for _,v in ipairs(drops) do
			mobkit_plus.drop(pos, table.unpack(v))
		end
	end
	return func
end

function ul_mobs.gen_spawn()
	local temp = {}
	for name,chance in pairs(monsters) do
		if math.random() < chance then
			table.insert(temp, name)
		end
	end
	if #temp > 0 then
		return temp[math.random(#temp)]
	end
end

function ul_mobs.can_see(self, tpos)

	if not self or not tpos or not mobkit.is_alive(self) then
		return false
	end

	local pos = self.object:get_pos()
	
	if not minetest.line_of_sight(pos, tpos) then
		return false
	end
	
	local view_range = self.view_range or 16
	local dist = vector.distance(pos, tpos)
	
	if dist > view_range then
		return false
	end
	
	local night_vision = self.vision or 0
	local light_level = minetest.get_node_light(tpos)
	
	if light_level < night_vision then
		local dist_frac = (dist / view_range)
		return light_level * dist_frac < night_vision * 0.5
	end
	
	return true
end

function ul_mobs.get_nearest_entity(self, checkfunc)
	local retv = nil					    -- return value
	local dist = active_block_range * 64	-- maximum distance
	local pos = mobkit.get_stand_pos(self)	-- position
	local check = checkfunc or function () return true end

	-- search in nearby objects
	for _,obj in ipairs(self.nearby_objects) do
		local ent = obj:get_luaentity()
		if obj:get_pos() then
			local can_see = ul_mobs.can_see(self, obj:get_pos())
			if can_see and check(self, obj) and not (ent and ent.disable_hunting) then
				local opos = obj:get_pos()
				local odist = math.abs(opos.x-pos.x) + math.abs(opos.z-pos.z)
				if odist < dist then
					dist = odist
					retv = obj
				end
			end
		end
	end
	
	return retv
end

function ul_mobs.midfunc(self, prty)
	if self.on_check_pred then
		local ent = ul_mobs.get_nearest_entity(self, self.on_check_pred)
		if ent then
			mobkit.make_sound(self, "flee")
			mobkit.hq_runfrom(self, 25, ent)
		end
	end
	if self.on_check_prey then
		local ent = ul_mobs.get_nearest_entity(self, self.on_check_prey)
		if ent then
			mobkit.make_sound(self, "hunt")
			mobkit_plus.hq_hunt(self, 25, ent)
		end
	end
end

-- brain
function ul_mobs.brain(self)

	if mobkit.timer(self,1) then mobkit_plus.node_dps_dmg(self) end
	mobkit_plus.vitals(self)

	if self.hp <= 0 then	-- if is dead
		if self._dead then
			return
		end
		self._dead = true
		
		local pos = self.object:get_pos()
		mobkit.make_sound(self, "die")
		
		self.object:set_properties({
			visual = "upright_sprite",
			textures = {"ul_mobs_dead.png"},
			collide_with_objects = false, 
			collisionbox = {0,0,0,0,0,0},
		})
		if self._owner then
			self.object:set_nametag_attributes{
				text = "x_x"
			}
		end
		
		if not self.disable_taming then
			ul_basic.drop(pos, 0.5, self.name, 1)
		end
		if self.on_die then
			self.on_die(self, pos)
		end
		
		ul_mobs.incmod(self.name)

		mobkit.clear_queue_high(self)	-- cease all activity
		core.after(1.0, self.object.remove, self.object)
		return
	end

	-- decision making doesn't need to happen too often
	if mobkit.timer(self, ul_mobs.reaction_time) then
		local prty = mobkit.get_queue_priority(self)
		local owner = self._owner and minetest.get_player_by_name(self._owner)
		local sitting = mobkit.recall(self, "sitting")
		
		if owner then
			local text = ""
			if sitting then
				text = text .. "(sitting)\n"
			end
			text = text .. tostring(self.hp).." / "..tostring(self.max_hp)
			self.object:set_nametag_attributes{
				text = text
			}
		end
		
		if prty < 25 and sitting then
			mobkit.clear_queue_high(self)
			return
		end
		if prty < 20 and owner and vector.distance(owner:get_pos(), self.object:get_pos()) > self.view_range then
			local pos = owner:get_pos()
			pos.x = pos.x + math.random(-1,1)
			pos.y = pos.y + 1
			pos.z = pos.z + math.random(-1,1)
			self.object:set_pos(pos)
			mobkit.clear_queue_high(self)
		end

		if prty < 10 then
			ul_mobs.midfunc(self, prty)
		end

		-- if doing nothing
		if mobkit.is_queue_empty_high(self) then
			if owner then
				mobkit_plus.hq_follow(self, 0, owner)
			else
				mobkit.hq_roam(self, 0)
			end
		end
	end
	
end

local timer = 0

function ul_mobs.mod_step(dtime)
	timer = timer + dtime
	
	if timer > 2 then
		timer = 0
		for nom,mod in pairs(modifier) do
			modifier[nom] = mod - mod / 20 * 5
		end
	end
end

minetest.register_globalstep(ul_mobs.mod_step)