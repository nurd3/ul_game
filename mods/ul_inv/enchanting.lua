local S = ul_inv.get_translator

sfinv.register_page("ul_inv:enchanting", {
	title = S"Enchanting",
	get = function(self, plyr, context, recipe)
		return sfinv.make_formspec(player, context,
			"label[5,5;Coming Soon "..minetest.formspec_escape(";)").."]"
		, true)
	end
})