local S = ul_inv.get_translator

local function get_item_display_name(id)
	return (minetest.registered_items[id] and (minetest.registered_items[id].short_description or minetest.registered_items[id].description)) or id
end

local selected = {}
local scrolls = {}
local recipes = {}
local recipes_formspec = ""

local function compile_recipes()
	local temp1, temp2 = {}, {}
    for item,_ in pairs(minetest.registered_items) do
        local x = minetest.get_all_craft_recipes(item)
        if x ~= nil then
            for _,t in ipairs(x) do
                local count = {}
				local id = ""
                for _,str in ipairs(t.items) do
                    local ist = ItemStack(str)
                    count[ist:get_name()] = (count[ist:get_name()] or 0) + ist:get_count()
					id = id..ist:get_name()
                end
                table.insert(temp1, item..id)
				temp2[item..id] = {
					input = count,
					output = t.output
                }
            end
        end
    end
	table.sort(temp1)
	for _,v in ipairs(temp1) do
		table.insert(recipes, temp2[v])
	end
	
	for i,rec in ipairs(recipes) do
		recipes_formspec = recipes_formspec.."container["..((i - 1) % 3 + 1)..","..(math.floor((i - 1) / 3)).."]\n"
		local offset = 0
		
		local itm, amt = minetest.registered_items[ItemStack(rec.output):get_name()], ItemStack(rec.output):get_count()
		
		local img = itm.inventory_image
		
		if img == "" and itm.tiles then
			img = itm.tiles[1]
		end
		
		recipes_formspec = recipes_formspec.."image_button[0,0;1,1;"..img..";"..i..";]\n"
		
		recipes_formspec = recipes_formspec.."container_end[]\n"
	end
end

minetest.register_on_mods_loaded(function()
    compile_recipes()
end)

sfinv.override_page("sfinv:crafting", {
    title = S"Crafting",
	get = function(self, plyr, context, recipe)

		
		local recipe = ""
		
		if selected[plyr:get_player_name()] then
			local rec = recipes[selected[plyr:get_player_name()]]
			local offset = 0.5
			recipe = recipe.."label[0,0;"..get_item_display_name(rec.output).."]"
			for nom,amt in pairs(rec.input) do
				local name = get_item_display_name(nom)
				recipe = recipe.."label[0.1,"..offset..";"..amt.."X "..name.."]\n"
				offset = offset + 0.3
			end
			recipe = recipe.."button[0,4;2,1;ul_craft;Craft]"
		end
		
		local scroll = scrolls[plyr:get_player_name()] or 0
		
		return sfinv.make_formspec(player, context,
			"scrollbar[0,0;0.5,4.5;vertical;ul_recipes;"..scroll.."]\n"..
			"scroll_container[0,0.5;10,5;ul_recipes;vertical]\n"..
            recipes_formspec..
			"scroll_container_end[]\n"..
			"container[5,0]\n"..
			recipe..
			"container_end[]"
		, true)
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		local rec = nil
		for k,v in pairs(fields) do
			if recipes[tonumber(k)] then
				rec = tonumber(k)
			end
		end
		if rec then
			selected[plyr:get_player_name()] = rec
			scrolls[plyr:get_player_name()] = fields.ul_recipes:sub(5)
			sfinv.set_page(plyr, "sfinv:crafting")
			return
		end
		
		if fields.ul_craft then
			local rec = recipes[selected[plyr:get_player_name()]]
			local inv = plyr:get_inventory()
			local out = ItemStack(rec.output)
			for nom,amt in pairs(rec.input) do
				local stack = ItemStack(nom.." "..amt)
				if not inv:contains_item("main", stack) then
					minetest.chat_send_player(plyr:get_player_name(), "Not enough "..get_item_display_name(nom).."!")
					return
				end
			end
			
			for nom,amt in pairs(rec.input) do
				local i = 0
				while i < amt do
					inv:remove_item("main", ItemStack(nom))
					i = i + 1
				end
			end
			
			if inv:room_for_item("main", out) then
				inv:add_item("main", out)
			else
				minetest.add_item(plyr:get_pos(), out)
			end
			
			return
		end
	end
})