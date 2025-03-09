local active_block_range = core.get_mapgen_setting('active_block_range') or 3
local modifier = {}


function ul_mobs.on_death(ent)
	return ent
end
function ul_mobs.register_on_death(func)
	local prev = ul_mobs.on_death
	ul_mobs.on_death = function(ent) return func(prev(ent)) or ent end
end

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
	local light = core.get_node_light(pos, 0)
	modifier[entname] = modifier[entname] or 0
	if light and light <= 5 then
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

function ul_mobs.can_see(self, tpos, obj)

	local txt = ""

	txt = txt .. "---can_see\n"

	if not self or not tpos or not mobkit.is_alive(self) then
		return false
	end
	
	local pos = self.object:get_pos()
	
	-- txt = txt .. "---1\n"

	if not core.line_of_sight(pos, tpos) then
		-- txt = txt .. ">false"
		-- self.object:set_nametag_attributes{text=txt}
		return false
	end
	
	local view_range = self.view_range or 16
	local dist = vector.distance(pos, tpos)
	local dist_frac = (dist / view_range)

	-- txt = txt .. string.format("view_range: %i\n", view_range)
	-- txt = txt .. string.format("dist: %i\n", dist)
	-- txt = txt .. string.format("dist_frac: %i%%\n", dist_frac * 100)

	-- txt = txt .. "---2\n"
	
	if dist > view_range then
		-- txt = txt .. ">false"
		-- self.object:set_nametag_attributes{text=txt}
		return false
	end

	local night_vision = 15 - (self.vision or 0)
	local light_level = core.get_node_light(tpos, 0)
	local stealth = 0
	
	if obj and obj:is_valid() then
		stealth = ul_magic.get_purpose_level(obj, "stealth")
	end

	-- txt = txt .. string.format("night_vision: %i\n", night_vision)
	-- txt = txt .. string.format("light_level: %i\n", light_level)
	-- txt = txt .. string.format("stealth: %i\n", stealth)

	-- txt = txt .. "---3\n"

	if light_level < night_vision then
		local ret = light_level * dist_frac + math.random() * stealth < night_vision
		-- txt = txt .. string.format(">%s\n", tostring(ret))
		-- self.object:set_nametag_attributes{text=txt}
		return ret
	end

	-- txt = txt .. "---4\n"
	local ret = self.vision / light_level > math.random() * stealth * dist_frac
	-- txt = txt .. string.format(">%s\n", tostring(ret))
	-- self.object:set_nametag_attributes{text=txt}
	return ret
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
			local can_see = ul_mobs.can_see(self, obj:get_pos(), obj)
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
			mobkit_plus.hq_runfrom(self, prty, ent)
		end
	end
	if self.on_check_prey then
		local ent = ul_mobs.get_nearest_entity(self, self.on_check_prey)
		if ent then
			ul_mobs.fight_or_flight(self, ent,
				self.comfortable_hp and self.hp < self.comfortable_hp, prty, prty)
		end
	end
end

function ul_mobs.fight_or_flight(self, ent, uncomfortable, hunt_prty, flee_prty)
	if not ent
	then return end
	if self.on_check_pred then
		local is_pred = self.on_check_pred(self, ent)
		if is_pred then
			mobkit.make_sound(self, "flee")
			mobkit_plus.hq_runfrom(self, flee_prty or 10, ent)
		end
	end
	local is_prey = self.on_check_prey(self, ent)
	if ent and uncomfortable then
		mobkit.make_sound(self, "flee")
		mobkit_plus.hq_runfrom(self, flee_prty or 10, ent)
	else
		mobkit.make_sound(self, "hunt")
		mobkit_plus.hq_hunt(self, hunt_prty or 10, ent)
	end
end

-- brain
function ul_mobs.brain(self)
	if self._hp
	then self.hp = self._hp
		self._hp = nil
	end

	if mobkit.timer(self,1) then mobkit_plus.node_dps_dmg(self) end
	mobkit_plus.vitals(self)

	if self.hp <= 0 then	-- if is dead
		if self._dead then
			return
		end
		self._dead = true

		ul_mobs.on_death(self)
		
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
			ul_basic.drop(pos, 0.1, self.name, 1)
		end
		if self.on_die then
			self.on_die(self, pos)
		end
		
		ul_mobs.incmod(self.name)

		mobkit.clear_queue_high(self)	-- cease all activity
		core.after(1.0, self.object.remove, self.object)
		return
	end

	if mobkit.timer(self, 5)
	and self.hp < self.max_hp
	and mobkit.get_queue_priority(self) < 10
	then
		self.hp = math.min(self.max_hp, self.hp + 1)
		ul_basic.objsound(self.object, "ul_heal")
	end

	-- decision making doesn't need to happen too often
	if mobkit.timer(self, ul_mobs.reaction_time) then
		local prty = mobkit.get_queue_priority(self)
		local owner = self._owner and core.get_player_by_name(self._owner)
		local sitting = mobkit.recall(self, "sitting")
		if not self._owner then
			local closest = math.huge
			for _,plyr in ipairs(core.get_connected_players()) do
				local dist = vector.distance(plyr:get_pos(), self.object:get_pos()) 
				closest = closest > dist and dist or closest
			end
			if closest > 512 and mobkit.timer(self, 30) then
				self.hp = 0
				return
			end
		end
		
		if true then
			local text = ""
			if sitting then
				text = text .. "(sitting)\n"
			end
			text = text .. tostring(self.hp).." / "..tostring(self.max_hp)
			self.object:set_nametag_attributes{
				text = text
			}
		end
		
		if self.comfortable_hp and prty < 20
		and self.hp < self.comfortable_hp
		then
			ul_mobs.midfunc(self, 20)
		end

		if prty < 10 then
			if not sitting
			and owner
			and vector.distance(owner:get_pos(), self.object:get_pos()) > self.view_range
			then
				local pos = owner:get_pos()
				pos.x = pos.x + math.random(-1,1)
				pos.y = pos.y + 1
				pos.z = pos.z + math.random(-1,1)
				self.object:set_pos(pos)
				mobkit.clear_queue_high(self)
			else ul_mobs.midfunc(self, 10)
			end
		end

		if prty < 1 and not sitting and owner then
			mobkit_plus.hq_follow(self, 1, owner)
		end

		-- if doing nothing
		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
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

core.register_globalstep(ul_mobs.mod_step)