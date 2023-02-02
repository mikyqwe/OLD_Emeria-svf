quest AndunDungeon01_zone begin
	state start begin
		when login with AndunDungeon01LIB.isActive() begin
			local settings = AndunDungeon01LIB.Settings();			
			local DungeonTimer = settings["DungeonTimer"]
			local Time = settings["time_to_destroy_stones"]
			local minutes = math.floor(Time / 60)
			local StoneCount = settings["MINIMUM_STONE_COUNT"]
			
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("AndunDungeon01_DungeonTimer", get_global_time() + DungeonTimer);
				d.setf("AndunDungeon01_stage", 1);
				d.setf("AndunDungeon01_1f_stone", 1);
				
				--AndunDungeon01LIB.setOutCoords();
				AndunDungeon01LIB.setReward();
				d.set_warp_location(settings["outside_index"], settings["outside_pos"][1], settings["outside_pos"][2]);
				
				d.set_regen_file("data/dungeon/andun_dungeon_01/regen_1f_stones.txt");
				
				d.notice(string.format("Suffering souls dungeon: Destroy %s stones within %s minutes!", StoneCount, minutes))
				d.notice("Suffering souls dungeon: Otherwise, next task will be much harder.")
				
				server_timer("AndunDungeon01_First_Stone_timer", Time, d.get_map_index())
				server_timer("AndunDungeon01_dungeon_time", DungeonTimer, d.get_map_index())
			end
		end
		
		-------------
		-- 1.Floor
		-- Players destroy stones at first floor
		-------------
		when 8719.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			local Stone_count = settings["MINIMUM_STONE_COUNT"];
			
			d.setf("AndunDung1_stone_1", d.getf("AndunDung1_stone_1")+1);
			if (d.getf("AndunDung1_stone_1") < Stone_count) then
				d.notice(string.format("Suffering souls dungeon: %d stones has left!", Stone_count-d.getf("AndunDung1_stone_1")));
			
			else
				AndunDungeon01LIB.clearDungeon();
				d.setf("AndunDungeon01_1f_stone", 0);
				clear_server_timer("AndunDungeon01_First_Stone_timer", d.get_map_index());
				
				d.notice("Suffering souls dungeon: Get ready! Monsters are coming!");
				
				server_timer("AndunDungeon01_First_Wave_timer", settings["time_to_proceed"], d.get_map_index());
			end
		end
		
		-------------
		-- 1.Floor
		-- Timer to check if all stones were destroyed
		-------------
		when AndunDungeon01_First_Stone_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunDungeon01_1f_stone") == 1 then
					local settings = AndunDungeon01LIB.Settings();
					
					d.setf("AndunDungeon01_Pillar_Hcount", 1);
					d.clear_regen();
					d.purge_area(3523200, 2321000, 3541500, 2345000);
					
					d.notice("Suffering souls dungeon: You didnt destroy the required number of stones!")
					d.notice("Suffering souls dungeon: Next floor task be much harder for you!")
					
					server_timer("AndunDungeon01_First_Wave_timer", settings["time_to_proceed"], d.get_map_index());
				end
			end
		end
		
		-------------
		-- 1.Floor
		-- Timer to spawn first wave of monsters
		-------------
		when AndunDungeon01_First_Wave_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				
				d.setf("AndunDungeon01_CanSpawnSeal", 1);
				d.setf("AndunDungeon01_1w_monsters_k", 1);
				d.set_regen_file("data/dungeon/andun_dungeon_01/regen_1f_mobs.txt");
				
				d.notice(string.format("Suffering souls dungeon: Kill monsters until you spawn %s", mob_name(9436)));
			end
		end
		
		---------
		-- 1.Floor
		-- Players kill first wave of monsters to get an item (30898)
		-------------
		when kill with AndunDungeon01LIB.isActive() and not npc.is_pc() and d.getf("AndunDungeon01_stage") == 1 and d.getf("AndunDungeon01_1w_monsters_k") == 1 begin
			local settings = AndunDungeon01LIB.Settings();		
			local SpawnChance = settings["SPAWN_CHANCE_SEAL"];
			
			if d.getf("AndunDungeon01_CanSpawnSeal") == 1 then
				
				if number(1, SpawnChance) == 1 then
				
					AndunDungeon01LIB.clearDungeon();					
					if d.getf("AndunDungeon01_Pillar_Hcount") == 1 then
						AndunDungeon01LIB.spawnMaxSeal();
					else
						AndunDungeon01LIB.spawnMinSeal();
					end
					
					d.setf("AndunDungeon01_CanSpawnSeal", 0);						
					d.setf("AndunDungeon01_CanClickSeal", 1);

					d.notice("Suffering souls dungeon: Open seals one by one until you find the right one!")
				end
			end
		end

		---------
		-- 1.Floor
		-- Players click to the seal and try to find the right one
		-------------
		when 9436.click with AndunDungeon01LIB.isActive() and not npc.is_pc() and d.getf("AndunDungeon01_stage") == 1 and d.getf("AndunDungeon01_CanClickSeal") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			d.setf("AndunDungeon01_CanClickSeal", 0);
			
			if npc.get_vid() == d.get_unique_vid("real") then
				AndunDungeon01LIB.clearDungeon();
				d.spawn_mob_dir(4516, 250, 869, 5);
				
				d.setf("AndunDungeon01_CanKillSecondBoss", 1);
				
				d.notice(string.format("Suffering souls dungeon: You have found the correct %s, %s is here!", mob_name(9436), mob_name(4516)));
				d.notice("Suffering souls dungeon: Kill it!!!");
			else
				npc.purge();
				d.spawn_mob(4515, 251, 818);
				
				d.setf("AndunDungeon01_CanKillFirstBoss", 1);
				
				d.notice(string.format("Suffering souls dungeon: This one was just a trap, %s is here!", mob_name(4515)));
				d.notice("Suffering souls dungeon: Kill it!!!");
			end
		end
		
		-------------
		-- 1.Floor
		-- Players kill a first boss (after they didnt find the right monument (9436))
		-------------
		when 4515.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 1  and d.getf("AndunDungeon01_CanKillFirstBoss") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			d.setf("AndunDungeon01_CanKillFirstBoss", 0);
			d.setf("AndunDungeon01_CanClickSeal", 1);
			
			d.notice(string.format("Suffering souls dungeon: You can proceed and try to unlock another %s", mob_name(9436)));
		end

		-------------
		-- 1.Floor
		-- Players kill a second boss (after they found the right monument (9436))
		-------------
		when 4516.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 1  and d.getf("AndunDungeon01_CanKillSecondBoss") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			d.setf("AndunDungeon01_CanKillSecondBoss", 0);
			d.setf("AndunDungeon01_CanSpeakNPC", 1);
			
			d.spawn_mob_dir(9435, 264, 884, 5);
			
			d.notice(string.format("Suffering souls dungeon: %s has been spawned! Let's speak with him.", mob_name(9435)));
		end

		-------------
		-- 1.Floor
		-- Players proceed to the next room (if they have item - 30899)
		-------------
		when 9435.chat."What next?" with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 1  and d.getf("AndunDungeon01_CanSpeakNPC") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			addimage(25, 10, "andun_dungeon01_bg2.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));	
			
			if (party.is_party() and not party.is_leader()) then
				say("Only leader of the group can teleport whole[ENTER]group to next level.[ENTER]Anyway, you need:")
				say_item(""..item_name(settings["2Floor_ticket"]).."", settings["2Floor_ticket"], "")
				say("If you don't have it, you will be[ENTER]teleport out of dungeon!!")
			end
			
			say("I can send you to the next level only if[ENTER]you have this item:")
			say_item(""..item_name(settings["2Floor_ticket"]).."", settings["2Floor_ticket"], "")
			say("You have no chance if you don't have it.")
			say_reward("All people without this item will be[ENTER]teleported out of dungeon!")
			
			if (select("Continue", "Close") == 1) then
				setskin(NOWINDOW)
				AndunDungeon01LIB.jumpToNextFloor();
			end
		end

		-------------
		-- 2.Floor
		-- Players can't die in second floor
		-------------
		when dead with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 2 begin
			d.notice("Suffering souls dungeon: You died. You have failed.")
			
			d.exit_all()
		end
		
		-------------
		-- 2.Floor
		-- Players destroy stones in a limited time, otherwise the dungeon is over
		-------------
		when 8720.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 2  and d.getf("AndunDungeon01_SeconStone") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			d.setf("AndunDungeon01_SeconStone", 0);
			d.setf("AndunDungeon01_2f_monsters_k", 1);
			clear_server_timer("AndunDungeon01_First_Stone_timer", d.get_map_index());
			
			d.regen_file("data/dungeon/andun_dungeon_01/regen_2f_mobs_a.txt");
			
			d.notice("Suffering souls dungeon: Great job! Kill all monsters!");
		end
		
		-------------
		-- 2.Floor
		-- Timer to close the whole dungeon if players wont destroy a stone (8720) in defined time
		-------------
		when AndunDungeon01_Second_Stone_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("AndunDungeon01_SeconStone") == 1 then
					d.notice("Suffering souls dungeon: Time is up. You have failed");
					d.exit_all();
				end
			end
		end
		---------
		-- 2.Floor
		-- Players kill 2 waves of monsters
		-------------
		when kill with AndunDungeon01LIB.isActive() and not npc.is_pc() and d.getf("AndunDungeon01_stage") == 2  begin
			local settings = AndunDungeon01LIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_1_WAVE"];
			local KILL_COUNT_2 = settings["KILL_COUNT_2_WAVE"];
			local n = d.getf("AndunDungeon01_2f_monsters_c") + 1
			
			d.setf("AndunDungeon01_2f_monsters_c", n)
			
			if d.getf("AndunDungeon01_2f_monsters_k") == 1 then
				
				if n >= KILL_COUNT then
				
					AndunDungeon01LIB.clearDungeon();
					d.notice("Suffering souls dungeon: Another wave is coming!");					
					server_timer("AndunDungeon01_Second_Wave_timer", settings["time_to_proceed"], d.get_map_index());
				end
			end
			
			if d.getf("AndunDungeon01_2f_monsters_k") == 2 then
				
				if n >= KILL_COUNT_2 then
				
					AndunDungeon01LIB.clearDungeon();
					d.setf("AndunDungeon01_2f_monsters_c", 0)
					d.setf("AndunDungeon01_2f_monsters_k", 0)
					
					d.notice(string.format("Suffering souls dungeon: Get ready! %s is coming!", mob_name(4517)));					
					server_timer("AndunDungeon01_BossSpawn_Timer", settings["time_to_proceed"], d.get_map_index());
				end
			end
		end
		
		-------------
		-- 2.Floor
		-- Timer to close the whole dungeon if players wont destroy a stone (8720) in defined time
		-------------
		when AndunDungeon01_Second_Wave_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf("AndunDungeon01_2f_monsters_k", 2);
				d.setf("AndunDungeon01_2f_monsters_c", 0)

				d.regen_file("data/dungeon/andun_dungeon_01/regen_2f_mobs_b.txt");				
			end
		end	
		
		-------------
		-- 2.Floor
		-- Timer to spawn final boss
		-------------
		when AndunDungeon01_BossSpawn_Timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				AndunDungeon01LIB.FinalBossSpawn();
			end
		end
		
		-------------
		-- 2.Floor
		-- Timer to spawn protection stone for final boss (8721)
		-------------
		when AndunDungeon01_ProtectionStoneSpawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = AndunDungeon01LIB.Settings();
				
				if d.getf("AndunDungeon01_FinalBoss") == 1 then 
					d.unique_set_def_grade("Final_boss", settings["final_boss_defense_ultra"])
					d.spawn_mob(8721, 187, 166);
					
					d.notice(string.format("Suffering souls dungeon: Destroy %s to be able to damage the boss again!", mob_name(8721)));
				end
			end
		end

		-------------
		-- 2.Floor
		-- Players destroy protection stone to be able to damage the final boss again
		-------------
		when 8721.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 2  and d.getf("AndunDungeon01_FinalBoss") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			d.unique_set_def_grade("Final_boss", settings["final_boss_defense_basic"])			
			d.notice(string.format("Suffering souls dungeon: You can damage the %s again, hurry up!", mob_name(4517)));
			
			server_timer("AndunDungeon01_ProtectionStoneSpawn", settings["time_to_damage_final_boss"], d.get_map_index())
		end
		
		-------------
		-- 2.Floor
		-- Players kill Final boss
		-------------
		when 4517.kill with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_stage") == 2  and d.getf("AndunDungeon01_FinalBoss") == 1 begin
			local settings = AndunDungeon01LIB.Settings();
			
			AndunDungeon01LIB.clearDungeon();
			
			clear_server_timer("AndunDungeon01_ProtectionStoneSpawn", d.get_map_index());
			clear_server_timer("AndunDungeon01_dungeon_time", d.get_map_index());
			
			d.setf("AndunDungeon01_FinalBoss", 0);
			d.setf("AndunDungeon01_CanGetReward", 1);
			
			AndunDungeon01LIB.SpawnRewardChest();
			
			notice_all(pc.get_name() .." killed the Kirath!")
			d.notice("Suffering souls dungeon: You have sucesfully finished the dungeon. You can take your reward now.");
			
			server_timer("AndunDungeon01_FinalExit", settings["timer_to_exit_dungeon"], d.get_map_index())
		end
		
		-----
		-- 2. Floor
		--Players can take reward from the chest before they continue to ghost stage
		-----	
		when 9437.chat."Take reward" with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_CanGetReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30902, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Suffering souls dungeon: You already took the reward!")
			end 
		end
		
		when 9438.chat."Take reward" with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_CanGetReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30902, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Suffering souls dungeon: You already took the reward!")
			end 
		end
		
		when 9439.chat."Take reward" with AndunDungeon01LIB.isActive() and d.getf("AndunDungeon01_CanGetReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30902, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Suffering souls dungeon: You already took the reward!")
			end 
		end
		
		-------------
		-- 2.Floor
		-- Final exit
		-------------
		when AndunDungeon01_FinalExit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all();
			end
		end
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with AndunDungeon01LIB.isActive() begin
			if not pc.is_gm() then
				AndunDungeon01LIB.setWaitingTime()
			end
		end
	end
end	
		
		
