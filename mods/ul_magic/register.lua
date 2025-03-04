local S = ul_magic.get_translator

local index = 0

ul_magic.registered_runes = {}
ul_magic.rune_palette = "ul_magic_rune_palette.png"

function ul_magic.register_rune(name, def)
	index = index + 1
	def.index = index
	local imgmod =  ""
	if def.color then
		ul_magic.rune_palette = ul_magic.rune_palette .. "^[fill:1x1:" .. tostring(index + 1) .. ",0:" .. def.color
		
		imgmod = "^[multiply:"..def.color
	end
	
	core.register_craftitem(name, {
		description = S("Rune of @1", def.description or name),
		inventory_image = "ul_magic_rune.png"..imgmod,
	})
	
	core.register_node(name.."_runestone", {
		description = S("@1 Runestone", def.description or name),
		sounds = ul_basic.node_sound_defaults(),
		drawtype = "normal",
		tiles = {"ul_basic_stone.png^[hsl:0:-100:0^(ul_magic_shard.png"..imgmod..")"},
		sunlight_propagates = true,
		is_ground_content = true,
		paramtype = "none",
		paramtype2 = "none",
		diggable = false,
		on_rightclick = function (pos, node, puncher)
			core.set_node(pos, {name="ul_magic:runestone_active"})
			local timer = core.get_node_timer(pos)
			timer:set(1, 0)
			core.add_item(pos, ItemStack(name))
			ul_basic.possound(pos, "ul_take")
		end,
		light_source = 14,
		groups = def.groups
	})
	
	if not def.disable_spell then
		local spell_def = {
			description = S("@1 Spell", def.description or name),
			inventory_image = "ul_magic_spell.png"..imgmod,
			on_use = function(itemstack, user, pointed_thing)
				ul_magic.shoot_ball(user, user:get_look_dir(), name, ul_magic.get_rune_level(user, name),
				vector.offset(user:get_look_dir(), 0, 1.625, 0))
				itemstack = ul_magic.wear_spell(itemstack, user)
				return itemstack
			end,
			
			on_secondary_use = function(itemstack, user, pointed_thing)
				if def.on_cast
				and def.on_cast(user, pointed_thing.ref, ul_magic.get_rune_level(user, name))
				then
					ul_magic.wear_level(user, name)
					itemstack:add_wear(65536 / 10)
					ul_basic.objsound(user, "ul_magic_cast")
				else
					ul_basic.objsound(user, "ul_fail")
				end
				return itemstack
			end,
			
			on_place = function(itemstack, user, pointed_thing)
				if def.on_cast
				and def.on_cast(user, pointed_thing.ref, ul_magic.get_rune_level(user, name))
				then
					ul_magic.wear_level(user, name)
					itemstack:add_wear(65536 / 10)
					ul_basic.objsound(user, "ul_magic_cast")
				else
					ul_basic.objsound(user, "ul_fail")
				end
				return itemstack
			end,
			
			groups = def.groups or {}
		}
		spell_def.groups.spell = 1
		core.register_tool(name.."_spell", spell_def)
	end
	
	if not def.disable_ring then
		local ring_def = {
			short_description = S"Outdated Ring",
			description = S"Outdated Ring, punch the ground with this ring to fix it",
			on_use = function()
				return ul_magic.enchant("ul_magic:ring", name)
			end,
			groups = def.groups or {}
		}
		ring_def.groups.ring = 1
		ul_inv.register_wearable(name.."_ring", ring_def)
		if not def.on_wear then
			def.on_wear = function () end
		end
	end
	
	core.register_craft({
		output = name.."_spell",
		type = "shapeless",
		recipe = {"ul_magic:spell", name}
	})
	
	ul_magic.registered_runes[name] = def
end