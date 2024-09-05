local S = ul_inv.get_translator

minetest.register_on_joinplayer(function(plyr)
    local inv = plyr:get_inventory()
	inv:set_size("outfit", 8)
end)

function ul_inv.register_wearable(name, def)

	local equip_sound = def.sounds and def.sounds.equip or "ul_basic_equip"

	def.on_use = function(itemstack, user, pointed_thing)
		local inv = user and user.get_inventory and user:get_inventory()
		
		if inv and inv:room_for_item("outfit", ItemStack(name)) then
			ul_basic.objsound(user, equip_sound)
			itemstack:set_count(itemstack:get_count() - 1)
			inv:add_item("outfit", ItemStack(name))
		end
		
		return itemstack
	end

	def.name = name
	
	def.groups = def.groups or {}
	
	def.groups.wearable = def.groups.wearable or 1
	
	minetest.register_tool(name, def)
end

sfinv.register_page("ul_inv:outfit", {
    title = S"Outfit",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				list[current_player;outfit;1.0,0.5;2,4;]
				listring[current_player;main]
				listring[current_player;outfit]
			]], true)
	end
})