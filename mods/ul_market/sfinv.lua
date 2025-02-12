local S = ul_market.get_translator
local T = function(t) return core.formspec_escape(S(table.unpack(t))) end

local opened = {}

local selected_company = {}
local scrolls_companies = {}

sfinv.register_page("ul_market:inv_companies", {
    title = S"Companies",
	get = function(self, plyr, context)
		
		local plyrname = plyr:get_player_name()
		local company = ""
		
		if selected_company[plyrname] then
			local cmp = ul_market.registered_companies[selected_company[plyrname]] or {title = "nil", description = "N/A", tag = "NIL"}
			local price, value = ul_market.calculate_company_price(selected_company[plyrname]), ul_market.calculate_company_value(selected_company[plyrname])
			local shares = ul_market.get_portfolio_shares(plyrname, selected_company[plyrname]) or 0

			company = company..string.format("label[0,0;%s]", core.formspec_escape(cmp.title))
			company = company..string.format("tooltip[0,0;4,0.5;%s]", core.formspec_escape(cmp.description))
			company = company..string.format("label[0,0.5;($%.2f) %i shares]", shares * price, shares)
			company = company..string.format("label[0,1;$%.2f ($%.2f)]", price, value)

			company = company.."label[0,1.5;Buy]"
			company = company.."button[0,2;1,1;ul_buy1;x1]"
			company = company.."button[0,3;1,1;ul_buy2;x2]"
			company = company.."button[0,4;1,1;ul_buy5;x5]"
			company = company.."label[1,1.5;Sell]"
			company = company.."button[1,2;1,1;ul_sell1;x1]"
			company = company.."button[1,3;1,1;ul_sell2;x2]"
			company = company.."button[1,4;1,1;ul_sell5;x5]"
		end
		
		local scroll = scrolls_companies[plyrname] or 0

		local companies = ""
		local offset = 0.0
		for _,v in pairs(ul_market.stocks_order) do
			local cmp = ul_market.registered_companies[v] or {title = v, description = "N/A", tag = "NIL"}
			companies = companies .. 
				string.format("button[0.5," .. offset .. ";3.5,0.25;" .. v .. ";%s $%.2f]", cmp.tag, ul_market.calculate_company_price(v)) ..
				string.format("tooltip[".. v ..";%s]", core.formspec_escape(cmp.title))
			offset = offset + 0.5
		end
		
		return sfinv.make_formspec(plyr, context,
			string.format("label[0,0;Wallet: $%.2f]", ul_market.get_wallet(plyrname)) ..
			string.format("tooltip[0,0;2,0.5;($%.2f) %i shares]", ul_market.calculate_player_value(plyrname), ul_market.get_portfolio_total_shares(plyrname)) ..
			"scrollbaroptions[max=".. offset * 8 .."]"..
			"scrollbar[0,0.5;0.5,4;vertical;ul_companies;"..scroll.."]\n"..
			"scroll_container[0.5,1;10,4.5;ul_companies;vertical]\n"..
            companies..
			"scroll_container_end[]\n"..
			"container[5,0]\n"..
			company..
			"container_end[]"
		, true)
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		local cmp = nil
		local buy = nil
		local sell = nil
		for k,v in pairs(fields) do
			if ul_market.registered_companies[k] then
				cmp = k
			elseif string.sub(k, 4, 6) == "buy" then
				buy = tonumber(k:sub(7))
			elseif string.sub(k, 4, 7) == "sell" then
				sell = tonumber(k:sub(8))
			end
		end
		scrolls_companies[plyr:get_player_name()] = fields.ul_companies and fields.ul_companies:sub(5)
		if cmp then
			selected_company[plyr:get_player_name()] = cmp
			sfinv.set_page(plyr, "ul_market:inv_companies")
			return
		end
		if buy then
			ul_market.portfolio_buy(plyr:get_player_name(), selected_company[plyr:get_player_name()], buy)
		elseif sell then
			ul_market.portfolio_sell(plyr:get_player_name(), selected_company[plyr:get_player_name()], sell)
		end
		sfinv.set_page(plyr, "ul_market:inv_companies")
	end,
	on_enter = function(self, plyr, context)
		opened[plyr:get_player_name()] = "ul_market:inv_companies"
	end,
	on_leave = function(self, plyr, context)
		opened[plyr:get_player_name()] = nil
	end
})

local scrolls_parties = {}
local selected_party = {}

sfinv.register_page("ul_market:inv_govt", {
	title = S"Government",
	get = function(self, plyr, context)
		
		local plyrname = plyr:get_player_name()
		local party = ""
		
		if selected_party[plyrname] then
			local prty = ul_market.registered_parties[selected_party[plyrname]] or {title = "nil", description = "N/A", tag = "NIL"}
			local seats = ul_market.get_party_seats(selected_party[plyrname]) or 0

			party = party..string.format("label[0,0;%s]", core.formspec_escape(prty.title))
			party = party..string.format("tooltip[0,0;4,0.5;%s]", core.formspec_escape(prty.description))
			party = party..string.format("label[0,0.5;\"%s\"]", core.formspec_escape(prty.motto))
			party = party..string.format("label[0,1;%i seats]", seats)

			party = party..string.format("button[0,2;2,0.5;ul_fund_party;%s]", T{"Fund Party $500"})
			party = party..string.format("label[0,3;$%.2f]", ul_market.get_party_bonus(selected_party[plyrname]) * 5000)
		end

		local chart = ""
		local parties = ""
		local party_offset = 0.0
		local chart_offset = 0.0
		for _,v in pairs(ul_market.party_order) do
			local prty = ul_market.registered_parties[v] or {title = v, short_title = v, description = "N/A", tag = "NIL"}
			parties = parties .. 
				string.format("label[0.25," .. party_offset .. ";%s]", prty.tag) ..
				string.format("button[1," .. party_offset .. ";1,0.5;" .. v .. ";%s]", T{"Info"}) ..
				string.format("box[0," .. party_offset .. ";0.25,0.5;%s]", prty.color.."ff") ..
				string.format("tooltip[".. v ..";%s]", core.formspec_escape(prty.title))
			local seats = ul_market.get_party_seats(v)
			local size = seats * 0.0075
			chart = chart ..
				string.format("box[%f,0;%f,0.5;%s]", chart_offset, size + 0.001, prty.color.."ff") ..
				string.format("tooltip[%f,0;%f,0.5;%s %s]", chart_offset, size, prty.tag, T{"@1 seats", seats})
			chart_offset = chart_offset + size
			party_offset = party_offset + 0.5
		end

		local policy_offset = 0.0
		local policies = ""
		for i,v in ipairs(ul_market.policy_order) do
			local plcy = ul_market.registered_policies[v] or {title = v, description = "N/A"}
			local lvl = ul_market.get_policy_intensity(v)
			policies = policies ..
				string.format("label[0.5," .. policy_offset .. ";%s]", ul_market.get_policy_name(lvl, plcy.title)) ..
				string.format("tooltip[0.5,".. policy_offset ..";4,0.5;%s]", core.formspec_escape(plcy.description))
			policy_offset = policy_offset + 0.5
		end
		
		return sfinv.make_formspec(plyr, context,
			string.format("label[2,0;%s]", T{"Policies"})..
			"scrollbaroptions[max=".. policy_offset * 8 .."]" ..
			"scrollbar[2,0.5;0.5,3;vertical;ul_policies;]"..
			"scroll_container[2.5,1;4,3.5;ul_policies;vertical]" ..
			policies..
			"scroll_container_end[]"..
			"container[0,0]"..
			parties..
			"container_end[]"..
			string.format("label[0,3.5;%s]", T{"Seat Distribution:"}) ..
			"container[0,4]"..
			chart..
			"container_end[]"..
			"container[5,0]"..
			party..
			"container_end[]"
		, true)
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		local plyrname = plyr:get_player_name()
		local prty = nil
		for k,v in pairs(fields) do
			if ul_market.registered_parties[k] then
				prty = k
			end
		end
		if prty then
			selected_party[plyrname] = prty
			sfinv.set_page(plyr, "ul_market:inv_govt")
			return
		end
		if fields.ul_fund_party and selected_party[plyrname] and ul_market.get_wallet(plyrname) > 500 then
			ul_market.get_portfolio(plyrname).wallet = ul_market.get_wallet(plyrname) - 500
			ul_market.save_portfolios()
			ul_market.add_party_bonus(selected_party[plyrname], 0.1)
		end
		sfinv.set_page(plyr, "ul_market:inv_govt")
	end,
	on_enter = function(self, plyr, context)
		opened[plyr:get_player_name()] = "ul_market:inv_govt"
	end,
	on_leave = function(self, plyr, context)
		opened[plyr:get_player_name()] = nil
	end
})

ul_market.register_marketstep(function()
	for plyrname,page in pairs(opened) do
		local plyr = core.get_player_by_name(plyrname)
		if page and plyr then
			sfinv.set_page(plyr, page)
		end
	end
end)