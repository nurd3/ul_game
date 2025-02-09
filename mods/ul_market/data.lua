-- the default industries, companies, trade, events, policies, and parties.

local S = ul_market.get_translator

----------------
-- INDUSTRIES --
----------------

ul_market.register_industry("ul_market:industry_mining", {
	title = S"Mining Industry",
	description = S"Lithorlogistics; Extractulation of Metallogenic Assets and other Eductionable Apophenons.",
	sector = 1,
	groups = {labour = 1.0},
	stats = {base_price = 15.0}
})
ul_market.register_industry("ul_market:industry_bones", {
	title = S"Boning Industry",
	description = S"You should already know what these are.",
	sector = 1,
	groups = {labour = 0.5},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_breeding", {
	title = S"Breeding Business",
	description = S"Domesticatology; Entelechation of Animated Automatons, especially Luxurious Troglodytic Beasts.",
	sector = 1,
	groups = {luxury = 0.5},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_magic", {
	title = S"Runes & Spells Business",
	description = S"Alchematruductionology; Production of Runes and Spells. Not much more to say.",
	sector = 1,
	groups = {war = 0.5, trades = 1.0, medical = 0.1},
	stats = {base_price = 50.0}
})
ul_market.register_industry("ul_market:industry_statlantic", {
	title = S"Atlantic Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stpacific", {
	title = S"Pacific Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stmediterranean", {
	title = S"Mediterranean Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stafrican", {
	title = S"African Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stslavic", {
	title = S"Slavic Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stamerican", {
	title = S"American Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stindian", {
	title = S"Indian Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_stasian", {
	title = S"Asian Slave Trade",
	description = S"This is illegal.",
	sector = 1,
	groups = {criminal = 1.0, slave_trade = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})

ul_market.register_industry("ul_market:industry_smithery", {
	title = S"Smithery Business",
	description = S"Swords, Knives, Pickaxes, &c...",
	sector = 2,
	groups = {war = 1.0, labour = 1.0, trades = 1.0},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_construction", {
	title = S"Construction Business",
	description = S"Windows, Doors, Building, &c...",
	sector = 2,
	groups = {labour = 1.0, trades = 1.0, civilian = 0.5},
	stats = {base_price = 50.0}
})
ul_market.register_industry("ul_market:industry_tech", {
	title = S"Tech Industry",
	description = S"Portals, Runestones, &c...",
	sector = 2,
	groups = {snobby = 1.0, trades = 1.0, civilian = 0.5},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_light", {
	title = S"Light Manufacturing Business",
	description = S"Lanterns, Lamps, &c...",
	sector = 2,
	groups = {snobby = 1.0, civilian = 1.0},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_medicine", {
	title = S"Medical Manufacturing Industry",
	description = S"Stuff that makes you feel less sick.",
	sector = 2,
	groups = {medical = 1.0, civilian = 0.5},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_forgery", {
	title = S"Forgery Business",
	description = S"Illegal.",
	sector = 2,
	groups = {criminal = 1.0},
	stats = {base_price = 100.0, chaotic = 500.0}
})

ul_market.register_industry("ul_market:industry_enlistment", {
	title = S"Enlistment Business",
	description = S"Good ol' war machine.",
	sector = 3,
	groups = {war = 1.0},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_retail", {
	title = S"Retail Industry",
	description = S"Horrible.",
	sector = 3,
	groups = {civilian = 1.0},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_housing", {
	title = S"Housing Industry",
	description = S"Modern day feudalism.",
	sector = 3,
	groups = {civilian = 0.5},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_gambling", {
	title = S"Gambling Business",
	description = S"A distraction from the hole in your heart.",
	sector = 3,
	groups = {civilian = 0.5, entertainment = 1.0},
	stats = {base_price = 10.0}
})
ul_market.register_industry("ul_market:industry_art", {
	title = S"Luxury Arts Industry",
	description = S"Poisoned by political brainrot and controversy. Trolling is quite the effective marketing strategy.",
	sector = 3,
	groups = {civilian = 0.5, entertainment = 1.0},
	stats = {base_price = 1000.0}
})
ul_market.register_industry("ul_market:industry_healthcare", {
	title = S"Healthcare Industry",
	description = S"Wee-oo.",
	sector = 3,
	groups = {medical = 1.0, civilian = 0.25},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_black_market", {
	title = S"Black Market",
	description = S"This is illegal.",
	sector = 3,
	groups = {criminal = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_illtrade_rune", {
	title = S"Illegal Rune Trade",
	description = S"This is illegal.",
	sector = 3,
	groups = {criminal = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_illtrade_mobs", {
	title = S"Illegal Mob Trade",
	description = S"This is illegal.",
	sector = 3,
	groups = {criminal = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_piracy", {
	title = S"Piracy",
	description = S"This is illegal.",
	sector = 3,
	groups = {criminal = 1.0},
	stats = {base_price = 100.0, chaos = 10.0}
})
ul_market.register_industry("ul_market:industry_edu_secondary", {
	title = S"Education",
	description = S"Learning.",
	sector = 3,
	groups = {civilian = 1.0, education = 1.0},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_edu_ps", {
	title = S"Post-Secondary Education",
	description = S"Learning.",
	sector = 3,
	groups = {civilian = 1.0, education = 1.0, snobby = 1.0, trades = 1.0},
	stats = {base_price = 100.0}
})
ul_market.register_industry("ul_market:industry_religion", {
	title = S"Religion",
	description = S"Faith.",
	sector = 3,
	groups = {civilian = 1.0, religion = 1.0, snobby = 1.0, trades = 1.0},
	stats = {base_price = 100.0}
})

---------------
-- COMPANIES --
---------------

ul_market.register_company("ul_market:company_llan", {
	tag = "LLAN",
	title = S"Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch Trading Company",
	description = S"A mysterious trading company which goes through a cycle of growth before making shares private.",
	attitude = {privating = 0.1, godlike = 1.0},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_rot", {
	tag = "RTHS",
	title = S"Rothschild Co.",
	description = S"Not to be mistaken with the long dead Rothschild & Co., this trading company took inspiration from antisemitic mythology surrounding the Rothschild family before their mysterious disappearence. Essentially a bunch of supervillain larpers.",
	attitude = {evil = 1.0, lobbying = 1.0},
	shares = {
		["ul_market:industry_mining"] = 100,
		["ul_market:industry_bones"] = 100,
		["ul_market:industry_breeding"] = 100,
		["ul_market:industry_magic"] = 100
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_fart", {
	tag = "FART",
	title = S"Farter Dynasty",
	description = S"Hehe. Fart.",
	attitude = {funny = 1.0},
	shares = {
		["ul_market:industry_magic"] = 100
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_octo", {
	tag = "OCTO",
	title = S"Octopus Industries",
	description = S"Industrialists with a lust for blood.",
	attitude = {violence = 1.0, evil = 0.5, rigging = 0.5},
	shares = {
		["ul_market:industry_smithery"] = 500,
		["ul_market:industry_statlantic"] = 100,
		["ul_market:industry_construction"] = 500,
		["ul_market:industry_tech"] = 500,
		["ul_market:industry_enlistment"] = 50
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_squid", {
	tag = "SQUID",
	title = S"Kraken Industries",
	description = S"People who split from Octopus Industries in favour of more diplomatic routes to success.",
	attitude = {lobbying = 0.5, evil = 0.5, rigging = 0.5},
	shares = {
		["ul_market:industry_smithery"] = 500,
		["ul_market:industry_statlantic"] = 5,
		["ul_market:industry_stpacific"] = 5,
		["ul_market:industry_construction"] = 500,
		["ul_market:industry_tech"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_hlfb", {
	tag = "HLFB",
	title = S"Halfbro",
	description = S"Monopony was a garbage game.",
	attitude = {lobbying = 0.5, evil = 0.5, rigging = 0.5, stupid = 1.0},
	shares = {
		["ul_market:industry_gambling"] = 500,
		["ul_market:industry_stafrican"] = 500,
		["ul_market:industry_art"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_grog", {
	tag = "GROG",
	title = S"Grog Entertainment Officiated Facility-Faculties",
	description = S"GEOFF.",
	attitude = {lobbying = 0.5, evil = 0.5, rigging = 0.5, stupid = 1.0},
	shares = {
		["ul_market:industry_gambling"] = 500,
		["ul_market:industry_art"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_jreg", {
	tag = "JREG",
	title = S"Gregory \"JrEg\" Guevara",
	description = S"Internet funnyman and modern day Greek philosopher.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_healthcare"] = 5,
		["ul_market:industry_gambling"] = 10,
		["ul_market:industry_art"] = 10
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_vegas", {
	tag = "VEGAS",
	title = S"Las Vegas",
	description = S"After the city was wiped off the map, the leftover billionaires decided to unite their casinos into one. They also have some NFTs.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_gambling"] = 1000,
		["ul_market:industry_stpacific"] = 100,
		["ul_market:industry_stamerican"] = 100,
		["ul_market:industry_art"] = 5
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_uhp", {
	tag = "SHP",
	title = S"Sexon Healthcare Plan",
	description = S"Metagaming scum.",
	attitude = {lobbying = 1.0, rigging = 1.0, evil = 1.0},
	shares = {
		["ul_market:industry_healthcare"] = 50,
		["ul_market:industry_stmediterranean"] = 5,
		["ul_market:industry_healthcare"] = 100
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_hspt", {
	tag = "HSPT",
	title = S"Hospitality Inc.",
	description = S"No one is quite sure what they do other than make hospitals.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_magic"] = 50,
		["ul_market:industry_stmediterranean"] = 25,
		["ul_market:industry_statlantic"] = 25,
		["ul_market:industry_stpacific"] = 25,
		["ul_market:industry_stafrican"] = 25,
		["ul_market:industry_construction"] = 50,
		["ul_market:industry_healthcare"] = 200
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_feb", {
	tag = "FEB",
	title = S"Federal Employment Bureau",
	description = S"Not government owned, but instead they own the government.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 250,
		["ul_market:industry_statlantic"] = 250,
		["ul_market:industry_stpacific"] = 250,
		["ul_market:industry_stafrican"] = 250,
		["ul_market:industry_stamerican"] = 250,
		["ul_market:industry_stasian"] = 250,
		["ul_market:industry_stindian"] = 250,
		["ul_market:industry_stslavic"] = 250,
		["ul_market:industry_enlistment"] = 50
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_nedu", {
	tag = "NEDU",
	title = S"National Education Plan",
	description = S"Organizes the education of youth.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 5,
		["ul_market:industry_statlantic"] = 5,
		["ul_market:industry_stpacific"] = 5,
		["ul_market:industry_stafrican"] = 5,
		["ul_market:industry_stamerican"] = 5,
		["ul_market:industry_stasian"] = 5,
		["ul_market:industry_stindian"] = 5,
		["ul_market:industry_stslavic"] = 5,
		["ul_market:industry_edu_secondary"] = 500,
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_uni", {
	tag = "UNI",
	title = S"Sexon University Agreement",
	description = S"A lobbyist group that owns most all post-secondary education institutions.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 5,
		["ul_market:industry_statlantic"] = 5,
		["ul_market:industry_edu_ps"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_scf", {
	tag = "SCF",
	title = S"Sexon Church Foundation",
	description = S"Promoters of the Sexon Church.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 20,
		["ul_market:industry_statlantic"] = 2,
		["ul_market:industry_stpacific"] = 3,
		["ul_market:industry_stafrican"] = 7,
		["ul_market:industry_stamerican"] = 12,
		["ul_market:industry_stasian"] = 1,
		["ul_market:industry_stindian"] = 14,
		["ul_market:industry_stslavic"] = 6,
		["ul_market:industry_magic"] = 200,
		["ul_market:industry_edu_secondary"] = 250,
		["ul_market:industry_edu_ps"] = 250,
		["ul_market:industry_religion"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_draft", {
	tag = "DRAFT",
	title = S"The Draft Company",
	description = S"The main source of conscripts.",
	attitude = {lobbying = 1.0, rigging = 1.0, violence = 0.1},
	shares = {
		["ul_market:industry_stmediterranean"] = 250,
		["ul_market:industry_statlantic"] = 250,
		["ul_market:industry_enlistment"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_nsia", {
	tag = "NSIA",
	title = S"National Social Insurance Agency",
	description = S"Private company that runs the vague social insurance industries.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 25,
		["ul_market:industry_statlantic"] = 25,
		["ul_market:industry_stpacific"] = 25,
		["ul_market:industry_stafrican"] = 25,
		["ul_market:industry_stamerican"] = 25,
		["ul_market:industry_stasian"] = 25,
		["ul_market:industry_stindian"] = 25,
		["ul_market:industry_stslavic"] = 25,
		["ul_market:industry_magic"] = 50,
		["ul_market:industry_construction"] = 50,
		["ul_market:industry_healthcare"] = 200,
		["ul_market:industry_healthcare"] = 200,
		["ul_market:industry_enlistment"] = 10,
		["ul_market:groceries"] = 50
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_gate", {
	tag = "GATE",
	title = S"Backdoor Gateway",
	description = S"Multinational grocer.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 5,
		["ul_market:industry_statlantic"] = 5,
		["ul_market:industry_stpacific"] = 5,
		["ul_market:industry_stafrican"] = 5,
		["ul_market:industry_stamerican"] = 5,
		["ul_market:industry_stasian"] = 5,
		["ul_market:industry_stindian"] = 5,
		["ul_market:industry_stslavic"] = 5,
		["ul_market:groceries"] = 500
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_smly", {
	tag = "SMLY",
	title = S"Smelly Joe's",
	description = S"Local grocer.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_statlantic"] = 500,
		["ul_market:groceries"] = 100
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})
ul_market.register_company("ul_market:company_cpne", {
	tag = "CPNE",
	title = S"Capone & Al",
	description = S"Suspiciously friendly grocery store & casino.",
	attitude = {lobbying = 1.0, rigging = 1.0},
	shares = {
		["ul_market:industry_stmediterranean"] = 25,
		["ul_market:industry_statlantic"] = 25,
		["ul_market:industry_stpacific"] = 25,
		["ul_market:industry_stafrican"] = 25,
		["ul_market:industry_stamerican"] = 25,
		["ul_market:industry_stasian"] = 25,
		["ul_market:industry_stindian"] = 25,
		["ul_market:industry_stslavic"] = 25,
		["ul_market:industry_gambling"] = 25,
		["ul_market:industry_black_market"] = 500,
		["ul_market:groceries"] = 5
	},
	stats = {supply = 1.0, demand = 1.0, cline = 1.0, strive = 1.0}
})

-----------
-- TRADE --
-----------

ul_market.register_goods {
	industry = "ul_market:industry_mining",
	items = {
		["ul_basic:stone"] = {supply = 192.0},
		["ul_basic:ore"] = {supply = 24.0},
		["ul_basic:ore_rare"] = {supply = 6.0},
		["ul_basic:ore_super"] = {supply = 1.5},
		["ul_magic:crystal"] = {supply = 0.75},
		["ul_mobs:kobold"] = {supply = 0.5},

		["ul_lives:life"] = {demand = 6.0},
		["ul_portal:portal"] = {demand = 24.0},
		["ul_magic:launch"] = {demand = 24.0},
		["ul_basic:pick"] = {demand = 24.0},
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_bones",
	items = {
		["ul_basic:bone"] = {supply = 3.0},
		["ul_basic:rod"] = {supply = 1.5},
		["ul_basic:pick"] = {supply = 0.5},
		["ul_mobs:stalker"] = {supply = 0.5},
		["ul_mobs:ghost"] = {supply = 0.25},
		["ul_mobs:skeleton"] = {supply = 0.25},
		["ul_mobs:vampire"] = {supply = 0.25},
		["ul_mobs:zombie"] = {supply = 0.25},

		["ul_lives:life"] = {demand = 6.0},
		["ul_mobs:rgull"] = {demand = 3.0},
		["ul_basic:sword"] = {demand = 3.0},
		["ul_basic:knife"] = {demand = 3.0},
		["ul_magic:defense"] = {demand = 1.5},
		["ul_magic:ring"] = {demand = 1.5},
		["ul_magic:cloak"] = {demand = 0.75}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_breeding",
	items = {
		["ul_mobs:eye"] = {supply = 6.0},
		["ul_mobs:big_eye"] = {supply = 3.0},
		["ul_mobs:ghost"] = {supply = 3.0},
		["ul_mobs:skeleton"] = {supply = 1.5},
		["ul_mobs:vampire"] = {supply = 1.5},
		["ul_mobs:zombie"] = {supply = 1.5},
		["ul_mobs:mgull"] = {supply = 0.75},
		["ul_mobs:rgull"] = {supply = 0.75, demand = 0.5},
		["ul_mobs:horbold"] = {supply = 0.5},
		["ul_mobs:lich"] = {supply = 0.5},
		
		["ul_lives:life"] = {demand = 6.0},
		["ul_basic:sword"] = {demand = 6.0},
		["ul_basic:knife"] = {demand = 6.0},
		["ul_magic:defense"] = {demand = 3.0},
		["ul_magic:ring"] = {demand = 3.0},
		["ul_magic:cloak"] = {demand = 1.5}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_magic",
	items = {
		["ul_magic:spell"] = {supply = 12.0},
		["ul_magic:fireball"] = {supply = 12.0},
		["ul_magic:levitate"] = {supply = 6.0},
		["ul_magic:defense"] = {supply = 6.0},
		["ul_magic:shard"] = {supply = 3.0},
		["ul_magic:heal"] = {supply = 3.0},
		["ul_magic:vampirism"] = {supply = 3.0},
		["ul_magic:darkness"] = {supply = 3.0},
		["ul_magic:crystal"] = {supply = 1.5},
		["ul_magic:regen"] = {supply = 1.5},
		["ul_magic:poison"] = {supply = 1.5},
		["ul_magic:launch"] = {supply = 1.5},
		["ul_magic:teleport"] = {supply = 1.5},
		["ul_magic:iridescence"] = {supply = 1.5},
		["ul_magic:light"] = {supply = 1.5},
		["ul_magic:moon"] = {supply = 0.5},
		["ul_magic:sun"] = {supply = 0.5},
		["ul_magic:blood"] = {supply = 0.5},

		["ul_magic:runestone"] = {demand = 384.0},
		["ul_mobs:mgull"] = {demand = 12.0},
	}
}

ul_market.register_goods {
	industry = "ul_market:industry_smithery",
	items = {
		["ul_basic:knife"] = {supply = 6.0},
		["ul_basic:pick"] = {supply = 3.0},
		["ul_basic:sword"] = {supply = 3.0},
		["ul_magic:ring"] = {supply = 0.75},
		["ul_magic:cloak"] = {supply = 0.25},

		["ul_basic:bone"] = {demand = 12.0},
		["ul_basic:rod"] = {demand = 6.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_construction",
	items = {
		["ul_basic:building"] = {supply = 3.0},
		["ul_basic:ladder"] = {supply = 3.0},
		["ul_basic:window"] = {supply = 1.5},
		["ul_basic:door"] = {supply = 1.5},

		["ul_basic:bone"] = {demand = 12.0},
		["ul_basic:rod"] = {demand = 6.0},
		["ul_basic:stone"] = {demand = 3.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_tech",
	items = {
		["ul_storage:crate"] = {supply = 3.0},
		["ul_portal:portal"] = {supply = 1.5},
		["ul_magic:runestone"] = {supply = 0.75},

		["ul_magic:crystal"] = {demand = 12.0},
		["ul_basic:stone"] = {demand = 6.0},
		["ul_basic:lantern"] = {demand = 3.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_light",
	items = {
		["ul_basic:lantern"] = {supply = 6.0},
		["ul_basic:lamp"] = {supply = 3.0},

		["ul_basic:stone"] = {demand = 12.0},
		["ul_magic:shard"] = {demand = 12.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_medicine",
	items = {
		["ul_market:hp_vial"] = {supply = 6.0},
		["ul_lives:life"] = {supply = 6.0},

		["ul_magic:heal"] = {demand = 12.0},
		["ul_basic:ore"] = {demand = 12.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_forgery",
	items = {
		["lootblocks:lootblock"] = {supply = 6.0},
		["lootblocks:lootblock_rare"] = {supply = 3.0},
		["lootblocks:lootblock_super"] = {supply = 1.5},

		["ul_basic:ore_super"] = {demand = 12.0},
		["ul_storage:crate"] = {demand = 12.0},
		["ul_basic:ore_rare"] = {demand = 6.0},
		["ul_basic:ore"] = {demand = 3.0},
		["ul_portal:portal"] = {demand = 3.0}
	}
}

ul_market.register_goods {
	industry = "ul_market:industry_enlistment",
	items = {
		["ul_portal:portal"] = {demand = 24.0},
		["ul_basic:sword"] = {demand = 24.0},
		["ul_basic:knife"] = {demand = 24.0},
		["ul_magic:cloak"] = {demand = 24.0},
		["ul_market:hp_vial"] = {demand = 12.0},
		["ul_lives:life"] = {demand = 6.0},
		["ul_magic:heal"] = {demand = 6.0},
		["ul_magic:ring"] = {demand = 6.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_retail",
	items = {
		["ul_portal:portal"] = {demand = 24.0},
		["ul_magic:spell"] = {demand = 12.0},
		["ul_magic:heal"] = {demand = 12.0},
		["ul_basic:lantern"] = {demand = 12.0},
		["ul_basic:knife"] = {demand = 12.0},
		["ul_storage:crate"] = {demand = 12.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_housing",
	items = {
		["ul_portal:portal"] = {demand = 48.0},
		["ul_storage:crate"] = {demand = 48.0},
		["ul_basic:building"] = {demand = 24.0},
		["ul_basic:lamp"] = {demand = 24.0},
		["ul_basic:window"] = {demand = 24.0},
		["ul_basic:ladder"] = {demand = 24.0},
		["ul_basic:door"] = {demand = 24.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_gambling",
	items = {
		["lootblocks:lootblock_super"] = {demand = 96.0},
		["lootblocks:lootblock_rare"] = {demand = 48.0},
		["lootblocks:lootblock"] = {demand = 24.0},
		["ul_storage:crate"] = {demand = 12.0},
		["ul_basic:lamp"] = {demand = 12.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_art",
	items = {
		["ul_mobs:big_eye"] = {demand = 3.0},
		["ul_mobs:eye"] = {demand = 3.0},
		["ul_mobs:ghost"] = {demand = 3.0},
		["ul_mobs:skeleton"] = {demand = 3.0},
		["ul_mobs:vampire"] = {demand = 3.0},
		["ul_mobs:zombie"] = {demand = 3.0},
		["ul_portal:portal"] = {demand = 0.5},
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_healthcare",
	items = {
		["ul_portal:portal"] = {demand = 24.0},
		["ul_magic:spell"] = {demand = 12.0},
		["ul_magic:regen"] = {demand = 12.0},
		["ul_magic:heal"] = {demand = 12.0},
		["ul_basic:lamp"] = {demand = 12.0},
		["ul_lives:life"] = {demand = 6.0}
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_black_market",
	items = {
		["ul_magic:darkness"] = {demand = 48.0},
		["ul_portal:portal"] = {demand = 24.0},
		["ul_magic:moon"] = {demand = 24.0},
		["ul_magic:sun"] = {demand = 24.0},
		["ul_magic:blood"] = {demand = 24.0},
		["ul_lives:life"] = {demand = 6.0},
		["ul_mobs:rgull"] = {demand = 6.0},
		["ul_magic:fireball"] = {demand = 3.0},
		["ul_magic:poison"] = {demand = 3.0},
		["ul_mobs:mgull"] = {demand = 3.0},
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_illtrade_rune",
	items = {
		["ul_magic:darkness"] = {demand = 48.0},
		["ul_portal:portal"] = {demand = 24.0},
		["ul_magic:moon"] = {demand = 24.0},
		["ul_magic:sun"] = {demand = 24.0},
		["ul_magic:blood"] = {demand = 24.0},
		["ul_magic:fireball"] = {demand = 3.0},
		["ul_magic:poison"] = {demand = 3.0},
		["ul_magic:vampirism"] = {demand = 3.0},
		["ul_magic:levitate"] = {demand = 3.0},
		["ul_magic:iridescence"] = {demand = 3.0},
		["ul_magic:light"] = {demand = 3.0},
	}
}
ul_market.register_goods {
	industry = "ul_market:industry_illtrade_mobs",
	items = {
		["ul_mobs:alien"] = {demand = 48.0},
		["ul_mobs:eeltig"] = {demand = 48.0},
		["ul_mobs:lootglob"] = {demand = 48.0},
		["ul_mobs:shadow"] = {demand = 48.0},
		["ul_mobs:horbold"] = {demand = 24.0},
		["ul_mobs:lich"] = {demand = 24.0},
		["ul_mobs:stalker"] = {demand = 12.0},
		["ul_mobs:kobold"] = {demand = 12.0},
	}
}

------------
-- EVENTS --
------------

ul_market.register_event("ul_market:event_growth", {
	title = S"Golden Age",
	description = S"Prosperity across Sexland",
	effect_groups = {
		overall = {strive = 0, cline = 0.5}
	},
	unrest = -1.0
})

ul_market.register_event("ul_market:event_bubble", {
	title = S"Market Bubble",
	description = S"A sudden explosion of value",
	effect_groups = {
		overall = {strive = 0, cline = 1.0}
	},
	target = {
		company = 10,
		industry = 10
	},
	unrest = -1.0
})

ul_market.register_event("ul_market:event_subsidies", {
	title = S"Subsidization",
	description = S"The government has invested",
	effect_groups = {
		overall = {strive = 0, cline = 0.1}
	},
	target = {
		company = 1,
		industry = 1
	},
	unrest = -1.0
})

ul_market.register_event("ul_market:event_famine", {
	title = S"Famine",
	description = S"Famine",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		civilian = {strive = -0.5, cline = 0.5},
	},
	unrest = 5.0
})
ul_market.register_event("ul_market:event_epidemic", {
	title = S"Epidemic",
	description = S"Medical disaster",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		medical = {strive = -0.5, cline = 1.0},
	},
	unrest = 5.0
})
ul_market.register_event("ul_market:event_strike", {
	title = S"Strike",
	description = S"Workers striking",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		labour = {strive = -0.5, cline = 0}
	},
	unrest = 0.5,
	target = {
		company = 10,
		industry = 10
	}
})
ul_market.register_event("ul_market:event_protest", {
	title = S"Protest",
	description = S"Protesters protesting",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		civilian = {strive = -0.1, cline = -0.05}
	},
	unrest = 0.5,
	target = {
		company = 10,
		industry = 10
	}
})
ul_market.register_event("ul_market:event_assassination", {
	title = S"Assassination",
	description = S"An important figure has been murdered",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		civilian = {strive = -0.1, cline = -0.05},
		criminal = {strive = 0, cline = 0.1},
		war = {strive = 0, cline = 0.1}
	},
	unrest = 10.0,
	target = {
		company = 10,
		industry = 10
	}
})
ul_market.register_event("ul_market:event_uprising", {
	title = S"Uprising",
	description = S"Violent demonstrations",
	effect_groups = {
		overall = {strive = -0.1, cline = 0},
		civilian = {strive = -0.1, cline = -0.05},
		criminal = {strive = 0, cline = 0.1}
	},
	unrest = 1.0,
	target = {
		company = 10,
		industry = 10
	}
})
ul_market.register_event("ul_market:event_coup", {
	title = S"Coup d'Etat",
	description = S"Upper Class Uprisings",
	effect_groups = {
		overall = {strive = -0.5, cline = 0},
		civilian = {strive = -1.0, cline = -0.05},
		criminal = {strive = 0, cline = 1.0}
	},
	unrest = 10.0,
	target = {
		company = 10,
		industry = 10
	}
})

--------------
-- POLICIES --
--------------

-- subsidies: fund companies/industries
-- in the extreme:
	-- money goes up
ul_market.register_policy("ul_market:policy_subsidies", {
	title = S"Subsidies",
	description = S"Subsidize the market.",
	effect_groups = {
		criminal = {strive = 0, cline = -0.5}
	},
	effect_events = {
		["ul_market:event_subsidies"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_bubble"] = {chance = -0.1, intensity = 1.0}
	}
})

-- public_education: make education more accessible
-- in the extreme:
	-- education is massive
ul_market.register_policy("ul_market:policy_public_education", {
	title = S"Public Education",
	description = S"Educate the masses.",
	effect_groups = {
		overall = {strive = 0, cline = 0.1},
		education = {strive = -0.05, cline = 0.0},
		civilian = {strive = 0.1, cline = 0.0},
		war = {strive = 0, cline = -0.1},
		slave_trade = {strive = 0, cline = -0.1},
		criminal = {strive = 0, cline = -0.1},
		religion = {strive = 0, cline = 0.1}
	},
	effect_events = {
		["ul_market:event_protest"] = {chance = 0.05, intensity = 1.0},
		["ul_market:event_strike"] = {chance = 0.05, intensity = 1.0},
		["ul_market:event_uprising"] = {chance = 0.05, intensity = 1.0}
	}
})

-- secularism: less religious government
-- in the extreme:
	-- religion is dead
ul_market.register_policy("ul_market:policy_secularism", {
	title = S"Secularism",
	description = S"Separation of church and government.",
	effect_groups = {
		overall = {strive = 0, cline = 0.1},
		education = {strive = -0.05, cline = 0.0},
		civilian = {strive = 0.1, cline = 0.0},
		war = {strive = 0, cline = 0.1},
		slave_trade = {strive = 0, cline = 0.1},
		criminal = {strive = 0, cline = 0.1},
		religion = {strive = 0, cline = -0.1}
	},
	effect_events = {
		["ul_market:event_protest"] = {chance = 0.05, intensity = 1.0},
		["ul_market:event_strike"] = {chance = 0.05, intensity = 1.0},
		["ul_market:event_uprising"] = {chance = 0.05, intensity = 1.0},
		["ul_market:event_coup"] = {chance = 0.05, intensity = 1.0},
	}
})

-- regulation: make prices more consistent
-- in the extreme:
	-- all stocks sit at 0.87 (excluding criminal industries)
	-- all goods stay at a flat price (unless tied to crime)
	-- famines become more likely
	-- coups daily
ul_market.register_policy("ul_market:policy_regulation", {
	title = S"Regulation",
	description = S"Better for workers, probably.",
	effect_groups = {
		overall = {strive = 0.05, cline = -0.05},
		criminal = {strive = 0.05, cline = 0.1}
	},
	effect_events = {
		["ul_market:event_subsidies"] = {chance = 0.1, intensity = 0.1},
		["ul_market:event_bubble"] = {chance = -0.1, intensity = -1.0},
		["ul_market:event_coup"] = {chance = 0.1, intensity = 5.0},
		["ul_market:event_famine"] = {chance = 0.05}
	}
})
-- busting: get rid of strikes
-- in the extreme:
	-- strikes never happen (instead armed rebellions happen)
	-- assassinations happen constantly
	-- demand goes up for criminal industries
ul_market.register_policy("ul_market:policy_busting", {
	title = S"Union Busting",
	description = S"Divided, they won't get in my darn way.",
	effect_groups = {
		overall = {strive = 0.05, cline = 0},
		criminal = {strive = -0.1, cline = 0.05}
	},
	effect_events = {
		["ul_market:event_bubble"] = {chance = 0.1, intensity = 0.1},
		["ul_market:event_subsidies"] = {chance = -0.1, intensity = -1.0},
		["ul_market:event_strike"] = {chance = -0.1},
		["ul_market:event_assassination"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_uprising"] = {chance = 0.05, intensity = 1.5},
	}
})
-- martial_law: the military is the police
-- in the extreme:
	-- strikes/protests never happen
	-- assassinations happen constantly
	-- constant strife and uprisings
	-- civilian goods become crazy expensive
	-- demand goes up for criminal industries
ul_market.register_policy("ul_market:policy_martial_law", {
	title = S"Martial Law",
	description = S"Obey.",
	effect_groups = {
		overall = {strive = -0.05, cline = 0},
		civilian = {strive = -0.1, cline = 0.1},
		criminal = {strive = 0, cline = 0.05},
		war = {strive = 0.05, cline = 0.05}
	},
	effect_events = {
		["ul_market:event_strike"] = {chance = -0.1},
		["ul_market:event_protest"] = {chance = -0.1},
		["ul_market:event_assassination"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_uprising"] = {chance = 0.1, intensity = 5.0},
		["ul_market:event_famine"] = {chance = 0.1, intensity = 5.0},
		["ul_market:event_epidemic"] = {chance = 0.1, intensity = 5.0},
		["ul_market:event_coup"] = {chance = 0.1, intensity = 5.0}
	}
})
-- militarism: make the military bigger
-- in the extreme:
	-- most stocks are flat excluding the ones in war industries
	-- swords/knives become crazy expensive
	-- constant strikes/protests
ul_market.register_policy("ul_market:policy_militarism", {
	title = S"Militarism",
	description = S"Love the war machine.",
	effect_groups = {
		overall = {strive = -0.05, cline = 0},
		criminal = {strive = 0, cline = 0.05},
		war = {strive = 0.05, cline = 0.05}
	},
	effect_events = {
		["ul_market:event_strike"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_protest"] = {chance = 0.1, intensity = 0.5}
	}
})
-- prohibition: get rid of "immoral" pastimes
-- in the extreme:
	-- "immoral" pastimes become more demanded
	-- constant strikes/protests and health crises
ul_market.register_policy("ul_market:policy_prohibition", {
	title = S"Prohibition",
	description = S"The only solution.",
	effect_groups = {
		overall = {strive = 0.05, cline = -0.05},
		civilian = {strive = 0, cline = 0.05},
		criminal = {strive = 0, cline = 0.1},
		entertainment = {strive = -0.1, cline = 0.1}
	},
	effect_events = {
		["ul_market:event_strike"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_protest"] = {chance = 0.1, intensity = 0.5},
		["ul_market:event_epidemic"] = {chance = 0.1, intensity = 0.5}
	}
})
-- abolition: abolish slavery
-- in the extreme:
	-- rich people get mad
ul_market.register_policy("ul_market:policy_abolition", {
	title = S"Abolition",
	description = S"We'll find a way around it.",
	effect_groups = {
		slave_trade = {strive = 0, cline = -0.1},
		criminal = {strive = 0, cline = 0.1},
	},
	effect_events = {
		["ul_market:event_coup"] = {chance = 0.1, intensity = 5.0},
		["ul_market:event_growth"] = {chance = 0.5, intensity = 1.0}
	}
})
-- wealthfare: give money to poor people
-- in the extreme:
	-- no health crises
	-- no more unrest
	-- things become more expensive
ul_market.register_policy("ul_market:policy_welfare", {
	title = S"Welfare",
	description = S"Poor people need money too.",
	effect_groups = {
		overall = {strive = -0.05, cline = 0.05},
		civilian = {strive = -0.1, cline = 0.1},
		criminal = {strive = -0.1, cline = 0},
		[1] = {strive = -0.1, cline = 0}
	},
	effect_events = {
		["ul_market:event_strike"] = {chance = -0.05},
		["ul_market:event_protest"] = {chance = -0.05},
		["ul_market:event_assassination"] = {chance = -0.05},
		["ul_market:event_famine"] = {chance = 0.1, intensity = 0.1},
		["ul_market:event_epidemic"] = {chance = -0.025, intensity = -0.05}
	}
})
-- social_healthcare: subsidize healthcare
-- in the extreme:
	-- no health crises
ul_market.register_policy("ul_market:policy_social_healthcare", {
	title = S"Social Healthcare",
	description = S"Something something, hypocritical oats or whatever.",
	effect_groups = {
		overall = {strive = 0.05, cline = 0.05},
		medical = {strive = 0, cline = -0.5}
	},
	effect_events = {
		["ul_market:event_assassination"] = {chance = -0.05},
		["ul_market:event_epidemic"] = {chance = -0.025, intensity = -0.05}
	}
})
-- tariffs: tax imported goods
-- in the extreme:
	-- criminals own everything
	-- shortages become more common
ul_market.register_policy("ul_market:policy_tariffs", {
	title = S"Tariffs",
	description = S"Make Great Again.",
	effect_groups = {
		overall = {strive = -0.1, cline = 0.1},
		criminal = {strive = 0.05, cline = 0.1}
	},
	effect_events = {
		["ul_market:event_famine"] = {chance = 0.1, intensity = 0.1},
		["ul_market:event_epidemic"] = {chance = 0.025, intensity = 0.05}
	}
})

-------------
-- PARTIES --
-------------
ul_market.register_party("ul_market:party_pps", {
	tag = S"PPS",
	title = S"Proletarian Party of Sexland",
	short_title = S"Proletarian",
	motto = S"Sexland For Workers",
	description = S"A controversial party due to its historical ties to authoritarian dicatatorships.",
	color = "#ff0000",
	starting_seats = 100,
	policies = {
		["ul_market:policy_social_healthcare"] = 5,
		["ul_market:policy_public_education"] = 5,
		["ul_market:policy_secularism"] = 5,
		["ul_market:policy_welfare"] = 5,
		["ul_market:policy_regulation"] = 5,
		["ul_market:policy_abolition"] = 5,
		["ul_market:policy_subsidies"] = 5,
		["ul_market:policy_busting"] = 0
	}
})
ul_market.register_party("ul_market:party_ssp", {
	tag = S"SSP",
	title = S"Sexon Social Party",
	short_title = S"Social",
	motto = S"Sexland For People",
	description = S"Historically the party of the working class.",
	color = "#ff7700",
	starting_seats = 200,
	policies = {
		["ul_market:policy_militarism"] = 0,
		["ul_market:policy_tariffs"] = 0,
		["ul_market:policy_busting"] = 0,
		["ul_market:policy_prohibition"] = 0,
		["ul_market:policy_social_healthcare"] = 3,
		["ul_market:policy_public_education"] = 4,
		["ul_market:policy_subsidies"] = 4,
		["ul_market:policy_welfare"] = 2,
		["ul_market:policy_regulation"] = 3,
		["ul_market:policy_martial_law"] = 0,
		["ul_market:policy_abolition"] = 2
	}
})
ul_market.register_party("ul_market:party_lps", {
	tag = S"LPS",
	title = S"Liberal Party of Sexland",
	short_title = S"Liberal",
	motto = S"God Bless Sexland",
	description = S"The ancient party of the centre.",
	color = "#ffff00",
	starting_seats = 300,
	policies = {
		["ul_market:policy_militarism"] = 0,
		["ul_market:policy_tariffs"] = 0,
		["ul_market:policy_busting"] = 1,
		["ul_market:policy_prohibition"] = 0,
		["ul_market:policy_social_healthcare"] = 1,
		["ul_market:policy_public_education"] = 3,
		["ul_market:policy_secularism"] = 3,
		["ul_market:policy_subsidies"] = 1,
		["ul_market:policy_welfare"] = 1,
		["ul_market:policy_regulation"] = 0,
		["ul_market:policy_martial_law"] = 0
	}
})
ul_market.register_party("ul_market:party_scp", {
	tag = S"SCP",
	title = S"Sexon Conservative Party",
	short_title = S"Conservative",
	motto = S"Made in Sexland",
	description = S"The spiritual successor to the now defunct Progressive Conservative Party of Sexland.",
	color = "#0000ff",
	starting_seats = 200,
	policies = {
		["ul_market:policy_militarism"] = 1,
		["ul_market:policy_tariffs"] = 2,
		["ul_market:policy_busting"] = 2,
		["ul_market:policy_prohibition"] = 2,
		["ul_market:policy_martial_law"] = 1,
		["ul_market:policy_social_healthcare"] = 0,
		["ul_market:policy_public_education"] = 3,
		["ul_market:policy_subsidies"] = 0,
		["ul_market:policy_welfare"] = 0,
		["ul_market:policy_regulation"] = 0
	}
})
ul_market.register_party("ul_market:party_spp", {
	tag = S"SPP",
	title = S"Sexon Patriot Party",
	short_title = S"Patriot",
	description = S"Made up of defecters from the SCP who agreed more with the NPS. Signs often vandalized.",
	motto = S"Save Sexland",
	color = "#7700ff",
	starting_seats = 100,
	policies = {
		["ul_market:policy_militarism"] = 2,
		["ul_market:policy_tariffs"] = 3,
		["ul_market:policy_busting"] = 3,
		["ul_market:policy_prohibition"] = 3,
		["ul_market:policy_martial_law"] = 2,
		["ul_market:policy_social_healthcare"] = 0,
		["ul_market:policy_public_education"] = 2,
		["ul_market:policy_secularism"] = 1,
		["ul_market:policy_subsidies"] = 1,
		["ul_market:policy_welfare"] = 0,
		["ul_market:policy_regulation"] = 0,
		["ul_market:policy_abolition"] = 0
	}
})
ul_market.register_party("ul_market:party_nps", {
	tag = S"NPS",
	title = S"National Party of Sexland",
	short_title = S"National",
	motto = S"Make Sexland Great Again",
	description = S"A controversial party due to its historical ties to authoritarian dictatorships.",
	color = "#000000",
	starting_seats = 100,
	policies = {
		["ul_market:policy_militarism"] = 5,
		["ul_market:policy_tariffs"] = 5,
		["ul_market:policy_busting"] = 5,
		["ul_market:policy_prohibition"] = 5,
		["ul_market:policy_martial_law"] = 5,
		["ul_market:policy_social_healthcare"] = 0,
		["ul_market:policy_public_education"] = 0,
		["ul_market:policy_secularism"] = 0,
		["ul_market:policy_subsidies"] = 5,
		["ul_market:policy_welfare"] = 0,
		["ul_market:policy_regulation"] = 0,
		["ul_market:policy_abolition"] = 0
	}
})

ul_market.policy_intensities = {
	"No @1",
	"Low @1",
	"Moderate @1",
	"High @1",
	"Very High @1",
	"Extreme @1",
}
function ul_market.get_policy_name(lvl, name)
	return S(ul_market.policy_intensities[math.min(lvl + 1, #ul_market.policy_intensities)], name)
end