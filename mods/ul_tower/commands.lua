local S = ul_tower.get_translator

core.register_chatcommand("reset_tower", {
	description = S"Reset the tower.",
	privs = {tower=true},
	func = function(plyrname, params)
		ul_tower.reset()
		core.chat_send_all(S("Tower has been reset by @1.", plyrname))
	end
})

core.register_privilege("tower", {
	description = S"Ability to modify the tower using commands.",
	give_to_singleplayer = false,
	give_to_admin = true
})