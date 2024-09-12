local S = ul_mobs.get_translator

local function dialogue(self, plyr)
	
end

local function monster_check(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	if luaent then
		
		if luaent.type == "monster" then
			return not luaent._owner
		end
		
	end
	
	return false
end

ul_mobs.register_mob("ul_mobs:cult", {
					-- engine values
	description = S"Cult",
	egg_colors = {"#800000", "#000000"},
	visual = "upright_sprite",
	textures = {"ul_mobs_cult.png", "ul_mobs_cult_back.png^[transformFX"},
	visual_size = {x = 2, y = 2},
	collisionbox = {-0.3, -0.4, -0.3, 0.3, 0.4, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 1,
	view_range = 128,
	vision = 15,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	ranged = {
		rate = 0.2,
		range = 128,
		func = ul_magic.shoot,
		args = {"ul_magic:fireball", 5}
	},
	melee = {dmg = 2},
	disable_fall_damage = true,
	disable_taming = true,
	disable_hunting = true,		-- will not be hunted
	
						-- behaviour
	on_check_prey = monster_check,
	type = "race",
	category = "cult"
})