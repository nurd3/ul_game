local S = ul_market.get_translator

core.register_chatcommand("price_industry", {
	params = "<industry_name>",
	description = S"Returns the price of an industry",
	privs = {},
	func = function(plyrname, params)
		if params ~= "" and ul_market.registered_industries[params] then
			core.chat_send_player(plyrname, ul_market.get_industry_price(params))
		end
	end
})
core.register_chatcommand("price_company", {
	params = "<company_name>",
	description = S"Returns the price of a company",
	privs = {},
	func = function(plyrname, params)
		if params ~= "" and ul_market.registered_companies[params] then
			core.chat_send_player(plyrname, ul_market.calculate_company_price(params))
		end
	end
})
core.register_chatcommand("value_company", {
	params = "<company_name>",
	description = S"Returns the value of a company",
	privs = {},
	func = function(plyrname, params)
		if params ~= "" and ul_market.registered_companies[params] then
			core.chat_send_player(plyrname, ul_market.calculate_company_value(params))
		end
	end
})
core.register_chatcommand("events", {
	params = "",
	description = S"Shows the events",
	privs = {},
	func = function(plyrname, params)
		local str = "--- EVENTS ---\n"
		for k,t in pairs(ul_market.get_active_events()) do
			for n,v in pairs(t) do
				str = str .. string.format("%.2f %s %s\n", v, ul_market.registered_events[k].title, n)
			end
		end
		core.chat_send_player(plyrname, str)
	end
})
core.register_chatcommand("event_bonuses", {
	params = "",
	description = S"Shows the event bonuses",
	privs = {},
	func = function(plyrname, params)
		local str = "--- EVENT_BONUSES ---\n"
		for k,v in pairs(ul_market.get_active_event_bonuses()) do
			str = str .. string.format("%.2f:%.2f %s\n", v.chance, v.intensity, (ul_market.registered_events[k] or {title = k}).title)
		end
		core.chat_send_player(plyrname, str)
	end
})
core.register_chatcommand("policies", {
	params = "",
	description = S"Shows the policies",
	privs = {},
	func = function(plyrname, params)
		local str = "--- POLICIES ---\n"
		for k,v in pairs(ul_market.get_active_policies()) do
			str = str .. string.format("%i %s\n", v, ul_market.registered_policies[k].title)
		end
		core.chat_send_player(plyrname, str)
	end
})
core.register_chatcommand("parties", {
	params = "",
	description = S"Shows the parties",
	privs = {},
	func = function(plyrname, params)
		local str = "--- PARTIES ---\n"
		for k,v in pairs(ul_market.get_parties()) do
			str = str .. string.format("%i %s\n", v, ul_market.registered_parties[k].title)
		end
		core.chat_send_player(plyrname, str)
	end
})
core.register_chatcommand("election", {
	params = "",
	description = S"Forces election",
	privs = {market_modify=true},
	func = function(plyrname, params)
		ul_market.election()
	end
})
core.register_chatcommand("clear_events", {
	params = "",
	description = S"Clears the events",
	privs = {market_modify=true},
	func = function(plyrname, params)
		local tbl = ul_market.get_active_events()
		for k,v in pairs(tbl) do
			tbl[k] = nil
		end
		core.chat_send_player(plyrname, "Events Cleared.")
	end
})
core.register_chatcommand("clear_policies", {
	params = "",
	description = S"Clears the policies",
	privs = {market_modify=true},
	func = function(plyrname, params)
		for k,v in pairs(ul_market.get_active_policies()) do
			ul_market.set_policy(k, 0)
		end
		core.chat_send_player(plyrname, "Policies Cleared.")
	end
})
core.register_chatcommand("write_policy", {
	params = "<policy_name> [intensity]",
	description = S"Sets the intensity of the policy, default intensity is 0",
	privs = {market_modify=true},
	func = function(plyrname, params)
		local index = 0
		local policy = ""
		local intensity = 0
		for str in string.gmatch(params, "([^ ]+)") do
			index = index + 1
			if index > 2 then
				return false, "Too many arguments given!"
			elseif index == 1 then
				policy = str
			elseif index == 2 then
				intensity = tonumber(str)
			end
		end

		ul_market.set_policy(policy, intensity)
		core.chat_send_player(plyrname, "Policy Written.")
	end
})
core.register_chatcommand("reset_market", {
	params = "",
	description = S"Resets events, stocks, policies, government, player stats and shuts the server down.",
	privs = {reset_market=true},
	func = function(plyrname, params)
		core.show_formspec(
			plyrname, "ul_market:reset_confirm", [[
				size[8,3]
				label[0.5,0.5;Server will shutdown, confirm?]
				label[0.5,1;WARNING: THIS CANNOT BE UNDONE]
				label[0.5,1.5;ALL MARKET DATA WILL BE LOST]
				button[0.5,2.5;1,0.5;ul_yes;Yes]
				button[6.5,2.5;1,0.5;ul_no;No]
			]]
		)
	end
})

core.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_market:reset_confirm" then
		return
	end

	local can_reset = core.check_player_privs(plyr, "reset_market")
	if not can_reset then
		core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S"You do not have permission to reset the market"))
		return
	end
	if fields.ul_yes then
		ul_market.reset_market()
	end
	core.close_formspec(plyr:get_player_name(), "ul_market:reset_confirm")
end)

core.register_privilege("reset_market", {
	description = S"Ability to reset market (Shuts down server!)",
	give_to_singleplayer = false,
	give_to_admin = true
})

core.register_privilege("market_modify", {
	description = S"Ability to modify the market using commands.",
	give_to_singleplayer = false,
	give_to_admin = true
})