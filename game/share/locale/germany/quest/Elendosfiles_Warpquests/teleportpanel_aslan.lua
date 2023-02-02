--+-------------------------------+------------+
--+-------------------------------+------------+
--|                                      		|                 |
--| Teleport-Panel Quest by Aslan 	| Version 1.0 |
--|                                      		|                 |
--+-------------------------------+------------+
--+-------------------------------+------------+

quest teleportpanel_aslan begin
	state start begin

---------------------------------------------------------------------------------------------------
---------------------------------     TELEPORT CONFIG     -----------------------------------------
---------------------------------------------------------------------------------------------------

		function MAP_DICT()
		return 
		{
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- EMPIRES
			{["command"] = "m1_red",		["coord_red"] = { 474300, 954800}, 	["coord_yel"] = { 474300, 954800}, 	["coord_blu"] = { 474300, 954800},			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "m1_yel",		["coord_red"] = { 63800, 166400}, 	["coord_yel"] = { 63800, 166400}, 	["coord_blu"] = { 63800, 166400}, 			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "m1_blu",		["coord_red"] = { 959900, 269200}, 	["coord_yel"] = { 959900, 269200}, 	["coord_blu"] = { 959900, 269200}, 			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "m2_red",		["coord_red"] = { 353100, 882900}, 	["coord_yel"] = { 353100, 882900}, 	["coord_blu"] = { 353100, 882900},			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "m2_yel",		["coord_red"] = { 145500, 240000}, 	["coord_yel"] = { 145500, 240000}, 	["coord_blu"] = { 145500, 240000},			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "m2_blu",		["coord_red"] = { 863900, 246000}, 	["coord_yel"] = { 863900, 246000}, 	["coord_blu"] = { 863900, 246000}, 			["min_lv"] = 1,		["max_lv"] = 250,	["money_cost"] = 0, 	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "dungeon_city_crafting",	["coord_red"] = { 870100, 357800},	["coord_yel"] = { 870100, 357800},		["coord_blu"] = { 870100, 357800},		["min_lv"] = 1,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "dungeon_city_dungeons",	["coord_red"] = { 858800, 359000},	["coord_yel"] = { 858800, 359000},		["coord_blu"] = { 858800, 359000},		["min_lv"] = 1,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "Elendosfiles_pvp_port",	["coord_red"] = { 472900, 484100},	["coord_yel"] = { 472900, 484100},		["coord_blu"] = { 472900, 484100},		["min_lv"] = 100,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- NEUTRAL
			{["command"] = "seungryong_start",	["coord_red"] = { 402500, 673500},	["coord_yel"] = { 270000, 740200},		["coord_blu"] = { 320700, 808400},		["min_lv"] = 20,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "seungryong_middle",	["coord_red"] = { 345900, 731900},	["coord_yel"] = { 317100, 731900},		["coord_blu"] = { 333100, 755900},		["min_lv"] = 20,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "seungryong_rek",	["coord_red"] = { 280500, 792600},	["coord_yel"] = { 280500, 792600},		["coord_blu"] = { 280500, 792600},		["min_lv"] = 20,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "yongbi_start",		["coord_red"] = { 216800, 628400},		["coord_yel"] = { 220800, 501300},		["coord_blu"] = { 344000, 502500},		["min_lv"] = 25,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "yongbi_middle",	["coord_red"] = { 297200, 547100},		["coord_yel"] = { 297200, 547100},		["coord_blu"] = { 297200, 547100},		["min_lv"] = 25,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "sohan_start",		["coord_red"] = { 434000, 292400},		["coord_yel"] = { 376000, 174000},		["coord_blu"] = { 492800, 172000},		["min_lv"] = 40,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "sohan_middle",		["coord_red"] = { 436500, 215300},		["coord_yel"] = { 436500, 215300},		["coord_blu"] = { 436500, 215300},		["min_lv"] = 40,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "fireland_start",		["coord_red"] = { 599500, 756400},		["coord_yel"] = { 597700, 622300},		["coord_blu"] = { 731500, 689600},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "fireland_middle",	["coord_red"] = { 604000, 682700},		["coord_yel"] = { 604000, 682700},		["coord_blu"] = { 604000, 682700},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "ghostwood_start",	["coord_red"] = { 289300, 5700},		["coord_yel"] = { 289300, 5700},		["coord_blu"] = { 289300, 5700},		["min_lv"] = 55,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "ghostwood_end",		["coord_red"] = { 286600, 43900},		["coord_yel"] = { 286600, 43900},		["coord_blu"] = { 286600, 43900},		["min_lv"] = 55,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "redwood_start",	["coord_red"] = { 1119000, 69700},		["coord_yel"] = { 1119000, 69700},		["coord_blu"] = { 1119000, 69700},		["min_lv"] = 60,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "redwood_end",		["coord_red"] = { 1120100, 11200},		["coord_yel"] = { 1120100, 11200},		["coord_blu"] = { 1120100, 11200},		["min_lv"] = 60,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "giants_start",		["coord_red"] = { 1811500, 1847000},		["coord_yel"] = { 1811500, 1847000},		["coord_blu"] = { 1811500, 1847000},		["min_lv"] = 65,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "giants_end",		["coord_red"] = { 1830000, 1812400},		["coord_yel"] = { 1830000, 1812400},		["coord_blu"] = { 1830000, 1812400},		["min_lv"] = 65,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "drachenfeuer",		["coord_red"] = { 1104700, 1786700},		["coord_yel"] = { 1104700, 1786700},		["coord_blu"] = { 1104700, 1786700},		["min_lv"] = 90,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "nephritbucht",		["coord_red"] = { 1087000, 1654500},		["coord_yel"] = { 1087000, 1654500},		["coord_blu"] = { 1087000, 1654500},		["min_lv"] = 90,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "donnerberge",		["coord_red"] = { 1134900, 1653600},		["coord_yel"] = { 1134900, 1653600},		["coord_blu"] = { 1134900, 1653600},		["min_lv"] = 90,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "verwaldport",		["coord_red"] = { 809200, 1496800},		["coord_yel"] = { 809200, 1496800},			["coord_blu"] = { 809200, 1496800},			["min_lv"] = 105,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "verwalddungeon",		["coord_red"] = { 828300, 1418500},		["coord_yel"] = { 828300, 1418500},			["coord_blu"] = { 828300, 1418500},			["min_lv"] = 105,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- DUNGEONS
			{["command"] = "sd1_start",		["coord_red"] = { 59900, 496300},			["coord_yel"] = { 59900, 496300},		["coord_blu"] = { 59900, 496300},		["min_lv"] = 40,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "sd1_end",		["coord_red"] = { 91600, 525300},			["coord_yel"] = { 91600, 525300},		["coord_blu"] = { 91600, 525300},		["min_lv"] = 40,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "sd2_start",		["coord_red"] = { 704100, 464100},		["coord_yel"] = { 704100, 464100},		["coord_blu"] = { 704100, 464100},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 71095, ["item_cost_count"] = 1 },
			{["command"] = "sd2_end",		["coord_red"] = { 704100, 522600},		["coord_yel"] = { 704100, 522600},		["coord_blu"] = { 704100, 522600},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 71095, ["item_cost_count"] = 1 },
			
			
			{["command"] = "sd3_start",		["coord_red"] = { 95100, 571000},		["coord_yel"] = { 95100, 571000},		["coord_blu"] = { 95100, 571000},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 71095, ["item_cost_count"] = 1 },
			{["command"] = "sd3_end",		["coord_red"] = { 68900, 610900},		["coord_yel"] = { 68900, 610900},		["coord_blu"] = { 68900, 610900},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 71095, ["item_cost_count"] = 1 },
			
			
			{["command"] = "deamontower",		["coord_red"] = { 590300, 110800},	["coord_yel"] = { 590300, 110800},		["coord_blu"] = { 590300, 110800},		["min_lv"] = 40,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "devilscatacomb",	["coord_red"] = { 586200, 98100},		["coord_yel"] = { 586200, 98100},		["coord_blu"] = { 586200, 98100},		["min_lv"] = 75,	["max_lv"] = 100,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "skipia1",			["coord_red"] = { 10000, 1213200},		["coord_yel"] = { 10000, 1213200},		["coord_blu"] = { 10000, 1213200},		["min_lv"] = 75,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 30190, ["item_cost_count"] = 1 },
			{["command"] = "skipia2",			["coord_red"] = { 241700, 1274900},		["coord_yel"] = { 241700, 1274900},	["coord_blu"] = { 241700, 1274900},	["min_lv"] = 75,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 30190, ["item_cost_count"] = 1 },
			{["command"] = "skipia_boss",	["coord_red"] = { 182500, 1220600},		["coord_yel"] = { 182500, 1220600},	["coord_blu"] = { 182500, 1220600},	["min_lv"] = 75,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 30190, ["item_cost_count"] = 1 },
			
			{["command"] = "blazingp",		["coord_red"] = { 598500, 707200},		["coord_yel"] = { 598500, 707200},		["coord_blu"] = { 598500, 707200},		["min_lv"] = 100,	["max_lv"] = 150,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "nemere",			["coord_red"] = { 432400, 168500},		["coord_yel"] = { 432400, 168500},		["coord_blu"] = { 432400, 168500},		["min_lv"] = 100,	["max_lv"] = 150,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 }, -- have sohan middle coordinate
			{["command"] = "hydraeingang",			["coord_red"] = { 168900, 612300},		["coord_yel"] = { 168900, 612300},		["coord_blu"] = { 168900, 612300},		["min_lv"] = 110,	["max_lv"] = 150,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- NEW DUNGEONS
			
			
			{["command"] = "slime_port",	["coord_red"] = { 857400, 361600},	["coord_yel"] = { 857400, 361600},		["coord_blu"] = { 857400, 361600},		["min_lv"] = 30,	["max_lv"] = 50,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "jungleport",	["coord_red"] = { 857200, 355200},	["coord_yel"] = { 857200, 355200},		["coord_blu"] = { 857200, 355200},		["min_lv"] = 50,	["max_lv"] = 85,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "chamberport",	["coord_red"] = { 857200, 362800},	["coord_yel"] = { 857200, 362800},		["coord_blu"] = { 857200, 362800},		["min_lv"] = 70,	["max_lv"] = 90,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "pflanzenport",	["coord_red"] = { 857400, 359100},	["coord_yel"] = { 857400, 359100},		["coord_blu"] = { 857400, 359100},		["min_lv"] = 75,	["max_lv"] = 95,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "sharkport",	["coord_red"] = { 857200, 360300},	["coord_yel"] = { 857200, 360300},		["coord_blu"] = { 857200, 360300},		["min_lv"] = 95,	["max_lv"] = 130,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "trollport",	["coord_red"] = { 857100, 357800},	["coord_yel"] = { 857100, 357800},		["coord_blu"] = { 857100, 357800},		["min_lv"] = 140,	["max_lv"] = 170,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "pyramideport",	["coord_red"] = { 731400, 2310400},	["coord_yel"] = { 731400, 2310400},		["coord_blu"] = { 731400, 2310400},		["min_lv"] = 150,	["max_lv"] = 200,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "skorpionport",	["coord_red"] = { 857200, 356400},	["coord_yel"] = { 857200, 356400},		["coord_blu"] = { 857200, 356400},		["min_lv"] = 180,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			
			
			
			{["command"] = "shadowentrice",	["coord_red"] = { 1903000, 2271300},	["coord_yel"] = { 1903000, 2271300},		["coord_blu"] = { 1903000, 2271300},		["min_lv"] = 180,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "seeleneingang",	["coord_red"] = { 3334000, 2377000},	["coord_yel"] = { 3334000, 2377000},		["coord_blu"] = { 3334000, 2377000},		["min_lv"] = 180,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- AN2 LEVEL MAPS
			{["command"] = "waterfallport",	["coord_red"] = { 1090200, 479900},	["coord_yel"] = { 1090200, 479900},		["coord_blu"] = { 1090200, 479900},		["min_lv"] = 95,	["max_lv"] = 120,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "dragonport1",	["coord_red"] = { 163200, 371100},	["coord_yel"] = { 163200, 371100},		["coord_blu"] = { 163200, 371100},		["min_lv"] = 120,	["max_lv"] = 135,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "dragonport2",	["coord_red"] = { 218100, 275700},	["coord_yel"] = { 218100, 275700},		["coord_blu"] = { 218100, 275700},		["min_lv"] = 120,	["max_lv"] = 135,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			
			{["command"] = "sandanfang",	["coord_red"] = { 653100, 2393500},	["coord_yel"] = { 653100, 2393500},		["coord_blu"] = { 653100, 2393500},		["min_lv"] = 135,	["max_lv"] = 200,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "sandmitte",	["coord_red"] = { 739100, 2276900},	["coord_yel"] = { 739100, 2276900},		["coord_blu"] = { 739100, 2276900},		["min_lv"] = 135,	["max_lv"] = 200,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "lavaeingang",	["coord_red"] = { 2600000, 2270100},	["coord_yel"] = { 2600000, 2270100},		["coord_blu"] = { 2600000, 2270100},		["min_lv"] = 150,	["max_lv"] = 200,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			{["command"] = "anduneingang",	["coord_red"] = { 3372400, 2260400},	["coord_yel"] = { 3372400, 2260400},		["coord_blu"] = { 3372400, 2260400},		["min_lv"] = 180,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
			-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- WORLDBOSS
			{["command"] = "worldbossfire",	["coord_red"] = { 901700, 664600},	["coord_yel"] = { 901700, 664600},		["coord_blu"] = { 901700, 664600},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			{["command"] = "worldbosselement",	["coord_red"] = { 807200, 803500},	["coord_yel"] = { 807200, 803500},		["coord_blu"] = { 807200, 803500},		["min_lv"] = 50,	["max_lv"] = 250,	["money_cost"] = 0,	["item_cost_vnum"] = 0, ["item_cost_count"] = 0 },
			
		}
		end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------
		----------------------------- Basic Quest | - | No Edit this -----------------------------------

		when login begin
			cmdchat('teleportpanel '..string.format("SET_QUEST_ID(%d)", q.getcurrentquestindex()))
		end
		
		when button begin
			local MAP_DICT = teleportpanel_aslan.MAP_DICT()
			local cmd = teleportpanel_aslan.get_quest_cmd()
			for i = 1, table.getn(MAP_DICT), 1 do
				if MAP_DICT[i]["command"] == cmd[2] then
					if pc.can_warp() == false then
						syschat("You can't teleport at the moment.")
						return
					end

					if pc.get_level() < MAP_DICT[i]["min_lv"]then
						syschat("Your level is too low to enter.")
						return
					end
					
					if pc.get_level() > MAP_DICT[i]["max_lv"]then
						syschat("Your level is too high to enter.")
						return
					end
					
					if pc.get_gold() < MAP_DICT[i]["money_cost"] then
						syschat("You don't have enough Yang.")
						return
					end
					
					if MAP_DICT[i]["item_cost_vnum"] != 0 and pc.count_item(MAP_DICT[i]["item_cost_vnum"]) < MAP_DICT[i]["item_cost_count"] then
						syschat("You don't have enough items.")
						return
					else
						pc.remove_item(MAP_DICT[i]["item_cost_vnum"], MAP_DICT[i]["item_cost_count"])
					end
					
					--syschat("Warp")
					pc.change_gold(-MAP_DICT[i]["money_cost"])
					if pc.get_empire() == 1 then
						pc.warp(MAP_DICT[i]["coord_red"][1], MAP_DICT[i]["coord_red"][2])
					elseif pc.get_empire() == 2 then
						pc.warp(MAP_DICT[i]["coord_yel"][1], MAP_DICT[i]["coord_yel"][2])
					elseif pc.get_empire() == 3 then
						pc.warp(MAP_DICT[i]["coord_blu"][1], MAP_DICT[i]["coord_blu"][2])
					end
					return
				end
			end
		end
		
		---------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------
		--------------------- CLIENT to QUEST functions | - | No Edit this ----------------------------
		
		function get_quest_cmd()
			cmdchat('GET_INPUT_BEGIN')
			local ret = input(cmdchat('teleportpanel GET_QUEST_CMD()'))
			cmdchat('GET_INPUT_END')
			-- syschat("cmd:"..ret)
			return teleportpanel_aslan.split_(ret,'#')
		end

		function split_(string_, sep)
			local sep, fields = sep or ":", {}
			local pattern = string.format("([^%s]+)", sep)
			string.gsub(string_,pattern, function(c) fields[table.getn(fields)+1] = c end)
			return fields
		end
	end
end
