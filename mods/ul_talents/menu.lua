local S = ul_talents.get_translator

local slot_formspecs = {}
local talent_formspecs = {}
local scrolls = {}
local menu_size = 0

local function compile_formspec()
	local formspec = ""

	local slot_sizes = {}

	for index,talent in ipairs(ul_talents.talents_order)
	do
		local def = ul_talents.registered_talents[talent]
		if def and def.slot
		then
			slot_sizes[def.slot] = (slot_sizes[def.slot] or 0) + 1
		end
	end

	local offset = 0
	local slot_offsets = {}
	for index,slot in ipairs(ul_talents.slots_order)
	do
		if not slot_sizes[slot]
		then
			slot_sizes[slot] = 0
		end
		local def = ul_talents.registered_slots[slot]
		local tooltip = def.title
			and def.description
			and (def.title .. "\n" .. def.description)
			or def.title
			or slot

		
		slot_formspecs[index] =
			string.format("style[talent%i;bgcolor=#ffffff]",
				index
			)
			.. string.format("label[0,%f;%s = %%s]",
				offset,
				core.formspec_escape(def.title or slot)
			)
			.. string.format("image_button[0,%f;1,1;%%s;slot%i;]",
					offset + 0.5,
					index
				)
			.. string.format("tooltip[slot%i;%s]",
				index,
				core.formspec_escape(tooltip)
			)
		slot_offsets[slot] = offset
		offset = offset + 1.5 + math.floor(slot_sizes[slot] / 5)
		menu_size = menu_size + offset
	end

	local slot_indexes = {}
	for index,talent in ipairs(ul_talents.talents_order)
	do
		local def = ul_talents.registered_talents[talent]
		if def and def.slot
		then
			slot_indexes[def.slot] = slot_indexes[def.slot] or 0

			local x = 1 + (slot_indexes[def.slot] % 5)
			local y = 0.5 + slot_offsets[def.slot] + math.floor(slot_indexes[def.slot] / 5)

			slot_indexes[def.slot] = slot_indexes[def.slot] + 1

			local img = def.icon
				or "blank.png"
			local tooltip = def.title
				or slot

			talent_formspecs[index] = 
				string.format("style[talent%i;bgcolor=%%s]",
					index
				)
				.. string.format("image_button[%f,%f;1,1;%s;talent%i;]",
					x,y,
					core.formspec_escape(img),
					index
				)
				.. string.format("tooltip[talent%i;%s%%s]",
					index,
					core.formspec_escape(tooltip)
				)
		end
	end
end

function ul_talents.get_formspec(plyrname)
	if not plyrname then return end

	local formspec = ""
	for index,format in ipairs(slot_formspecs)
	do
		local slot = ul_talents.slots_order[index]
		local talent = ul_talents.get_slot(plyrname, slot)

		if talent == ""
		then talent = nil end

		local img = talent
			and ul_talents.registered_talents[talent]
			and ul_talents.registered_talents[talent].icon
			or "blank.png"
		local title = talent
			and ul_talents.registered_talents[talent]
			and ul_talents.registered_talents[talent].title
			or talent
		formspec = formspec .. string.format(format, 
			core.formspec_escape(title or "N/A"),
			core.formspec_escape(img)
		)
	end

	for index,format in ipairs(talent_formspecs)
	do
		local talent = ul_talents.talents_order[index]
		local bgcolor = ul_talents.knows_talent(plyrname, talent)
			and (ul_talents.using_talent(plyrname, talent)
			and "#ffffff"
			or "#777777")
			or "#000000"
		local desc = ul_talents.knows_talent(plyrname, talent)
			and talent
			and ul_talents.registered_talents[talent]
			and ul_talents.registered_talents[talent].description
			or S"Click to discover talent"
		local class = talent
			and ul_talents.registered_talents[talent]
			and ul_talents.registered_talents[talent].class
		local classname = class
			and ul_talents.registered_classes[class]
			and (ul_talents.registered_classes[class].title or class)
			or "??"
		formspec = formspec .. string.format(format, 
			bgcolor,
			core.formspec_escape("\n"..desc.."\nClass: "..classname)
		)
	end

	local scroll = scrolls[plyrname] or 0

	return "size[8,8]"
		.. string.format("label[0,0;%s]",
			core.formspec_escape(S("Levels: @1",
				xplib.get_player_level(plyrname) - ul_talents.get_used_levels(plyrname)))
		)
		.. "scrollbaroptions[max=" .. (menu_size * 1.5) .. "]"
		.. "scrollbar[-0.25,0.5;0.5,7.5;vertical;ul_talents;"..scroll.."]"
		.. "scroll_container[0.5,1;8,8;ul_talents;vertical]"
		.. formspec
		.. "scroll_container_end[]"
end

core.register_on_player_receive_fields(function(plyr, formname, fields)
	if formname ~= "ul_talents:formspec"
	or fields.quit
	then return
	end
	
	local plyrname = plyr:get_player_name()
	
	if not plyrname then
		return
	end

	local slot = nil
	local talent = nil

	for k,v in pairs(fields)
	do
		if k:sub(1,4) == "slot"
		then slot = tonumber(k:sub(5))
		elseif k:sub(1,6) == "talent"
		then talent = tonumber(k:sub(7))
		end
	end

	scrolls[plyrname] = fields.ul_talents and fields.ul_talents:sub(5)
	local slotname = slot and ul_talents.slots_order[slot]
	local talentname = talent and ul_talents.talents_order[talent]

	if slotname
	then ul_talents.set_slot(plyrname, slotname, "")
		ul_basic.objsound(plyr, "ul_take")
	elseif talentname
	then
		if ul_talents.knows_talent(plyrname, talentname)
		then ul_talents.equip_talent(plyrname, talentname)
			ul_basic.objsound(plyr, "ul_basic_equip")
		elseif ul_talents.get_used_levels(plyrname) >= xplib.get_player_level(plyrname)
		then core.chat_send_player(plyrname, core.colorize("#ff0000", "Not enough levels!"))
			ul_basic.objsound(plyr, "ul_fail")
		else ul_talents.discover_talent(plyrname, talentname)
			ul_talents.add_used_levels(plyrname, 1)
			ul_basic.objsound(plyr, "ul_activate")
		end
	end
	
	core.show_formspec(plyrname, "ul_talents:formspec", ul_talents.get_formspec(plyrname))
end)

core.register_on_mods_loaded(compile_formspec)