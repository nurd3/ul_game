local storage = core.get_mod_storage()
local S = ul_market.get_translator

local events = core.deserialize(storage:get_string("events")) or {}
local event_bonuses = {overall = {chance = 1.0, intensity = 1.0}}

local function generate_random_company()
	return ul_market.stocks_order[math.random(#ul_market.stocks_order)]
end

local function generate_random_industry()
	local temp = {}

	for k,_ in pairs(ul_market.registered_industries) do
		table.insert(temp, k)
	end

	return temp[math.random(#temp)]
end

local event_bonus_calc = function(event_bonuses) 
	for k,v in pairs(ul_market.registered_events) do
		event_bonuses[k] = {chance = 1.0, intensity = 1.0}
	end
	return event_bonuses 
end
function ul_market.register_on_eventbonuscalc(func)
	local og = event_bonus_calc
	event_bonus_calc = function(event_bonuses)
		return func(og(event_bonuses) or event_bonuses)
	end
end

function ul_market.generate_event_target(target_table)
	if not target_table then
		return
	end
	local company = nil
	local industry = nil

	if target_table.company then
		company = generate_random_company()
	end
	if target_table.industry then
		industry = generate_random_industry()
	end

	if not company then
		company = industry
	elseif not industry then
		industry = company
	end

	if math.random() > 0.5 then
		return company
	end
	return industry
end

function ul_market.get_active_events()
	return events
end

function ul_market.get_active_event_bonuses()
	return event_bonus_calc({})
end

function ul_market.set_event_bonus(event_bonuses, event, t)
	event_bonuses[event] = event_bonuses[event] or {chance = 1, intensity = 1}
	event_bonuses[event].chance = t.chance or event_bonuses[event].chance
	event_bonuses[event].intensity = t.intensity or event_bonuses[event].intensity
end

function ul_market.add_event_bonus(event_bonuses, event, t)
	event_bonuses[event] = event_bonuses[event] or {chance = 1, intensity = 1}
	event_bonuses[event].chance = event_bonuses[event].chance + (t.chance or 0)
	event_bonuses[event].intensity = event_bonuses[event].intensity + (t.intensity or 0)
end


function ul_market.get_event_bonus(event)
	event_bonuses[event] = event_bonuses[event] or {chance = 1, intensity = 1}
	event_bonuses.overall = event_bonuses.overall or {chance = 1, intensity = 0}
	return {chance = event_bonuses[event].chance * event_bonuses.overall.chance, intensity = event_bonuses[event].intensity * event_bonuses.overall.intensity}
end

function ul_market.generate_random_event(event_bonuses)
	local temp = {}

	for k,v in pairs(event_bonuses) do
		local def = ul_market.registered_events[k]
		if k ~= "overall"
		and (not def or not def.disable_random)
		and math.random() * v.chance * event_bonuses.overall.chance > math.random() * 5
		then
			table.insert(temp, k)
		end
	end

	return temp[math.random(#temp)]
end

function ul_market.generate_event(event)
	local event_bonuses = event_bonus_calc({})
	event = event or ul_market.generate_random_event(event_bonuses)
	if not event then
		return
	end
	local intensity = math.random() * ul_market.get_event_bonus(event).intensity
	local def = ul_market.registered_events[event] or {title = event, description = "N/A"}
	local target = ul_market.generate_event_target(def.target)
	ul_market.add_intensity(event, intensity, target)

	if target then
		local tgtname = (ul_market.registered_companies[target] or ul_market.registered_industries[target] or {title = target}).title
		local dsc = def.target_description and S(def.target_description, tgtname) or S("@1 in @2", def.description, tgtname)
		ul_market.broadcast(
			string.format("%s! %s! (%.2f) [%s]", def.title, dsc, intensity, S"NEWS")
		)
	else
		ul_market.broadcast(
			string.format("%s! %s! (%.2f) [%s]", def.title, def.description, intensity, S"NEWS")
		)
	end

end

function ul_market.add_intensity(event, intensity, target)
	local def = ul_market.registered_events[event]
	if not def then
		return
	end
	if not events[event] then
		events[event] = {}
	end
	if not def.target or not target then
		events[event] = {overall = (events[event].overall or 0) + intensity}
		return
	end
	events[event][target] = (events[event][target] or 0) + intensity
	storage:set_string("events", core.serialize(events))
end

function ul_market.set_intensity(event, intensity, target)
	local def = ul_market.registered_events[event]
	if not def then
		return
	end
	if not def.target then
		events[event] = {overall = intensity}
		return
	end
	if not target then
		target = ul_market.generate_event_target(def.target)
	end
	if not events[event] then
		events[event] = {[target] = intensity}
		return
	end
	events[event][target] = intensity
	storage:set_string("events", core.serialize(events))
end

core.register_on_mods_loaded(function()
	for k,v in pairs(events) do
		if not ul_market.registered_events[k] then
			v = nil
		end
	end
	for k,v in pairs(ul_market.registered_events) do
		event_bonuses[k] = {chance = 1.0, intensity = 1.0}
	end
end)

ul_market.register_marketstep(function()
	for k,t in pairs(events) do
		local sum = 0
		for n,v in pairs(t) do
			if math.random() < 0.5 and v then
				t[n] = v - 0.01 * math.max(v, 5)
			end
			sum = sum + math.max(t[n], 0)
			if t[n] and t[n] <= 0 then
				local def = ul_market.registered_events[k] or {title = event, description = "N/A"}
				if n == "overall" then
					ul_market.broadcast(
						string.format("%s Ended! %s no more! [%s]", def.title, def.description, S"NEWS")
					)
				else
					local tgtname = (ul_market.registered_companies[n] or ul_market.registered_industries[n] or {title = n}).title
					ul_market.broadcast(
						string.format("%s Ended! %s in %s no more! [%s]", def.title, def.description, tgtname, S"NEWS")
					)
				end
				t[n] = nil
			end
		end
		if sum <= 0 then
			events[k] = nil
		end
	end
	if math.random() < 0.4 then
		storage:set_string("events", core.serialize(events))
		core.after(math.random() * 120, ul_market.generate_event)
	end
end)