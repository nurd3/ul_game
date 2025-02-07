ul_market.registered_industries = {}
ul_market.registered_companies = {}
ul_market.registered_goods = {}
ul_market.registered_events = {}
ul_market.registered_policies = {}
ul_market.registered_parties = {}
ul_market.stocks_order = {}
ul_market.goods_order = {}
ul_market.party_order = {}

function ul_market.register_industry(name, def)
	ul_market.registered_industries[name] = def
end

function ul_market.register_company(name, def)
	if not ul_market.registered_companies[name] then
		table.insert(ul_market.stocks_order, name)
	end
	ul_market.registered_companies[name] = def
	table.sort(ul_market.stocks_order)
end

function ul_market.register_goods(def)
	local industry = def.industry

	for item,stats in pairs(def.items) do
		if not ul_market.registered_goods[item] then
			ul_market.registered_goods[item] = {[industry] = {supply = 0, demand = 0}}
			table.insert(ul_market.goods_order, item)
		end
		ul_market.registered_goods[item][industry] = {supply = stats.supply, demand = stats.demand}

	end
	
	table.sort(ul_market.goods_order)
end

function ul_market.register_event(name, def)
	ul_market.registered_events[name] = def
end

function ul_market.register_policy(name, def)
	ul_market.registered_policies[name] = def
end

function ul_market.register_party(name, def)
	if not ul_market.registered_parties[name] then
		table.insert(ul_market.party_order, name)
	end
	ul_market.registered_parties[name] = def
end