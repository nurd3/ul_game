local S = ul_basic.get_translator

local hud_ids = {}

core.register_on_joinplayer(function(plyr)
	local name = plyr:get_player_name()
	
	hud_ids[name] = plyr:hud_add({
		type = "text",
		hud_elem_type = "text",
		position = {x=0.5, y=0.5},
		name = "attackbar",
		scale = {x = 1, y = 1},
		text = "",
		number = 0xFF0000,
		direction = 0,
		offset = {x = 0, y= 24},
	})
end)

local timer = 0
local before = {}

core.register_globalstep(function(delta)
	timer = timer + delta
	for _,plyr in ipairs(core.get_connected_players()) do
		local plyrname = plyr:get_player_name()
		local controls = plyr:get_player_control()
		local tool_capabilities = plyr:get_wielded_item():get_tool_capabilities()

		if controls.dig and not before[plyrname] then
			before[plyrname] = true
			ul_basic.get_attackdtime(plyrname, tool_capabilities.full_punch_interval, true)
		elseif not controls.dig then
			before[plyrname] = false
		end
		if timer > 0.1 then
				local name = plyr:get_player_name()
				local pos = vector.round(plyr:get_pos())
				local dtime = ul_basic.get_attackdtime(name)
				
				if tool_capabilities and tool_capabilities.full_punch_interval and dtime then
					local interval = tool_capabilities.full_punch_interval - dtime
				
					local text = interval > 0 and string.format("%.1f", interval) or ""
				
					plyr:hud_change(hud_ids[name], "text", text)
				end
		end
	end
	if timer > 0.1 then
		timer = 0
	end
end)