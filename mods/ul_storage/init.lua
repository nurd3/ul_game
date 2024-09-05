ul_storage = {}

local S = minetest.get_translator"ul_storage"
local path = minetest.get_modpath"ul_storage"

local opened_storage = {}

ul_storage.get_translator = S
ul_storage.get_modpath = path

-- stolen from MT game's default/chests.lua
function ul_storage.get_formspec(pos)
	local meta = minetest.get_meta(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local formspec =
		"size[8,9]" ..
		"field[0.3,0.5;3,1;name_field;Crate Name;" .. meta:get_string("_name") .. "]" ..
		"button[0.3,1;2,1;save_button;Save]" ..
		"list[nodemeta:" .. spos .. ";main;4,0.3;4,4;]" ..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";main]" ..
		"listring[current_player;main]"
	return formspec
end

minetest.register_node("ul_storage:crate", {
	description = S"Crate",
	tiles = {"ul_storage_crate.png"},
	stack_max = 1,
	on_place = function (pos, placer, pointed_thing)
		minetest.set_node(pointed_thing.above, {name="ul_storage:crate"})
		
		local node_meta = minetest.get_meta(pointed_thing.above)
		local invref = node_meta:get_inventory()
		invref:set_size("main", 4*4)
		
		local stack = placer:get_wielded_item()
		local stack_meta = stack:get_meta()
		
		ul_storage.to_inv(invref, "main", stack_meta:get_string("_inventory"))
		
		node_meta:set_string("_name", stack_meta:get_string("_name"))
		node_meta:set_string("infotext", node_meta:get("_name") or "Unnamed Crate")
		
		stack:set_count(stack:get_count() - 1)
		
		return stack
	end,
	on_punch = function (pos, puncher)
		local node_meta = minetest.get_meta(pos)
		local stack = ItemStack"ul_storage:crate"
		local stack_meta = stack:get_meta()
		
		local inv = minetest.get_meta(pos):get_inventory()
		
		stack_meta:set_string("_inventory", ul_storage.from_inv(inv, "main"))
		
		ul_storage.set_stack_name(stack_meta, node_meta:get("_name"))
		
		minetest.set_node(pos, {name="air"})
		minetest.add_item(pos, stack)
	end,
	on_rightclick = function (pos, node, puncher)
		local node_meta = minetest.get_meta(pos)
		if not node_meta:get("infotext") then
			node_meta:set_string("infotext", node_meta:get("_name") or "Unnamed Crate")
		end
		
		local plyrname = puncher:get_player_name()
		if plyrname then
			opened_storage[plyrname] = pos
			minetest.show_formspec(
				plyrname,
				"ul_storage:formspec", 
				ul_storage.get_formspec(pos)
			)
		end
	end
})

function ul_storage.set_stack_name(dest, name)
	
	if not name then return end
	
	dest:set_string("_name", name)
	
	dest:set_string("description", "Crate\n\""..name.."\"")
	dest:set_string("short_description", "\""..name.."\"")
	
end

function ul_storage.to_inv(invref, list, str)
	local data = minetest.deserialize(str)
	local ret, size = {}, 0
	
	if not data then return end
	
	for i,v in ipairs(data) do
		if type(v) == "string" then
			table.insert(ret, ItemStack(v))
		elseif type(v) == "table" then
			local stack = ItemStack(v.name.." "..v.count)
			local stack_meta = stack:get_meta()
			
			stack_meta:set_string("_inventory", v._inventory)
			stack_meta:set_string("_magic", v._magic)
			
			ul_storage.set_stack_name(stack_meta, v._name)
			
			stack:set_wear(v.wear or 0 )
			
			table.insert(ret, stack)
		end
		size = size + 1
	end
	
	invref:set_size(list, size)
	invref:set_list(list, ret)
end

function ul_storage.from_inv(invref, list)
	local data = {}
	local index = 1
	local size = invref:get_size(list)
	
	if not size then return "" end
	
	while index <= size do
		local stack = invref:get_stack(list, index)
		local stack_meta = stack:get_meta()
		
		local tbl = {
			name = stack:get_name(),
			count = stack:get_count(),
			wear = stack:get_wear(),
			_inventory = stack_meta:get("_inventory"),
			_name = stack_meta:get("_name"),
			_magic = stack_meta:get("_magic")
		}
		
		table.insert(data, tbl)
		
		index = index + 1
	end
	
	return minetest.serialize(data)
end

minetest.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_storage:formspec"
	or not fields.name_field then
		return
	end
	
	local plyrname = plyr:get_player_name()
	
	if not plyrname then
		return
	end
	
	local node_meta = minetest.get_meta(opened_storage[plyrname])
	
	node_meta:set_string("_name", fields.name_field)
end)

minetest.register_craft{
	type = "shapeless",
	output = "ul_storage:crate",
	recipe = {
		"ul_basic:stone",
		"ul_basic:lantern",
	}
}