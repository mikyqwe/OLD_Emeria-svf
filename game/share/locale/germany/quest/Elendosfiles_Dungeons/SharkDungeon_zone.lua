quest SharkDungeon_zone begin
	state start begin
		when login with SharkDungeonLIB.isActive() begin
			local settings = SharkDungeonLIB.Settings();
			
			SharkDungeonLIB.setOutCoords()
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				local vid = d.spawn_mob_dir(9339, 213, 287, 3)--- Door (rock)
				d.set_unique("RockDoor", vid);
				
				d.regen_file("data/dungeon/shark_dungeon/regen_1fa.txt");
				
				d.setf("SharkDungeon_level", 1); d.setf("SharkDungeon_1f_monsters1", 1); d.setf("SharkDungeon_1f_monsters1_c", d.count_monster())
				
				server_timer("SharkDungeon_FinalExit", settings["dungeon_timer"], d.get_map_index()) ---- Full dungeon timer
				
				d.notice("Deep shark cave: Kill all monsters to proceed")
			end
		end
		
		-- 1. Floor - kill first wave of monsters + set timer
		when kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 1 begin
			local settings = SharkDungeonLIB.Settings();
			if pc.get_x() > 10548 and pc.get_y() > 22732 and pc.get_x() < 10891 and pc.get_y() < 22904 then				
				if d.getf("SharkDungeon_1f_monsters1") == 1 then
				
					d.setf("SharkDungeon_1f_monsters1_c", d.getf("SharkDungeon_1f_monsters1_c")-1)	
					if d.getf("SharkDungeon_1f_monsters1_c") < 1 then
						d.setf("SharkDungeon_1f_monsters1", 2); d.setf("SharkDungeon_stone1", 1);
						d.purge_area(1054800, 2273200, 1089100, 2290400);
						
						d.notice("Deep shark cave: Another curses are there! Be careful!");
						timer("SharkDungeon_1fStone_spawn", 5)
					end
				end
			end
		end
		
		-- 1. Floor - Spawn of stones (8477) and set timer until you can destroy them
		when SharkDungeon_1fStone_spawn.timer begin
			local settings = SharkDungeonLIB.Settings();
			
			d.regen_file("data/dungeon/shark_dungeon/regen_1fb.txt");
			
			d.notice("Deep shark cave: Destroy all stones in 15 minutes!")
			d.notice("Deep shark cave: Otherwise you will be teleported out of dungeon")
			
			d.setf("SharkDungeon_stone1_k", 1);
			server_timer("SharkDungeon_1fStone_kill", settings["time_until_destroy_8_stones"], d.get_map_index())
		end
					
		-- 1. Floor - Destroy all 8 stones in defined time (15 minutes by deafult)
		when 8477.kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 1 and d.getf("SharkDungeon_stone1") == 1 begin
			local settings = SharkDungeonLIB.Settings(); local Stone_count = 8;
			
			d.setf("SharkDungeon_1f_stone1", d.getf("SharkDungeon_1f_stone1")+1);
			if (d.getf("SharkDungeon_1f_stone1") < Stone_count) then			
				d.notice(string.format("Deep shark cave: %d stones has left!", Stone_count-d.getf("SharkDungeon_1f_stone1")))				
			else
				d.setf("SharkDungeon_stone1_k", 2);
				
				d.notice("Deep shark cave: Great job! Be careful now!")
				d.notice(string.format("Deep shark cave: %s is coming!", mob_name(4305)));
				
				timer("SharkDungeon_1fBoss_spawn", 7)
			end
		end
		
		-- 1. Floor - If players haven't destroyed all stones (8477), they will be teleported out
		when SharkDungeon_1fStone_kill.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("SharkDungeon_stone1_k") == 1 then
					d.notice("Deep shark cave: You have failed!")
					d.exit_all()
				end
			end
		end
		
		-- 1. Floor - Spawn of first boss (4305) + set timer to spawn aggresive monsters if players wont kill him within defined time
		when SharkDungeon_1fBoss_spawn.timer begin
			local settings = SharkDungeonLIB.Settings(); local vid = d.spawn_mob(4305, 153, 281);
			
			d.setf("SharkDungeon_1f_1boss", 1);
			d.set_unique("AncientSharkBoss", vid);
			
			d.notice(string.format("Deep shark cave: If you won't kill %s within 4 minutes, aggressive monsters will be spawned", mob_name(4305)));
			
			server_timer("SharkDungeon_KillFirstBoss", settings["time_until_kill_first_boss"], d.get_map_index())
		end
		
		-- 1. Floor - If players haven't killed the boss in defined time, aggresive monsters are spawned
		when SharkDungeon_KillFirstBoss.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("SharkDungeon_1f_1boss") == 1 then
					d.notice(string.format("Deep shark cave: %s was able to summon his monsters!", mob_name(4305)));					
					d.set_regen_file("data/dungeon/shark_dungeon/regen_1fc.txt");
				end
			end
		end
		
		-- 1. Floor - Killing of the first boss + destroying block for way to the other room + spawn of pillar
		when 4305.kill with SharkDungeonLIB.isActive() and not npc.is_pc() begin
			if d.getf("SharkDungeon_level") == 1 then
				d.setf("SharkDungeon_level", 2); d.setf("SharkDungeon_1f_1boss", 0); d.setf("SharkDungeon_Pillar1", 1);
				d.clear_regen();
				d.purge_area(1054800, 2273200, 1089100, 2290400);
				d.kill_unique("RockDoor")
				
				local vid = d.spawn_mob(9340, 344, 294)--- Door (rock)
				d.set_unique("SharkPillar", vid);
				
				d.notice("Deep shark cave: Good job! The way was opened!")
				d.notice(string.format("Deep shark cave: The pillar in the middle of the room is protecting %s!", mob_name(4307)));
				d.notice("Deep shark cave: Break all spells to destroy it!")
			end
		end
		
		when 9340.click with SharkDungeonLIB.isActive() and d.getf("SharkDungeon_level") == 2 and d.getf("SharkDungeon_Pillar1") == 1 begin
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("SharkDungeon_Pillar1", 0)
				timer("SharkDungeon_2Wave_spawn", 5)
					
				d.notice("Deep shark cave: Monsters are coming!")
			else
				syschat("Deep shark cave: Only group leader can do this")
			end
		end
		
		-- 2. Floor - Spawn of second wave of monsters
		when SharkDungeon_2Wave_spawn.timer begin
			local settings = SharkDungeonLIB.Settings(); local monster_count = settings["monsters_killed_in_second_room"];
			
			d.setf("SharkDungeon_2f_monsters", 1); d.setf("SharkDungeon_2f_monsters1_c", monster_count)
			d.set_regen_file("data/dungeon/shark_dungeon/regen_2fa.txt");
			
			d.notice(string.format("Deep shark cave: Kill %s monsters to proceed", monster_count));			
		end
		
		when kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 2 begin
			local settings = SharkDungeonLIB.Settings();
			if pc.get_x() > 10548 and pc.get_y() > 22732 and pc.get_x() < 10891 and pc.get_y() < 22904 then				
				if d.getf("SharkDungeon_2f_monsters") == 1 then
				
					d.setf("SharkDungeon_2f_monsters1_c", d.getf("SharkDungeon_2f_monsters1_c")-1)	
					if d.getf("SharkDungeon_2f_monsters1_c") < 1 then
						d.setf("SharkDungeon_2f_monsters", 0);
						d.clear_regen()
						d.purge_area(1054800, 2273200, 1089100, 2290400);
						
						d.notice("Deep shark cave: You have killed all monsters!");
						d.notice(string.format("Deep shark cave: %s is coming! Be careful, you can not kill him by weapon!", mob_name(4306)));
						d.notice(string.format("Deep shark cave: Only %s can kill it!", item_name(30808)));
						timer("SharkDungeon_2fStone_spawn1", 5) 
					end
				end
				if d.getf("SharkDungeon_2f_monsters2") == 1 then
				
					d.setf("SharkDungeon_2f_monsters2_c", d.getf("SharkDungeon_2f_monsters2_c")-1)	
					if d.getf("SharkDungeon_2f_monsters2_c") < 1 then
						d.setf("SharkDungeon_2f_monsters2", 0);
						d.clear_regen()
						d.purge_area(1054800, 2273200, 1089100, 2290400);
						
						d.notice("Deep shark cave: You have killed all monsters!");
						d.notice(string.format("Deep shark cave: The %s is almost destroyed", mob_name(9340)));
						d.notice("Deep shark cave: Stones will be reveal in few seconds, be careful, thet are sneaky!");
						timer("SharkDungeon_2fStone_spawn2", 10) 
					end
				end
			end
		end
		
		-- 2. Floor - Spawn of second wave of monsters
		when SharkDungeon_2fStone_spawn1.timer begin
			local settings = SharkDungeonLIB.Settings(); local position = settings["clam_stone_position"]; local n = number(1,8); 			
			
			for i = 1, 8 do
				if (i != n) then
					d.spawn_mob(8478, position[i][1], position[i][2])
				end
			end
		
			local stone_real = d.spawn_mob(8478, position[n][1], position[n][2])
			local vid = d.spawn_mob(4306, 320, 290);
			
			d.set_unique ("real",stone_real)
			d.set_unique ("DarkShark",vid)
			
			d.notice(string.format("Deep shark cave: Let's start desotrying %s!", mob_name(8478)));			
		end

		when 8478.kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 2 begin
			local settings = SharkDungeonLIB.Settings();
			if d.is_unique_dead("real") then
				game.drop_item(30808, 1)
			else
				game.drop_item(30809, 1)
			end
		end
		
		
		when 30809.use with SharkDungeonLIB.isActive() and d.getf("SharkDungeon_level") == 2 begin
			item.remove()
			syschat("Deep shark cave: This clam is broken")
		end
		
		when 30808.use with SharkDungeonLIB.isActive() and d.getf("SharkDungeon_level") == 2 begin
			item.remove()
			d.kill_unique("DarkShark");
			d.purge_area(1054800, 2273200, 1089100, 2290400);
			
			d.notice("Deep shark cave: This was the right clam!");
			d.notice("Deep shark cave: Monsters are coming!");
			timer("SharkDungeon_2fMonster_spawn2", 15) 
		end
		
			
		-- 2. Floor - Spawn of second wave of monsters
		when SharkDungeon_2fMonster_spawn2.timer begin
			d.regen_file("data/dungeon/shark_dungeon/regen_2fb.txt");
			d.setf("SharkDungeon_2f_monsters2", 1); d.setf("SharkDungeon_2f_monsters2_c", d.count_monster());
			---Kill function is on line 156
		end
		
		-- 2. Floor - Spawn of second wave of monsters
		when SharkDungeon_2fStone_spawn2.timer begin
			d.regen_file("data/dungeon/shark_dungeon/regen_2fc.txt");
			d.setf("SharkDungeon_stone3", 1); 
		end

		-- 2. Floor - Destroying 4x stone (each stone spawn boss (4305) after its destroyed)
		when 8479.kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 2 and d.getf("SharkDungeon_stone3") == 1 begin
			local settings = SharkDungeonLIB.Settings(); local Stone_count = 4;
			
			d.setf("SharkDungeon_2f_stone2", d.getf("SharkDungeon_2f_stone2")+1);
			if (d.getf("SharkDungeon_2f_stone2") < Stone_count) then			
				d.notice(string.format("Deep shark cave: %d stones has left!", Stone_count-d.getf("SharkDungeon_2f_stone2")))				
			else
				d.kill_all()
				d.notice(string.format("Deep shark cave: Great job! The %s is destroyed!", mob_name(9340)));
				d.notice(string.format("Deep shark cave: %s is coming!", mob_name(4307)));
				
				timer("SharkDungeon_FinalBoss_spawn", 10)
			end
		end
		
		-- 2. Floor - Spawn of final boss
		when SharkDungeon_FinalBoss_spawn.timer begin
			d.spawn_mob(4307, 328, 293)
		end
		
		-- 2. Floor - killing the final boss
		when 4307.kill with SharkDungeonLIB.isActive() and not npc.is_pc() and d.getf("SharkDungeon_level") == 2 begin
			local settings = SharkDungeonLIB.Settings(); 
			d.setf("SharkDungeon_level", 2);
			d.purge_area(1054800, 2273200, 1089100, 2290400);
			notice_all(pc.get_name() .." killed the Great shark god!")
			
			d.notice("Deep shark cave: Great job! You will be teleported out of dungeon in 2 minutes.")
			
			clear_server_timer("SharkDungeon_FinalExit", get_server_timer_arg());
			server_timer("SharkDungeon_FinalExit", settings["time_final_exit_after_boss_kill"], d.get_map_index()) ---- Full dungeon timer
		end

		when SharkDungeon_FinalBoss_spawn.server_timer begin
			if (d.select(get_server_timer_arg())) then
				d.exit_all()
			end
		end
		------------
		--Dungeon enter
		------------
		when 9338.chat."Deep shark cave" with not SharkDungeonLIB.isActive() begin
			say_size(350,350); addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(220, 200, "shark_dungeon_npc1.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Hey warrior![ENTER]We, whales, have been fighting with[ENTER]shakrs our whole lives. But since some[ENTER]dark power is on their side, we lost[ENTER]every single time we fight.[ENTER]They have started to steal our land![ENTER]And last time, we lost our home.[ENTER]Big ancient sharks showed up and killed half[ENTER]of us.")
			wait()
			say_size(350,350); addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(220, 200, "shark_dungeon_npc1.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say_reward("Do you think you can go there[ENTER]and help us?")
			if (select("Yes", "No") == 1) then
				if SharkDungeonLIB.checkEnter() then
					say_size(350,350); addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(225, 200, "shark_dungeon_npc1.tga")
					say_reward("[ENTER]You must finish the dungeon in 2 hours.[ENTER]Otherwise you will be teleported out[ENTER]of the dungeon.[ENTER][ENTER]I wish you best luck!")
					wait()
					SharkDungeonLIB.CreateDungeon();
				end
			end
		end
		
		
		------------
		--Time reset - ONLY FOR GM 
		------------
		when 9338.chat."Time reset" with pc.is_gm() and not SharkDungeonLIB.isActive() begin
			local settings = SharkDungeonLIB.Settings();
			addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(225, 150, "shark_dungeon_npc1.tga")
			say("[ENTER][ENTER]")
			if select("Reset time","Close") == 2 then return end
				addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(225, 150, "shark_dungeon_npc1.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
				say("[ENTER]The time has been reseted.")
				pc.setf("pyramid_dungeon","exit_pyramid_dungeon_time", 0)
				pc.setqf("rejoin_time", get_time() - settings["dungeon_cooldown"])
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with SharkDungeonLIB.isActive() begin
			local settings = SharkDungeonLIB.Settings();
			if not pc.is_gm() then
				pc.setf("pyramid_dungeon","exit_pyramid_dungeon_time", get_global_time())
				pc.setqf("pyramid_dungeon", get_time() + settings["dungeon_cooldown"])
			end
		end
	end
end	
		
		
