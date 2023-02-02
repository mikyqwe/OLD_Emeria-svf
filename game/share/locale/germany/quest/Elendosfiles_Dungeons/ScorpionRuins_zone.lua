quest ScorpionRuins_zone begin
	state start begin
		when login with ScorpionRuinsLIB.isActive() begin
			local settings = ScorpionRuinsLIB.Settings();			
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("ScorpionRuins_stage", 1);
				d.setf("ScorpionRuins_FirstBoss_stage", 1);
				d.setf("ScorpionRuins_FirstBoss_kill", 1);
				
				ScorpionRuinsLIB.setReward();
				ScorpionRuinsLIB.setOutCoords();
				ScorpionRuinsLIB.spawnCrystals();
				ScorpionRuinsLIB.spawnBoss();
				
				server_timer("ScorpionRuins_FinalExit", settings["time_to_finish_dungeon"], d.get_map_index())
			end
		end
				
		---------
		-- Players kill the first boss and get item to activate the cyrstal (4x)
		-------------
		when 4429.kill with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_stage") == 1 and d.getf("ScorpionRuins_FirstBoss_kill") == 1  begin
			local settings = ScorpionRuinsLIB.Settings();
			local ItemCrystal = settings["Item_crystal"];
			local n = d.getf("ScorpionRuins_FirstBoss_stage") + 1
			
			d.setf("ScorpionRuins_FirstBoss_stage", n)			
			d.setf("ScorpionRuins_FirstBoss_kill", 0);
			d.setf("ScorpionRuins_CanActivate_crystal", 1);
							
			game.drop_item(ItemCrystal, 1);
		end
		
		---------
		-- Players activate the crystals, one by one (4x)
		-------------
		when 9415.take with ScorpionRuinsLIB.isActive() and item.get_vnum() == ScorpionRuinsLIB.Settings()["Item_crystal"] and d.getf("ScorpionRuins_stage") == 1 and d.getf("ScorpionRuins_CanActivate_crystal") == 1 begin
			local settings = ScorpionRuinsLIB.Settings();
			local Position = settings["crystal_pos"];
			local ActivatedCrystal = settings["crystal_activated"];
			local BossStage = d.getf("ScorpionRuins_FirstBoss_stage")
			local Timer = settings["time_to_proceed"]
			
			item.remove();
			
			if npc.get_vid() == d.get_unique_vid("crystal_1") then
				d.spawn_mob_dir(ActivatedCrystal, Position[1][1], Position[1][2], Position[1][3]);
				d.kill_unique("crystal_1");
			
			elseif npc.get_vid() == d.get_unique_vid("crystal_2") then
				d.spawn_mob_dir(ActivatedCrystal, Position[2][1], Position[2][2], Position[2][3]);
				d.kill_unique("crystal_2");
			
			elseif npc.get_vid() == d.get_unique_vid("crystal_3") then
				d.spawn_mob_dir(ActivatedCrystal, Position[3][1], Position[3][2], Position[3][3]);
				d.kill_unique("crystal_3");
			
			elseif npc.get_vid() == d.get_unique_vid("crystal_4") then
				d.spawn_mob_dir(ActivatedCrystal, Position[4][1], Position[4][2], Position[4][3]);
				d.kill_unique("crystal_4");
			end
			
			if BossStage == 2 then
				local FirstWaveTimer = settings["time_to_kill_first_wave"]
				local minutes = math.floor(FirstWaveTimer / 60)
				
				d.setf("ScorpionRuins_1w_monsters_k", 1)
				
				d.regen_file("data/dungeon/scorpion_ruins/regen_1.txt");
				
				d.notice("Scorpion ruins: Kill all monsters to proceed!");
				d.notice(string.format("Scorpion ruins: Make it quickly, you have to kill them in %s minutes!", minutes));
				
				server_timer("ScorpionRuins_FirstWave_limit", FirstWaveTimer, d.get_map_index())
			
			elseif BossStage == 3 then
				ScorpionRuinsLIB.spawnFirstStones();
				d.setf("ScorpionRuins_stone_kill", 1)
				
				d.notice(string.format("Scorpion ruins: These stones are hiding %s, but only one is the right one!", item_name(settings["FalseSkillBook"])));
			
			elseif BossStage == 4 then
				d.setf("ScorpionRuins_2w_monsters_k", 1)
				d.setf("ScorpionRuins_2w_monsters_w", 1)
				
				d.regen_file("data/dungeon/scorpion_ruins/regen_2.txt");
			
				d.notice("Scorpion ruins: Kill 2 waves of monsters to proceed!");
				
			elseif BossStage == 5 then
				d.setf("ScorpionRuins_stone_kill", 2)
				
				d.regen_file("data/dungeon/scorpion_ruins/regen_3.txt");
				
				d.notice(string.format("Scorpion ruins: Destroy 10x %s!", mob_name(8708)));
			end
		end

		---------
		-- Players talk to NPC once they spawn in the dungeon (9394), then monsters are spawned
		-------------
		when kill with ScorpionRuinsLIB.isActive() and not npc.is_pc() and d.getf("ScorpionRuins_stage") == 1 and d.getf("ScorpionRuins_1w_monsters_k") == 1 begin
			local settings = ScorpionRuinsLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_1_WAVE"];
			local n = d.getf("ScorpionRuins_1w_monsters_c") + 1
			
			d.setf("ScorpionRuins_1w_monsters_c", n)
			
			if pc.get_x() > 24772 and pc.get_y() > 22590 and pc.get_x() < 25177 and pc.get_y() < 22926 then				
				
				if n >= KILL_COUNT then
					clear_server_timer("ScorpionRuins_FirstWave_limit", d.get_map_index());
					
					d.setf("ScorpionRuins_1w_monsters_c", 0)
					d.setf("ScorpionRuins_1w_monsters_k", 0)
					
					server_timer("ScorpionRuins_FBoss_spawner", settings["time_to_proceed"], d.get_map_index())
				end
			end
		end
		
		------
		-- Players are teleported out of dungeon if they didnt kill all monsters in defined time
		-------------
		when ScorpionRuins_FirstWave_limit.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("ScorpionRuins_1w_monsters_k") == 1 then
					d.exit_all();
				end
			end
		end
		
		---------
		-- Timer for spawn first boss
		-------------
		when ScorpionRuins_FBoss_spawner.server_timer begin
			if d.select(get_server_timer_arg()) then
			
				d.setf("ScorpionRuins_FirstBoss_kill", 1);		
				ScorpionRuinsLIB.spawnBoss();
			end
		end

		---------
		-- Players kill the first boss and get item to activate the cyrstal (4x)
		-------------
		when 8708.kill with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_stage") == 1 begin
			local settings = ScorpionRuinsLIB.Settings();
			local StoneStage = d.getf("ScorpionRuins_stone_kill")
			local TrueItem = settings["TrueSkillBook"]
			local FalseItem = settings["FalseSkillBook"]
			
			if StoneStage == 1 then
				
				if npc.get_vid() == d.get_unique_vid("real") then
					game.drop_item(TrueItem, 1)
				end
					
				for i = 1, 7 do
					if npc.get_vid() == d.get_unique_vid("fake"..i) then
						game.drop_item(FalseItem, 1)
					end
				end
			
			elseif StoneStage == 2 then
				
				local Stone_count = 10;
				
				d.setf("ScorpionRuins_stone_2", d.getf("ScorpionRuins_stone_2")+1);
				if (d.getf("ScorpionRuins_stone_2") < Stone_count) then
					d.notice(string.format("Scorpion ruins: %d stones has left!", Stone_count-d.getf("ScorpionRuins_stone_2")));
				
				else
					ScorpionRuinsLIB.clearDungeon();
					d.notice(string.format("Scorpion ruins: Get ready!!! %s is coming!", mob_name(settings["second_boss"])));
					
					server_timer("ScorpionRuins_FinalBoss_spawner", settings["time_to_proceed"], d.get_map_index());
				end
			end
		end
		
		when 30879.use with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_stage") == 1 begin
			item.remove();
			
			d.notice("Scorpion ruins: It's just empty book. Go for another one!")
		end
		
		when 30880.use with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_stage") == 1 begin
			local settings = ScorpionRuinsLIB.Settings();
			
			item.remove();
			
			d.purge_area(2477200, 2259000, 2517700, 2292600);
			
			d.notice("Scorpion ruins: This book had correct spells inside!")
			d.notice("Scorpion ruins: You can proceed!")
			
			server_timer("ScorpionRuins_FBoss_spawner", settings["time_to_proceed"], d.get_map_index())
		end
		
		
		---------
		-- Players kill 2 waves of monsters
		-------------
		when kill with ScorpionRuinsLIB.isActive() and not npc.is_pc() and d.getf("ScorpionRuins_stage") == 1 and d.getf("ScorpionRuins_2w_monsters_k") == 1 begin
			local settings = ScorpionRuinsLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_2_WAVE"];
			local n = d.getf("ScorpionRuins_2w_monsters_c") + 1
			
			d.setf("ScorpionRuins_2w_monsters_c", n)
			
			if pc.get_x() > 24772 and pc.get_y() > 22590 and pc.get_x() < 25177 and pc.get_y() < 22926 then				
				
				if n >= KILL_COUNT then
					if d.getf("ScorpionRuins_2w_monsters_w") == 1 then 
					
						d.setf("ScorpionRuins_2w_monsters_w", 2)
						d.setf("ScorpionRuins_2w_monsters_c", 0)
						d.setf("ScorpionRuins_2w_monsters_k", 0)
						
						d.notice("Scorpion ruins: Another wave is coming!");
						
						server_timer("ScorpionRuins_2_wave", settings["time_to_proceed"], d.get_map_index())
					
					elseif d.getf("ScorpionRuins_2w_monsters_w") == 2 then 
						d.setf("ScorpionRuins_2w_monsters_c", 0)
						d.setf("ScorpionRuins_2w_monsters_k", 0)
						d.setf("ScorpionRuins_2w_monsters_w", 0)
						
						d.notice(string.format("Scorpion ruins: Good job! %s is coming!", mob_name(settings["first_boss"])));
						
						server_timer("ScorpionRuins_FBoss_spawner", settings["time_to_proceed"], d.get_map_index())
					end
				end
			end
		end
		
		------
		-- Second wave of monsters is spawned
		-------------
		when ScorpionRuins_2_wave.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf("ScorpionRuins_2w_monsters_k", 1)
				
				d.regen_file("data/dungeon/scorpion_ruins/regen_2.txt");
			end
		end
		
		------
		-- Final boss spawner
		-------------
		when ScorpionRuins_FinalBoss_spawner.server_timer begin
			if d.select(get_server_timer_arg()) then
				ScorpionRuinsLIB.spawnFinalBoss();			
			end
		end
		
		
		---------
		-- Players kill the first boss and get item to activate the cyrstal (4x)
		-------------
		when 4430.kill with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_stage") == 1 and d.getf("ScorpionRuins_FinalBoss_kill") == 1  begin
			local settings = ScorpionRuinsLIB.Settings();
			local ItemCrystal = settings["Item_crystal"];
			
			clear_server_timer("ScorpionRuins_FinalExit", d.get_map_index());
			
			d.setf("ScorpionRuins_FinalBoss_kill", 0);
			d.setf("ScorpionRuins_CanGet_Reward", 1);
							
			d.spawn_mob_dir(9417, 270, 162, 1);
			
			notice_all(pc.get_name() .." killed the Scorpion king!")
			d.notice("Scorpion ruins: Well done! It's over!")
			d.notice("Scorpion ruins: You can get your reward now!")
			d.notice("Scorpion ruins: -----------------------------")
			d.notice("Scorpion ruins: You will be teleported out of dungeon in few minutes.")

			server_timer("ScorpionRuins_FinalExit", settings["timer_to_exit_dungeon"], d.get_map_index())			
		end
		
		-----
		--Players can take reward from the chest
		-----	
		when 9417.chat."Take reward" with ScorpionRuinsLIB.isActive() and d.getf("ScorpionRuins_CanGet_Reward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30881, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Scorpion ruins: You already took the reward!")
			end 
		end
		
		------
		-- 3. Floor
		-- Server timer for final exit
		-------------
		when ScorpionRuins_FinalExit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all();
			end
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with ScorpionRuinsLIB.isActive() begin
			local settings = ScorpionRuinsLIB.Settings(); 	
			local Items = {settings["FalseSkillBook"], settings["TrueSkillBook"]};		
						
			for index = 1, table.getn(Items) do
				pc.remove_item(Items[index], pc.count_item(Items[index]));
			end
						
			if not pc.is_gm() then
				ScorpionRuinsLIB.setWaitingTime()
			end
		end
	end
end	
		
		
