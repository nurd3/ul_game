
function ul_magic.get_level(obj, rune)
	local inv = obj.get_inventory and obj:get_inventory()
	
	if inv then
		local lvl = 0
		
		local list = inv:get_list"outfit"
		
		for _,stack in ipairs(list) do
			if stack:get_name() == rune.."_ring" then
				lvl = lvl + 1
			end
		end
		
		return lvl + 1
	end
end

function ul_magic.wear_level(obj, rune)
	local inv = obj.get_inventory and obj:get_inventory()
	
	if inv then
		local lvl = 0
		
		local list = inv:get_list"outfit"
		
		for i,stack in ipairs(list) do
			if stack:get_name() == rune.."_ring" then
				stack:add_wear(65536 / 10)
				lvl = lvl + 1
			end
			inv:set_stack("outfit", i, stack)
		end
		
		return lvl + 1
	end
end

function ul_magic.shoot(self, target, name, level)
	local def = ul_magic.registered_runes[name]
	if not def then error("undefined rune: "..tostring(name), 2) end
	if not def.disable_primary
	then
		local pos = self.object:get_pos()
		local tpos = target:get_pos()
		tpos.y = tpos.y + (
			target:get_luaentity() and 0
			or 1.0
		)
		local hvel = vector.multiply(vector.direction(pos, tpos),8)
		local o = minetest.add_entity(pos, name.."_ball", minetest.serialize{
			_velocity = hvel,
			_level = level,
		})
		o:get_luaentity()._shooter = user
		
		ul_basic.objsound(self.object, "ul_magic_attack")
	else
		ul_basic.objsound(self.object, "ul_fail")
	end
end