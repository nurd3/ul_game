local S = ul_mobs.get_translator

core.register_chatcommand("ul_mobs_hide", {
	params = "[target_player]",
	description = S"Make mobs ignore a specific player",
	privs = {debug = 1},
	func = function(plyrname, params)
		local tgt = plyrname

		if params ~= ""
		then tgt = params
			if not core.check_player_privs(plyrname, "server")
			then
				return "You do not have permission to hide/show other players."
			end
		end

		ul_mobs.set_player_hidden(tgt, true)

		if tgt ~= plyrname
		then
			core.chat_send_player(plyrname, string.format("%s has been hidden", tgt))
		end
		core.chat_send_player(tgt, core.colorize("#ffff00", "Mobs will no longer see you"))
	end
})

core.register_chatcommand("ul_mobs_show", {
	params = "[target_player]",
	description = S"Make mobs stop ignoring a specific player",
	privs = {debug = 1},
	func = function(plyrname, params)
		local tgt = plyrname

		if params ~= ""
		then tgt = params
			if not core.check_player_privs(plyrname, "server")
			then
				return "You do not have permission to hide/show other players."
			end
		end

		ul_mobs.set_player_hidden(tgt, false)

		if tgt ~= plyrname
		then
			core.chat_send_player(plyrname, string.format("%s has been unhidden", tgt))
		end
		core.chat_send_player(tgt, core.colorize("#ffff00", "Mobs can now see you"))
	end
})