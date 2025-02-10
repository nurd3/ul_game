local goods_formspec = ""
local goods_prices = {}
local selected = {}
local opened = {}
local scrolls = {}
local T = function(s) return core.formspec_escape(ul_market.get_translator(s)) end

-- stolen from MT game's default/chests.lua
function ul_market.get_formspec_tradeinator(plyrname, pos)
	opened[plyrname] = pos
	local meta = core.get_meta(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local scroll = scrolls[plyrname] or 0.0
	local goods_formatted = goods_formspec
	local selected_formspec = ""

	local h = math.max(meta:get_inventory():get_size"fuel", 2)
	local w = 1
	if meta:get_inventory():get_size"fuel" == 4 then
		w = 2
	end

	if selected[plyrname] then
		local itm = core.registered_items[selected[plyrname]] or {}
		local price = ul_market.calculate_good_price(selected[plyrname])
		local name = itm.short_description or itm.description or selected[plyrname]

		selected_formspec = selected_formspec .. 
			string.format("label[0,0;%s]", name) .. 
			string.format("label[0,0.25;$%.2f]", price) ..
			string.format("button[0,0.5;2,1;ul_buy;%s]", T"Buy")
	end
	
	for i,_ in ipairs(goods_prices) do
		goods_prices[i] = ul_market.calculate_good_price(ul_market.goods_order[i])
	end

	local formspec =
		"size[8,10]" ..
		string.format("label[0,0;Wallet: $%.2f]", ul_market.get_wallet(plyrname)) ..
		string.format("tooltip[0,0;2,0.5;($%.2f) %i shares]", ul_market.calculate_player_value(plyrname), ul_market.get_portfolio_total_shares(plyrname)) ..
		"scrollbaroptions[max=".. (math.floor((#ul_market.goods_order - 1) / 3) * 8) .."]" ..
		"scrollbar[0,0.5;0.5,5;vertical;ul_goods;"..scroll.."]\n"..
		"scroll_container[0.5,1;10,5.7;ul_goods;vertical]\n"..
		string.format(goods_formatted, table.unpack(goods_prices))..
		"scroll_container_end[]\n"..
		"container[6,2.5]" ..
		selected_formspec ..
		"container_end[]" ..
		string.format("label[4,0.25;%s]", T"Inbox") ..
		string.format("tooltip[4,0.25;1,0.5;%s]", T"Bought items end up here.\nThis is also where you put items to sell.") ..
		string.format("button[4,4.75;2,1;ul_sell;%s]", T"Sell Inbox") ..
		string.format("tooltip[ul_sell;%s]", T"Sells the items in the Inbox.") ..
		"list[current_player;inbox;4,0.75;2,4;]" ..
		string.format("label[6,0;%s]", T"Fuel") ..
		string.format("tooltip[6,0;1,0.5;%s]", T"The Tradeinator requires lanterns to work") ..
		string.format("list[nodemeta:%s;fuel;6,0.5;%i,%i;]", spos, w, h) ..
		"list[current_player;main;0,5.85;8,1;]" ..
		"list[current_player;main;0,7.08;8,3;8]" ..
		"listring[current_player;inbox]" ..
		"listring[current_player;main]"
	return formspec
end

local function update_formspec(plyrname, pos)
	core.show_formspec(
		plyrname,
		"ul_market:formspec_tradeinator", 
		ul_market.get_formspec_tradeinator(plyrname, pos)
	)
end

local function compile_goods()
	for i,name in ipairs(ul_market.goods_order) do
		table.insert(goods_prices, 0.87)
		goods_formspec = goods_formspec.."container["..((i - 1) % 3 + 0.3)..","..(math.floor((i - 1) / 3)).."]\n"
		
		local itm, amt = core.registered_items[name]
		
		local img = itm.inventory_image
		
		if img == "" and itm.tiles then
			img = itm.tiles[1]
		end
		
		goods_formspec = goods_formspec.."image_button[0,0;1,1;"..img..";"..name..";]\n" .. 
			"tooltip["..name..";".. core.formspec_escape(itm.short_description or itm.description or i) .." $%.2f]"
		
		goods_formspec = goods_formspec.."container_end[]\n"
	end
end

local function get_fuel(pos)
	local inv = core.get_meta(pos):get_inventory()
	local max = 0

	for i,v in ipairs(inv:get_list"fuel") do
		if v:get_name() == "ul_basic:lantern" then
			max = max + (8 - math.floor(v:get_wear() / 65536 * 8))
		end
	end

	return max
end

local function wear_fuel(pos, amount)
	amount = amount or 1
	local inv = core.get_meta(pos):get_inventory()
	for i,v in ipairs(inv:get_list"fuel") do
		if amount > 0 and v:get_name() == "ul_basic:lantern" then
			local wear = math.ceil(v:get_wear() / 65536 * 8)
			v:add_wear(math.floor(amount / 8 * 65536))
			inv:set_stack("fuel", i, v)
			amount = amount - (8 - wear)
		end
	end
end

core.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_market:formspec_tradeinator" then
		return
	end
	
	local plyrname = plyr:get_player_name()
	
	if not plyrname or not opened[plyrname] then
		return
	end
	
	if fields.quit then
		opened[plyrname] = nil
		return
	end

	scrolls[plyrname] = fields.ul_goods and fields.ul_goods:sub(5)

	local new_selected = nil
	for k,v in pairs(fields) do
		if ul_market.registered_goods[k] then
			new_selected = k
		end
	end
	
	if new_selected then
		selected[plyrname] = new_selected
		update_formspec(plyrname, opened[plyrname])
	end
	
	if selected[plyrname] and fields.ul_buy then
		if get_fuel(opened[plyrname]) > 0 and ul_market.trade_buy(plyr, "inbox", selected[plyrname]) then
			wear_fuel(opened[plyrname])
		end
	end
	if fields.ul_sell then
		local inv = core.get_meta(opened[plyrname]):get_inventory()
		local max = get_fuel(opened[plyrname])
		local sold = ul_market.trade_sell_inv(plyr, "inbox", max)

		wear_fuel(opened[plyrname], sold)
	end
end)

core.register_on_mods_loaded(compile_goods)

core.register_on_joinplayer(function(plyr)
	local inv = plyr:get_inventory()
	inv:set_size("inbox", 2*4)
end)

ul_market.register_marketstep(function()
	for plyrname,pos in pairs(opened) do
		update_formspec(plyrname, pos)
	end
end)