local S = minetest.get_translator"ul_inv"

local recipes = {}
local pagemax = 0
local pagenums = {}

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
    pagemax = math.ceiling(#recipes / 5)
end)

sfinv.register_page(":sfinv:crafting", {
    title = S"Crafting",
	get = function(self, player, context)
        pagenums[player:get_player_name()] = pagenums[player:get_player_name()] or 0
        local pagenum = pagenums[player:get_player_name()]
        local content = ""
        for i = pagenum * 5 + 1, pagenum * 5 + 5 do
            content = content.."container[]"

            

            content = content.."container_end[]"
        end
		return sfinv.make_formspec(player, context,
			"scrollbar[0,0;1,10;vertical;ul_recipes]\n"..
			"scroll_container[0,0;10,10;ul_recipes;vertical]\n"..
            content..
			"scroll_container_end[]"
		, true)
	end
})