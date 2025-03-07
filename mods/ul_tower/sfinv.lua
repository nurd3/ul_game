local S = ul_tower.get_translator
local storage = core.get_mod_storage()
local T = function(args) return core.formspec_escape(S(table.unpack(args))) end

local rec = core.deserialize(storage:get_string("recipe"))

local function generate_random_recipe(max)
	rec = {}
	max = max or 3
	for i = 1, max do
		table.insert(rec, ul_tower.get_random_stack())
	end
	storage:set_string("recipe", core.serialize(rec))
end

local function get_item_display_name(id)
	return (core.registered_items[id] and (core.registered_items[id].short_description or core.registered_items[id].description)) or id
end

local opened = {}

local babel = {
	S"From humble beginnings",
	S"Humble adventurers climb",
	S"Anew something rises",
	S"Summoning a long gone being",

	S"This deity is manifest",
	S"Bringing anger to its foe",
	S"Horrors amplify",
	S"God is angry",

	S"The train blares its horn",
	S"You stand tall",
	S"Full of pride",
	S"In its way",

	S"To ambitious endings",
	S"You crawl",
	S"You lack ego",
	S"Say goodbye",

	----

	S"But it's not over just yet",
	S"You still have strength",
	S"Consuming your mind",
	S"Swallowing your pride",

	S"The poem continues",
	S"The writer sick and tired",
	S"I'm kinda bored",
	S"...",

	S"Maybe I shall write",
	S"A haiku to be silly",
	S"Five more syllables",
	S"...",

	S"This is taking very long",
	S"If you fall you're likely to die",
	S"Something something lamp flavoured pie",
	S"...",

	----

	S"It is nearly over",
	S"Time is coming my friend",
	S"Suns shine outside",
	S"This final line is useless for dramatic effect",

	S"This is the homestretch",
	S"You've worked hard",
	S"Long and hard",
	S"Things haven't seemed to change",

	S"But it's not over just yet",
	S"But it's not over just yet",
	S"You cry to the cruel godless sky",
	S"Surely there must be something right?",

	S"To ambitious endings",
	S"Say goodbye",
	S"No destination",
	S"Only bragging rights."
}

sfinv.register_page("ul_tower:inv_tower", {
    title = S"Tower",
	get = function(self, plyr, context)
		
		local recipe = ""
		if ul_tower.get_height() < #babel then
			local offset = 0.5
			for _,str in ipairs(rec) do
				local stack = ItemStack(str)
				local name = get_item_display_name(stack:get_name())
				recipe = recipe.."label[0.1,"..offset..";"..stack:get_count().."X "..name.."]\n"
				offset = offset + 0.3
			end
			recipe = recipe.."button[0,4;2,1;ul_craft;Craft]"
		else
			recipe = "label[0.1,0.5;Tower is complete.]"
		end

		local babel_text = ""

		if ul_tower.get_height() > 0 then
			babel_text = core.formspec_escape(table.concat(babel, "\n", 1, math.min(ul_tower.get_height(), #babel)))
		end
		
		return sfinv.make_formspec(player, context,
			string.format("label[0,0;%s]", T{"Tower"}) ..
			"scrollbaroptions[max=".. #babel * 4 .."]" ..
			"scrollbar[0,0.5;0.5,3.5;vertical;ul_babel;]\n"..
			"scroll_container[0.5,1;5,4;ul_babel;vertical]\n"..
			string.format("label[0.5,0;%s]", babel_text)..
			"scroll_container_end[]\n"..
			"container[5,0]\n"..
			recipe..
			"container_end[]"
		, true, "size[9,9.1]")
	end,
	on_player_receive_fields = function(self, plyr, ctx, fields)
		if fields.ul_craft then
			local inv = plyr:get_inventory()
			for _,str in pairs(rec) do
				local stack = ItemStack(str)
				if not inv:contains_item("main", stack, true) then
					core.chat_send_player(plyr:get_player_name(), core.colorize("#ff0000", S("Not enough @1!", get_item_display_name(stack:get_name()))))
					return
				end
			end
			
			for _,str in pairs(rec) do
				local count, nom = ItemStack(str):get_count(), ItemStack(str):get_name()
				if count > 0 then
					for i,stack in ipairs(inv:get_list"main") do
						if count ~= 0 and stack:get_name() == nom and #stack:get_meta():get_keys() == 0 then
							local x = math.min(count, stack:get_count())
							count = count - x
							stack:take_item(x)
							inv:set_stack("main", i, stack)
						end
					end
				end
			end
			
			if inv:room_for_item("main", ItemStack"ul_tower:tower") then
				inv:add_item("main", ItemStack"ul_tower:tower")
			else
				core.add_item(plyr:get_pos(), ItemStack"ul_tower:tower")
			end

			generate_random_recipe()
			ul_tower.update("new_recipe")
			
			return
		end
	end,
	on_enter = function(self, plyr, context)
		opened[plyr:get_player_name()] = true
	end,
	on_leave = function(self, plyr, context)
		opened[plyr:get_player_name()] = nil
	end
})

core.register_on_mods_loaded(function()
	if not rec then
		generate_random_recipe()
	end
	local invalid = false
	for _,str in ipairs(rec) do
		if not ItemStack(str):is_known() then
			invalid = true
		end
	end
	if invalid then
		generate_random_recipe()
	end
end)

ul_tower.register_on_towerupdate(function()
	for plyrname,bool in pairs(opened) do
		local plyr = core.get_player_by_name(plyrname)
		if plyr and bool then
			sfinv.set_page(plyr, "ul_tower:inv_tower")
		end
	end
end)