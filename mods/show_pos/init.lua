local hud_ids = {}

minetest.register_on_joinplayer(function(plyr)
	local name = plyr:get_player_name()
	
	hud_ids[name] = plyr:hud_add({
		type = "text",
		hud_elem_type = "text",
		alignment = {x=1, y=0},
		position = {x=0, y=0.5},
		name = "position",
		scale = {x = 1, y = 1},
		text = "Position",
		number = 0xffffff,
		direction = 0,
		offset = {x = 10, y= -10},
	})
end)

local timer = 0

minetest.register_globalstep(function(delta)
	timer = timer + delta
	if timer > 0.1 then
		for _,plyr in ipairs(minetest.get_connected_players()) do
			local name = plyr:get_player_name()
			local pos = vector.round(plyr:get_pos())
			plyr:hud_change(hud_ids[name], "text", 
				"X: "..pos.x
				.."\nY: "..pos.y
				.."\nZ: "..pos.z
			)
		end
		timer = 0
	end
end)
