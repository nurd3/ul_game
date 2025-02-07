-- script used for applying damage to players in darkness

local timer = 0
local plyrtimers = {}

core.register_globalstep(function (dtime)
	timer = timer + dtime
	if timer >= 1 then
		for _,plyr in ipairs(core.get_connected_players()) do
			local plyrnom = plyr:get_player_name()
			local pos = plyr:get_pos()
			pos = vector.round(pos)
            pos.y = math.floor(pos.y) + 1.0

			-- prevent certain edge cases			
			core.fix_light(
				vector.offset(pos, -1, -1, -1),
				vector.offset(pos, 1, 1, 1)
			)
			
			local light = core.get_node_light(pos, 0) or -1
			local plyrtimer = plyrtimers[plyrnom] or 0
			
			-- if light level below 5
			if light < 5 then
			
				-- player must be in darkness for at least 5 seconnds
				if plyrtimer >= 5 then
					local defense = ul_magic.get_purpose_level(plyr, "darkness")
					if math.random() + math.random() * defense < 1 then
						plyr:set_hp(plyr:get_hp() - 1, {type="drown"})
					end
					-- darkness should only cause damage every 2 seconds (without armour)
					plyrtimers[plyrnom] = 4 - math.max(math.min(defense, 1), -1)

				else

					plyrtimers[plyrnom] = plyrtimer + 1

				end

			else

				-- set timers back to 0 if player is in light
				plyrtimers[plyrnom] = 0

			end
		end
		timer = 0
	end
end)