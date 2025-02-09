local storage = core.get_mod_storage()

local industries = {}
local companies = {}
local updated_industries = {}
local updated_companies = {}

-- Basic Utility function for getting the sign of a number
local function sign(number)
	return (number == 0 and 0) or (number > 0 and 1) or -1
end

local function update_industry(name)
	if not industries[name] then
		industries[name] = {table.unpack(updated_industries[name])}
		return
	end
	local table = industries[name]
	local updated = updated_industries[name]
	for k,v in pairs(updated) do
		table[k] = v
	end
end

local function update_company(name)
	if not companies[name] then
		companies[name] = {table.unpack(updated_companies[name])}
		return
	end
	local table = companies[name]
	local updated = updated_companies[name]
	for k,v in pairs(updated) do
		table[k] = v
	end
end

local marketstep = function() end
function ul_market.register_marketstep(func)
	local og = marketstep
	marketstep = function()
		og()
		func()
	end
end

local timer = 1.1
local save_counter = 0

local function step()
	save_counter = save_counter + 1
	local index = 1
	for k,v in pairs(updated_industries) do
		update_industry(k)
		core.after((index + math.random()) * 0.1, function(k, v)
			ul_market.apply_policies(v)
			ul_market.calculate_stats(v)
			ul_market.industry_apply_events(k, v)
			v.supply = math.min(math.max(v.supply, -1.0), 10.0)
			v.demand = math.min(math.max(v.demand, -1.0), 10.0)
			v.strive = math.min(math.max(v.strive, -1.0), 10.0)
			v.cline = math.min(math.max(v.cline, -1.0), 10.0)
		end, k, v)
		if save_counter > 4 then
			core.after((index + math.random()) * 0.5, storage.set_string, storage, string.format("industry:%s", k), core.serialize(v))
		end
		index = index + 1
	end
	index = 1
	for k,v in pairs(updated_companies) do
		update_company(k)
		core.after((index + math.random()) * 0.1, function(k, v)
			ul_market.apply_policies(v)
			ul_market.company_apply_events(k, v)
			ul_market.calculate_stats(v)
			v.supply = math.min(math.max(v.supply, -1.0), 10.0)
			v.demand = math.min(math.max(v.demand, -1.0), 10.0)
			v.strive = math.min(math.max(v.strive, -1.0), 10.0)
			v.cline = math.min(math.max(v.cline, -1.0), 10.0)
		end, k, v)
		if save_counter > 4 then
			core.after((index + math.random()) * 0.5, storage.set_string, storage, string.format("company:%s", k), core.serialize(v))
		end
		index = index + 1
	end
	if save_counter > 4 then
		save_counter = 0
	end
	marketstep()
end

core.register_globalstep(function (dtime) timer = timer + dtime; if timer > 1.0 then step(); timer = 0.0 end end)

function ul_market.reset_market()
	storage:set_string("reset", "true")
	core.request_shutdown(
		ul_market.get_translator"Market reset, server must be restarted."
	)
end

function ul_market.calculate_price(t)
	if not t.demand then return 0.87 end
	if not t.supply then return 1000000000000 end
	return math.max(t.base_price * (t.demand / t.supply), 0.87)
end

function ul_market.get_industry_price(name)
	if name and industries[name] then
		return ul_market.calculate_price(industries[name])
	end
	return 0.87
end

function ul_market.calculate_company_price(name)
	local cmp = ul_market.registered_companies[name]
	local bonus = companies[name]
	local sum = 0
	local count = 0
	if not cmp or not cmp.shares then
		return 0.87
	end
	for k,v in pairs(cmp.shares) do
		count = count + v
		sum = sum + v * ul_market.get_industry_price(k)
	end
	
	local price = (sum / count)
	if bonus then
		price = ul_market.calculate_price({base_price = price, supply = bonus.supply, demand = bonus.demand})
	end

	return math.max(price, 0.87)
end

function ul_market.calculate_company_value(name)
	local cmp = ul_market.registered_companies[name]
	local bonus = companies[name]
	local sum = 0
	if not cmp.shares then
		return 0.87
	end
	for k,v in pairs(cmp.shares) do
		sum = sum + v * ul_market.get_industry_price(k)
	end

	if bonus then
		sum = ul_market.calculate_price({base_price = sum, supply = bonus.supply, demand = bonus.demand})
	end

	return math.max(sum, 0.87)
end

local market_acceleration = 1

-- calculates the changes of the stats
-- explanation:
-- 	misc.
--		 chaos: constant, makes small variations more extreme
--	stabilization - hovering around the base_price
-- 		supply: approaches strive, makes things cheaper
-- 		demand: approaches cline, makes things costlier
-- 		strive: approaches demand, attracts businesses
-- 		 cline: approaches supply, attracts customers
-- 	trends - the general longterm movements
-- 		s_dest: short for supply destination, where the supply stat is going towards
--		  push: how fast the supply approaches s_dest
-- 		d_dest: short for demand destination, where the demand stat is going towards
--		  pull: how fast the demand approaches d_dest
function ul_market.calculate_stats(t)
	local save = false

	-- check if a new supply destination needs to be set
	if not t.s_dest or math.abs(t.supply - t.s_dest) < 0.1 then
		t.s_dest = math.random(1.0, 500.0) * 0.01
		t.push = nil
	end
	-- check if a new demand destination needs to be set
	if not t.d_dest or math.abs(t.demand - t.d_dest) < 0.1 then
		t.d_dest = math.random(1.0, 500.0) * 0.01
		t.pull = nil
	end

	-- make sure push and pull are defined
	if not t.push then t.push = math.random() end
	if not t.pull then t.pull = math.random() end

	local chaos = (t.chaos * 0.1) * market_acceleration
	-- stabilization & chaos
	t.supply = t.supply + (t.strive - t.supply) * 0.1 	+ chaos * (math.random() - math.random()) -- math.random() - math.random() gives us a float from -1 to 1
	t.demand = t.demand + (t.cline - t.demand) * 0.1 	+ chaos * (math.random() - math.random())
	t.strive = t.strive + (t.demand - t.strive) * 0.1 	+ chaos * (math.random() - math.random())
	t.cline = t.cline 	+ (t.supply - t.cline) * 0.1 	+ chaos * (math.random() - math.random())

	-- general trend
	t.supply = t.supply + sign(t.s_dest - t.supply) * 0.5 * t.push * market_acceleration
	t.demand = t.demand + sign(t.d_dest - t.demand) * 0.5 * t.pull * market_acceleration

	return save
end

function ul_market.apply_policies(t)
	for name,intensity in pairs(ul_market.get_active_policies()) do
		local def = ul_market.registered_policies[name]

		if def and def.effect_groups then
			local fx = {strive = 0, cline = 0}
			for group,relation in pairs(t.groups) do
				if def.effect_groups[group] then
					fx.strive = fx.strive + def.effect_groups[group].strive * intensity * relation
					fx.cline = fx.cline + def.effect_groups[group].cline * intensity * relation
				end
			end
			if fx.strive == 0 and fx.cline == 0 and def.effect_groups.overall then
				fx.strive = fx.strive + def.effect_groups.overall.strive * intensity
				fx.cline = fx.cline + def.effect_groups.overall.cline * intensity
			end
			t.strive = t.strive + fx.strive * market_acceleration
			t.cline = t.cline + fx.cline * market_acceleration
		end
	end
end

function ul_market.company_apply_events(company, t)
	for name,table in pairs(ul_market.get_active_events()) do
		local def = ul_market.registered_events[name]
		local intensity = table.overall

		if table[company] then
			intensity = table[company] * def.target.company
		end

		if def and def.effect_groups and intensity then
			local fx = {strive = 0, cline = 0}
			for group,relation in pairs(t.groups) do
				if def.effect_groups[group] then
					fx.strive = fx.strive + def.effect_groups[group].strive * intensity * relation
					fx.cline = fx.cline + def.effect_groups[group].cline * intensity * relation
				end
			end
			if fx.strive == 0 and fx.cline == 0 and def.effect_groups.overall then
				fx.strive = fx.strive + def.effect_groups.overall.strive * intensity
				fx.cline = fx.cline + def.effect_groups.overall.cline * intensity
			end
			t.strive = t.strive + fx.strive * market_acceleration
			t.cline = t.cline + fx.cline * market_acceleration
		end

	end
end

function ul_market.industry_apply_events(industry, t)
	for name,table in pairs(ul_market.get_active_events()) do
		local def = ul_market.registered_events[name]
		local intensity = table.overall

		if def and table[industry] then
			intensity = table[industry] * def.target.industry
		end

		if def and def.effect_groups and intensity then
			local fx = {strive = 0, cline = 0}
			for group,relation in pairs(t.groups) do
				if def.effect_groups[group] then
					fx.strive = fx.strive + def.effect_groups[group].strive * intensity * relation
					fx.cline = fx.cline + def.effect_groups[group].cline * intensity * relation
				end
			end
			if fx.strive == 0 and fx.cline == 0 and def.effect_groups.overall then
				fx.strive = fx.strive + def.effect_groups.overall.strive * intensity
				fx.cline = fx.cline + def.effect_groups.overall.cline * intensity
			end
			t.strive = t.strive + fx.strive
			t.cline = t.cline + fx.cline
		end

	end
end

core.register_on_mods_loaded(function()
	for k,v in pairs(ul_market.registered_industries) do
		local stats = v.stats or {}
		local stored = storage:get("industry:"..k)
		if stored then
			stored = core.deserialize(stored)
			stats.supply = stored.supply
			stats.demand = stored.demand
			stats.strive = stored.strive
			stats.cline = stored.cline
			stats.push = stored.push
			stats.pull = stored.pull
			stats.s_dest = stored.s_dest
			stats.d_dest = stored.d_dest
		end
		updated_industries[k] = {
			chaos = stats.chaos or 1.0,
			base_price = stats.base_price or 1.0,
			supply = stats.supply or 1.0,
			demand = stats.demand or 1.0,
			strive = stats.strive or 1.0,
			cline = stats.cline or 1.0,
			groups = v.groups or {}
		}
	end
	for k,v in pairs(ul_market.registered_companies) do
		local stats = v.stats or {}
		local stored = storage:get("company:"..k)
		if stored then
			stored = core.deserialize(stored)
			stats.supply = stored.supply
			stats.demand = stored.demand
			stats.strive = stored.strive
			stats.cline = stored.cline
			stats.push = stored.push
			stats.pull = stored.pull
			stats.s_dest = stored.s_dest
			stats.d_dest = stored.d_dest
		end
		updated_companies[k] = {
			chaos = stats.chaos or 1.0,
			base_price = stats.base_price or 1.0,
			supply = stats.supply or 1.0,
			demand = stats.demand or 1.0,
			strive = stats.strive or 1.0,
			cline = stats.cline or 1.0,
			groups = v.groups or {}
		}
	end
end)