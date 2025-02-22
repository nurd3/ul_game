xplib = {}

local storage = core.get_mod_storage()

local function lvl2xp(lvl)
	local xp = 0
	while lvl > 1 do
		lvl = lvl - 1
		xp = xp + lvl * 100
	end
	return xp
end

local function xp2lvl(xp)
	local lvl = 1
	while xp >= lvl * 100 do
		xp = xp - lvl * 100
		lvl = lvl + 1
	end
	return lvl
end

local function xpmod(xp)
	local lvl = 1
	while xp >= lvl * 100 do
		xp = xp - lvl * 100
		lvl = lvl + 1
	end
	return xp
end

local function xpfrac(xp)
	return xpmod(xp) / (100 * xp2lvl(xp))
end

local function lvlset(xp, lvl)
	if not lvl then return 0 end

	local nxp = xpfrac(xp) * lvl * 100
	
	xp = xp + nxp

	return xp
end

local function lvladd(xp, lvl)
	lvl = (lvl or 1) + xp2lvl(xp)
	return lvlset(xp, lvl)
end

function xplib.get_player_xp(name)
	if not name then return end
	return storage:get_int(name)
end

function xplib.set_player_xp(name, val, reason)
	if not name then return end
	local lvlchange = xp2lvl(val) - xp2lvl(storage:get_int(name))
	local xpchange = val - storage:get_int(name)
	storage:set_int(name, math.max(0, val))
	xplib.on_update(name, val, reason, lvlchange, xpchange)
end

function xplib.add_player_xp(name, val, reason)
	if not name then return end
	xplib.set_player_xp(name, xplib.get_player_xp(name) + (val or 1), reason)
end

function xplib.get_player_level(name)
	if not name then return end
	return xp2lvl(storage:get_int(name))
end

function xplib.set_player_level(name, level, reason)
	if not name then return end
	xplib.set_player_xp(name, 
		lvlset(storage:get_int(name), level),
	reason)
end

function xplib.add_player_level(name, level, reason)
	if not name then return end
	xplib.set_player_xp(name,
		lvladd(storage:get_int(name), level),
	reason)
end

local function update() end

function xplib.on_update(playername, xp, reason, lvlchange, xpchange)
	reason = reason and {table.unpack(reason)} or {type = "set_xp"}
	reason.lvlchange = lvlchange
	reason.xpchange = xpchange
	update(playername, reason, xpmod(xp), xp2lvl(xp), xp)
end

function xplib.register_on_update(func)
	local prev = update
	update = function(playername, reason, xp, lvl, total)
		prev(playername, reason, xp, lvl, total)
		func(playername, reason, xp, lvl, total)
	end
end

local hud_ids = {}

core.register_on_joinplayer(function(player)
	local playername = player:get_player_name()
	
	hud_ids[playername] = player:hud_add({
		type = "text",
		hud_elem_type = "text",
		position = {x=0.6, y=0.9},
		name = "level",
		scale = {x = 1, y = 1},
		text = string.format("L%02i\n%04i/%04i", xplib.get_player_level(playername), xpmod(xplib.get_player_xp(playername)), xplib.get_player_level(playername) * 100),
		number = 0xFFFF00,
		direction = 0,
		offset = {x = 0, y= 24},
	})
end)

xplib.register_on_update(function(playername, reason, xp, lvl, total)
	local player = core.get_player_by_name(playername)

	player:hud_change(hud_ids[playername], "text", string.format("L%02i\n%04i/%04i", lvl, xp, lvl * 100))
end)

local S = core.get_translator"xplib"

xplib.get_translator = S

core.register_chatcommand("reset_level", {
	description = S"Reset your level.",
	privs = {levels=true},
	func = function(playername, params)
		xplib.set_player_xp(playername, 0)
	end
})

core.register_privilege("levels", {
	description = S"Ability to modify the tower using commands.",
	give_to_singleplayer = false,
	give_to_admin = true
})