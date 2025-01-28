ul_portal = {}

local path = core.get_modpath"ul_portal"
local S = core.get_translator"ul_portal"
local storage = core.get_mod_storage()

ul_portal.get_modpath = path
ul_portal.get_translator = S

local portals = core.deserialize(storage:get_string("portal_positions")) or {}

local scrolls = {}
local opened_portals = {}
-- stolen from MT game's default/chests.lua
function ul_portal.get_formspec(pos, plyr)
	local scroll = scrolls[plyr:get_player_name()] or 0
	local spos = vector.to_string(pos)
	local locations_spec = ""
	local offset = 0
	local max_dist = 50 + 50 * ul_magic.get_rune_level(plyr, "ul_magic:teleport")

	opened_portals[plyr:get_player_name()] = spos

	for k,v in pairs(portals) do 
		local pos2 = vector.from_string(k)
		local node = core.get_node_or_nil(pos)
		if not node or node.name ~= "ul_portal:portal" then
			portals[k] = nil
		elseif k ~= spos and math.abs(pos.x - pos2.x) <= max_dist and math.abs(pos.z - pos2.z) <= max_dist then
			locations_spec = locations_spec .. 
				"button[0.5," .. offset .. ";3,1;" .. k .. ";" .. k .. " \"" .. core.formspec_escape(v) .. "\"]"
			offset = offset + 1
		end end

	if locations_spec == "" then
		locations_spec = "label[1,0;No Portals]"
	end

	return 
		"size[8,9]" ..
		"scrollbar[0,0;0.5,4.5;vertical;ul_locations;"..scroll.."]\n" ..
		"scroll_container[0,0.5;10,5;ul_locations;vertical]\n" ..
		locations_spec ..
		"scroll_container_end[]\n" ..
		"container[5,0]\n" ..
		"field[0.3,0.5;3,1;name_field;Portal Name;" .. core.formspec_escape(portals[vector.to_string(pos)] or S"Portal") .. "]" ..
		"button[0.3,1;2,1;save_button;Save]" ..
		"container_end[]"
end

core.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_portal:formspec" then
		return
	end
	
	local plyrname = plyr:get_player_name()
	
	for k,v in pairs(fields) do
		if portals[k] then
			local pos = vector.from_string(k)
			pos.y = pos.y + 1
			plyr:set_pos(pos)
			core.close_formspec(plyrname, "ul_portal:formspec")
			return
		end
	end

	if fields.name_field then
		if not plyrname then
			return
		end
		
		portals[opened_portals[plyrname]] = fields.name_field
		storage:set_string("portal_positions", core.serialize(portals))
	end
	
end)

core.register_chatcommand("portals", {
	func = function (name, param)
		core.chat_send_player(name, core.serialize(portals))
	end
})

core.register_node("ul_portal:portal", {
	description = S"Portal",
	tiles = {"ul_portal_portal.png"},
	on_place = function(stack, placer, pointed_thing)
		core.set_node(pointed_thing.above, {name="ul_portal:portal"})
		portals[vector.to_string(pointed_thing.above)] = S"Portal"
		storage:set_string("portal_positions", core.serialize(portals))
		stack:take_item()
		return stack
	end,
	on_punch = function (pos, puncher)
		core.set_node(pos, {name="air"})
		core.add_item(pos, ItemStack"ul_portal:portal")
		portals[vector.to_string(pos)] = nil
		storage:set_string("portal_positions", core.serialize(portals))
	end,
	on_rightclick = function (pos, node, puncher)
		local plyrname = puncher:get_player_name()
		if plyrname then
			opened_portals[plyrname] = pos
			core.show_formspec(
				plyrname,
				"ul_portal:formspec", 
				ul_portal.get_formspec(pos, puncher)
			)
		end
	end
})

core.register_craft({
	output = "ul_portal:portal 2",
	type = "shapeless",
	recipe = {"ul_magic:teleport", "ul_magic:crystal"}
})