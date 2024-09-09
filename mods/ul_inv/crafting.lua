local S = minetest.get_translator"ul_inv"

local selected = {}
local recipes = {}

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
end

minetest.register_on_mods_loaded(function()
    compile_recipes()
end)

sfinv.override_page("sfinv:crafting", {
    title = S"Crafting",
	get = function(self, plyr, context, recipe)
        local content = ""
		local i = 1
        for _,rec in pairs(recipes) do
            content = content.."container["..((i - 1) % 2 + 1)..","..(math.floor((i - 1) / 2)).."]\n"
			local offset = 0
			
			local itm, amt = minetest.registered_items[ItemStack(rec.output):get_name()], ItemStack(rec.output):get_count()
			
			local img = itm.inventory_image or itm.textures[1]
			
            content = content.."image_button[0,0;1,1;"..img..";"..i..";]\n"
            
			content = content.."container_end[]\n"
			i = i + 1
        end
		
		local recipe = ""
		
		if selected[plyr:get_player_name()] then
			local rec = recipes[selected[plyr:get_player_name()]]
			local offset = 0
			for nom,amt in pairs(rec.input) do
				local name = (minetest.registered_items[nom] and (minetest.registered_items[nom].short_description or minetest.registered_items[nom].description)) or nom
				content = content.."label[0,"..offset..";"..amt.."X "..name.."]\n"
				offset = offset + 0.3
			end
		end
		
		return sfinv.make_formspec(player, context,
			"scrollbar[0,0;0.5,4.5;vertical;ul_recipes;0]\n"..
			"scroll_container[0,0.5;10,5;ul_recipes;vertical]\n"..
            content..
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
			sfinv:set_page(plyr, "sfinv:crafting")
		end
	end
})