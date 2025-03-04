ul_talents.registered_classes = {}
ul_talents.registered_talents = {}
ul_talents.registered_slots = {}
ul_talents.classes_order = {}
ul_talents.talents_order = {}
ul_talents.slots_order = {}

-- from luanti/builtin/game/register.lua:57
local function check_modname_prefix(name)
	if name:sub(1,1) == ":" then
		-- If the name starts with a colon, we can skip the modname prefix
		-- mechanism.
		return name:sub(2)
	else
		-- Enforce that the name starts with the correct mod name.
		local expected_prefix = core.get_current_modname() .. ":"
		if name:sub(1, #expected_prefix) ~= expected_prefix then
			error("Name " .. name .. " does not follow naming conventions: " ..
			"\"" .. expected_prefix .. "\" or \":\" prefix required")
		end

		-- Enforce that the name only contains letters, numbers and underscores.
		local subname = name:sub(#expected_prefix+1)
		if subname:find("[^%w_]") then
			error("Name " .. name .. " does not follow naming conventions: " ..
			"contains unallowed characters")
		end

		return name
	end
end

function ul_talents.register_class(name, def)
	if name == nil then
		error("ul_talents.register_class: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_talents.registered_classes[name] then
		table.insert(ul_talents.classes_order, name)
	end

	ul_talents.registered_classes[name] = def
	def.mod_origin = core.get_current_modname() or "??"

	table.sort(ul_talents.classes_order)
end

function ul_talents.register_talent(name, def)
	if name == nil then
		error("ul_talents.register_talent: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_talents.registered_talents[name] then
		table.insert(ul_talents.talents_order, name)
	end

	ul_talents.registered_talents[name] = def
	def.mod_origin = core.get_current_modname() or "??"

	table.sort(ul_talents.talents_order, function(a,b)
		local def1, def2 = ul_talents.registered_talents[a], ul_talents.registered_talents[b]
		
		-- sort undefineds by name
		if not def1 and not def2
		then return a < b
		-- defined > undefined
		elseif not def1 and def2
		then return false
		elseif def1 and not def2
		then return true
		end


		if not def1.class and not def2.class
		or def1.class == def2.class
		then return a < b
		elseif not def1.class and def2.class
		then return false
		elseif def1.class and not def2.class
		then return true
		end
		

		return def1.class < def2.class
	end)
end

function ul_talents.register_slot(name, def)
	if name == nil then
		error("ul_talents.register_slot: Name is nil")
	end
	name = check_modname_prefix(tostring(name))

	if not ul_talents.registered_slots[name] then
		table.insert(ul_talents.slots_order, name)
	end

	ul_talents.registered_slots[name] = def
	def.mod_origin = core.get_current_modname() or "??"

	table.sort(ul_talents.slots_order)
end