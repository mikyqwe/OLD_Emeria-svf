quest Easter2020Dungeon_zone begin
	state start begin
		when login with Easter2020DungeonLIB.isActive() begin
			local settings = Easter2020DungeonLIB.Settings();
			
			Easter2020DungeonLIB.setOutCoords()
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("Easter2020Dungeon_level", 1);
				d.spawn_mob(8461, 201, 281)
				
				server_timer("EasterDungeon2020_30min_left", 10*60, d.get_map_index())
				
				d.notice(string.format("Rabbit hole: Destroy the %s", mob_name(8461)))
			end
		end
		
		------------
		-- First floor - Destroying first stone 
		-- Second floor - killing right stone
		------------		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 8461 begin
			local settings = Easter2020DungeonLIB.Settings();
			if d.getf("Easter2020Dungeon_level") == 1 then   ---First floor, first stone
				d.notice("Rabbit hole: Good job! Monsters are coming!")
				server_timer("Easter2020_WaveSpawn1", 12, d.get_map_index())
			elseif d.getf("Easter2020Dungeon_level") == 7 then 
				if d.is_unique_dead("real_stone") then			
					game.drop_item(30790, 1)
					d.notice(string.format("Rabbit hole: You got the item! Let's go back to %s", mob_name(9308)))
					d.purge_area(433400, 2269200, 452500, 2285100)
				else
					d.notice("Rabbit hole: This stone doesn't has the right piece.")
				end
			end
		end
		
		------------
		-- First floor - Spawning first monsters wave
		------------		
		
		when Easter2020_WaveSpawn1.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/easter2020/regen_1a.txt");
				d.setf("Easter2020_mobs1", d.count_monster())
			end
		end

		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and d.getf("Easter2020Dungeon_level") == 1 begin
			local settings = Easter2020DungeonLIB.Settings();
			
			d.setf("Easter2020_mobs1", d.getf("Easter2020_mobs1")-1)
			if d.getf("Easter2020_mobs1") < 1 then
				d.notice("Rabbit hole: You've killed all monsters.")
				d.notice(string.format("Rabbit hole: Kill %s within 2 minutes, otherwise, he will spawn again!", mob_name(4102)))
				server_timer("Easter2020_WaveSpawn2", 5, d.get_map_index())
				
				d.setf("Easter2020Dungeon_level", 2); d.setf("Easter2020Dungeon_FirstBossKill", 0);
			end
		end
		
		when Easter2020_WaveSpawn2.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(4102, 218, 374)
				server_timer("Easter2020_BossCheck", 120, d.get_map_index())
			end
		end
		
		------------
		-- First floor - Killing first boss
		------------		
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 4102 begin
			local settings = Easter2020DungeonLIB.Settings();
			if d.getf("Easter2020Dungeon_level") == 2 then   ---First floor, first stone
				clear_server_timer("Easter2020_BossCheck", get_server_timer_arg())
				d.notice("Rabbit hole: Good job! You will be teleported to next floor!")
				d.setf("Easter2020Dungeon_FirstBossKill", 1);
				server_timer("Easter2020_Jump", 10, d.get_map_index())
			elseif d.getf("Easter2020Dungeon_level") == 14 then   ---First floor, first stone
				if d.is_unique_dead("real_boss") then
					d.purge_area(436200, 2299100, 450000, 2314200);
					game.drop_item(30793, 1)
					d.setf("Easter2020Dungeon_level", 15);
					d.notice("Rabbit hole: Perfect, you found the key!")
				else
					d.notice("Rabbit hole: He has not the key.")
				end
			end
		end
		
		------------
		-- First floor - Respawn of the boss if you wont kill him within 2 minutes!
		------------		
		
		when Easter2020_BossCheck.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("Easter2020Dungeon_FirstBossKill") == 0 then
					d.purge_area(398600, 2276600, 412000, 2294000)
					d.spawn_mob(4102, 210, 319)
					d.notice(string.format("Rabbit hole: %s has healed and respawned! Kill him!!", mob_name(4102)))
				end
			end
		end
		
		------------
		-- Jump to second floor
		------------		
		
		when Easter2020_Jump.server_timer begin
			local settings = Easter2020DungeonLIB.Settings();
			if d.select(get_server_timer_arg()) then
				d.setf("Easter2020Dungeon_level", 3);
				d.purge_area(398600, 2276600, 412000, 2294000)
				d.jump_all(settings["insidePos"][3], settings["insidePos"][4])
				d.spawn_mob_dir(9309, 609, 362, 1)
				
				d.regen_file("data/dungeon/easter2020/regen_2a.txt");
				d.setf("Easter2020_mobs2", d.count_monster())
			end
		end
		
		------------
		-- Second floor - Killing first monster wave + spawn npc and drop key
		------------		
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and d.getf("Easter2020Dungeon_level") == 3 begin
			local settings = Easter2020DungeonLIB.Settings();
			
			d.setf("Easter2020_mobs2", d.getf("Easter2020_mobs2")-1)
			if d.getf("Easter2020_mobs2") < 1 then
				d.notice(string.format("Rabbit hole: You've got a %s!", item_name(30788)))
				d.notice(string.format("Rabbit hole: Bring it to the %s!", mob_name(9308)))
				
				d.setf("Easter2020Dungeon_level", 4)
				game.drop_item(30788, 1)
				d.spawn_mob_dir(9308, 608, 355, 5)				
			end
		end
		
		------------
		-- Second floor - Talking with rabbit (9308) after you put item on him
		------------		
		
		when 9308.take with item.get_vnum() == 30788 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 4 begin
			local settings = Easter2020DungeonLIB.Settings(); local CarrotPos = settings["CarrotPos"]; local CarrotCount = table.getn(CarrotPos); local randomNumber = number(1, table.getn(CarrotPos))	
			item.remove()
			addimage(25, 10, "easter2020_bg2.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Thank you! I need this chocolate! It gives me so much[ENTER]energy. You will need my help. This waffle door can be[ENTER]opened just by magic i know.")
			wait()
			addimage(25, 10, "easter2020_bg2.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("So, i will need couple of requsites.[ENTER]First one is:")
			say_item(""..item_name(30789).."", 30789, "")
			wait()
			setskin(NOWINDOW)
			
			d.setf("Easter2020Dungeon_level", 5);						

			for index = 1, CarrotCount, 1 do
				local FrestCarrot = d.spawn_mob(9310, CarrotPos[index][1], CarrotPos[index][2])
				if index == randomNumber then
					d.set_unique("fresh_carrot", FrestCarrot)
				end
			end
			d.set_unique ("fresh_carrot",vid)
			d.notice(string.format("Rabbit hole: Find fresh carrot and bring it back to %s!", mob_name(9308)))
		end
		
		------------
		-- Second floor - Searching for right carrot
		------------		
		
		when 9310.click with Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 5 begin
			if (npc.get_vid() == d.get_unique_vid("fresh_carrot")) then
				d.setf("Easter2020Dungeon_level", 6);
				game.drop_item(30789, 1)
				npc.purge()
				chat(string.format("Rabbit hole: This one seems really fresh. Take it to %s!", mob_name(9308)))
			else
				npc.purge()
				chat("Rabbit hole: This one is completly rotten")
			end
		end
		
		------------
		-- Second floor - Putting carrot to npc + spawn of stones
		------------		
		
		when 9308.take with item.get_vnum() == 30789 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 6 begin
			local settings = Easter2020DungeonLIB.Settings(); local position = settings["StonePos"]; local n = number(1,7)
			item.remove()
			addimage(25, 10, "easter2020_bg2.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Perfect, one more thing. I need:")
			say_item(""..item_name(30790).."", 30790, "")
			say(string.format("You can get it from %s, but only[ENTER]one stone contains this right piece.", mob_name(8461)))
			wait()
			setskin(NOWINDOW)
			
			d.setf("Easter2020Dungeon_level", 7);						
			for i = 1, 7 do
				if (i != n) then
					d.set_unique("fake_stone"..i, d.spawn_mob(8461, position[i][1], position[i][2]))
				end
			end		
			local vid = d.spawn_mob(8461, position[n][1], position[n][2])
			d.set_unique ("real_stone",vid)
			d.notice(string.format("Rabbit hole: Destroy right stone and get %s from it!", item_name(30790)))
		end
		
		------------
		-- Second floor - Putting 30790 to npc + spawn of npc and monsters in next stage
		------------		
		when 9308.take with item.get_vnum() == 30790 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 7 begin
			local settings = Easter2020DungeonLIB.Settings();
			item.remove(); npc.purge();
			d.kill_all();
			
			d.setf("Easter2020Dungeon_level", 8);
			d.spawn_mob_dir(9309, 597, 476, 1); -- Door
			d.spawn_mob_dir(9311, 598, 469, 4); -- Basket			
			server_timer("Easter2020_BasketSpawn", 4, d.get_map_index())			
		end
		
		------------
		-- Third floor - Basket spawn - random position of real basket
		------------		
		when Easter2020_BasketSpawn.server_timer begin
			local settings = Easter2020DungeonLIB.Settings(); local position = settings["BasketPos"]; local n = number(1,10)
			if d.select(get_server_timer_arg()) then
				for i = 1, 10 do
					if (i != n) then
						d.set_unique("fake_basket"..i, d.spawn_mob(8462, position[i][1], position[i][2]))
					end
				end		
				local vid = d.spawn_mob(8462, position[n][1], position[n][2])
				d.set_unique ("real_basket",vid)
			end
		end

		------------
		-- Third floor - destroying baskets to get 30791
		------------		
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 8462 begin
			local settings = Easter2020DungeonLIB.Settings();
			if d.getf("Easter2020Dungeon_level") == 8 then
				if d.is_unique_dead("real_basket") then
					game.drop_item(30791, 1)
					d.purge_area(442100, 2287200, 445700, 2299400)
				else
					return
				end
			end
		end
		
		when 9311.take with item.get_vnum() == 30791 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 8 begin
			local settings = Easter2020DungeonLIB.Settings();
			d.spawn_mob_dir(9312, 598, 469, 4);
			item.remove();
			npc.kill();
			
			d.notice("Rabbit hole: The basket is not full yet.")
			server_timer("Easter2020_BasketSpawn", 4, d.get_map_index())			
		end
		
		when 9312.take with item.get_vnum() == 30791 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 8 begin
			local settings = Easter2020DungeonLIB.Settings();
			d.spawn_mob_dir(9313, 598, 469, 4);
			item.remove();
			npc.kill();
			
			d.notice("Rabbit hole: The basket is not full yet.")
			server_timer("Easter2020_BasketSpawn", 4, d.get_map_index())			
		end
		
		when 9313.take with item.get_vnum() == 30791 and Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 8 begin
			local settings = Easter2020DungeonLIB.Settings();
			d.spawn_mob_dir(9314, 598, 469, 4); d.spawn_mob_dir(9308, 599, 454, 5);
			item.remove();
			npc.kill();
			
			d.notice("Rabbit hole: The basket is full enough now!")
			d.notice(string.format("Rabbit hole: %ss are coming!", mob_name(4102)))
			server_timer("Spawn_2boss", 4, d.get_map_index())			
		end
		
		when 9314.click with Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 8 begin
			if party.is_party() and not party.is_leader() then
				chat("Rabbit hole: Only leader of your group can take the basket")
			else
				npc.purge()
				pc.give_item2(30792, 1)
				chat(string.format("Rabbit hole: Let's talk with %s", mob_name(9308)))
				d.setf("Easter2020Dungeon_level", 9);
			end
		end
		
		when 9308.chat."What next?" with Easter2020DungeonLIB.isActive() and d.getf("Easter2020Dungeon_level") == 9 begin
			addimage(25, 10, "easter2020_bg3.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			if party.is_party() and not party.is_leader() then
				say_reward("Only leader of your group can do it.")
				return;
			else
				if pc.count_item(30792) < 1 then
					say("I can help you, but i need")
					say_item(""..item_name(30792).."", 30792, "")
					say("for that. Without this item i can not help you.[ENTER]Once you have it, you can proceed.")
				else
					pc.remove_item(30792, 1)
					say("Oh, you have the basket. Perfect!![ENTER]I don't have much more energy. But its enough[ENTER]to destroy the door. I have go out of this place[ENTER]then. I won't be no more able to help you here.[ENTER]You have to finish it by yourself!!")
					wait()
					setskin(NOWINDOW)
					npc.purge();
					d.kill_all();
					d.setf("Easter2020Dungeon_level", 10);
					d.regen_file("data/dungeon/easter2020/regen_4a.txt");
					d.set_regen_file("data/dungeon/easter2020/regen_4b.txt");
					d.notice("Rabbit hole: Break the magic by open all chests!")
					d.notice(string.format("Rabbit hole: This the only way to uncover %s!", mob_name(4103)))
				end
			end
		end
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and d.getf("Easter2020Dungeon_level") == 10 begin
			if number(1,150) == 1 then
				d.setf("Easter2020Dungeon_level", 11)
				game.drop_item(30793);
				d.clear_regen(); 
				d.purge_area(436200, 2299100, 450000, 2314200);
				d.notice("Rabbit hole: You've got the key!")
				d.notice(string.format("Rabbit hole: Let's open the %s!", mob_name(9315)))
			end
		end
		
		when 9315.take with item.get_vnum() == 30793 and Easter2020DungeonLIB.isActive() begin
			local settings = Easter2020DungeonLIB.Settings();
			item.remove()
			npc.kill()
			if d.getf("Easter2020Dungeon_level") == 11 then
				d.setf("Easter2020Dungeon_level", 12);
				d.notice("Rabbit hole: Destroy all stones to get next key!")
				d.regen_file("data/dungeon/easter2020/regen_4c.txt");
			elseif d.getf("Easter2020Dungeon_level") == 13 then
				d.setf("Easter2020Dungeon_level", 14);
				d.notice(string.format("Rabbit hole: Be careful! %s are here!", mob_name(4102)))
				d.notice("Rabbit hole: One of them has next key!")
				local Boss1Pos = settings["Boss1Pos"]; local Boss1Count = table.getn(Boss1Pos); local randomNumber = number(1, table.getn(Boss1Pos))	
				for index = 1, Boss1Count, 1 do
					local RealBoss1 = d.spawn_mob(4102, Boss1Pos[index][1], Boss1Pos[index][2])
					if index == randomNumber then
						d.set_unique("real_boss", RealBoss1)
					end
				end
			elseif d.getf("Easter2020Dungeon_level") == 15 then
				d.purge_area(433400, 2269200, 452500, 2285100)
				server_timer("Easter2020_mobs4", 10, d.get_map_index())
				d.setf("Easter2020Dungeon_level", 16);
				d.notice("Rabbit hole: Monsters are coming!!")
			elseif d.getf("Easter2020Dungeon_level") == 17 then
				d.kill_all()
				d.setf("Easter2020Dungeon_level", 18);
				d.notice("Rabbit hole: Great job!")
				d.notice(string.format("Rabbit hole: %s will be uncover in 10 seconds!", mob_name(4103)))
				server_timer("Easter2020_FinalBoss", 10, d.get_map_index())
			end
		end
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 8463 and d.getf("Easter2020Dungeon_level") == 12 begin
			local LastStoneCount = 8;
			d.setf("Easter2020_3stone", d.getf("Easter2020_3stone")+1);
			if (d.getf("Easter2020_3stone") < LastStoneCount) then
				d.notice(string.format("Rabbit hole: %d stones has left!", LastStoneCount-d.getf("Easter2020_3stone")))
			else
				d.notice("Rabbit hole: You've destroyed all stones!")
				d.notice(string.format("Rabbit hole: Let's open next %s!", mob_name(9315)))
				d.setf("Easter2020Dungeon_level", 13)
				game.drop_item(30793, 1)
			end
		end
		
		when Easter2020_mobs4.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/easter2020/regen_4b.txt");
				d.setf("Easter2020_mobs3", d.count_monster())
				d.notice("Rabbit hole: Kill all monsters!!")
			end
		end

		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and d.getf("Easter2020Dungeon_level") == 16 begin
			d.setf("Easter2020_mobs3", d.getf("Easter2020_mobs3")-1)
			if d.getf("Easter2020_mobs3") < 1 then
				d.notice("Rabbit hole: You've killed all monsters.")
				d.notice(string.format("Rabbit hole: Let's get open the last %s", mob_name(9315)))
				game.drop_item(30793, 1)
				
				d.setf("Easter2020Dungeon_level", 17);
			end
		end
		
		when Easter2020_FinalBoss.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf("Easter2020_FinalBossKill", 1);
				d.spawn_mob(4103, 594, 547)
				
				server_timer("Easter2020_FinalBossKillCheck", 180, d.get_map_index())
				
				d.notice(string.format("Rabbit hole: Kill %s within 3 minutes!", mob_name(4103)))
				d.notice("Rabbit hole: If you won't kill him under 3 minutes, you will be teleported out of dungeon.")
			end
		end
		
		when Easter2020_FinalBossKillCheck.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("Easter2020_FinalBossKill") == 1 then
					d.kill_all()
					d.notice("Rabbit hole: 3 minutes are gone")
					d.notice(string.format("Rabbit hole: You failed, magic of %s was stronger", mob_name(4103)))
					d.notice("Rabbit hole: You will be teleported out of dungeon!")
					
					server_timer("Easter2020_Finalexit", 10, d.get_map_index())
				else
					return;
				end
			end
		end
		
		when kill with Easter2020DungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 4103 and d.getf("Easter2020Dungeon_level") == 18 begin
			clear_server_timer("Easter2020_FinalBossKillCheck", get_server_timer_arg())
			d.setf("Easter2020_FinalBossKill", 0);
			Easter2020DungeonLIB.clearTimers()
			Easter2020DungeonLIB.clearDungeon()
			notice_all(pc.get_name() .." killed the Urdush!")
			d.notice(string.format("Rabbit hole: You have succesfuly killed %s!", mob_name(4103)))
			d.notice("Rabbit hole: You will be teleported out of dungeon in 3 minutes.")
			server_timer("Easter2020_Finalexit", 120, d.get_map_index())
		end
		
		when EasterDungeon2020_30min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Rabbit cave: 30 minutes left!")
				server_timer("EasterDungeon2020_20min_left", 10*60, d.get_map_index())
			end
		end
		
		when EasterDungeon2020_20min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Rabbit cave: 20 minutes left!")
				server_timer("EasterDungeon2020_10min_left", 10*60, d.get_map_index())
			end
		end
		
		when EasterDungeon2020_10min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Rabbit cave: 10 minutes left! Hurry up!")
				server_timer("EasterDungeon2020_5min_left", 5*60, d.get_map_index())
			end
		end
		
		when EasterDungeon2020_5min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Rabbit cave: 5 minutes left! Time is ticking!")
				server_timer("EasterDungeon2020_1min_left", 4*60, d.get_map_index())
			end
		end
		
		when EasterDungeon2020_1min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Rabbit cave: 1 minute left! You almost failed!")
				server_timer("EasterDungeon2020_0min_left", 60, d.get_map_index())
			end
		end
		
		when EasterDungeon2020_0min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.kill_all()
				Easter2020DungeonLIB.clearTimers()
				d.notice("Rabbit cave: You failed! You will be teleported out of dungeon.")
				server_timer("Easter2020_Finalexit", 5, d.get_map_index())
			end
		end
		
		when Easter2020_Finalexit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
		------------
		--Dungeon enter
		------------
		when 9308.chat."Into the rabbit hole" with not Easter2020DungeonLIB.isActive() begin
			addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("So, you have decided to help! I'm so greatful![ENTER]")
			say_reward("Are really sure you want to help me?")
			if (select("Yes", "No") == 1) then
				if Easter2020DungeonLIB.checkEnter() then
					say_reward("[ENTER]You must finish the run in 40 minutes.[ENTER]Otherwise you will be teleported out of the dungeon.[ENTER][ENTER]I wish you best luck!")
					wait()
					Easter2020DungeonLIB.CreateDungeon();
				end
			end
		end
		
		when 9308.chat."The story" with not Easter2020DungeonLIB.isActive() begin
			addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Hello![ENTER]Nice to meet you! I'm... Well i don't even[ENTER]have a name. I was made by very good[ENTER]scientist. He loved chocolate so much that he created[ENTER]me. And not just me! He made hunderds of us.[ENTER]We were very different, every new chocolate creature[ENTER]was better than a previous one.[ENTER]But then it came.")
			wait()
			addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("The last creature he made was so perfect,[ENTER]but also so smart and evil.[ENTER]He killed our creator and went far[ENTER]into forests. The place is very dangerous now.[ENTER]It looks like easter forest or something.[ENTER]All creatures and animals are enchanted.[ENTER]Name of the traitor is Urdush.")			
			wait()
			addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("He made a hole and lives there.[ENTER]The hole is protected by magic, it's very[ENTER]difficult to get there.[ENTER]I was waiting long time for this moment.[ENTER]I'm easter rabbit, so i can be discovered only[ENTER]during esater time.[ENTER]We need your help!")				
		end
		
		------------
		--Time reset - ONLY FOR GM 
		------------
		when 9308.chat."Time reset" with pc.is_gm() and not Easter2020DungeonLIB.isActive() begin
			addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
			say("[ENTER][ENTER]")
			if select("Reset time","Close") == 2 then return end
				addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
				say("[ENTER]The time has been reseted.")
				pc.setf("easter2020_dungeon","exit_easter2020_dungeon_time", 0)
				pc.setqf("rejoin_time", get_time() - 1800)
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with Easter2020DungeonLIB.isActive() begin 
			pc.setf("easter2020_dungeon","exit_easter2020_dungeon_time", get_global_time())
			pc.setqf("easter2020_dungeon", get_time() + 1800)
		end
	end
end	
		
		
