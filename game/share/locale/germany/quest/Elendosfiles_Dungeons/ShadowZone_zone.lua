define FIRST_STONE 8494
define SECOND_STONE 8495
define THIRD_STONE 8496
define FOURTH_STONE 8499
define FIFTH_STONE 8497
define SIXTH_STONE 8498

define GATE_NPC 9382
define FIRST_SEAL 9377
define FIRST_STATUE 9378
define SECOND_STATUE 9379
define THIRD_STATUE 9380
define FOURTH_STATUE 9381
define FIRST_PILLAR 9383
define SECOND_PILLAR 9384
define THIRD_PILLAR 9385
define CHEST 9386

define FIRST_BOSS 4382
define SECOND_BOSS 4383
define THIRD_BOSS 4384
define FOURTH_BOSS 4385
define FIFTH_BOSS 4386
define SIXTH_BOSS 4387
define FINAL_BOSS 4388

define FIRST_KEY 30845
define SECOND_KEY 30846
define THIRD_KEY 30847
define ITEM_SOUL 30848
define DEMON_EYE 30849
define ITEM_AMULET 30850
define ITEM_MAIN_REWARD 30854
define ITEM_KEY_REWARD 30855
define ITEM_SMALL_REWARD 30856

quest ShadowZone_zone begin
	state start begin
		when login with ShadowZoneLIB.isActive() begin
			local settings = ShadowZoneLIB.Settings();			
			local OutsidePosition = settings["outside_pos"]			

			if (party.is_party() and party.is_leader() or not party.is_party()) then
				
				local FirstFloorTimer = settings["timer_first_floor"];
				
				d.setf("ShadowZone_floor", 1);						
				d.setf("ShadowZone_FirstStone", 1);						
				d.setf("ShadowZone_floor1_timer", FirstFloorTimer);						
				d.setf("ShadowZone_nocool_timer", 1);						
				
				d.set_warp_location(settings["outside_index"], OutsidePosition[1], OutsidePosition[2]);
				
				d.set_regen_file(settings["regen_file"].."regen_1a.txt");
				d.regen_file(settings["regen_file"].."regen_1b.txt");
				
				d.notice(string.format("Shadow tower: Destroy all %s! You have only limited time! Hurry up!", mob_name(FIRST_STONE)));
				
				ShadowZoneLIB.setCoolTimer();			
				
				server_timer("ShadowZone_FirstFloor", FirstFloorTimer, d.get_map_index()) 
			end
		end
				
		------------
		---Players destroy first stone (3x), after that, timer is cleared and set another for jump them to next floor
		------------
		when FIRST_STONE.kill with ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 1 begin
			local settings = ShadowZoneLIB.Settings();			
			local KILL_COUNT = settings["FIRST_STONE_COUNT"]
			local n = d.getf("ShadowZone_FirstStone_count") + 1
			
			d.setf("ShadowZone_FirstStone_count", n)
			
			if n >= KILL_COUNT then
			
				ShadowZoneLIB.clearDungeon()				
				clear_server_timer("ShadowZone_FirstFloor", d.get_map_index());
				
				d.setf("ShadowZone_FirstStone", 0);
				ShadowZoneLIB.clearCoolTimer();
				
				d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				ShadowZoneLIB.spawnPortalGate()
			end
		end

		-----
		--Server timer to check if the stones (8494) are destroyed, if not, dungeon is ended
		-----
		when ShadowZone_FirstFloor.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("ShadowZone_FirstStone") == 1 then
					d.notice("Shadow tower: Time is up. You have failed!")
					
					d.exit_all()
				end
			end
		end

		-----
		--Killing wave of monsters to get a key (2x)
		-----
		when kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 2 and d.getf("ShadowZone_2f_KillMonsters") == 1 begin
			local settings = ShadowZoneLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_2_FLOOR"];
			local n = d.getf("ShadowZone_2f_KillCount") + 1
			
			d.setf("ShadowZone_2f_KillCount", n)
			
			if pc.get_x() > 17729 and pc.get_y() > 22951 and pc.get_x() < 17932 and pc.get_y() < 23140 then				
				
				if n >= KILL_COUNT then
					game.drop_item(FIRST_KEY, 1)
					
					d.setf("ShadowZone_2f_KillCount", 0)
					d.setf("ShadowZone_2f_KillMonsters", 0)
				end
			end
		end
		
		-----
		--Destroying 2 Shadow seals to spawn a frist boss (4382)
		-----
		when FIRST_SEAL.take with item.get_vnum() == FIRST_KEY and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 2 and d.getf("ShadowZone_2f_KillMonsters") == 0 begin
			local settings = ShadowZoneLIB.Settings();
			local Position = settings["first_boss_pos"]
			
			item.remove()
			npc.kill()
			
			if d.getf("ShadowZone_2f_Seal") == 2 then
			
				ShadowZoneLIB.clearDungeon()
				d.notice(string.format("Shadow tower: %s is coming!", mob_name(FIRST_BOSS)))
				
				d.spawn_mob(FIRST_BOSS, Position[1], Position[2])
			else
				d.notice(string.format("Shadow tower: Kill second wave of monsters to destroy second %s!", mob_name(FIRST_SEAL)))
				
				d.setf("ShadowZone_2f_KillMonsters", 1);
				d.setf("ShadowZone_2f_Seal", 2);
				d.regen_file(settings["regen_file"].."regen_2a.txt");
			end
		end
		
		-----
		--Server timer to check if the stones (8494) are destroyed, if not, dungeon is ended
		-----
		when ShadowZone_SecondFloor.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("ShadowZone_FirstStone") == 1 then
					d.notice("Shadow tower: Time is up. You have failed!")
					
					d.exit_all()
				end
			end
		end
		
		-----
		-- Players kill the first boss (4382), after that, server timer for jump to next floor is set
		-----
		when FIRST_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 2 begin
			local settings = ShadowZoneLIB.Settings();
			
			clear_server_timer("ShadowZone_SecondFloor", d.get_map_index());
			ShadowZoneLIB.clearCoolTimer();
			
			ShadowZoneLIB.spawnPortalGate();
			
			d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
		end
		
		-----
		--Players destroying stones in third floor. 4 of them are fake, one is real
		-----
		when SECOND_STONE.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 3 begin
			local settings = ShadowZoneLIB.Settings(); 
			local n = d.getf("ShadowZone_wrong_count_f") + 1
			
			if npc.get_vid() == d.get_unique_vid("real") then
				ShadowZoneLIB.clearDungeon()
				ShadowZoneLIB.clearDungeon()
				
				d.notice("Shadow tower: You have destroyed the right stone!")
				d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				
				ShadowZoneLIB.spawnPortalGate()
			else
				d.setf("ShadowZone_wrong_count_f", n);	
				
				d.notice("Shadow tower: This one was just an illusion!")
			end
		end
				
		-----
		--Killing wave of monsters to get a key (30846 - 3x)
		-----
		when kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 4 and d.getf("ShadowZone_4f_KillMonsters") == 1 begin
			local settings = ShadowZoneLIB.Settings();		
			local KILL_COUNT = settings["KILL_COUNT_4_FLOOR"];
			local n = d.getf("ShadowZone_4f_KillCount") + 1
			
			d.setf("ShadowZone_4f_KillCount", n)
			
			if pc.get_x() > 17353 and pc.get_y() > 22626 and pc.get_x() < 17511 and pc.get_y() < 22740 then				
				
				if n >= KILL_COUNT then
					game.drop_item(SECOND_KEY, 1)
					
					d.setf("ShadowZone_4f_KillCount", 0)
					d.setf("ShadowZone_4f_KillMonsters", 0)
				end
			end
		end
		

		-----
		-- Building a Statue of reaper (9378, 9379, 9380, 9381)
		-----
		when FIRST_STATUE.take with item.get_vnum() == SECOND_KEY and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 4 and d.getf("ShadowZone_4f_KillMonsters") == 0 begin
			local settings = ShadowZoneLIB.Settings();
			local StatuePosition = settings["reaper_statue_pos"]
			item.remove()
			npc.kill()
			
			d.setf("ShadowZone_4f_KillMonsters", 1);
			
			d.spawn_mob_dir(SECOND_STATUE, StatuePosition[1], StatuePosition[2], StatuePosition[3]);
			d.regen_file(settings["regen_file"].."regen_4a.txt");
		end
				
		when SECOND_STATUE.take with item.get_vnum() == SECOND_KEY and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 4 and d.getf("ShadowZone_4f_KillMonsters") == 0 begin
			local settings = ShadowZoneLIB.Settings();
			local StatuePosition = settings["reaper_statue_pos"]
			item.remove()
			npc.kill()
			
			d.setf("ShadowZone_4f_KillMonsters", 1);
			
			d.spawn_mob_dir(THIRD_STATUE, StatuePosition[1], StatuePosition[2], StatuePosition[3]);
			d.regen_file(settings["regen_file"].."regen_4a.txt");
		end
				
		when THIRD_STATUE.take with item.get_vnum() == SECOND_KEY and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 4 and d.getf("ShadowZone_4f_KillMonsters") == 0 begin
			local settings = ShadowZoneLIB.Settings();
			local StatuePosition = settings["reaper_statue_pos"]
			local BossPosition = settings["second_boss_pos"]
			
			ShadowZoneLIB.clearDungeon()
			
			item.remove()
			npc.kill()
			
			d.spawn_mob_dir(FOURTH_STATUE, StatuePosition[1], StatuePosition[2], StatuePosition[3]);
			
			---- Shadow reaper spawn (HP are depending on negative points collected in third floor from destroying fake stones)
			d.set_unique("ShadowReaper", d.spawn_mob(SECOND_BOSS, BossPosition[1], BossPosition[2]))
			
			if d.getf("ShadowZone_wrong_count_f") == 1 then
				d.unique_set_maxhp("ShadowReaper", settings["REAPER_HP_1"])
			elseif d.getf("ShadowZone_wrong_count_f") == 2 then
				d.unique_set_maxhp("ShadowReaper", settings["REAPER_HP_2"])
			elseif d.getf("ShadowZone_wrong_count_f") == 3 then
				d.unique_set_maxhp("ShadowReaper", settings["REAPER_HP_3"])
			elseif d.getf("ShadowZone_wrong_count_f") == 4 then
				d.unique_set_maxhp("ShadowReaper", settings["REAPER_HP_4"])
			else
				return
			end
		end
				
		-----
		-- Players kill the second boss (4383), they drop a key (30847) to destroy Statue of reaper (9381)
		-----
		when SECOND_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 4 begin
			game.drop_item(THIRD_KEY, 1);
			
			
			d.setf("ShadowZone_4f_CanDesSta", 1)
			
			d.notice(string.format("Shadow tower: Well done! Now destroy the %s to able to continue!", mob_name(FIRST_STATUE)));			
		end
		
		-----
		-- Players destroy statue of reaper (9381), then Shadow gate is spawned and players can proceed to next floor
		-----
		when FOURTH_STATUE.take with item.get_vnum() == THIRD_KEY and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 4 and d.getf("ShadowZone_4f_CanDesSta") == 1 begin
			clear_server_timer("ShadowZone_FourthFloor", d.get_map_index());
			ShadowZoneLIB.clearCoolTimer();
			
			item.remove();
			npc.kill();
			
			d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				
			ShadowZoneLIB.spawnPortalGate();
		end
			
		-----
		--Players destroy stone, then they need to kill a third boss to proceed
		-----
		when THIRD_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 5 begin
			local settings = ShadowZoneLIB.Settings(); 
			clear_server_timer("ShadowZone_FifthFloor", d.get_map_index());
			ShadowZoneLIB.clearCoolTimer();
			
			ShadowZoneLIB.clearDungeon();
			
			d.notice("Shadow tower: Great job! You will proceed in few seconds!")
			
			d.spawn_mob(GATE_NPC, pc.get_local_x(), pc.get_local_y());
		end
		
		-----
		--Server timer to check if the stones (8494) are destroyed, if not, dungeon is ended
		-----
		when ShadowZone_FifthFloor.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Shadow tower: Time is up. You have failed!")
					
				d.exit_all()
			end
		end
		
		-----
		--Players destroy a statue in sixth floor (8499)
		-----
		when FOURTH_STONE.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 6 begin
			d.setf("ShadowZone_PillarActive", 0);
			
			d.notice(string.format("Shadow tower: Protection of %s is gone. You can kill him now!", mob_name(FOURTH_BOSS)));
		end
		
		-----
		--Players kill Azrael boss, if the statue is not destroyed yet, boss will spawned again
		-----
		when FOURTH_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 6 begin
			local settings = ShadowZoneLIB.Settings(); 
			local BossPos = settings["fourth_boss_pos"]
			
			if d.getf("ShadowZone_PillarActive") == 1 then
				d.notice(string.format("Shadow tower: %s wasn't destroyed yet. %s was recovered from shadows!", mob_name(FOURTH_STONE), mob_name(FOURTH_BOSS)));
				
				d.spawn_mob(FOURTH_BOSS, BossPos[1],BossPos[2]);
			else
				clear_server_timer("ShadowZone_SixthFloor", d.get_map_index());
				ShadowZoneLIB.clearCoolTimer();
				
				ShadowZoneLIB.clearDungeon()
				d.set_item_group("ShadowZone_6F_ticket", 1, ITEM_SOUL, 1)
				
				d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				
				ShadowZoneLIB.spawnPortalGate()
			end
		end
		
		-----
		--Players can not die in the dungeon
		-----
		when dead with ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 6 begin
			d.notice("Shadow tower: You died. You have failed.")
			
			d.exit_all()
		end
		-----
		--Server timer to check if the fourth boss (Azrael) is killed
		-----
		when ShadowZone_SixthFloor.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Shadow tower: Time is up. You have failed!")
					
				d.exit_all()
			end
		end
		
		-----
		--Players destroy a 8x stone in 7th floor, after that, boss is spawned
		-----
		when FIFTH_STONE.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 7 begin
			local settings = ShadowZoneLIB.Settings(); 
			local KILL_COUNT = settings["FIFTH_STONE_COUNT"]
			local n = d.getf("ShadowZone_7th_stone") + 1				
			
			d.setf("ShadowZone_7th_stone", n)
			
			if n >= KILL_COUNT then
			
				d.notice(string.format("Shadow tower: Beware! Majesty is coming!", mob_name(FIFTH_BOSS)));				
				
				server_timer("ShadowZone_FifthFBoss_spawner", settings["time_to_jump"], d.get_map_index())
			end
		end
		
		-----
		--Server timer to spawn a fifth boss (4386)
		-----
		when ShadowZone_FifthFBoss_spawner.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = ShadowZoneLIB.Settings(); 
				local BossPosition = settings["fifth_boss_pos"]
			
				d.spawn_mob(FIFTH_BOSS, BossPosition[1], BossPosition[2]);
			end
		end
		
		-----
		--Players kill Queen of suffering (4386), after that, Gate npc is spawned
		-----
		when FIFTH_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 7 begin
			ShadowZoneLIB.clearDungeon()
				
			d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				
			ShadowZoneLIB.spawnPortalGate()
		end
		
		-----
		--Killing wave of monsters to get a key (30846 - 3x)
		-----
		when kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 8 begin
			local settings = ShadowZoneLIB.Settings();		
			local DropChance = settings["drop_chance_8f"]
			
			if pc.get_x() > 16799 and pc.get_y() > 23654 and pc.get_x() < 16934 and pc.get_y() < 23802 then				
				
				if d.getf("ShadowZone_8F_Drop") == 1 then
					
					if number(1, DropChance) == 75 then
					
						game.drop_item(DEMON_EYE, 1);
						d.setf("ShadowZone_8F_Drop", 0);
					end
				end
			end
		end
		
		-----
		--Destrying pillar (3 phases - 9383-9385) at 8 floor
		-----
		when FIRST_PILLAR.take with item.get_vnum() == DEMON_EYE and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 8 and d.getf("ShadowZone_8F_Pillar") == 1 begin
			local settings = ShadowZoneLIB.Settings();
			local PillarPos = settings["pillar2_pos"]
			
			d.setf("ShadowZone_8F_Pillar", 2);
			d.setf("ShadowZone_8F_Drop", 1);
			
			item.remove()
			npc.kill()
			
			d.spawn_mob_dir(SECOND_PILLAR, PillarPos[1],  PillarPos[2],  PillarPos[3])
		end
		
		when SECOND_PILLAR.take with item.get_vnum() == DEMON_EYE and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 8 and d.getf("ShadowZone_8F_Pillar") == 2 begin
			local settings = ShadowZoneLIB.Settings();
			local PillarPos = settings["pillar2_pos"]
			
			d.setf("ShadowZone_8F_Pillar", 3)
			d.setf("ShadowZone_8F_Drop", 1);
			
			item.remove()
			npc.kill()
			
			d.spawn_mob_dir(THIRD_PILLAR, PillarPos[1],  PillarPos[2],  PillarPos[3])
		end
		
		when THIRD_PILLAR.take with item.get_vnum() == DEMON_EYE and ShadowZoneLIB.isActive() and d.getf("ShadowZone_floor") == 8 and d.getf("ShadowZone_8F_Pillar") == 3 begin
			local settings = ShadowZoneLIB.Settings();
			local PillarPos = settings["pillar2_pos"]
			local Time = settings["time_to_spawn_6_boss"]
			
			item.remove()
			ShadowZoneLIB.clearDungeon();
			
			d.notice(string.format("Shadow tower: If you have %s, you have last %s seconds to use it!", item_name(ITEM_AMULET), Time));
			
			server_timer("ShadowZone_SixthBoss_spawner", Time, d.get_map_index())
		end
		
		-----
		--Players can use amulet to spawn the sixth boss with less HP.
		-----		
		when ITEM_AMULET.use with ShadowZoneLIB.isActive() begin
			local AmuletSetting = d.getf("ShadowZone_CanUseAmulet")
			
			if AmuletSetting == 1 then		--- Players can use the amulet		
				item.remove();			
				d.setf("ShadowAmuletIsActive", 2);
				
				d.notice(string.format("Shadow zone: %s is now active! %s is gonna be much weaker!", item_name(ITEM_AMULET), mob_name(SIXTH_BOSS)));
				
			elseif AmuletSetting == 2 then		---- Players already used the amulet, so the effect is already active		
				d.notice("Shadow tower: This effect is already active!");
				
			else		--- Players are in last floor, or the boss is already spawned
				d.notice("Shadow tower: You can use this only during first 8 floors!");
			end
		end
				
		-----
		--Server timer to spawn a sixth boss (4387)
		-----
		when ShadowZone_SixthBoss_spawner.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = ShadowZoneLIB.Settings(); 
				local BossPosition = settings["sixth_boss_pos"]
				local ShadowAmuletIsActive = d.getf("ShadowAmulet")
			
				d.setf("ShadowZone_CanUseAmulet", 0)
				d.set_unique("SixthBoss", d.spawn_mob(SIXTH_BOSS, BossPosition[1], BossPosition[2]))
				
				if ShadowAmuletIsActive == 1 then
					d.unique_set_maxhp("SixthBoss", settings["ABBADON_HP_SMALL"])
				else
					d.unique_set_maxhp("SixthBoss", settings["ABBADON_HP_NORMAL"])
				end
			end
		end
		
		-----
		--Players kill Abbadon (4387), after that, Gate npc is spawned
		-----
		when SIXTH_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 8 begin
			ShadowZoneLIB.clearDungeon();
			
			clear_server_timer("ShadowZone_EightFloor", d.get_map_index());
			ShadowZoneLIB.clearCoolTimer();
			
			d.notice(string.format("Shadow tower: %s was revealed! You can proceed to next floor!", mob_name(GATE_NPC)));
				
			ShadowZoneLIB.spawnPortalGate()
		end
		
		-----
		--Server timer to check if the sixth floor is done (Sixth boss is killed)
		-----
		when ShadowZone_EightFloor.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Shadow tower: Time is up. You have failed!")
					
				d.exit_all()
			end
		end
		-----
		--Players destroy a Shadow demon stone, after that, monsters are spawned
		-----
		when SIXTH_STONE.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 9 begin
			local settings = ShadowZoneLIB.Settings(); 
			
			ShadowZoneLIB.clearDungeon()
			
			d.setf("ShadowZone_9f_Monsters", 1)
			d.regen_file(settings["regen_file"].."regen_9a.txt");
			
			if d.getf("ShadowZone_9f_StoneD") == 1 then
			
				ShadowZoneLIB.clearCoolTimer();
				
				clear_server_timer("ShadowZone_NinethFloor_1", d.get_map_index());
				d.setf("ShadowZone_9f_StoneD", 0)
				
			else
				d.setf("ShadowZone_9f_StoneFail", 1)
			end				
		end
		
		-----
		--Server timer to spawn a fifth boss (4386)
		-----
		when ShadowZone_NinethFloor_1.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("ShadowZone_9f_StoneD") == 1 then
					d.setf("ShadowZone_9f_StoneD", 0)
				end
			end
		end
		
		-----
		--Players destroy a 8x stone in 7th floor, after that, boss is spawned
		-----
		when kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_9f_Monsters") == 1 begin
			local settings = ShadowZoneLIB.Settings(); 
			local KILL_COUNT = settings["KILL_COUNT_9_FLOOR"]
			local n = d.getf("ShadowZone_9th_count") + 1				
			
			d.setf("ShadowZone_9th_count", n)
			
			if n >= KILL_COUNT then
			
				if d.getf("ShadowZone_9f_StoneFail") == 1 then
					d.notice("Shadow tower: One more wave is coming!")
					
					d.setf("ShadowZone_9f_StoneFail", 0)
					d.setf("ShadowZone_9th_count", 0)
					
					server_timer("ShadowZone_NinethFloor_2", settings["time_to_jump"], d.get_map_index())
				else
					ShadowZoneLIB.clearDungeon();
					
					d.setf("ShadowZone_9th_count", 0)
					d.setf("ShadowZone_9f_Monsters", 0);
					d.setf("ShadowZone_9f_Boss", 1);
					
					d.notice("Shadow tower: A monster is coming, its unknown!");
					
					server_timer("ShadowZone_NinethFloor_3", settings["time_to_jump"], d.get_map_index());	
				end
			end
		end
		
		-----
		--Server timer to spawn another wave of monsters
		-----
		when ShadowZone_NinethFloor_2.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = ShadowZoneLIB.Settings(); 
				
				d.regen_file(settings["regen_file"].."regen_9a.txt");
			end
		end
		
		-----
		--Server timer to spawn random boss from previous stages
		-----
		when ShadowZone_NinethFloor_3.server_timer begin
			if d.select(get_server_timer_arg()) then
				ShadowZoneLIB.spawnRandomBoss();
			end
		end
		
		-----
		--Players killing random boss spawned after they kill waves of monsters.
		-----
		when kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 9 and d.getf("ShadowZone_9f_Boss") == 1 begin
			local settings = ShadowZoneLIB.Settings(); 
			local Position = settings["final_boss_pos"] 
			local FinalBossTimer = settings["time_to_kill_final_boss"] 
			local Floor = d.getf("ShadowZone_floor")
			
			if npc.get_vid() == d.get_unique_vid("RandomBoss") then
				d.setf("ShadowZone_9f_Boss", 0)
				d.notice("Shadow tower: You are almost at the end. But the worst is just about to come!")
								
				d.setf("ShadowZone_FinalBoss", 1)
				
				d.spawn_mob_dir(FINAL_BOSS, Position[1], Position[2], Position[3]);
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_FinalBoss_kill", FinalBossTimer, d.get_map_index())
			end
		end
			
		-----
		--Server timer to check if the boss is killed or not
		-----
		when ShadowZone_FinalBoss_kill.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("ShadowZone_FinalBoss") == 1 then
					d.notice("Shadow tower: Time is up. You have failed");
					d.exit_all()
				end
			end
		end
		
		-----
		--Players kill Final boss (4388), after that, chest is spawned
		-----
		when FINAL_BOSS.kill with ShadowZoneLIB.isActive() and not npc.is_pc() and d.getf("ShadowZone_floor") == 9 and d.getf("ShadowZone_FinalBoss") == 1 begin
			local settings = ShadowZoneLIB.Settings(); 
			local Position = settings["chest_pos"] 
			local TimeToExit = settings["time_to_final_exit"] 
			local minutes = math.floor(TimeToExit / 60)
			
			ShadowZoneLIB.clearDungeon();
			ShadowZoneLIB.setReward();
			
			clear_server_timer("ShadowZone_FinalBoss_kill", d.get_map_index());
			ShadowZoneLIB.clearCoolTimer();
			
			d.setf("ShadowZone_FinalBoss", 0);
			d.setf("ShadowZone_CanTakeReward", 1);
			
			notice_all(pc.get_name() .." killed the Nija!")
			d.notice("Shadow tower: You will be teleported out of dungeon in %s minutes.", minutes);
			d.notice("Shadow tower: Now you can take your reward!");
			
			d.spawn_mob_dir(CHEST, Position[1], Position[2], Position[3]);
			
			server_timer("ShadowZone_Final_Exit", TimeToExit, d.get_map_index());
		end
		
		
		-----
		--Players can take reward from the chest
		-----	
		when CHEST.chat."Take reward" with ShadowZoneLIB.isActive() and d.getf("ShadowZone_CanTakeReward") == 1 begin
			setskin(NOWINDOW);
			
			if d.getf(string.format("player_%d_reward_state", pc.get_player_id())) == 1 then
				pc.give_item2(ITEM_MAIN_REWARD, 1);
				
				d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 0);	
			else
				syschat("Shadow tower: You already took the reward!")
			end 
		end
		
		-----
		--Players can put key (30855) to the chest and take another smaller reward
		-----	
		when CHEST.take with item.get_vnum() == ITEM_KEY_REWARD and ShadowZoneLIB.isActive() and d.getf("ShadowZone_CanTakeReward") == 1 begin
			item.remove()
			pc.give_item2(ITEM_SMALL_REWARD, 1)
		end
			
		-----
		--Players are teleported out of dungeon.
		-----
		when ShadowZone_Final_Exit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
		
		-----
		--Player, or leader (if its group) proceed to next level by clicking to the gate NPC spawned in every floor
		-----
		when GATE_NPC.chat."Next floor" with ShadowZoneLIB.isActive() and (party.is_party() and party.is_leader() or not party.is_party()) begin
			local settings = ShadowZoneLIB.Settings();
			local Floor = d.getf("ShadowZone_floor")
			local StatuePosition = settings["reaper_statue_pos"]
			
			---- Set and jump 2nd floor
			if Floor == 1 then
				local Position_2 = settings["pos_2_floor"]
				local SecondFloorTimer = settings["timer_second_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
				
				
				d.setf("ShadowZone_floor", 2);
				d.setf("ShadowZone_2f_KillMonsters", 1);
				d.setf("ShadowZone_2f_Seal", 1);
				
				d.regen_file(settings["regen_file"].."regen_2a.txt");
				d.regen_file(settings["regen_file"].."regen_2b.txt");
				
				d.notice(string.format("Shadow tower: Destroy both %s! Destroy all monsters to get a key!", mob_name(FIRST_SEAL)));
				
				d.jump_all(Position_2[1], Position_2[2])
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_SecondFloor", SecondFloorTimer, d.get_map_index())
			
			---- Set and jump 3rd floor
			elseif Floor == 2 then
				local Position_3 = settings["pos_3_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
				
				d.setf("ShadowZone_floor", 3);
				
				ShadowZoneLIB.spawnSecondStone();
				
				d.notice(string.format("Shadow tower: Find real %s and destroy it!", mob_name(SECOND_STONE)));
				d.notice(string.format("Shadow tower: Every wrong stone hides %s inside!", mob_name(FIRST_BOSS)));
				d.notice("Shadow tower: The more fake stones you destroy, the more HP will have a next boss!");
				
				ShadowZoneLIB.noCoolTimer();
				
				d.jump_all(Position_3[1], Position_3[2])
							
			---- Set and jump 4th floor
			elseif Floor == 3 then
				local Position_4 = settings["pos_4_floor"]
				local FourthFloorTimer = settings["timer_fourth_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
				
				d.setf("ShadowZone_floor", 4);
				d.setf("ShadowZone_4f_KillMonsters", 1);
				
				d.spawn_mob_dir(FIRST_STATUE, StatuePosition[1], StatuePosition[2], StatuePosition[3]);
				d.regen_file(settings["regen_file"].."regen_4a.txt");
				
				d.jump_all(Position_4[1], Position_4[2])
				
				d.notice(string.format("Shadow tower: Kill all monsters to get %s, then start to build a %s", item_name(SECOND_KEY), mob_name(FIRST_STATUE)));
				
				ShadowZoneLIB.setCoolTimer();
				
				server_timer("ShadowZone_FourthFloor", FourthFloorTimer, d.get_map_index())
			
			---- Set and jump 5th floor
			elseif Floor == 4 then
				local Position_5 = settings["pos_5_floor"]
				local FifthFloorTimer = settings["timer_fifth_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
				
				d.setf("ShadowZone_floor", 5);
				
				ShadowZoneLIB.spawnThirdStone();
				d.set_regen_file(settings["regen_file"].."regen_5a.txt");
				
				d.jump_all(Position_5[1], Position_5[2])
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_FifthFloor", FifthFloorTimer, d.get_map_index())
			
			---- Set and jump 6th floor
			elseif Floor == 5 then
				local Position_6 = settings["pos_6_floor"]
				local PillarPos = settings["fourth_stone_pos"]
				local BossPos = settings["fourth_boss_pos"]
				local SixthFloorTimer = settings["timer_sixth_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
									
				d.setf("ShadowZone_floor", 6);
				d.setf("ShadowZone_PillarActive", 1);
				
				d.spawn_mob(FOURTH_STONE, PillarPos[1],PillarPos[2]);
				d.spawn_mob(FOURTH_BOSS, BossPos[1],BossPos[2]);
				d.set_regen_file(settings["regen_file"].."regen_6a.txt");
				
				d.jump_all(Position_6[1], Position_6[2])
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_SixthFloor", SixthFloorTimer, d.get_map_index())
			
			---- Set and jump 7th floor
			elseif Floor == 6 then
				local Position_7 = settings["pos_7_floor"]
				
				addimage(25, 10, "shadowzone_bg2.tga"); say("[ENTER][ENTER]")
				say_title(mob_name(9376))
				say("[ENTER]If you want to continue, all people need:")
				say_item(""..item_name(ITEM_SOUL).."", ITEM_SOUL, "")
				say_reward("Those, who don't have it will be[ENTER]teleported out of dungeon after you continue")
				
				if (select("Continue", "Close") == 1) then
					setskin(NOWINDOW);
					npc.purge();
					
					d.exit_all_by_item_group ("ShadowZone_6F_ticket"); d.delete_item_in_item_group_from_all ("ShadowZone_6F_ticket");
					d.setf("ShadowZone_floor", 7);
					
					d.regen_file(settings["regen_file"].."regen_7a.txt");
					
					ShadowZoneLIB.noCoolTimer();
					
					d.jump_all(Position_7[1], Position_7[2])
				end
				
			---- Set and jump 8th floor
			elseif Floor == 7 then
				local Position_8 = settings["pos_8_floor"]
				local Pillar2Pos = settings["pillar2_pos"]
				local EightFloorTimer = settings["timer_eight_floor"]
				
				setskin(NOWINDOW);
				npc.purge();
									
				d.setf("ShadowZone_floor", 8);
				d.setf("ShadowZone_8F_Pillar", 1);
				d.setf("ShadowZone_8F_Drop", 1);
				
				d.set_regen_file(settings["regen_file"].."regen_8a.txt");
				d.spawn_mob_dir(FIRST_PILLAR, Pillar2Pos[1],  Pillar2Pos[2],  Pillar2Pos[3])
				
				d.jump_all(Position_8[1], Position_8[2])
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_EightFloor", EightFloorTimer, d.get_map_index())
				
			---- Set and jump 9th floor
			elseif Floor == 8 then
				local Position_9 = settings["pos_9_floor"]
				local StonePos = settings["sixth_stone_pos"]
				local TimeToDestroy = settings["time_to_destroy_finalstone"]
				local minutes = math.floor(TimeToDestroy / 60)
				
				setskin(NOWINDOW);
				npc.purge();
									
				d.setf("ShadowZone_floor", 9);
				d.setf("ShadowZone_9f_StoneD", 1);
				
				d.jump_all(Position_9[1], Position_9[2])
				d.spawn_mob(SIXTH_STONE, StonePos[1], StonePos[2]);
				
				d.notice(string.format("Shadow tower: Destroy %s in %s minutes! Otherwise you will have to finish next mission 2x!", mob_name(SIXTH_STONE), minutes));
				
				ShadowZoneLIB.setCoolTimer();
				server_timer("ShadowZone_NinethFloor_1", TimeToDestroy, d.get_map_index());
			end				
		end
		
		when logout with ShadowZoneLIB.isActive() begin
			local settings = ShadowZoneLIB.Settings();
			local Items = {30845, 30846, 30847, 30849};		
						
			for index = 1, table.getn(Items) do
				pc.remove_item(Items[index], pc.count_item(Items[index]));
			end
			
			if not pc.is_gm() then
				pc.setf("shadow_dungeon","exit_shadow_dungeon_time", get_global_time())
				pc.setqf("shadow_dungeon", get_time() + settings["dungeon_cooldown"])
			end
		end
	end
end	
		
		
