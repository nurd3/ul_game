-- script used for applying damage to players in darkness

local timer = 0

minetest.register_globalstep(function (dtime)
	timer = timer + dtime
	if timer >= 5 then
		for _,plyr in ipairs(minetest.get_connected_players()) do
			local pos = plyr:get_pos()
			pos = vector.round(pos)
            pos.y = math.floor(pos.y) + 1.5
			local light = minetest.get_node_light(pos, 0) or 0
			
			if light < 3 then
				plyr:set_hp(plyr:get_hp() - 2, {type="drown"})
			elseif light < 5 then
				plyr:set_hp(plyr:get_hp() - 1, {type="drown"})
			end
		end
		timer = 0
	end
end)