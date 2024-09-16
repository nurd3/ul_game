local S = ul_basic.get_translator

local hud_ids = {}

minetest.register_on_joinplayer(function(plyr)
	local name = plyr:get_player_name()
	
	hud_ids[name] = plyr:hud_add({
		type = "text",
		hud_elem_type = "text",
		position = {x=0.6, y=0.5},
		name = "attackbar",
		scale = {x = 1, y = 1},
		text = "",
		number = 0xFF0000,
		direction = 0,
		offset = {x = 10, y= -(48 + 24 + 16)},
	})
end)

local timer = 0

minetest.register_globalstep(function(delta)
	timer = timer + delta
	if timer > 0.1 then
		for _,plyr in ipairs(minetest.get_connected_players()) do
			local name = plyr:get_player_name()
			local pos = vector.round(plyr:get_pos())
			local dtime = ul_basic.get_attackdtime(name)
			local itemname = plyr:get_wielded_item():get_name()
			local item = minetest.registered_items[itemname]
			local tool_capabilities = item.tool_capabilities
			
			if tool_capabilities and tool_capabilities.full_punch_interval and dtime then
				local interval = tool_capabilities.full_punch_interval - dtime
			
				local text = interval > 0 and string.format("%.1f", interval) or ""
			
				plyr:hud_change(hud_ids[name], "text", text)
			end
		end
		timer = 0
	end
end)