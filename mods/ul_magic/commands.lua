local S = ul_magic.get_translator

core.register_chatcommand("get_levels", {
	params = "",
	description = S"Shows the bonus levels of your outfit.",
	func = function(plyrname)
		local str = "--- RUNE LEVELS ---\n"
		local plyr = core.get_player_by_name(plyrname)
		local inv = plyr:get_inventory()
		for k,v in pairs(ul_magic.get_rune_levels(inv:get_list"outfit")) do
			str = str .. string.format("%s %i\n", k, v)
		end
		str = str .. "--- PURPOSE LEVELS ---\n"
		str = str .. string.format("defense %i\n", ul_magic.get_purpose_level(plyr, "defense"))
		str = str .. string.format("darkness %i\n", ul_magic.get_purpose_level(plyr, "darkness"))
		str = str .. string.format("stealth %i\n", ul_magic.get_purpose_level(plyr, "stealth"))
		core.chat_send_player(plyrname, str)
	end
})