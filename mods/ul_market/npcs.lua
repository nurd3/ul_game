local function check_pred(self, obj)
	if not mobkit.is_alive(obj) then return end
	local luaent = obj:get_luaentity()
	
	if luaent then
		
		if luaent.type == "monster" then
			return true
		end
		
	end
	
	return false
end

ul_market.npc_dialogue = {
	gross = {
		"Ew... You're naked.",
		"I do not speak to peasants.",
		"Leave me alone street rat."
	},
	shock = {
		"Sweet Jerry! You spooked me...",
		"You must be new around here, eh?",
		"You should probably put something on, people don't take kindly to nudity."
	},
	kind = {
		"Oh... hey.",
		"Don't worry, I used to be poor too.",
		"Ok, I'm sorry. I lied. But I'm a lot like you! we're both humans, right?",
		"I swear I'm not a jerk, I have lots of poor friends!",
	},
	nvrc = {
		"Ah, finally. Someone who isn't unbearable.",
		"I'm nouveau rich. These jerkwads make fun of me because I actually earned my wealth!",
		"Don't become rich man, I thought I'd get freedom but it feels like I'm a slave to my money now.",
		"Almost like my puny mortal mind wasn't made to carry such big responsibilities.",
		"Sisyphus shrugs, I guess."
	},
	busy = {
		"...",
		"I'm kinda busy right now.",
		"...",
		"...",
		"You're nosy aren't you?",
		"Fine, I'll tell you. I heard there's maniacs going around and assassinating important people like me.",
		"So I'm pretending to be poor.",
		"Wait... Do poor people wear clothes?"
	},
	small_talk1 = {
		"I heard if you mix a bunch of junk together, you can make a tower up to the sky to summon the sun god... not sure if I believe it."
	},
	small_talk2 = {
		"Apparently there was a sun god named Jerry or whatever until Luna overcame him.",
		"And that's why everything's so dark.",
		"I kinda miss Jerry."
	},
	small_talk3 = {
		"There's solid evidence to show that moon runes protect against the darkness.",
		"All the studies were classified after the mob trade lobbied to limit access to moon runes.",
		"No one's sure why the mob trade did so, but a conspiracy theory has gone around suggesting that mobs are the result of darkness exposure."
	},
	small_talk4 = {
		"The Boogieman was quite the interesting murderer.",
		"He'd use darkness runes on his blades and moon runes on his cloaks, proving that darkness runes weren't as useless as we thought.",
		"Of course, I don't support murder... but it's fascinating how clever they can be.",
		"Don't turn me in, please."
	},
	small_talk5 = {
		"Some rich people are very annoying.",
		"All fancy and show-off, it's like being rich is their entire personality!",
		"I know I'm rich too, but you don't have to be all piggy about it.",
		"What do you mean? I'm allowed to say pig. Reclaimation and all that, bro.",
		"Why are you such a snowflake? like... it's not that serious! It ain't my fault you're offended, not my job to baby you. Like you libturd crapservative communo-nazi wokester snowflakes are so annoying; all you do is complain! I'll say what I want and I don't care if you're a little baby and can't handle it.",
	},
	small_talk6 = {
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"I became rich to avoid speaking to people. Leave me alone.",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"You're persistent, I'll give you that.",
		"Everyone is so annoying... I can barely deal with myself. Everyday I get angrier and angrier, always one bit of stress away from snapping.",
		"I have fantasies of ridding this world of the pests we've all become.",
		"But I know I'm no better, it'd be hypocritical to assume my judgement is better than the people around me.",
		"Thanks for listening... You're pretty cool.",
		"Maybe things will finally change for the better with someone like you around."
	},
	small_talk7 = {
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"Hehe... I wasted your time."
	},
	small_talk8 = {
		"Legend has it, the last person who built a tower died. The moon god probably smited them."
	}
}

if ul_music then
	ul_market.npc_dialogue.ul_music1 = {
		"I know I'm not supposed to break the 4th wall...",
		"But I quite enjoy Unlit's soundtrack.",
		"Thanks for using it."
	}
	ul_market.npc_dialogue.ul_music2 = {
		"What's this music that's playing?",
		"I can hear it as if it's playing through headphones...",
		"Impressive... I guess that's just how far tech has come!"
	}
end

local function random_dialogue_group()
	local temp = {}

	for k,_ in pairs(ul_market.npc_dialogue) do
		table.insert(temp, k)
	end

	return temp[math.random(#temp)]
end

local function died()
	ul_market.generate_event("ul_market:event_assassination")
end

local S = ul_market.get_translator

ul_mobs.register_mob("ul_market:npc", {
					-- engine values
	description = S"NPC",
	visual = "upright_sprite",
	egg_colors = {"#ffffff", "#ff8000", "#000000"},
	textures = {"ul_market_npc.png", "ul_market_npc_back.png^[transformFX"},
	visual_size = {x = 1, y = 2},
	collisionbox = {-0.3, -1.0, -0.3, 0.3, 0.8, 0.3},
	
					-- stats
	max_speed = 10,
	jump_height = 1,
	view_range = 128,
	vision = 7,	-- how well they see in the dark
	lung_capacity = nil,
	max_hp = 20,
	disable_taming = true,
	disable_hunting = true,
	runaway = true,
	on_rightclick = function(self, clicker)
		local name = clicker:get_player_name()
		if name then
			self._dialogue_index = self._dialogue_index or {}
			self.memory.dialogue_group = self.memory.dialogue_group or random_dialogue_group()
			self._dialogue_index[name] = math.min((self._dialogue_index[name] or 0) + 1, #ul_market.npc_dialogue[self.memory.dialogue_group])
			core.chat_send_player(name, S("<NPC> @1", 
				S(ul_market.npc_dialogue[self.memory.dialogue_group][self._dialogue_index[name]])
			))
		end
	end,
	
	sounds = {
		flee = "ul_mobs_animal_flee"
	},
	
						-- behaviour
	on_check_pred = check_pred,
	on_die = died,
	type = "npc"
})

natural_entities.register_spawn("ul_market:npcs", {
	
	spawn_rate = 0.05,
	
	min_y = 0,
	max_y = 64,
	
	entities = {
		["ul_market:npc"] = 0.8
	},
	
	check = function (pos)
		return (core.get_node_light(pos, 0) or 0) > 5
	end
	
})