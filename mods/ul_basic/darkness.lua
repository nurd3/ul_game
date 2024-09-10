-- script used for applying damage to players in darkness

local timer = 0
local switch = {}

minetest.register_globalstep(function (dtime)
	timer = timer + dtime
	if timer >= 5 then
		for _,plyr in ipairs(minetest.get_connected_players()) do
			local pos = plyr:get_pos()
			pos = vector.round(pos)
            pos.y = math.floor(pos.y) + 1.5
			local light = minetest.get_node_light(pos, 0) or 0

			-- primitive buffer to prevent darkness from being unforgiving
			if switch[plyr:get_player_name()] then
			
				if light < 3 then
					plyr:set_hp(plyr:get_hp() - 2, {type="drown"})
				elseif light < 5 then
					plyr:set_hp(plyr:get_hp() - 1, {type="drown"})
				else
					switch[plyr:get_player_name()] = nil
				end

			elseif light < 3 then

				switch[plyr:get_player_name()] = true

			end
		end
		timer = 0
	end
end)