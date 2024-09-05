ul_mobs = {}

local S = minetest.get_translator"ul_mobs"
local path = minetest.get_modpath"ul_mobs"

ul_mobs.get_translator = S
ul_mobs.get_modpath = path

if not table.unpack then
    table.unpack = unpack
end

dofile(path.."/mobkit_plus.lua")

function ul_mobs.register_mob(name, def)
	
	local colors = {"#ffffff", "#777777"}
	
	if def.egg_colors then
		colors[1] = def.egg_colors[1] or colors[1]
		colors[2] = def.egg_colors[2] or colors[2]
		colors[3] = def.egg_colors[3] or nil
	end
	
	if not colors[3] then
		colors[3] = colors[2] or colors[1]
	end
	
	minetest.register_craftitem(name, {
		description = S("@1 Spawn Egg", def.description),
		inventory_image = 
			"(ul_mobs_egg.png^[multiply:"..colors[1]..":255)"..
			"^(ul_mobs_egg_detail.png^[multiply:"..colors[2]..":255)"..
			"^(ul_mobs_egg_detail2.png^[multiply:"..colors[3]..":255)",
		on_place = function(stack, plyr, pointed_thing)
			if pointed_thing.type == "node" then
				local pos = pointed_thing.above
				pos.y = pos.y - def.collisionbox[2]
				minetest.add_entity(pos, name, minetest.serialize({_owner=plyr:get_player_name()}))
				stack:set_count(stack:get_count() - 1)
				return stack
			end
		end
	})
	
	local sounds = {}
	
	if def.sounds then
		sounds = def.sounds
	end
	
	
	sounds.hunt = sounds.hunt or "ul_mobs_hunt"
	sounds.hurt = sounds.hurt or "player_damage"
	sounds.die = sounds.die or "ul_mobs_die"
	sounds.idle = sounds.idle or "ul_mobs_idle"

	local entdef = {
												-- common props
		physical = true,
		stepheight = 0.1,				--EVIL!
		collide_with_objects = true,
		collisionbox = def.collisionbox,
		visual = def.visual,
		textures = def.textures,
		visual_size = def.visual_size,
		static_save = true,
		makes_footstep_sound = true,
		on_step = mobkit.stepfunc,			-- required
		on_activate = function(self, staticdata, dtime_s)
			mobkit.actfunc(self, staticdata, dtime_s)
			
			local sdat = minetest.deserialize(staticdata)
			
			if sdat and sdat._owner then
				self.object:set_properties{
					infotext = "owner: "..self._owner
				}
			end
		end,
		get_staticdata = function (self)	-- mobkit does not save hp or owner
			local ret = minetest.deserialize(mobkit.statfunc(self))
			ret._owner = self._owner or self.owner
			ret.hp = self.hp
			return minetest.serialize(ret)
		end,
											-- api props
		springiness = 0,
		buoyancy = 0.5,						-- portion of hitbox submerged
		attack={
			range=0.5, 
			damage_groups={fleshy=def.melee and def.melee.dmg or 0}
		},
		brainfunc = ul_mobs.brain,
		
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			
			if puncher:is_player() and self._owner and puncher:get_player_name() == self._owner then
				return
			end
			mobkit.make_sound(self, "hurt")
			if mobkit.is_alive(puncher) then						-- is puncher a living and alive thing
				if self.runaway then
					mobkit.hq_runfrom(self, 12, puncher)
				else
					mobkit.hq_hunt(self, 12, puncher)		-- get revenge
				end
			end
			
			mobkit_plus.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
		end,
		
		on_rightclick = function(self, clicker)
			if not self._owner or not ul_basic.is_alive(self) then
				return
			end
			local name = clicker:get_player_name()
			if name then
				if name == self._owner then
					if mobkit.recall(self, "sitting") then
						mobkit.forget(self, "sitting")
						minetest.chat_send_player(name, "this mob is now standing")
					else
						mobkit.remember(self, "sitting", "true")
						minetest.chat_send_player(name, "this mob is now sitting")
					end
				else
					minetest.chat_send_player(name, "this mob is owned by "..self._owner)
				end
			end
		end

	}
	
	if def.disable_on_punch then
		entdef.on_punch = nil
	end
	
	for key,val in pairs(def) do
		entdef[key] = val
	end
	
	entdef.sounds = sounds
	
	minetest.register_entity(name, entdef)

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

local spawn_rate = minetest.settings:get('ul_mobs_spawn_rate') or 1.0
local active_block_range = tonumber(minetest.get_mapgen_setting('active_block_range')) or 3

dofile(path.."/functions.lua")

dofile(path.."/soul.lua")

dofile(path.."/monsters.lua")
dofile(path.."/animals.lua")
dofile(path.."/arcanoids.lua")

if natural_entities then
	dofile(path.."/natural_entities.lua")
end