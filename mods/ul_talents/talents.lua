local S = ul_talents.get_translator

local function check_groups(node_name, groups)
	if type(node_name) == "table"
	then return check_groups(node_name.name, groups) end
	if not node_name
	or not core.registered_nodes[node_name]
	or not core.registered_nodes[node_name].groups
	then return false end

	local node_groups = core.registered_nodes[node_name].groups
	for group, level in pairs(groups) do
		if not node_groups[group]
		or node_groups[group] ~= level
		then
			return false
		end
	end

	return true
end


local function round_distance(dist)
	if dist >= 30
	then return math.round(dist / 10) * 10
	elseif dist >= 10
	then return math.round(dist / 5) * 5
	else return math.round(dist)
	end
end

--------------
-- EXTERNAL --
--------------

-- cool_sneakers --
core.register_on_player_hpchange(function(plyr, hp_change, reason)
	if hp_change < 0
	and ul_talents.using_talent(plyr:get_player_name(), "ul_talents:cool_sneakers")
	then
		return math.ceil(hp_change * 1.25)
	end
	return hp_change
end, true)

ul_talents.register_talentphysics("ul_talents:cool_sneakers", {
	speed_walk = 1.5,
	jump = 1.5
})

-- oobleck_suit --
core.register_on_player_hpchange(function(plyr, hp_change, reason)
	local plyrname = plyr:get_player_name()
	if not reason
	or not reason.type
	or not ul_talents.using_talent(plyrname, "ul_talents:oobleck_suit")
	then return hp_change end
	if hp_change < 0
	and reason.type == "punch"
	then
		local speed_mult =
			plyr:get_physics_override().speed
			* plyr:get_physics_override().speed_walk
		return math.floor(hp_change * 
			(vector.length(plyr:get_velocity()) / (8 * speed_mult) + math.max(0, 5 - ul_basic.get_attackdtime(plyrname, 5)) / 5)
		)
	elseif hp_change < 0
	and reason.type == "fall"
	then return math.max(0, math.floor(hp_change * 0.2) - 5)
	end
	return hp_change
end, true)

-- heavy_mitts --
local heavy_mitts_old_on_punch = core.registered_entities["ul_magic:ball"].on_punch
core.registered_entities["ul_magic:ball"].on_punch = function (self, puncher, time_from_last_punch, tool_capabilities, direction)
	if puncher and puncher:is_player() then
		local plyrname = puncher:get_player_name()

		if ul_talents.using_talent(plyrname, "ul_talents:heavy_mitts") then
			self.object:remove()
		end
	end
	return heavy_mitts_old_on_punch and heavy_mitts_old_on_punch(self, puncher, time_from_last_punch, tool_capabilities, direction)
end

ul_talents.register_talentphysics("ul_talents:heavy_mitts", {
	speed_walk = 0.75,
	jump = 1.25,
	speed_crouch = 4
})

--------------
-- HABITUAL --
--------------

-- deflect --
local deflect_old_on_punch = core.registered_entities["ul_magic:ball"].on_punch
core.registered_entities["ul_magic:ball"].on_punch = function (self, puncher, time_from_last_punch, tool_capabilities, direction)
	if puncher and puncher:is_player() then
		local plyrname = puncher:get_player_name()

		if ul_talents.using_talent(plyrname, "ul_talents:deflect") then
			self._velocity = puncher:get_look_dir() * 10
			self:set_shooter(puncher)
		end
	end
	return deflect_old_on_punch and deflect_old_on_punch(self, puncher, time_from_last_punch, tool_capabilities, direction)
end

-- stun --
local stun_old_on_melee = ul_basic.on_melee

ul_basic.on_melee = function (stack, user, pointed_thing, level)
	if user
	and user:is_player()
	and ul_talents.using_talent(user:get_player_name(), "ul_talents:stun")
	then
		return stun_old_on_melee(stack, user, pointed_thing, level, {damage_groups = {fleshy = 1}})
	else return stun_old_on_melee(stack, user, pointed_thing, level)
	end
end

local function stun_step(plyr)
	if plyr:get_player_control().dig
	then local pos = vector.offset(plyr:get_pos(),0,1.625,0)
		local dir = plyr:get_look_dir()
		local ray = Raycast(pos, pos + (dir * 4.2), objects, liquids)
		local pointed_thing = ray() and ray()

		if not pointed_thing
		then return
		elseif pointed_thing.type == "object"
		and ul_basic.is_alive(pointed_thing.ref)
		then ul_statfx.apply(pointed_thing.ref, "ul_magic:stun", 1.0) end
	end
end

ul_talents.register_talentstep(0, "ul_talents:stun", stun_step)

-- block --
core.register_on_player_hpchange(function(plyr, hp_change, reason)
	if hp_change < 0
	and reason.type == "punch"
	and ul_talents.using_talent(plyr:get_player_name(), "ul_talents:block")
	and plyr:get_player_control().sneak
	and math.random() > 0.75
	then
		if reason.object then
			ul_basic.objsound(reason.object, "ul_miss")
		end
		return 0
	end
	return hp_change
end, true)

------------------
-- INSTRUMENTAL --
------------------

-- durability_magic --
local old_wear_spell = ul_magic.wear_spell

ul_magic.wear_spell = function (itemstack, plyr)
	itemstack = old_wear_spell(itemstack, plyr)

	if ul_talents.using_talent(plyr:get_player_name(), "ul_talents:durability_magic")
	then
		itemstack:set_wear(itemstack:get_wear() - 65536 / 20)
	end

	return itemstack
end

-- durability_lantern --

local function wear_lantern(stack)
	if stack:get_name() == "ul_basic:lantern" then
		stack:set_wear(stack:get_wear() - 65536 / 600)
	end
	return stack
end

local function durability_lantern_step(plyr)
	local inv = plyr:get_inventory()
	if inv
	then
		inv:set_stack("offhand", 1, 
			wear_lantern(inv:get_stack("offhand", 1))
		)
		plyr:set_wielded_item( 
			wear_lantern(plyr:get_wielded_item())
		)
	end
end

ul_talents.register_talentstep(1.0, "ul_talents:durability_lantern", durability_lantern_step)

-- durability_pick --
core.register_on_dignode(function(pos, oldnode, digger)
	if digger and digger:is_player() then
		local plyrname = digger:get_player_name()
		local stack = digger:get_wielded_item()
		local wear = stack:get_wear()

		if stack:get_name() == "ul_basic:pick"
		and ul_talents.using_talent(plyrname, "ul_talents:durability_pick")
		then
			stack:set_wear(wear - (65536 / 20))
		end
	end
end)

-- durability_weapons --
local durability_weapons_old_on_melee = ul_basic.on_melee
ul_basic.on_melee = function (stack, user, pointed_thing, level)
	local ret = durability_weapons_old_on_melee(stack, user, pointed_thing, level)

	if stack
	and user
	and user.get_wielded_item
	and user:is_player()
	and ul_talents.using_talent(user:get_player_name(), "ul_talents:durability_weapons")
	then
		local old_wear = stack:get_wear()
		local new_wear = user:get_wielded_item():get_wear()

		if old_wear ~= new_wear
		and user:get_wielded_item():get_name() == stack:get_name()
		then
			stack:set_wear(new_wear + (old_wear - new_wear) * 0.5)
			return stack
		end
	end

	return ret
end

----------------
-- PERCEPTUAL --
----------------

-- foveal_inspect --
core.register_entity("ul_talents:foveal_inspect_marker", {
	visual = "sprite",
	textures = {"blank.png"},
	pointable = false,
	physical = false,
	static_save = false,
	on_activate = function(self, staticdata)
		local sdat = staticdata and core.deserialize(staticdata)

		self._timer = 0
		self._maxtimer = 0.3
		self._text = "unknown"

		if sdat
		then
			self._maxtimer = sdat._maxtimer or self._maxtimer
			self._text = sdat._text or self._text
			self._player = sdat._player
		end

		if self._player
		then
			self.object:set_observers{[self._player] = true}
		end

		self.object:set_nametag_attributes {
			text = self._text
		}
	end,
	on_step = function(self, dtime)
		if not self or not mobkit.exists(self.object) then
			return
		end
		self._timer = self._timer + dtime

		if self._timer > self._maxtimer
		then
			self.object:remove()
		end
	end
})

local function foveal_inspect_step(plyr, plyrname)
	local pos = vector.offset(plyr:get_pos(),0,1.625,0)
	local dir = plyr:get_look_dir()
	local ray = Raycast(pos, pos + (dir * 128), objects, liquids)
	local pointed_thing = ray() and ray()

	if not pointed_thing
	then return
	elseif pointed_thing.type == "node"
	then
		local face = pointed_thing.above - pointed_thing.under
		local pos2 = vector.offset(pointed_thing.under,
			face.x * 0.5,
			face.y * 0.5 - 1,
			face.z * 0.5
		)
		core.add_entity(pos2, "ul_talents:foveal_inspect_marker", core.serialize{
			_player = plyrname,
			_text = string.format("node ~%im away\n%s",
				round_distance(vector.distance(pointed_thing.under, pos)),
				face.y > 0
				and "top"
				or face.y < 0
				and "bottom"
				or "side"
			)
		})
	elseif pointed_thing.type == "object"
	then
		local pos2 = vector.offset(pointed_thing.ref:get_pos(),
			0,
			-1,
			0
		)
		core.add_entity(pos2, "ul_talents:foveal_inspect_marker", core.serialize{
			_player = plyrname,
			_text = string.format("obj ~%im away",
				round_distance(vector.distance(pointed_thing.ref:get_pos(), pos))
			)
		})
	end
end

ul_talents.register_talentstep(0.25, "ul_talents:foveal_inspect", foveal_inspect_step)

-- lithosonic_ear --
local function lithosonic_ear_new(pos)
	local MAX_RADIUS = 16
	local offset = vector.new(-MAX_RADIUS,-MAX_RADIUS,-MAX_RADIUS)
	local temp = {} 
	while offset.y <= MAX_RADIUS
	do
		if check_groups(core.get_node(pos + offset), {lithosonic = 1})
		then table.insert(temp, {offset + pos, 
			math.abs(vector.distance(pos + offset, pos) - 4)
		}) end
		offset.x = offset.x + 1
		if offset.x > MAX_RADIUS
		then
			offset.x = -MAX_RADIUS
			offset.z = offset.z + 1
		end
		if offset.z > MAX_RADIUS
		then
			offset.z = -MAX_RADIUS
			offset.y = offset.y + 1
		end
	end

	table.sort(temp, function(a,b)
		return a[2] < b[2]
	end)
	if temp[1]
	then return temp[1][1]
	end
end

local lithosonic_ear_focuses = {}
local function lithosonic_ear_step(plyr, plyrname)
	local wielded_item = plyr:get_wielded_item()
	if wielded_item
	and wielded_item:get_name() == "ul_basic:pick"
	then
		if lithosonic_ear_focuses[plyrname]
		and vector.distance(lithosonic_ear_focuses[plyrname], plyr:get_pos()) < 20
		and check_groups(core.get_node(lithosonic_ear_focuses[plyrname]), {lithosonic = 1})
		then
			ul_basic.possound(lithosonic_ear_focuses[plyrname], "ul_talents_lithosonic", {to_player = plyrname})
		else lithosonic_ear_focuses[plyrname] = lithosonic_ear_new(vector.round(
				vector.offset(
					plyr:get_pos(),
					0, 1.5, 0
				)
			))
		end
	end
end

ul_talents.register_talentstep(1.0, "ul_talents:lithosonic_ear", lithosonic_ear_step)

-- predatory_vision --
core.register_entity("ul_talents:predatory_vision_marker", {
	visual = "sprite",
	textures = {"blank.png"},
	pointable = false,
	physical = false,
	static_save = false,
	on_activate = function(self, staticdata)
		local sdat = staticdata and core.deserialize(staticdata)

		self._timer = 0
		self._maxtimer = 1
		self._intensity = 1
		self._text = "UNKNOWN MOVEMENT"

		if sdat
		then
			self._maxtimer = sdat._maxtimer or self._maxtimer
			self._intensity = sdat._intensity or self._intensity
			self._text = sdat._text or self._text
			self._player = sdat._player
		end

		if self._player
		then
			self.object:set_observers{[self._player] = true}
		end



		self.object:set_nametag_attributes {
			text = self._text,
			color = {a=self._intensity * 255, r=255, g=255, b=255},
			bgcolor = {a=self._intensity * 255, r=self._intensity * 255}
		}
	end,
	on_step = function(self, dtime)
		if not self or not mobkit.exists(self.object) then
			return
		end
		self._timer = self._timer + dtime

		if self._timer > self._maxtimer
		then
			self.object:remove()
		end
	end
})

local function predatory_vision_step(plyr, plyrname)
	local temp = {}

	-- loop for getting moving objects
	for ref in core.objects_inside_radius(plyr:get_pos(), 100)
	do
		if ref
		and ref:get_velocity()
		and vector.length(ref:get_velocity()) > 1
		and vector.distance(plyr:get_pos(), ref:get_pos()) > 4
		then
			table.insert(temp, {
				vector.round(ref:get_pos()), 
					-- sorting value is based off of the speed of the movement
					-- randomized to avoid cluttering
				math.random() * vector.length(ref:get_velocity()),
				vector.length(ref:get_velocity())
			})
		end
	end

	-- sort by sorting value
	table.sort(temp, function(a,b)
		return a[2] > b[2]
	end)

	-- put markers on up to 8 moving objects
	for i,pos in ipairs(temp)
	do
		if i > 8 then return end
		local dist = vector.distance(pos[1], plyr:get_pos())
		pos[1].y = pos[1].y - 1
		core.add_entity(pos[1], "ul_talents:predatory_vision_marker", core.serialize{
			_player = plyrname,
			_intensity = pos[2] / 5,
			_text = string.format("~%im",
				round_distance(dist)
			)
		})
	end
end

ul_talents.register_talentstep(0.5, "ul_talents:predatory_vision", predatory_vision_step)

------------------
-- SUPPLEMENTAL --
------------------

xplib.register_on_update(function(plyrname, reason, xp, lvl, total)
	if reason.lvlchange > 0
	then
		-- more_lives --
		local lives = 
			(ul_talents.using_talent(plyrname, "ul_talents:more_lives_1") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_lives_2") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_lives_3") and 1 or 0)
		ul_lives.add_life(plyrname, lives * reason.lvlchange)

		-- more_money --
		local money = 
			(ul_talents.using_talent(plyrname, "ul_talents:more_money_1") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_money_2") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_money_3") and 1 or 0)
		local portfolio = ul_market.get_portfolio(plyrname)
		if portfolio
		then portfolio.wallet = (portfolio.wallet or 0) + money * 1000 * reason.lvlchange
			ul_market.save_portfolios()
		end

		-- more_piety --
		local piety = 
			(ul_talents.using_talent(plyrname, "ul_talents:more_piety_1") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_piety_2") and 1 or 0)
			+ (ul_talents.using_talent(plyrname, "ul_talents:more_piety_3") and 1 or 0)
		ul_shrines.add_piety_level(plyrname, piety * reason.lvlchange)
	end
end)

xplib.register_multiplier(function(plyrname, reason, xp, lvl, total)
	-- more_xp --
	local mult =
		(ul_talents.using_talent(plyrname, "ul_talents:more_xp_1") and 1 or 0)
		+ (ul_talents.using_talent(plyrname, "ul_talents:more_xp_2") and 1 or 0)
		+ (ul_talents.using_talent(plyrname, "ul_talents:more_xp_3") and 1 or 0)
	return total + reason.xpchange * (mult / 6)
end)