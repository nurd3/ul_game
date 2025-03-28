ul_portal = {}

local path = core.get_modpath"ul_portal"
local S = core.get_translator"ul_portal"
local storage = core.get_mod_storage()

ul_portal.get_modpath = path
ul_portal.get_translator = S

local portals = core.deserialize(storage:get_string("portal_positions")) or {}
local portal_order = {}


local function sort_portals()
	local temp = {}

	for k,v in pairs(portals)
	do table.insert(temp, {k, v})
	end

	table.sort(temp, function (a, b)
		if a[2] == b[2]
		then return a[1] > b[1]
		else return a[2] > b[2]
		end
	end)

	portal_order = {}

	for i,v in ipairs(temp)
	do portal_order[i] = v[1]
	end
end

sort_portals()

function ul_portal.get_portal_count()
	return #portal_order
end

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

	for i,v in ipairs(portal_order)
	do 
		local pos2 = vector.from_string(v)
		local node = core.get_node_or_nil(pos)
		if not node
		or node.name ~= "ul_portal:portal"
		then
			portals[v] = nil
			table.remove(portal_order, v)
		elseif v ~= spos 
		and math.abs(pos.x - pos2.x) <= max_dist 
		and math.abs(pos.z - pos2.z) <= max_dist
		then
			local name = portals[v]
			locations_spec = locations_spec .. 
				"button[0.5," .. offset .. ";3,1;" .. i .. ";" .. core.formspec_escape(v) .. " \"" .. core.formspec_escape(name) .. "\"]"
			offset = offset + 1
		end
	end

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
		"button[0.3,2;2,1;destroy;Destroy]" ..
		"container_end[]"
end

core.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_portal:formspec" then
		return
	end
	
	local plyrname = plyr:get_player_name()
	
	for k,v in pairs(fields) do
		if tonumber(k) then
			local pos = vector.from_string(portal_order[tonumber(k)])
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
		sort_portals()
	end

	if fields.destroy
	then 
		local pos = vector.from_string(opened_portals[plyrname])
		core.set_node(pos, {name="air"})
		core.add_item(pos, ItemStack"ul_portal:portal")
		portals[vector.to_string(pos)] = nil
		sort_portals()
		storage:set_string("portal_positions", core.serialize(portals))
		core.close_formspec(plyrname, "ul_portal:formspec")
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
	light_source = 15,
	on_place = function(stack, placer, pointed_thing)
		core.set_node(pointed_thing.above, {name="ul_portal:portal"})
		portals[vector.to_string(pointed_thing.above)] = S"Portal"
		sort_portals()
		storage:set_string("portal_positions", core.serialize(portals))
		stack:take_item()
		return stack
	end,
	on_punch = function (pos, node, puncher)
		if puncher
		and puncher:get_player_name()
		then core.chat_send_player(puncher:get_player_name(), core.colorize("#ff0000", "Use the Destroy button in the portal menu!"))
		end
	end,
	on_rightclick = function (pos, node, puncher)
		local plyrname = puncher and puncher:get_player_name()
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