local S = ul_market.get_translator

ul_market.registered_industries = {}
ul_market.registered_companies = {}
ul_market.registered_goods = {}
ul_market.registered_events = {}
ul_market.registered_policies = {}
ul_market.registered_parties = {}

ul_market.stocks_order = {}
ul_market.goods_order = {}
ul_market.policy_order = {}
ul_market.party_order = {}

-- from luanti/builtin/game/register.lua:57
local function check_modname_prefix(name)
	if name:sub(1,1) == ":" then
		-- If the name starts with a colon, we can skip the modname prefix
		-- mechanism.
		return name:sub(2)
	else
		-- Enforce that the name starts with the correct mod name.
		local expected_prefix = core.get_current_modname() .. ":"
		if name:sub(1, #expected_prefix) ~= expected_prefix then
			error("Name " .. name .. " does not follow naming conventions: " ..
			"\"" .. expected_prefix .. "\" or \":\" prefix required")
		end

		-- Enforce that the name only contains letters, numbers and underscores.
		local subname = name:sub(#expected_prefix+1)
		if subname:find("[^%w_]") then
			error("Name " .. name .. " does not follow naming conventions: " ..
			"contains unallowed characters")
		end

		return name
	end
end

function ul_market.register_industry(name, def)
	if name == nil then
		error("ul_market.register_industry: Name is nil")
	end
	name = check_modname_prefix(tostring(name))
	
	ul_market.registered_industries[name] = def
	def.mod_origin = core.get_current_modname() or "??"
end

function ul_market.register_company(name, def)
	if name == nil then
		error("ul_market.register_company: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_market.registered_companies[name] then
		table.insert(ul_market.stocks_order, name)
	end

	ul_market.registered_companies[name] = def
	def.mod_origin = core.get_current_modname() or "??"

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
	if name == nil then
		error("ul_market.register_event: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	ul_market.registered_events[name] = def
end

function ul_market.register_policy(name, def)
	if name == nil then
		error("ul_market.register_policy: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_market.registered_policies[name] then
		table.insert(ul_market.policy_order, name)
	end

	ul_market.registered_policies[name] = def
	def.mod_origin = core.get_current_modname() or "??"

	table.sort(ul_market.policy_order)
end

function ul_market.register_party(name, def)
	if name == nil then
		error("ul_market.register_party: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_market.registered_parties[name] then
		table.insert(ul_market.party_order, name)
	end

	ul_market.registered_parties[name] = def
	def.mod_origin = core.get_current_modname() or "??"

	local title = def.short_title or def.title or name
	local color = def.color or "#ffffff"

	core.register_craftitem(name .. "_card", {
		short_description = S("@1 Card", title),
		stack_max = 65535,
		description = S("@1 Card\nSexonland Political Trading Cards\nUse to fund @2", title, def.title or name),
		inventory_image = "ul_market_card.png^[multiply:" .. color,
		party = name,
		on_use = function(stack, user, pointed_thing)
			stack:take_item()
			ul_market.add_party_bonus(name, 0.1)
			return stack
		end
	})
end