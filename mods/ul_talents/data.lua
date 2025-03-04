local S = ul_talents.get_translator

-------------
-- CLASSES --
-------------

ul_talents.register_class("ul_talents:cast", {
	title = S"Caster",
	description = S"Specialized for creative uses of magic",
	color = "#0000ff"
})

ul_talents.register_class("ul_talents:gather", {
	title = S"Gatherer",
	description = S"Specialized for collecting resources",
	color = "#00ff00"
})

ul_talents.register_class("ul_talents:hunt", {
	title = S"Hunter",
	description = S"Specialized for unique combat strategies",
	color = "#ff0000"
})

-----------
-- SLOTS --
-----------

ul_talents.register_slot("ul_talents:external", {
	title = S"External",
	description = S"For your body"
})

ul_talents.register_slot("ul_talents:habitual", {
	title = S"Habitual",
	description = S"For your reflexes"
})

ul_talents.register_slot("ul_talents:instrumental", {
	title = S"Instrumental",
	description = S"For your tools/spells"
})

ul_talents.register_slot("ul_talents:perceptual", {
	title = S"Perceptual",
	description = S"For your awareness"
})

ul_talents.register_slot("ul_talents:supplemental_1", {
	title = S"First Supplemental",
	description = S"For your deficits"
})

ul_talents.register_slot("ul_talents:supplemental_2", {
	title = S"Second Supplemental",
	description = S"For your deficits"
})

ul_talents.register_slot("ul_talents:supplemental_3", {
	title = S"Third Supplemental",
	description = S"For your deficits"
})

-------------
-- TALENTS --
-------------

-- EXTERNAL --
ul_talents.register_talent("ul_talents:cool_sneakers", {
	title = S"Cool Sneakers",
	description = S"Jump higher and move faster but take more damage",
	slot = "ul_talents:external",
	class = "ul_talents:cast",
	icon = "ul_talents_cool_sneakers.png"
})
ul_talents.register_talent("ul_talents:oobleck_suit", {
	title = S"Oobleck Suit",
	description = S"Take less damage when staying still, near immunity to fall damage",
	slot = "ul_talents:external",
	class = "ul_talents:gather",
	icon = "ul_talents_oobleck_suit.png"
})
ul_talents.register_talent("ul_talents:heavy_mitts", {
	title = S"Heavy Mitts",
	description = S"Move just as fast while sneaking and hit spell balls",
	slot = "ul_talents:external",
	class = "ul_talents:hunt",
	icon = "ul_talents_heavy_mitts.png"
})
-- HABITUAL --
ul_talents.register_talent("ul_talents:deflect", {
	title = S"Magic Deflect",
	description = S"Deflect spells by hitting them",
	slot = "ul_talents:habitual",
	class = "ul_talents:cast",
	icon = "ul_magic_ball.png"
})
ul_talents.register_talent("ul_talents:stun", {
	title = S"Stun",
	description = S"Do less damage for the bonus of stunning enemies",
	slot = "ul_talents:habitual",
	class = "ul_talents:gather",
	icon = "ul_talents_stun.png"
})
ul_talents.register_talent("ul_talents:block", {
	title = S"Block",
	description = S"Block attacks by crouching",
	slot = "ul_talents:habitual",
	class = "ul_talents:hunt",
	icon = "ul_talents_block.png"
})
-- INSTRUMENTAL --
ul_talents.register_talent("ul_talents:durability_spell", {
	title = S"Stronger Spells",
	description = S"Makes spells last longer",
	slot = "ul_talents:instrumental",
	class = "ul_talents:cast",
	icon = "ul_magic_spell.png"
})
ul_talents.register_talent("ul_talents:durability_lantern", {
	title = S"Stronger Lanterns",
	description = S"Makes lanterns last longer",
	slot = "ul_talents:instrumental",
	icon = "ul_basic_lantern.png"
})
ul_talents.register_talent("ul_talents:durability_pick", {
	title = S"Stronger Pickaxes",
	description = S"Makes pickaxes last longer",
	slot = "ul_talents:instrumental",
	class = "ul_talents:gather",
	icon = "ul_basic_pick.png"
})
ul_talents.register_talent("ul_talents:durability_weapons", {
	title = S"Stronger Weapons",
	description = S"Makes swords/knives last longer",
	slot = "ul_talents:instrumental",
	class = "ul_talents:hunt",
	icon = "ul_basic_sword.png"
})
-- PERCEPTUAL --
ul_talents.register_talent("ul_talents:foveal_inspect", {
	title = S"Foveal Inspect",
	description = S"Get information on a distant aimed point up to 100m away",
	slot = "ul_talents:perceptual",
	class = "ul_talents:cast",
	icon = "ul_talents_foveal_inspect.png"
})
ul_talents.register_talent("ul_talents:lithosonic_ear", {
	title = S"Lithosonic Ear",
	description = S"While holding a pickaxe, hear the nearest ore/crystal in a 32 block radius",
	slot = "ul_talents:perceptual",
	class = "ul_talents:gather",
	icon = "ul_talents_lithosonic_ear.png"
})
ul_talents.register_talent("ul_talents:predatory_vision", {
	title = S"Predatory Vision",
	description = S"See movement within a 100m radius, does not distinguish between monsters, animals, and casted spells",
	slot = "ul_talents:perceptual",
	class = "ul_talents:hunt",
	icon = "ul_talents_predatory_vision.png"
})
-- SUPPLEMENTAL --
ul_talents.register_talent("ul_talents:more_lives_1", {
	title = S"More Lives",
	description = S"Get a life each time you level up",
	slot = "ul_talents:supplemental_1",
	icon = "ul_lives_life.png"
})
ul_talents.register_talent("ul_talents:more_money_1", {
	title = S"More Money",
	description = S"Get money each time you level up",
	slot = "ul_talents:supplemental_1",
	icon = "ul_talents_more_money.png"
})
ul_talents.register_talent("ul_talents:more_piety_1", {
	title = S"More Piety",
	description = S"Get more piety each time you level up",
	slot = "ul_talents:supplemental_1",
	icon = "ul_shrines_piety_vial.png"
})
ul_talents.register_talent("ul_talents:more_xp_1", {
	title = S"More XP",
	description = S"Get more XP",
	slot = "ul_talents:supplemental_1",
	icon = "ul_talents_more_xp.png"
})
-- second
ul_talents.register_talent("ul_talents:more_lives_2", {
	title = S"More Lives",
	description = S"Get a life each time you level up",
	slot = "ul_talents:supplemental_2",
	icon = "ul_lives_life.png"
})
ul_talents.register_talent("ul_talents:more_money_2", {
	title = S"More Money",
	description = S"Get money each time you level up",
	slot = "ul_talents:supplemental_2",
	icon = "ul_talents_more_money.png"
})
ul_talents.register_talent("ul_talents:more_piety_2", {
	title = S"More Piety",
	description = S"Get more piety each time you level up",
	slot = "ul_talents:supplemental_2",
	icon = "ul_shrines_piety_vial.png"
})
ul_talents.register_talent("ul_talents:more_xp_2", {
	title = S"More XP",
	description = S"Get more XP",
	slot = "ul_talents:supplemental_2",
	icon = "ul_talents_more_xp.png"
})
-- third
ul_talents.register_talent("ul_talents:more_lives_3", {
	title = S"More Lives",
	description = S"Get a life each time you level up",
	slot = "ul_talents:supplemental_3",
	icon = "ul_lives_life.png"
})
ul_talents.register_talent("ul_talents:more_money_3", {
	title = S"More Money",
	description = S"Get money each time you level up",
	slot = "ul_talents:supplemental_3",
	icon = "ul_talents_more_money.png"
})
ul_talents.register_talent("ul_talents:more_piety_3", {
	title = S"More Piety",
	description = S"Get more piety each time you level up",
	slot = "ul_talents:supplemental_3",
	icon = "ul_shrines_piety_vial.png"
})
ul_talents.register_talent("ul_talents:more_xp_3", {
	title = S"More XP",
	description = S"Get more XP",
	slot = "ul_talents:supplemental_3",
	icon = "ul_talents_more_xp.png"
})