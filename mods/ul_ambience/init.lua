local function global_sound(sound, gain, pitch)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		pos.y = pos.y + 1.625
		if pos.y < -5 then
			minetest.sound_play(sound, {to_player = player:get_player_name(), gain=gain, pitch=pitch})
		end
	end
end

local music_timer = 179.5

minetest.register_globalstep(function(dtime)
	music_timer = music_timer + dtime
	
	if music_timer > 180 then
		global_sound("ul_music", 0.25, 1.0)
		music_timer = math.random(-180, 0)
	end
	
end)