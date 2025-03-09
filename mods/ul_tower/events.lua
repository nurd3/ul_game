local storage = core.get_mod_storage()
local S = ul_tower.get_translator

local broadcast = ul_market.broadcast

ul_market.register_event("ul_tower:event_explosion", {
	title = S"Secret Explosion",
	description = S"Shhh...",
	effect_groups = {
		overall = {strive = 0, cline = 500.0}
	},
	target = {
		company = 1,
		industry = 1
	},
	disable_random = true,
	unrest = 0
})

local function do_events(reason)
	if reason == "reset"
	then storage:set_int("events_last_update", 0)
		return
	end

	local level = ul_tower.get_height()
	local last_update = storage:get_int("events_last_update")

	core.log(last_update)

	if reason == "set_pos"
	then broadcast(S"Tower! The first piece of the tower has been placed! [NEWS]")
	elseif last_update < 4
	and level >= 4
	then
		ul_market.add_intensity("ul_tower:event_explosion", 800, "ul_market:company_llan")
	end

	storage:set_int("events_last_update", level)
end

ul_tower.register_on_towerupdate(do_events)