local S = ul_mobs.get_translator

local soft_timer = core.settings:get("ul_mobs_soft_despawn_timer") or 10.0
local soft_dist = core.settings:get("ul_mobs_soft_despawn_distance") or 96

function ul_mobs.register_mob(name, def)
	
	local colors = {"#ffffff", "#777777"}
	
	if def.egg_colors then
		colors[1] = def.egg_colors[1] or colors[1]
		colors[2] = def.egg_colors[2] or colors[2]
		colors[3] = def.egg_colors[3] or nil
	end
	
	
	colors[2] = colors[2] or colors[1]
	colors[3] = colors[3] or colors[2]
	
	local egg_def = {
		description = S("@1 Spawn Egg", def.description),
		inventory_image = 
			"(ul_mobs_egg.png^[multiply:"..colors[1]..":255)"..
			"^(ul_mobs_egg_detail.png^[multiply:"..colors[2]..":255)"..
			"^(ul_mobs_egg_detail2.png^[multiply:"..colors[3]..":255)",
		on_place = function(stack, plyr, pointed_thing)
			if pointed_thing.type == "node" then
				local pos = pointed_thing.above
				pos.y = pos.y - def.collisionbox[2]
				core.add_entity(pos, name, core.serialize({_owner=plyr:get_player_name()}))
				stack:set_count(stack:get_count() - 1)
				return stack
			end
		end,
		groups = def.groups or {}
	}

	egg_def.groups.egg = 1
	core.register_craftitem(name, egg_def)

	
	
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
		on_step = ul_mobs.stepfunc,			-- required
		on_activate = ul_mobs.actfunc,
		get_staticdata = ul_mobs.statfunc,
											-- api props
		springiness = 0,
		buoyancy = 0.5,						-- portion of hitbox submerged
		attack={
			range=0.5, 
			damage_groups={fleshy=def.melee and def.melee.dmg or 0}
		},
		brainfunc = ul_mobs.brain,
		
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			
			if puncher and puncher:is_player() and self._owner and puncher:get_player_name() == self._owner then
				return
			end

			local dmg = self.hp
			
			mobkit_plus.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)

			dmg = dmg - self.hp
			
			if mobkit.is_alive(puncher) then						-- is puncher a living and alive thing
				if self.runaway then
					mobkit_plus.hq_runfrom(self, 12, puncher)
				else
					local uncomfortable = self.comfortable_hp
						and self.hp < self.comfortable_hp
					uncomfortable = uncomfortable
						or self.scare_dmg
						and dmg >= self.scare_dmg

					ul_mobs.fight_or_flight(self, puncher, 
						uncomfortable, 12, 20)
				end
				self._puncher = puncher
				self._puncher_last_punched = self.time_total
			end

			if self._puncher and self.hp <= 0 and self.time_total - 5 < self._puncher_last_punched then
				self._killer = self._puncher
				if self.xp_worth
				then
					if self._puncher:is_player()
					then xplib.add_player_xp(self._puncher:get_player_name(), self.xp_worth, {type="ul_mobs_kill"})
					elseif self._puncher:get_luaentity()
					and self._puncher:get_luaentity()._owner
					then xplib.add_player_xp(self._puncher:get_luaentity()._owner, self.xp_worth, {type="ul_mobs_pet_kill"})
					end
				end
			end
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
						core.chat_send_player(name, "this mob will follow you")
					else
						mobkit.remember(self, "sitting", "true")
						core.chat_send_player(name, "this mob is no longer following you")
						mobkit.clear_queue_high(self)
					end
				else
					core.chat_send_player(name, "this mob is owned by "..self._owner)
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

	if entdef.attack
	and not entdef.attack.full_punch_interval
	then
		entdef.attack.full_punch_interval = 0.5
	end
	
	entdef.sounds = sounds
	
	core.register_entity(name, entdef)

end