local news_log = {
	"...",
	"...",
	"...",
	"...",
	"..."
}
local hud_ids = {}

core.register_on_joinplayer(function(plyr)
	local name = plyr:get_player_name()
	
	hud_ids[name] = plyr:hud_add({
		type = "text",
		hud_elem_type = "text",
		alignment = {x=-1, y=0},
		position = {x=1, y=0.5},
		name = "news",
		scale = {x = 1, y = 1},
		text = "",
		number = 0xffffff,
		direction = 0,
		offset = {x = -10, y= -10},
	})
end)

function ul_market.broadcast(txt)
	table.insert(news_log, txt)
	if #news_log > 5 then
		table.remove(news_log, 1)
	end
	for _,plyr in ipairs(core.get_connected_players()) do
		local name = plyr:get_player_name()
		plyr:hud_change(hud_ids[name], "text", table.concat(news_log, "\n"))
	end
end