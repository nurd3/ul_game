local S = ul_shrines.get_translator
local T = function(...) return core.formspec_escape(S(...)) end

local scrolls = {}
local opened = {}

sfinv.register_page("ul_shrines:shrines", {
	title = S"Shrines",
	get = function(self, plyr, context)
		
		local plyrname = plyr:get_player_name()

		local offset = 0.0
		local shrines = ""
		for i,v in ipairs(ul_shrines.shrine_order) do
			local shrn = ul_shrines.registered_shrines[v] or {title = v, description = "N/A"}
			local lvl = ul_shrines.get_shrine_level(v)
			shrines = shrines ..
				string.format("label[0.5," .. offset .. ";%.2f%% %s]", lvl, core.formspec_escape(shrn.title)) ..
				string.format("tooltip[0.5,".. offset ..";4,0.5;%s]", core.formspec_escape(shrn.description))
			if shrn.repentable then
				shrines = shrines ..
					string.format("button[2," .. offset .. ";1,0.5;".. core.formspec_escape(v) ..";%s]", T"Repent")
			end
			offset = offset + 0.5
		end

		local scroll = scrolls[plyrname] or 0
		
		return sfinv.make_formspec(plyr, context,
			string.format("label[0,0;%s]", T("@1 Piety", ul_shrines.get_piety_level(plyrname)))..
			string.format("label[0,1;%s]", T"Shrines")..
			"scrollbaroptions[max=".. offset * 7 .."]" ..
			"scrollbar[2,0.5;0.5,3;vertical;ul_shrines;"..scroll.."]"..
			"scroll_container[2.5,1;4,3.5;ul_shrines;vertical]" ..
			shrines..
			"scroll_container_end[]"
		, true, "size[9,9.1]")
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		local plyrname = plyr:get_player_name()
		scrolls[plyrname] = fields.ul_shrines and fields.ul_shrines:sub(5)

		local shrn = nil
		local shrn_def = nil

		for k,v in pairs(fields) do
			if ul_shrines.registered_shrines[k] then
				shrn = k
				shrn_def = ul_shrines.registered_shrines[k]
			end
		end

		if shrn then
			if ul_shrines.get_piety_level(plyrname) ~= 0 and ul_shrines.repent_shrine(shrn) then
				ul_shrines.add_piety_level(plyrname, -1)
			elseif ul_shrines.get_shrine_level(shrn) ~= 0 then
				core.chat_send_player(plyrname, core.colorize("#ff0000", S"Not enough Piety!"))
			else
				core.chat_send_player(plyrname, core.colorize("#ff0000", S"Nothing to repent!"))
			end
		end

		sfinv.set_page(plyr, "ul_shrines:shrines")
	end,
	on_enter = function(self, plyr, context)
		opened[plyr:get_player_name()] = true
	end,
	on_leave = function(self, plyr, context)
		opened[plyr:get_player_name()] = nil
	end
})

ul_shrines.register_on_step(function()
	for plyrname,bool in pairs(opened) do
		if core.get_player_by_name(plyrname) and bool then
			sfinv.set_page(core.get_player_by_name(plyrname), "ul_shrines:shrines")
		end
	end
end)