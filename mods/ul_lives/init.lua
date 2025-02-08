ul_lives = {}

local S = core.get_translator"ul_lives"
local storage = core.get_mod_storage()

ul_lives.get_translator = S

local hud_ids = {}

-- stolen from MT game's default/chests.lua
function ul_lives.grave_formspec(pos)
	local meta = core.get_meta(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local formspec =
		"size[8,9]" ..
		"list[nodemeta:" .. spos .. ";main;4,0.3;4,4;]" ..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";main]" ..
		"listring[current_player;main]"
	return formspec
end
function ul_lives.get_life(plyrname)
	if not plyrname then return end
	if not storage:get(plyrname) then ul_lives.set_life(plyrname, 3) end
	return storage:get_int(plyrname)
end
function ul_lives.set_life(plyrname, val)
	if not plyrname or not val then return end
	storage:set_int(plyrname, val)
	if hud_ids[plyrname] then
		core.get_player_by_name(plyrname):hud_change(hud_ids[plyrname], "text", string.format(S("%i Death Left"), val))
	end
end
function ul_lives.add_life(plyrname, val)
	if not plyrname then return end
	ul_lives.set_life(plyrname, ul_lives.get_life(plyrname) + (val or 1))
end

core.register_on_joinplayer(function(plyr)
	local plyrname = plyr:get_player_name()

	hud_ids[plyrname] = plyr:hud_add({
		type = "text",
		hud_elem_type = "text",
		alignment = {x=1, y=0},
		position = {x=0, y=0.75},
		name = "lives",
		scale = {x = 1, y = 1},
		text = string.format(S("%i Death Left"), ul_lives.get_life(plyrname)),
		number = 0xffffff,
		direction = 0,
		offset = {x = 10, y= -10},
	})
end)

core.register_craftitem("ul_lives:life", {
	short_description = S"Revive",
	description = S"Gives you an extra life before you lose items.",
	inventory_image = "ul_lives_life.png",
	light_source = 14,
	on_use = function(stack, user)
		if user:is_player() then
			ul_lives.add_life(user:get_player_name())
			ul_basic.objsound(user, "ul_basic_equip")
		end
		stack:take_item()
		return stack
	end
})
core.register_node("ul_lives:grave", {
	tiles = {"ul_lives_grave.png"},
	on_punch = function (pos, puncher)
		local inv = core.get_meta(pos):get_inventory()

		if inv:is_empty("main") then
			core.set_node(pos, {name="air"})
		end
	end,
	on_rightclick = function (pos, node, puncher)
		if puncher:is_player() then
			core.show_formspec(
				puncher:get_player_name(),
				"ul_lives:grave_formspec", 
				ul_lives.grave_formspec(pos)
			)
		end
	end
})

core.register_on_dieplayer(function (plyr)
	local plyrname = plyr:get_player_name()
	if ul_lives.get_life(plyrname) > 0 then
		ul_lives.add_life(plyrname, -1)
	else
		local pos = plyr:get_pos()
		core.set_node(pos, {name="ul_lives:grave"})
		local nodeinv = core.get_meta(pos):get_inventory()

		nodeinv:set_size("main", 4*4)

		local plyrinv = plyr:get_inventory()
		local maximum = 64
		local continue = true

		while continue do
			continue = maximum > 0 and not plyrinv:is_empty("main")
			for i,stack in ipairs(plyrinv:get_list"main") do
				if stack:get_count() > 0 then
					local new_stack = stack
					local amt = math.min(math.random(0, stack:get_count()), maximum)
					if nodeinv:room_for_item("main", new_stack) then
						nodeinv:add_item("main", new_stack)
						stack:set_count(stack:get_count() - amt)
						maximum = maximum - amt
						plyrinv:set_stack("main", i, stack)
					else
						return
					end
				end
			end
		end
	end
end)

core.register_chatcommand("clear_lives", {
	params = "",
	description = S"Set your life counter to 0",
	func = function(plyrname, params)
		ul_lives.set_life(plyrname, 0)
	end
})