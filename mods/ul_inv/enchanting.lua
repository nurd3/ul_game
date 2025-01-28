local S = ul_inv.get_translator

local function get_item_display_name(id)
	return (core.registered_items[id] and (core.registered_items[id].short_description or core.registered_items[id].description)) or id
end

sfinv.register_page("ul_inv:enchanting", {
	title = S"Enchanting",
	get = function(self, plyr, context, recipe)
		return sfinv.make_formspec(player, context,
			"label[1,0.5;Enchantable]"..
			"list[current_player;craft;1,1;1,1;]"..
			"label[1,2.5;Rune]"..
			"list[current_player;craft;1,3;1,1;1]"..
			"label[5,1.5;Result]"..
			"list[current_player;craft;5,2;1,1;2]"..
			"button[2.5,2;2,1;ul_enchant;Enchant]"
		, true)
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		if not fields.ul_enchant then
			return
		end
		
		local inv = plyr:get_inventory()
		local input = inv:get_stack("craft", 1):get_name()
		local rune = inv:get_stack("craft", 2):get_name()
		
		if inv:get_stack("craft", 1):is_empty() then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"You can't enchant air!"))
		elseif inv:get_stack("craft", 2):is_empty() then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Air is not a rune!"))
		end
		
		local inpdef = core.registered_items[input]
		local enctype = inpdef and inpdef.enchantable
		local runedef =  ul_magic.registered_runes[rune]
		local func = runedef and runedef["on_"..(enctype or "")]
		
		if not enctype then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S("@1 is not enchantable!", get_item_display_name(input))))
			return
		elseif not runedef then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S("@1 is not a rune!", get_item_display_name(rune))))
			return
		elseif not func then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S("@1 cannot be enchanted with @2!", get_item_display_name(input), get_item_display_name(rune))))
			return
		elseif inv:get_stack("craft", 3):get_count() > 0 then
			core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"Clear the result box!"))
			return
		end
		
		inv:set_stack("craft", 3, ul_magic.enchant(input, rune))

		inv:remove_item("craft", ItemStack(input))
		inv:remove_item("craft", ItemStack(rune))
	end
})

