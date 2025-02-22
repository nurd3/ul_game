xplib.register_on_update(function(plyrname, reason, xp, lvl, total)
	if reason.lvlchange >= 1 and lvl % 3 == 0 then
		local plyr = core.get_player_by_name(plyrname)
		ul_basic.give_or_drop(plyr:get_inventory(), "main", plyr:get_pos(), 2, ItemStack"ul_tower:tower")
	end
end)