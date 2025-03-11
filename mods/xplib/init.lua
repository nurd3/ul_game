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
	if type(name) ~= "string"
	then error(
		string.format("xplib.get_player_xp(): bad argument #1 (string expected, got %s)",
			type(name)
	)) end

	return storage:get_int(name)
end

function xplib.set_player_xp(name, val, reason, disable_multiplier)
	if type(name) ~= "string"
	then error(
		string.format("xplib.set_player_xp(): bad argument #1 (string expected, got %s)",
			type(name)
	)) elseif type(val) ~= "number"
	then error(
		string.format("xplib.set_player_xp(): bad argument #2 (number expected, got %s)",
			type(val)
	)) elseif reason
	and type(reason) ~= "table"
	then error(
		string.format("xplib.set_player_xp(): bad argument #3 (table expected, got %s)",
			type(reason)
	)) elseif disable_multiplier
	and type(disable_multiplier) ~= "boolean"
	then error(
		string.format("xplib.set_player_xp(): bad argument #3 (boolean expected, got %s)",
			type(disable_multiplier)
	)) end

	local lvlchange = xp2lvl(val) - xp2lvl(storage:get_int(name))
	local xpchange = val - storage:get_int(name)

	if not disable_multiplier
	then val = xplib.multiplier(name, val, reason, lvlchange, xpchange) or val
		lvlchange = xp2lvl(val) - xp2lvl(storage:get_int(name))
		xpchange = val - storage:get_int(name)
	end
	
	storage:set_int(name, math.max(0, val))
	core.log("info", "attempting on_update")
	xplib.on_update(name, val, reason, lvlchange, xpchange, disable_multiplier ~= nil)
end

function xplib.add_player_xp(name, val, reason, disable_multiplier)
	if type(name) ~= "string"
	then error(
		string.format("xplib.add_player_xp(): bad argument #1 (string expected, got %s)",
			type(name)
	)) elseif type(val) ~= "number"
	then error(
		string.format("xplib.add_player_xp(): bad argument #2 (number expected, got %s)",
			type(val)
	)) elseif reason
	and type(reason) ~= "table"
	then error(
		string.format("xplib.add_player_xp(): bad argument #3 (table expected, got %s)",
			type(reason)
	)) elseif disable_multiplier
	and type(disable_multiplier) ~= "boolean"
	then error(
		string.format("xplib.set_player_xp(): bad argument #3 (boolean expected, got %s)",
			type(disable_multiplier)
	)) end

	xplib.set_player_xp(name, xplib.get_player_xp(name) + (val or 1), reason, disable_multiplier)
end

function xplib.get_player_level(name)
	if type(name) ~= "string"
	then error(
		string.format("xplib.get_player_level(): bad argument #1 (string expected, got %s)",
			type(name)
	)) end

	return xp2lvl(storage:get_int(name))
end

function xplib.set_player_level(name, level, reason)
	if type(name) ~= "string"
	then error(
		string.format("xplib.set_player_level(): bad argument #1 (string expected, got %s)",
			type(name)
	)) elseif type(level) ~= "number"
	then error(
		string.format("xplib.set_player_level(): bad argument #2 (number expected, got %s)",
			type(level)
	)) elseif reason
	and type(reason) ~= "table"
	then error(
		string.format("xplib.set_player_level(): bad argument #3 (table expected, got %s)",
			type(reason)
	)) end

	xplib.set_player_xp(name, 
		lvlset(storage:get_int(name), level),
	reason, true)
end

function xplib.add_player_level(name, level, reason)
	if type(name) ~= "string"
	then error(
		string.format("xplib.add_player_level(): bad argument #1 (string expected, got %s)",
			type(name)
	)) elseif type(level) ~= "number"
	then error(
		string.format("xplib.add_player_level(): bad argument #2 (number expected, got %s)",
			type(level)
	)) elseif reason
	and type(reason) ~= "table"
	then error(
		string.format("xplib.add_player_level(): bad argument #3 (table expected, got %s)",
			type(reason)
	)) end

	xplib.set_player_xp(name,
		lvladd(storage:get_int(name), level),
	reason, true)
end

function xplib.lvl2xp(lvl)
	if type(lvl) ~= "number"
	then error(
		string.format("xplib.lvl2xp(): bad argument #1 (number expected, got %s)",
			type(lvl)
	)) end

	return lvl2xp(lvl)
end

function xplib.xp2lvl(xp)
	if type(xp) ~= "number"
	then error(
		string.format("xplib.xp2lvl(): bad argument #1 (number expected, got %s)",
			type(xp)
	)) end

	return xp2lvl(xp)
end

function xplib.xpmod(xp)
	if type(xp) ~= "number"
	then error(
		string.format("xplib.xpmod(): bad argument #1 (number expected, got %s)",
			type(xp)
	)) end

	return xpmod(xp)
end

function xplib.xpfrac(xp)
	if type(xp) ~= "number"
	then error(
		string.format("xplib.xpmod(): bad argument #1 (number expected, got %s)",
			type(xp)
	)) end

	return xpfrac(xp)
end

function xplib.lvlset(xp, lvl)
	if type(xp) ~= "number"
	then error(
		string.format("xplib.lvlset(): bad argument #1 (number expected, got %s)",
			type(xp)
	)) elseif type(lvl) ~= "number"
	then error(
		string.format("xplib.lvlset(): bad argument #2 (number expected, got %s)",
			type(lvl)
	)) end

	return lvlset(xp, lvl)
end

function xplib.lvladd(xp, lvls)
	if type(xp) ~= "number"
	then error(
		string.format("xplib.lvladd(): bad argument #1 (number expected, got %s)",
			type(xp)
	)) elseif type(lvls) ~= "number"
	then error(
		string.format("xplib.lvladd(): bad argument #2 (number expected, got %s)",
			type(lvls)
	)) end

	return lvladd(xp, lvls)
end

local function update() end
local function multiply() end

function xplib.on_update(playername, xp, reason, lvlchange, xpchange, disable_multiplier)
	core.log("info", "doing on_update")
	if not core.get_player_by_name(playername)
	then
		core.log("info", "player is not here, pending on_update")
		local pending = core.deserialize(storage:get_string("pending_updates "..playername)) or {}
		table.insert(pending, {xp, reason, lvlchange, xpchange, disable_multiplier})
		storage:set_string("pending_updates "..playername, core.serialize(pending))
		return
	end
	reason = reason and table.copy(reason) or {type = "set_xp"}
	reason.lvlchange = lvlchange
	reason.xpchange = xpchange
	update(playername, reason, xpmod(xp), xp2lvl(xp), xp, disable_multiplier)
end

function xplib.multiplier(playername, xp, reason, lvlchange, xpchange)
	core.log("info", "doing multiplier")
	if not core.get_player_by_name(playername)
	then
		core.log("info", "player is not here, pending multiplier")
		local pending = core.deserialize(storage:get_string("pending_multipliers "..playername)) or {}
		table.insert(pending, {xp, reason, lvlchange, xpchange})
		storage:set_string("pending_multipliers "..playername, core.serialize(pending))
		return
	end
	reason = reason and table.copy(reason) or {type = "set_xp"}
	reason.lvlchange = lvlchange
	reason.xpchange = xpchange
	return multiply(playername, reason, xpmod(xp), xp2lvl(xp), xp) or xp
end

function xplib.register_on_update(func)
	local modname = core.get_current_modname() or "??"
	core.log("info", string.format("register_on_update from mod %s", modname))
	local prev = update
	update = function(playername, reason, xp, lvl, total, disable_multiplier)
		prev(playername, reason, xp, lvl, total, disable_multiplier)
		core.log("info", string.format("performing registered on_update from %s", modname))
		func(playername, reason, xp, lvl, total, disable_multiplier)
	end
end

function xplib.register_multiplier(func)
	local modname = core.get_current_modname() or "??"
	core.log("info", string.format("register_multiplier from mod %s", modname))
	local prev = multiply
	multiply = function(playername, reason, xp, lvl, total)
		total = prev(playername, reason, xp, lvl, total) or total
		core.log("info", string.format("performing registered multiplier from %s", modname))
		return func(playername, reason, xp, lvl, total) or total
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

	local updates = core.deserialize(storage:get_string("pending_updates "..playername))

	if updates
	then
		for _,args in ipairs(updates)
		do
			xplib.on_update(playername, table.unpack(args))
		end
		storage:set_string("pending_updates "..playername, "")
	end

	local multipliers = core.deserialize(storage:get_string("pending_multipliers "..playername))

	if multipliers
	then
		for _,args in ipairs(multipliers)
		do
			xplib.multiplier(playername, table.unpack(args))
		end
		storage:set_string("pending_multipliers "..playername, "")
	end
end)

xplib.register_on_update(function(playername, reason, xp, lvl)
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