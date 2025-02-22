ul_shrines.registered_shrines = {}
ul_shrines.shrine_order = {}

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

local prototype = {
	title = "string",
	description = "string",
	repentable = "boolean",
	on_step = "function",
	on_repent = "function"
}

function ul_shrines.register_shrine(name, def)
	if name == nil then
		error("ul_shrines.register_shrine: Name is nil")
	end

	name = check_modname_prefix(tostring(name))	

	for k, v in pairs(def) do
		if prototype[k] and prototype[k] ~= type(v) then
			error(string.format("ul_shrines.register_shrine: %s expected %s, got %s instead (%s)",
				k, prototype[k],
				type(v), name
			))
		end
	end

	if not ul_shrines.registered_shrines[name] then
		table.insert(ul_shrines.shrine_order, name)
	end
	
	ul_shrines.registered_shrines[name] = def
	def.mod_origin = core.get_current_modname() or "??"
end