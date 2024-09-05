ul_ambience = {}

function ul_ambience.register_ambience(sound, gain, pitch, min_delay, variance, play_on_open)
	local tbl = {}
	local min_delay = min_delay or 60
	local variance = variance or 0
	local play_on_open = play_on_open or false
	minetest.register_globalstep(function(dtime)
		for _,plyr in ipairs(minetest.get_connected_players()) do
			local name = plyr:get_player_name()
			if not play_on_open and not tbl[name] then
				tbl[name] = math.random(-(variance * 0.25), 0)
			end
			if not tbl[name] or tbl[name] > min_delay then
				minetest.sound_play(sound, {to_player = plyr:get_player_name(), gain=gain, pitch=pitch})
				tbl[name] = math.random(-(variance * 0.25), 0)
			end
			tbl[name] = tbl[name] + dtime
		end
	end)
end

ul_ambience.register_ambience("ul_ambience", 0.1, 1.0, 15, 120)