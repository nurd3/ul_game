common_storage = {}

local S = minetest.get_translator"common_storage"

common_storage.get_translator = S

local inv = minetest.create_detached_inventory("common_storage")

local storage = minetest.get_mod_storage()

inv:set_size("main", 4 * 4)

local function save()
	
	local size = inv:get_size("main")
	
	if not size then return end
	
	local data = {}
	local index = 1
	
	while index <= size do
	
		local stack = inv:get_stack("main", index)
		
		table.insert(data, {
			name = stack:get_name(),
			count = stack:get_count(),
			wear = stack:get_wear(),
			meta = stack:get_meta():to_table()
		})
	
		index = index + 1
	
	end
	
	storage:set_string("items", minetest.serialize(data))
	
end

sfinv.register_page("common_storage:common_storage", {
    title = S"Common",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				label[0.5,4.5;Changes only save when this page is closed]
				list[detached:common_storage;main;2,0.3;4,4;]
				listring[current_player;main]
				listring[detached:common_storage;main]
			]], true)
	end,
	on_leave = save,
	on_player_receive_fields = save
})


local data = minetest.deserialize(storage:get_string("items")) or {}
local index = 1

for i,v in ipairs(data) do

	local stack = ItemStack(v.name.." "..v.count)
	
	stack:set_wear(v.wear)
	
	stack:get_meta():from_table(v.meta)
	
	inv:set_stack("main", i, stack)

end
