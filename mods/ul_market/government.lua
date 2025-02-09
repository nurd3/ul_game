local storage = core.get_mod_storage()
local S = ul_market.get_translator

local policies = core.deserialize(storage:get_string("policies")) or {}
local parties = core.deserialize(storage:get_string("parties")) or {}
local party_bonus = core.deserialize(storage:get_string("party_bonus")) or {}
local till_election = storage:get("election") or 60
local unrest_bonus = storage:get("unrest_bonus") or 0

local function sign(number)
	return (number == 0 and 0) or (number > 0 and 1) or -1
end
local function generate_random_party()
	local temp = {}

	for k,_ in pairs(parties) do
		table.insert(temp, k)
	end

	return temp[math.random(#temp)]
end

local function generate_random_party_policy(party)
	local temp = {}

	for k,v in pairs(ul_market.registered_parties[party].policies) do
		if (policies[k] or 0) ~= v then
			table.insert(temp, k)
		end
	end

	if #temp < 0 then return end
	local ret = temp[math.random(#temp)]
	return ret, ul_market.registered_parties[party].policies[ret]
end

local function vote(policy, intensity)
	local aye, nay, tbd = 0, 0, 0
	local current = policies[policy] or 0

	for party,seats in pairs(parties) do
		if seats and ul_market.registered_parties[party] then
			local stance = ul_market.registered_parties[party].policies[policy]
			if stance then
				if math.abs(stance - current) < math.abs(stance - intensity) then
					nay = nay + seats
				elseif math.abs(stance - current) > math.abs(stance - intensity) then
					aye = aye + seats
				else
					nay = nay + math.ceil(seats * 0.5)
					aye = aye + math.floor(seats * 0.5)
				end
			else
				tbd = tbd + seats
			end
		end
	end

	local ratio = math.min(nay / aye, aye / nay)
	if nay > aye then
		nay = nay + math.ceil(tbd * (1 - ratio))
		aye = aye + math.floor(tbd * ratio)
	else
		nay = nay + math.ceil(tbd * ratio)
		aye = aye + math.floor(tbd * (1 - ratio))
	end

	return aye > nay, aye, nay
end

local function get_unrest()
	local ret = 0
	for n,t in pairs(ul_market.get_active_events()) do
		local amt = 0
		for _,v in pairs(t) do
			amt = amt + v
		end
		ret = ret + amt * ul_market.registered_events[n].unrest
	end
	
	return ret + unrest_bonus
end

local function get_party_extremeness(party)
	local ret = 0
	for policy,current in pairs(policies) do
		local stance = ul_market.registered_parties[party].policies[policy]
		if stance then
			ret = ret + math.abs(stance - current)
		end
	end

	return ret
end

function ul_market.election()
	local unrest = get_unrest()
	local total = 0
	local min_dist = math.huge
	local dists = {}
	local biggest_party = ""

	for party,_ in pairs(parties) do
		dists[party] = math.abs(unrest - get_party_extremeness(party)) - ul_market.get_party_bonus(party)
		party_bonus[party] = nil
		min_dist = min_dist < dists[party] and min_dist or dists[party]
	end
	local max_dist = 0
	for party,dist in pairs(dists) do
		dists[party] = math.max(dist - min_dist, 0)
		max_dist = math.max(max_dist, dists[party])
		total = total + dists[party]
	end

	local count = 0
	for party,dist in pairs(dists) do
		parties[party] = parties[party] + math.floor((math.floor((max_dist - dist) / total * 1000 + 0.5) - parties[party]) * 0.5 + 0.5)
		count = count + parties[party]
	end
	local new_count = 0
	for party,dist in pairs(parties) do
		parties[party] = math.floor(dist / count * 1000 + 0.5)
		new_count = new_count + parties[party]
	end

	local party = generate_random_party()
	parties[party] = parties[party] - sign(new_count - 1000)

	storage:set_string("parties", core.serialize(parties))
	storage:set_string("party_bonus", core.serialize(party_bonus))
	ul_market.set_unrest_bonus(0)
	ul_market.broadcast(string.format("%s [%s]",
		S"Election!",
		S"NEWS"
	))
end

function ul_market.get_parties()
	return parties
end

function ul_market.set_unrest_bonus(bonus)
	unrest_bonus = bonus
	storage:set_int("unrest_bonus", unrest_bonus)
end

function ul_market.add_unrest_bonus(bonus)
	unrest_bonus = unrest_bonus + bonus
	storage:set_int("unrest_bonus", unrest_bonus)
end

function ul_market.get_unrest_bonus()
	return unrest_bonus
end

function ul_market.set_party_bonus(party, bonus)
	party_bonus[party] = bonus
	storage:set_string("party_bonus", core.serialize(party_bonus))
end

function ul_market.add_party_bonus(party, bonus)
	party_bonus[party] = ul_market.get_party_bonus(party) + bonus
	storage:set_string("party_bonus", core.serialize(party_bonus))
end

function ul_market.get_party_bonus(party)
	return party_bonus[party] or 0
end

function ul_market.get_party_seats(party)
	return parties[party]
end

function ul_market.get_active_policies()
	return policies
end

function ul_market.set_policy(policy, intensity)
	policies[policy] = intensity
	storage:set_string("policies", core.serialize(policies))
end

function ul_market.vote_on_policy(policy, intensity)
	local passed, aye, nay = vote(policy, intensity)
	local prev = policies[policy] or 0
	if passed then
		ul_market.set_policy(policy, intensity)
		ul_market.broadcast(string.format("%s %s %i -> %i! (%i/%i) [%s]",
			S"Law Passed!",
			ul_market.registered_policies[policy].title or policy,
			prev,
			intensity,
			aye,
			nay,
			S"NEWS"
		))
	else
		ul_market.broadcast(string.format("%s %s %i -> %i! (%i/%i) [%s]",
			S"Law Rejected!",
			ul_market.registered_policies[policy].title or policy,
			prev,
			intensity,
			aye,
			nay,
			S"NEWS"
		))
	end
end

core.register_on_mods_loaded(function()
	for k,v in pairs(policies) do
		if not ul_market.registered_policies[k] or v == 0 then
			v = nil
		end
	end
	for k,v in pairs(ul_market.registered_parties) do
		if not parties[k] then
			parties[k] = v.starting_seats
		end
	end
	for k,v in pairs(parties) do
		if not ul_market.registered_parties[k] then
			parties[k] = nil
		end
	end
	storage:set_string("parties", core.serialize(parties))
	if type(unrest_bonus) ~= "number" then
		ul_market.set_unrest_bonus(tonumber(unrest_bonus) or 0)
	end
end)

ul_market.register_marketstep(function()
	if math.random() < 0.1 then
		local tries = 5
		local policy, intensity = generate_random_party_policy(generate_random_party())
		policy, intensity = generate_random_party_policy(generate_random_party())
		tries = tries - 1
		if not policy or not intensity then
			return
		end
		intensity = (policies[policy] or 0) + sign(intensity - (policies[policy] or 0))
		core.after(math.random() * 10, ul_market.vote_on_policy, policy, intensity)
	end
end)

ul_market.register_marketstep(function()
	till_election = till_election - 1
	if till_election < 0 then
		ul_market.election()
		till_election = 60
	end
	storage:set_int("election", till_election)
end)

ul_market.register_on_eventbonuscalc(function(event_bonuses)
	for policy,intensity in pairs(policies) do
		local def = ul_market.registered_policies[policy]
		if def then
			for event,t in pairs(def.effect_events) do
				ul_market.add_event_bonus(event, t)
			end
		end
	end
	return event_bonuses
end)