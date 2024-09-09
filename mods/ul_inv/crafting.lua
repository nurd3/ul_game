local S = minetest.get_translator"ul_inv"

local recipes = {}

local function compile_recipes()
    for item,_ in pairs(minetest.registered_items) do
        local x = minetest.get_all_craft_recipes()
        if x then
            for _,t in ipairs(x) do
                local count = {}
                for _,item in ipairs(t.recipe) do
                    local ist = ItemString(item)
                    count[ist.name] = (count[ist.name] or 0) + ist.count
                end
                table.insert(recipes, {
                    {
                        input = count,
                        output = t.output
                    }
                })
            end
        end
    end
end

minetest.register_on_mods_loaded(function()
    compile_recipes()
end)

sfinv.register_page(":sfinv:crafting", {
    title = S"Crafting",
	get = function(self, player, context)
        local content = ""
        for i,rec in ipairs(recipes) do
            content = content.."container[0,"..tostring(5 * i).."]"

			local offset = 0
			for nom,amt in pairs(rec.input) do
            	content = content.."label[0,"..offset..";10,5;"..tostring(amt).."X "..nom.."]"
				offset = offset + 5
			end
			local nom, amt = ItemString(rec.output).name, ItemString(rec.output).count
            content = content.."label[50,0;10,5;"..tostring(amt).."X "..nom.."]"..
				"button[100,0;10,5;ul_craft"..tostring(i).."]"

            content = content.."container_end[]"
        end
		return sfinv.make_formspec(player, context,
			"scrollbar[0,0;10,100;vertical;ul_recipes]\n"..
			"scroll_container[0,0;100,100;ul_recipes;vertical]\n"..
            content..
			"scroll_container_end[]"
		, true)
	end
})

minetest.register_on_player_receive_fields(function(plyr, formname, fields)
	minetest.log(tostring(fields.button))
end)