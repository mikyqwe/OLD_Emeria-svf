quest Easter2022_zone begin
	state start begin
		when login with Easter2022LIB.isActive() begin
			local settings = Easter2022LIB.Settings();
			local DungeonTimer = settings["DungeonTimer"]			
			local FloorTimer = settings["time_to_finish_first_floor"]
			local minutes = math.floor(FloorTimer / 60)			
			
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("Easter2022_DungeonTimer", get_global_time() + DungeonTimer);
				d.setf("Easter2022_stage", 1);
				d.setf("Easter2022_1w_monsters_k", 1);
				d.setf("Easter2022_root_active", 1);
				
				Easter2022LIB.setOutCoords();
				Easter2022LIB.setReward();
				Easter2022LIB.spawnStoneNpc();
				
				d.spawn_mob_dir(9441, 235, 281, 5);
				d.regen_file("data/dungeon/easter2022/regen_1f_mobs.txt");
				
				d.notice(string.format("Infected hole: Destroy all stones and open the gate within %s minutes!", minutes))
				d.notice("Infected hole: To be able to destroy the stones, kill all monsters first")
				
				server_timer("Easter2022_First_Floor_timer", FloorTimer, d.get_map_index())
				server_timer("Easter2022_dungeon_time", DungeonTimer, d.get_map_index())
			end
		end
		
		---------
		-- 1. Floor
		-- Players kill wave of monsters to get an item (30914) to be able activate the stones
		-------------
		when kill with Easter2022LIB.isActive() and not npc.is_pc() and d.getf("Easter2022_stage") == 1 and d.getf("Easter2022_1w_monsters_k") == 1 begin
			local settings = Easter2022LIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_1_WAVE"];
			local n = d.getf("Easter2022_1w_monsters_c") + 1
			
			d.setf("Easter2022_1w_monsters_c", n)
			
			if n >= KILL_COUNT then
				game.drop_item(30914, 1)
				
				d.setf("Easter2022_1w_monsters_c", 0)
				d.setf("Easter2022_1w_monsters_k", 0)
				d.setf("Easter2022_CanUseSpell", 1)
			end
		end

		---------
		-- 1. Floor
		-- Players use item to be able to destroy the stones
		-------------
		when 30914.use with Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 1 and d.getf("Easter2022_CanUseSpell") == 1 begin
			item.remove();
			d.setf("Easter2022_CanUseSpell", 0)
			d.setf("Easter2022_CanDestroyStone", 1)
			
			for i = 1, 4 do
				d.purge_unique("npcStone_"..i);
			end
			d.regen_file("data/dungeon/easter2022/regen_1f_stones.txt");
			
			d.notice("Infected hole: you can destroy the stones now!")
		end
		
		-------------
		-- 1.Floor
		-- Players destroy stones at first floor
		-------------
		when 8722.kill with Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 1 and d.getf("Easter2022_CanDestroyStone") == 1 begin
			local settings = Easter2022LIB.Settings();
			local Stone_count = 4;
			
			d.setf("Easter2022_stone_1", d.getf("Easter2022_stone_1")+1);
			if (d.getf("Easter2022_stone_1") < Stone_count) then
				d.notice(string.format("Infected hole: %d stones has left!", Stone_count-d.getf("Easter2022_stone_1")));
			
			else
				game.drop_item(30915, 1)
				d.setf("Easter2022_CanKillRoot", 1)
				
				d.notice("Infected hole: Lets open the gate!");
			end
		end
		
		-------------
		-- 1.Floor
		-- Players put an item to root to kill them and get to another stage
		-------------
		when 9441.take with item.get_vnum() == 30915 and Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 1 and d.getf("Easter2022_CanKillRoot") == 1 begin
			d.setf("Easter2022_root_active", 0)
			clear_server_timer("Easter2022_First_Floor_timer", d.get_map_index());
			
			item.remove();
			Easter2022LIB.clearDungeon();
			Easter2022LIB.prepareNextFloor();
		end

		-------------
		-- 1.Floor
		-- Timer to check if the first stage was made in defined time
		-------------
		when Easter2022_First_Floor_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("Easter2022_root_active") == 1 then
					d.notice("Infected hole: You have failed.")
					d.exit_all();
				end
			end
		end
		
		-------------
		-- 2.Floor
		-- Players kill first boss to get an amulet item
		-------------
		when 4524.kill with Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 2 and d.getf("Easter2022_canKillFirstBoss") == 1 begin
			d.setf("Easter2022_canKillFirstBoss", 0);
			d.setf("Easter2022_canActivateSeal", 1);
			
			game.drop_item(30916, 1);
			
			d.notice(string.format("Infected hole: You can activate the %s now!", mob_name(9443)));
		end

		-------------
		-- 2.Floor
		-- Players put an item on the seal to activate it
		-------------
		when 9443.take with item.get_vnum() == 30916 and Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 2 and d.getf("Easter2022_canActivateSeal") == 1 begin
			item.remove();
			
			Easter2022LIB.activateSeal();
		end
		
		---------
		-- 2. Floor
		-- Players kill wave of monsters to spawn a boss (4524)
		-------------
		when kill with Easter2022LIB.isActive() and not npc.is_pc() and d.getf("Easter2022_stage") == 2 and d.getf("Easter2022_2w_monsters_k") == 1 begin
			local settings = Easter2022LIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_2_WAVE"];
			local n = d.getf("Easter2022_2w_monsters_c") + 1
			
			d.setf("Easter2022_2w_monsters_c", n)
			
			if n >= KILL_COUNT then
				Easter2022LIB.spawnfirstBoss();
				
				d.setf("Easter2022_2w_monsters_c", 0)
				d.setf("Easter2022_2w_monsters_k", 0)
				d.setf("Easter2022_canKillFirstBoss", 1)
			end
		end

	
		-------------
		-- 2.Floor
		-- Final boss spawn
		-------------
		when Easter2022_FinalBossSpawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				Easter2022LIB.spawnFinalBoss();
			end
		end
	
		-------------
		-- 2.Floor
		-- Players kill first boss to get an amulet item
		-------------
		when 4525.kill with Easter2022LIB.isActive() and d.getf("Easter2022_stage") == 2 and d.getf("Easter2022_canKillFinalBoss") == 1 begin
			local settings = Easter2022LIB.Settings();
			
			d.setf("Easter2022_canKillFinalBoss", 0);
			d.setf("Easter2022_canTakeReward", 1);
			
			clear_server_timer("Easter2022_dungeon_time", d.get_map_index());
			Easter2022LIB.clearDungeon();
			Easter2022LIB.SpawnRewardChest();
			
			notice_all(pc.get_name() .." killed the Infected rabbit!")
			d.notice("Infected hole: You have sucesfully finished the dungeon.");
			d.notice("Infected hole: You can take your reward now!");
			d.notice("Infected hole: You will be teleported out of dungeon in few moments.");
			
			server_timer("Easter2022_FinalExit", settings["timer_to_exit_dungeon"], d.get_map_index())
		end
		
		-------------
		-- 2.Floor
		-- Players take reward
		-------------
		
		when 9445.chat."Take reward" with Easter2022LIB.isActive() and d.getf("Easter2022_canTakeReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30917, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Infected hole dungeon: You already took the reward!")
			end 
		end
		
		when 9446.chat."Take reward" with Easter2022LIB.isActive() and d.getf("Easter2022_canTakeReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(30918, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Infected hole dungeon: You already took the reward!")
			end 
		end
		
		
		-------------
		-- 2.Floor
		-- Final exit
		-------------
		when Easter2022_FinalExit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all();
			end
		end
		
		-------------
		-- Exit timer for dungeon
		-------------
		when Easter2022_dungeon_time.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("You have failed. Time is up.");
				d.exit_all();
			end
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with Easter2022LIB.isActive() begin
			local Items = {30914, 30915, 30916};
			
			for index = 1, table.getn(Items) do
				pc.remove_item(Items[index], pc.count_item(Items[index]));
			end
			
			if not pc.is_gm() then
				Easter2022LIB.setWaitingTime()
			end
		end
	end
end	
		
		
