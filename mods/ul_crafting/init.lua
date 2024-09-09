ul_crafting = {}

local S = minetest.get_translator"ul_crafting"

ul_crafting.get_translator = S

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

		return sfinv.make_formspec(player, context,
            page..
            [[
                button[1,20;5,1;back;<]
                label[2,20;]][[]
				listring[current_player;main]
			]], true)
	end
})