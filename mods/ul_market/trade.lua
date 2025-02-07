function ul_market.calculate_good_price(item)
	if not item or not ul_market.registered_goods[item] then
		return 0.87
	end
	local supply = 0
	local demand = 0
	for industry,stats in pairs(ul_market.registered_goods[item]) do
		supply = supply + ul_market.get_industry_price(industry) * (stats.supply or 0)
		demand = demand + ul_market.get_industry_price(industry) * (stats.demand or 0)
	end
	if supply == 0 then
		return 1000000000000
	end
	return math.max(10 * (demand / supply), 0.87)
end

function ul_market.trade_buy(plyr, list, item, amount)
	if not amount then
		amount = 1
	end
	local wallet = ul_market.get_wallet(plyr:get_player_name())
	local cost = ul_market.calculate_good_price(item) * amount
	local inv = plyr:get_inventory()
	local stack = ItemStack(item.." "..tostring(amount))

	if wallet < cost or not inv:room_for_item(list, stack) then
		return false
	end
	ul_market.get_portfolio(plyr:get_player_name()).wallet = wallet - cost
	inv:add_item(list, stack)
	return true
end

function ul_market.trade_sell(plyr, list, item, amount)
	if not amount then
		amount = 1
	end
	local wallet = ul_market.get_wallet(plyr:get_player_name())
	local inv = plyr:get_inventory()
	local stack = ItemStack(item.." "..tostring(amount))

	if not inv:contains_item(list, stack, true) then
		return
	end

	local main_list = inv:get_list(list)
	local count = amount
	for i,v in ipairs(main_list) do
		if count > 0 and v:get_name() == item and v:get_meta():get_string("") == "" then
			v:set_count(math.max(v:get_count() - count, 0))
			inv:set_stack(list, i, v)
			count = count - v:get_count()
		end
	end
	
	ul_market.get_portfolio(plyr:get_player_name()).wallet = wallet + ul_market.calculate_good_price(item) * amount
	ul_market.save_portfolios()
end

function ul_market.trade_sell_inv(plyr, list, maximum)
	local wallet = ul_market.get_wallet(plyr:get_player_name())
	local inv = plyr:get_inventory()

	if inv:is_empty(list) then
		return 0
	end

	local main_list = inv:get_list(list)
	local count = 0
	for i,v in ipairs(main_list) do
		if count >= maximum then
			ul_market.get_portfolio(plyr:get_player_name()).wallet = wallet
			ul_market.save_portfolios()
			return count
		end
		if #v:get_meta():get_keys() == 0 then
			local taken = maximum and math.min(v:get_count(), maximum - count) or v:get_count()
			count = count + taken
			wallet = wallet + ul_market.calculate_good_price(v:get_name()) * taken
			v:take_item(taken)
			inv:set_stack(list, i, v)
		end
	end
	
	ul_market.get_portfolio(plyr:get_player_name()).wallet = wallet
	ul_market.save_portfolios()

	return count
end