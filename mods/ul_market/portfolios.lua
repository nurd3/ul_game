local storage = core.get_mod_storage()

local portfolios = core.deserialize(storage:get_string("portfolios")) or {}

function ul_market.get_portfolio_or_nil(plyrname)
	if plyrname and portfolios[plyrname] then
		return portfolios[plyrname]
	end
end

function ul_market.get_portfolio(plyrname)
	if not plyrname then
		return
	end
	
	if not portfolios[plyrname] then
		portfolios[plyrname] = {wallet = 0.0, companies = {}}
	end
	return portfolios[plyrname]
end

function ul_market.get_wallet(plyrname)
	if not plyrname then
		return
	end
	
	if not portfolios[plyrname] then
		portfolios[plyrname] = {wallet = 0.0, companies = {}}
	end
	return portfolios[plyrname].wallet or 0
end

function ul_market.get_portfolio_total_shares(plyrname)
	local portfolio = ul_market.get_portfolio_or_nil(plyrname)
	local amount = 0
	if portfolio then
		for k,v in pairs(portfolio.companies) do
			amount = amount + v
		end
	end
	return amount
end

function ul_market.calculate_player_value(plyrname)
	local portfolio = ul_market.get_portfolio_or_nil(plyrname)
	local value = 0
	if portfolio then
		for k,v in pairs(portfolio.companies) do
			value = value + v * ul_market.calculate_company_price(k)
		end
	end
	return value
end

function ul_market.save_portfolios()
	storage:set_string("portfolios", core.serialize(portfolios))
end

function ul_market.portfolio_buy(plyrname, company, amount)
	if not plyrname or not company then
		return
	elseif not amount then
		amount = 1
	end
	local cost = ul_market.calculate_company_price(k) * amount
	local portfolio = ul_market.get_portfolio(plyrname)
	if portfolio.wallet < cost then
		return false
	end
	portfolio.companies[company] = (portfolios[plyrname].companies[company] or 0) + amount
	portfolio.wallet = (portfolio.wallet or 0) - cost
	ul_market.save_portfolios()
	return true
end

function ul_market.portfolio_sell(plyrname, company, amount)
	if not plyrname or not company then
		return
	elseif not amount then
		amount = 1
	end
	local portfolio = ul_market.get_portfolio(plyrname)
	if not portfolio.companies[company] or portfolio.companies[company] < amount then
		return false
	end
	portfolio.companies[company] = portfolios[plyrname].companies[company] - amount
	portfolio.wallet = (portfolio.wallet or 0) + ul_market.calculate_company_price(company) * amount
	ul_market.save_portfolios()
	return true
end

function ul_market.get_portfolio_shares(plyrname, company)
	local portfolio = ul_market.get_portfolio_or_nil(plyrname)
	return portfolio and portfolio.companies and portfolio.companies[company]
end

core.register_on_dieplayer(function (plyr)
	local plyrname = plyr:get_player_name()
	ul_market.get_portfolio(plyrname).wallet = ul_market.get_wallet(plyrname) - 500
	ul_market.save_portfolios()
end)