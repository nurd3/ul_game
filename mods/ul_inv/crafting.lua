local S = ul_inv.get_translator

local recipes = {}

sfinv.register_page("ul_inv:crafting", {
	title = S("Crafting"),
	get = function(self, player, context)
		
		return sfinv.make_formspec(player, context, [[
				list[current_player;craft;1.75,0.5;3,3;]
				list[current_player;craftpreview;5.75,1.5;1,1;]
				image[4.75,1.5;1,1;sfinv_crafting_arrow.png]
				listring[current_player;main]
				listring[current_player;craft]
			]], true)
	end
})