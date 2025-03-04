local S = ul_talents.get_translator

local function get_slot_title(name)
	return name and
	(ul_talents.registered_slots[name]
	and ul_talents.registered_slots[name].title
	or name)
end

core.register_chatcommand("equip_talent", {
	params = "<talent_name>",
	description = S"Equip a talent",
	privs = {server = true},
	func = function(plyrname, params)
		local def = ul_talents.registered_talents[params]
		if not def
		then core.chat_send_player(plyrname, core.colorize("#ff0000", S("Unknown Talent: @1", params)))
			return
		end
		ul_talents.set_slot(plyrname, def.slot, params)
		core.chat_send_player(plyrname, S("Set slot @1 to @2", get_slot_title(def.slot), def.title or params))
	end
})

core.register_chatcommand("slots", {
	params = "",
	description = S"Check your talent slots",
	func = function(plyrname, params)
		for slot, talent in pairs(ul_talents.get_slots(plyrname))
		do
			core.chat_send_player(plyrname, string.format("%s = %s", slot, talent))
		end
		
	end
})