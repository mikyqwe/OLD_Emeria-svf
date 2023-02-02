quest PyramidDungeon_zone begin
	state start begin
		when login with PyramidDungeonLIB.isActive() begin
			local settings = PyramidDungeonLIB.Settings();
			
			PyramidDungeonLIB.setOutCoords()
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				
				pc.setqf("PyramidDungeon_reward", 0) --- Player can get reward on last floor
				d.setf("PyramidDungeon_level", 1); d.setf("PyramidDungeon_stone1", 1);
				d.spawn_mob(8472, 91, 130) --- First stone
				
				server_timer("PyramidDungeon_full_timer", settings["dungeon_timer"], d.get_map_index()) ---- Full dungeon timer
				server_timer("PyramidDungeon_1st_stone", settings["time_until_destroy_first_stone"], d.get_map_index())
				
				d.notice("Ancient pyramid: Destroy the stone within 4 minutes!")
				d.notice("Ancient pyramid: Otherwise, you will be teleported out of dungeon.")
			end
		end
		
		-- 1. Floor - destroy the stone (8472)
		when 8472.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 1 begin
			local settings = PyramidDungeonLIB.Settings();
			clear_server_timer("PyramidDungeon_1st_stone", get_server_timer_arg())
			
			d.setf("PyramidDungeon_stone1", 2);
			
			d.notice("Ancient pyramid: You will continue in few seconds.")
			server_timer("PyramidDungeon_1st_jump", 12, d.get_map_index())
			--server_timer("PyramidDungeon_5th_jump", 12, d.get_map_index())
		end
		
		-- 1. Floor - Stone timer, if you wont destroy the stone within 4 minutes, dungeon is closed
		when PyramidDungeon_1st_stone.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("PyramidDungeon_stone1") == 1 then
					d.notice("Ancient pyramid: You have failed!")
					d.exit_all()
				else
					return;
				end
			end
		end
		
		-- 1. Floor - Second floor jumper
		when PyramidDungeon_1st_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = PyramidDungeonLIB.Settings();

				d.jump_all(settings["insidePos_2f"][1], settings["insidePos_2f"][2]);
				d.setf("PyramidDungeon_level", 2); d.setf("PyramidDungeon_pergamen", 0);  d.setf("PyramidDungeon_CanUseSeal", 0);
				d.spawn_mob_dir(9332, 306, 158, 5);
				d.regen_file("data/dungeon/pyramid_dungeon/regen_2f_a.txt");
				d.setf("Pyramid_2floor_monsters", d.count_monster())
				
				d.notice("Ancient pyramid: Kill monsters to collect pieces of pergamen, once you have 4 pieces")
				d.notice(string.format("Ancient pyramid: destroy the %s!", mob_name(9332)))
			end
		end
		
		-- 2. Floor - Getting all pieces of pergamen (30800-30803)
		when kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 2 begin
			local settings = PyramidDungeonLIB.Settings(); local pergamen = d.getf("PyramidDungeon_pergamen");
			if pc.get_x() > 9238 and pc.get_y() > 22616 and pc.get_x() < 9294 and 22694 then				
				if pergamen == 0 then
					d.setf("Pyramid_2floor_monsters", d.getf("Pyramid_2floor_monsters")-1)
					if d.getf("Pyramid_2floor_monsters") < 1 then
						game.drop_item(settings["Items_2floor"][1], 1)
						d.setf("Pyramid_2floor_monsters", 0);  d.setf("PyramidDungeon_pergamen", 1);
						server_timer("PyramidDungeon_2floor_spawner", 12, d.get_map_index())														
					end
				end
				if pergamen == 1 then
					d.setf("Pyramid_2floor_monsters", d.getf("Pyramid_2floor_monsters")-1)
					if d.getf("Pyramid_2floor_monsters") < 1 then
						game.drop_item(settings["Items_2floor"][2], 1)
						d.setf("Pyramid_2floor_monsters", 0);  d.setf("PyramidDungeon_pergamen", 2);
						server_timer("PyramidDungeon_2floor_spawner", 12, d.get_map_index())							
					end
				end
				if pergamen == 2 then
					d.setf("Pyramid_2floor_monsters", d.getf("Pyramid_2floor_monsters")-1)
					if d.getf("Pyramid_2floor_monsters") < 1 then
						game.drop_item(settings["Items_2floor"][3], 1)
						d.setf("Pyramid_2floor_monsters", 0);  d.setf("PyramidDungeon_pergamen", 3);
						server_timer("PyramidDungeon_2floor_spawner", 12, d.get_map_index())							
					end
				end
				if pergamen == 3 then
					d.setf("Pyramid_2floor_monsters", d.getf("Pyramid_2floor_monsters")-1)
					if d.getf("Pyramid_2floor_monsters") < 1 then
						game.drop_item(settings["Items_2floor"][4], 1)
						d.setf("Pyramid_2floor_monsters", 0);  d.setf("PyramidDungeon_CanUseSeal", 1);  d.setf("PyramidDungeon_pergamen", 4);

						d.notice("Ancient pyramid: You have all pieces! Go to seal and decipher it!")
					end
				end
			end
		end
		
		-- 2. Floor - Monster spawner	
		when PyramidDungeon_2floor_spawner.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/pyramid_dungeon/regen_2f_a.txt");
				d.setf("Pyramid_2floor_monsters", d.count_monster())
			end
		end
		
		-- 2. Floor - Open seal (9332) and spawn of first boss (4153)
		when 9332.chat."Decipher the pergamens" with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 2 and d.getf("PyramidDungeon_CanUseSeal") == 1 begin
			local settings = PyramidDungeonLIB.Settings(); local Items = settings["Items_2floor"];			
			if pc.count_item(Items[1]) < 1 or pc.count_item(Items[2]) < 1 or pc.count_item(Items[3]) < 1 or pc.count_item(Items[4]) < 1 then 
				setskin(NOWINDOW)
				syschat("Ancient pyramid: You need to have all 4 pieces!")
			else
				setskin(NOWINDOW)
				for index = 1, table.getn(Items) do
					pc.remove_item(Items[index], pc.count_item(Items[index]));
				end
				npc.kill()
				
				d.notice(string.format("Ancient pyramid: It was spell to summon %s, kill it!", mob_name(4154)));
				d.spawn_mob(4154, 306, 126)
			end
		end
		
		-- 2. Floor - Kill first boss and start timer for jump to next floor
		when 4154.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 2 begin
			local settings = PyramidDungeonLIB.Settings();			
			PyramidDungeonLIB.clearDungeon()
			
			d.notice("Ancient pyramid: You will jump to next floor in few seconds")
			
			server_timer("PyramidDungeon_2st_jump", 20, d.get_map_index())
		end
		
		-- 2. Floor - Third floor jumper
		when PyramidDungeon_2st_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = PyramidDungeonLIB.Settings(); local position = settings["3f_stone_pos"]; local n = number(1,8); 

				d.jump_all(settings["insidePos_3f"][1], settings["insidePos_3f"][2]);
				d.setf("PyramidDungeon_level", 3); d.setf("PyramidDungeon_3f_stones_q", 0);
				
				for i = 1, 8 do
					if (i != n) then
						d.set_unique("fake"..i, d.spawn_mob(8473, position[i][1], position[i][2]))
					end
				end
			
				local vid = d.spawn_mob(8473, position[n][1], position[n][2])
				d.set_unique ("real",vid)
				
				d.regen_file("data/dungeon/pyramid_dungeon/regen_3f_a.txt");
				
				d.notice(string.format("Ancient pyramid: Find and destroy right %s within 21 minutes!", mob_name(8473)));
				d.notice("Ancient pyramid: Be careful, something strong is hiding inside of them!")
				
				server_timer("PyramidDungeon_3f_stone", 21*60, d.get_map_index())
			end
		end

		-- 3. Floor - Destroying real stone + timer to spawn next boss is set
		when 8473.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 3 begin
			local settings = PyramidDungeonLIB.Settings();
			if d.is_unique_dead("real") then	
				d.setf("PyramidDungeon_3f_stones_q", 1);
				--PyramidDungeonLIB.clearDungeon()
				d.purge_area(949600, 2260100, 957800, 2272600)				
				d.notice("Ancient pyramid: You have destroyed the right stone!")
				d.notice(string.format("Ancient pyramid: %s is coming!", mob_name(4155)));
			
				server_timer("PyramidDungeon_3f_bossspawn", 10, d.get_map_index())
			else
				d.notice("Ancient pyramid: This stone was just an illusion.")
			end
		end
		
		-- 3. Floor - Stone timer, if the stones are not destroyed in 21 minutes, players are kicked out			
		when PyramidDungeon_3f_stone.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("PyramidDungeon_3f_stones_q") == 0 then
					d.notice("Ancient pyramid: You have failed!")
					d.exit_all();
				else
					return;
				end
			end
		end
		
		-- 3. Floor - Boss spawn	
		when PyramidDungeon_3f_bossspawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(4155, 577, 136)
			end
		end
		
		-- 3. Floor - Kill second boss  (4155) and start timer for jump to next floor
		when 4155.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 3 begin
			local settings = PyramidDungeonLIB.Settings();			
			PyramidDungeonLIB.clearDungeon()
			
			d.notice("Ancient pyramid: You will jump to next floor in few seconds")
			
			server_timer("PyramidDungeon_3rd_jump", 15, d.get_map_index())
		end
		
		-- 3. Floor - Fourth floor jumper (into the maze)
		when PyramidDungeon_3rd_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = PyramidDungeonLIB.Settings();
				
				d.setf("PyramidDungeon_level", 4);
				d.jump_all(settings["insidePos_4f"][1], settings["insidePos_4f"][2]);
				d.set_regen_file("data/dungeon/pyramid_dungeon/regen_4f_a.txt");
				d.regen_file("data/dungeon/pyramid_dungeon/regen_4f_b.txt");
				local Boss3Pos = settings["4f_boss_pos"]; local Boss1Count = table.getn(Boss3Pos); local randomNumber = number(1, table.getn(Boss3Pos))	
				for index = 1, Boss1Count, 1 do
					local RealBoss3f = d.spawn_mob(4156, Boss3Pos[index][1], Boss3Pos[index][2])
					if index == randomNumber then
						d.set_unique("real_boss", RealBoss3f)
					end
				end
				
				d.notice("Ancient pyramid: Find a way out from this maze!")			
				d.notice(string.format("Ancient pyramid: At the end, you have to kill real %s!", mob_name(4156)));			
			end
		end
		
		-- 4. Floor - 3rd boss killing
		when 4156.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 4 begin
			local settings = PyramidDungeonLIB.Settings();			
			if d.is_unique_dead("real_boss") then	
				PyramidDungeonLIB.clearDungeon()
			
				d.notice(string.format("Ancient pyramid: This was the real %s", mob_name(4156)));
				d.notice("Ancient pyramid: You will be moved to next floor in few seconds")			
			
				server_timer("PyramidDungeon_4th_jump", 15, d.get_map_index())
			else
				d.notice(string.format("Ancient pyramid: This was a fake %s!", mob_name(4156)));
			end
		end
		
		-- 4. Floor - 4th jump + next floor set
		when PyramidDungeon_4th_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = PyramidDungeonLIB.Settings();
				
				d.setf("PyramidDungeon_level", 5); d.setf("PyramidDungeon_5f_monsters1", 1); d.setf("PyramidDungeon_5f_NpcMech", 1);
				
				for i = 1,4 do
					d.set_unique("anubis_head_"..i, d.spawn_mob_dir(9333, settings["5f_npc_pos"][i][1], settings["5f_npc_pos"][i][2],settings["5f_npc_pos"][i][3]))
				end
				d.set_regen_file("data/dungeon/pyramid_dungeon/regen_5f_a.txt");
				
				d.jump_all(settings["insidePos_5f"][1], settings["insidePos_5f"][2]);
				d.notice(string.format("Ancient pyramid: Destroy all %s, but be careful, it has its own mechanism!", mob_name(9333)))			
				d.notice("Ancient pyramid: You need to destroy them in exact sequence!");			
			end
		end
		
		-- 5. Floor - Killing first wave of monsters
		when kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 5 begin
			local settings = PyramidDungeonLIB.Settings();
			
			if pc.get_x() > 9063 and pc.get_y() > 23515 and pc.get_x() < 9206 and 23599 then				
				if d.getf("PyramidDungeon_5f_monsters1") == 1 then
					if number(1,100) == 1 then
						d.setf("PyramidDungeon_5f_monsters1", 2);
						game.drop_item(settings["Item_5floor"], 1);
						d.clear_regen();
						d.purge_area(906300, 2351500, 920600, 2359900);
					end
				elseif d.getf("PyramidDungeon_5f_monsters2") == 1 then
					if number(1,150) == 1 then
						d.setf("PyramidDungeon_5f_monsters2", 2);
						game.drop_item(settings["Item_5floor"], 1);
						d.clear_regen();
						d.purge_area(906300, 2351500, 920600, 2359900);
					end
				end
			end
		end
		
		-- 5. Destroying 9333 (anubis head) by 30804
		when 9333.take with item.get_vnum() == 30804 and PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 5 begin
			if d.getf("PyramidDungeon_5f_NpcMech") == 1 then
				if npc.get_vid() == d.get_unique_vid("anubis_head_1") then
					--npc.kill();
					d.kill_unique("anubis_head_1")
					item.remove();
					d.spawn_mob(8474, 178, 1054);
					d.setf("PyramidDungeon_5f_NpcMech", 2); d.setf("PyramidDungeon_5f_Stone1", 1);
					
					d.notice("Ancient pyramid: This was the right one!");
					d.notice(string.format("Ancient pyramid: Now destroy %s to get another item!", mob_name(8474)));
				else
					item.remove();
					d.setf("PyramidDungeon_5f_monsters1", 1);
					d.set_regen_file("data/dungeon/pyramid_dungeon/regen_5f_a.txt");
					
					d.notice(string.format("Ancient pyramid: You need to destroy other %s", mob_name(9333)));
				end
			elseif d.getf("PyramidDungeon_5f_NpcMech") == 2 then					
				if npc.get_vid() == d.get_unique_vid("anubis_head_2") then
					item.remove();
					d.kill_unique("anubis_head_2")
					
					d.setf("PyramidDungeon_5f_NpcMech", 3); d.setf("PyramidDungeon_5f_monsters2", 1);
					
					d.notice("Ancient pyramid: Great! Monsters are coming! One of them has another item!");
					server_timer("PyramidDungeon_5th_monster2", 5, d.get_map_index())
				else	
					item.remove();
					d.setf("PyramidDungeon_5f_Stone1", 1);
					d.spawn_mob(8474, 178, 1054);
					
					d.notice(string.format("Ancient pyramid: You need to destroy other %s", mob_name(9333)));
				end
			elseif d.getf("PyramidDungeon_5f_NpcMech") == 3 then					
				if npc.get_vid() == d.get_unique_vid("anubis_head_3") then
					item.remove();
					d.kill_unique("anubis_head_3")
					
					d.setf("PyramidDungeon_5f_NpcMech", 4); d.setf("PyramidDungeon_5f_Stone2", 1);
					d.regen_file("data/dungeon/pyramid_dungeon/regen_5f_c.txt");
				else
					item.remove();
					d.setf("PyramidDungeon_5f_monsters2", 1);
					d.set_regen_file("data/dungeon/pyramid_dungeon/regen_5f_b.txt");

					d.notice(string.format("Ancient pyramid: You need to destroy other %s", mob_name(9333)));
				end
			elseif d.getf("PyramidDungeon_5f_NpcMech") == 4 then					
				if npc.get_vid() == d.get_unique_vid("anubis_head_4") then
					item.remove();
					d.kill_unique("anubis_head_4")
					d.setf("PyramidDungeon_5f_NpcMech", 0); d.setf("PyramidDungeon_5f_Boss", 1);
					
					d.notice("Ancient pyramid: Great, but now, to alert!!!");
					d.notice("Ancient pyramid: Real Anubis is coming!");
					
					server_timer("PyramidDungeon_5th_boss", 10, d.get_map_index())
				else
					syschat("Ancient pyramid: Something wrong")
					return;
				end
			end
		end
				
		-- 5. Floor - Spawner timer for second wave of monsters	
		when PyramidDungeon_5th_monster2.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.set_regen_file("data/dungeon/pyramid_dungeon/regen_5f_b.txt");
			end
		end
		
				
		-- 5. Floor - Destroying stone to get 30804
		when 8474.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 5 begin
			local settings = PyramidDungeonLIB.Settings(); local Stone_count = 6;
			
			if d.getf("PyramidDungeon_5f_Stone1") == 1 then
				d.setf("PyramidDungeon_5f_Stone1", 2);
				game.drop_item(settings["Item_5floor"], 1);
			elseif d.getf("PyramidDungeon_5f_Stone2") == 1 then
				d.setf("PyramidDungeon_5f_Stone2_k", d.getf("PyramidDungeon_5f_Stone2_k")+1);
				if (d.getf("PyramidDungeon_5f_Stone2_k") < Stone_count) then
					d.notice(string.format("Ancient pyramid: %d stones has left!", Stone_count-d.getf("PyramidDungeon_5f_Stone2_k")))
				else
					d.setf("PyramidDungeon_5f_Stone2", 2);
					game.drop_item(settings["Item_5floor"], 1);
				end
			end
		end
				
		-- 5. Floor - Spawner timer for second wave of monsters	
		when PyramidDungeon_5th_boss.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(4157, 177, 1031);
			end
		end
			
		-- 5. Floor - 4th boss
		when 4157.kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 5 begin
			PyramidDungeonLIB.clearDungeon()			
			d.notice("Ancient pyramid: You will be moved to next floor in few seconds")			
			
			server_timer("PyramidDungeon_5th_jump", 15, d.get_map_index())
		end
		
		-- 5. Floor - 5th jump to the last floor
		when PyramidDungeon_5th_jump.server_timer begin
			if d.select(get_server_timer_arg()) then
				local settings = PyramidDungeonLIB.Settings();
				
				d.regen_file("data/dungeon/pyramid_dungeon/regen_6f_a.txt");
				d.regen_file("data/dungeon/pyramid_dungeon/regen_6f_b.txt");
				
				d.setf("PyramidDungeon_level", 6); d.setf("PyramidDungeon_6f_monsters1", 1); d.setf("PyramidDungeon_KeyPickUp", 0); d.setf("PyramidDungeon_CanUseKey", 0); d.setf("PyramidDungeon_6f_monsters1_c", d.count_monster())
				
				d.jump_all(settings["insidePos_6f"][1], settings["insidePos_6f"][2]);
				d.notice(string.format("Ancient pyramid: Destroy %s to be able summon a real boss!", mob_name(9334)))			
				d.notice("Ancient pyramid: Kill all monsters now!");			
			end
		end
		
		-- 6. Floor - Killing monsters until the key is dropped
		when kill with PyramidDungeonLIB.isActive() and not npc.is_pc() and d.getf("PyramidDungeon_level") == 6 begin
			local settings = PyramidDungeonLIB.Settings();
			if pc.get_x() > 9742 and pc.get_y() > 23584 and pc.get_x() < 10011 and 23764 then				
				if d.getf("PyramidDungeon_6f_monsters1") == 1 then
				
					d.setf("PyramidDungeon_6f_monsters1_c", d.getf("PyramidDungeon_6f_monsters1_c")-1)
					
					if d.getf("PyramidDungeon_6f_monsters1_c") < 1 then
						d.setf("PyramidDungeon_6f_monsters1", 2); d.setf("PyramidDungeon_KeyPickUp", 1);
						d.clear_regen();
						d.purge_area(974200, 2358400, 1001100, 2376400);
						
						d.notice(string.format("Ancient pyramid: The spell is gone, you can take the %s", mob_name(9335)));
					end
					
				elseif d.getf("PyramidDungeon_6f_monsters2") == 1 then --- Killing all monsters in the second wave 
				
					d.setf("PyramidDungeon_6f_monsters2_c", d.getf("PyramidDungeon_6f_monsters2_c")-1);					
					if d.getf("PyramidDungeon_6f_monsters2_c") < 1 then
						
						d.setf("PyramidDungeon_6f_monsters2", 2); d.setf("PyramidDungeon_6f_monsters2_c", 0); d.setf("PyramidDungeon_KeyPickUp", 2);
											
						d.notice(string.format("Ancient pyramid: The spell is gone, you can take the %s", mob_name(9335)));
					end
				end
			end
		end
		
		-- 6. Floor - Picking the ankh key (9335)
		when 9335.click with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			local settings = PyramidDungeonLIB.Settings();
			
			if d.getf("PyramidDungeon_KeyPickUp") == 0 then
				syschat("Ancient pyramid: You can not even touch it")
				syschat("Ancient pyramid: Some dark magic is protecting it")
				
			elseif d.getf("PyramidDungeon_KeyPickUp") == 1 then
				d.setf("PyramidDungeon_KeyPickUp", 0); d.setf("PyramidDungeon_CanUseKey", 1);
				pc.give_item2(settings["Item_6floor"], 1)
				npc.purge()
				
			elseif d.getf("PyramidDungeon_KeyPickUp") == 2 then
				d.setf("PyramidDungeon_KeyPickUp", 0); d.setf("PyramidDungeon_CanUseKey", 2);
				pc.give_item2(settings["Item_6floor"], 1)
				npc.purge()
			end
		end
		
		-- 6. Floor - Opening the pillars of wajdet (9334)
		when 9334.take with item.get_vnum() == PyramidDungeonLIB.Settings()["Item_6floor"] and PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			local settings = PyramidDungeonLIB.Settings();
			if d.getf("PyramidDungeon_CanUseKey") == 0 then
				syschat("Ancient pyramid: You can not do it right now")
				
			elseif d.getf("PyramidDungeon_CanUseKey") == 1 then
				d.setf("PyramidDungeon_CanUseKey", 0); d.setf("PyramidDungeon_6f_stone", 0);
				item.remove()
				npc.kill()
				
				d.notice(string.format("Ancient pyramid: %s is gonna appear.", mob_name(8475)));
				d.notice("Ancient pyramid: It can spawn any previous monsters and bosses!");
				d.notice("--------------------------------------------------------------");
				d.notice("Ancient pyramid: If you destroy it within 5 minutes, you avoid attracting another monsters!");
				
				server_timer("PyramidDungeon_6th_StoneSpawn", 5, d.get_map_index())
				
			elseif d.getf("PyramidDungeon_CanUseKey") == 2 then
				d.setf("PyramidDungeon_CanUseKey", 0);
				item.remove();
				PyramidDungeonLIB.clearDungeon();
				
				local vid = d.spawn_mob_dir(4158, 1012, 1144, 7);
				d.set_unique("SphinxBoss", vid);
				
				server_timer("PyramidDungeon_6th_PillarSpawn", settings["time_until_pillar_is_spawned"], d.get_map_index())
				
			end
		end
				
		-- 6. Floor - Stone spawner timer
		when PyramidDungeon_6th_StoneSpawn.server_timer begin
			local settings = PyramidDungeonLIB.Settings();
			
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(8475, 948, 1142);
				d.setf("PyramidDungeon_6f_Pillar_n", 0);
				server_timer("PyramidDungeon_6f_stone_k", settings["time_to_destroy_final_stone"], d.get_map_index())
			end
		end
		
		-- 6. Floor - Stone destroying
		when 8475.kill with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			if d.getf("PyramidDungeon_6f_stone") == 0 then
				d.setf("PyramidDungeon_6f_stone", 2); d.setf("PyramidDungeon_KeyPickUp", 2);
				clear_server_timer("PyramidDungeon_6f_stone_k", get_server_timer_arg())
				
				d.notice(string.format("Ancient pyramid: The spell is gone, you can take the %s", mob_name(9335)));
				
			elseif d.getf("PyramidDungeon_6f_stone") == 1 then
				d.notice("Ancient pyramid: You were too slow, monsters have beholded you!")
				d.notice("Ancient pyramid: They are coming, kill them all!")
				
				server_timer("PyramidDungeon_6f_monster2", 12, d.get_map_index())
			end
		end
			
		-- 6. Floor - Stone spawner timer
		when PyramidDungeon_6f_stone_k.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("PyramidDungeon_6f_stone") == 0 then
					d.setf("PyramidDungeon_6f_stone", 1);
				else
					return;
				end
			end
		end
			
		-- 6. Floor - Stone spawner timer
		when PyramidDungeon_6f_monster2.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/pyramid_dungeon/regen_6f_b.txt");
				d.setf("PyramidDungeon_6f_monsters2", 1); d.setf("PyramidDungeon_6f_monsters2_c", d.count_monster())
			end
		end
		
		-- 6. Floor - Pillar spawn
		when PyramidDungeon_6th_PillarSpawn.server_timer begin
			local settings = PyramidDungeonLIB.Settings();
			
			if d.select(get_server_timer_arg()) then
				if d.getf("PyramidDungeon_6f_Pillar_n") == 0 then
					d.setf("PyramidDungeon_6f_pillar_k", 0);
					d.spawn_mob_dir(8476, 961, 1142, 3);
					
					d.notice(string.format("Ancient pyramid: %s has spawned!", mob_name(8476)));
					d.notice("Ancient pyramid: Destroy it within 3 minutes! Otherwise, the dungeon will be closed");
					
					server_timer("PyramidDungeon_6f_pillar_d", settings["time_until_pillar_is_killed"], d.get_map_index())
				end
			end
		end
		
		-- 6. Floor - Pillar destroying
		when 8476.kill with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			d.setf("PyramidDungeon_6f_pillar_k", 1);
			
			d.notice(string.format("Ancient pyramid: The %s has no power to do magic anymore!", mob_name(4158)));
			d.notice("Ancient pyramid: Kill it!!");
		end
			
		-- 6. Floor - If the pillar (8476) is not destroyed before this timer, dungeon is closed.
		when PyramidDungeon_6f_pillar_d.server_timer begin
			local settings = PyramidDungeonLIB.Settings();
			
			if d.select(get_server_timer_arg()) then
				if d.getf("PyramidDungeon_6f_pillar_k") == 0 then
					d.purge_area(974200, 2358400, 1001100, 2376400);
					d.notice("Ancient pyramid: You have failed!")
					d.notice(string.format("Ancient pyramid: The %s has been protected!", mob_name(4158)));
					
					server_timer("PyramidDungeon_final_exit", 5, d.get_map_index())
				else
					return
				end
			end
		end
		
		-- 6. Floor - Sphinx kill and final chest spawn
		when 4158.kill with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			PyramidDungeonLIB.clearDungeon();
			PyramidDungeonLIB.clearTimers();
			
			notice_all(pc.get_name() .." killed the Sphinx!")
			d.notice("Anci group: You did it! Spectacular job!");
			d.notice("Anci group: Get your reward!");
			d.notice("Anci group: Dungeon will be automatically closed in 3 minutes.");
			
			d.setf("PyramidDungeon_CanTakeReward", 1); d.setf("PyramidDungeon_6f_Pillar_n", 1);
			d.spawn_mob_dir(9337, 992, 1142, 7)
			d.spawn_mob_dir(9331, 962, 1142, 3)
			
			server_timer("PyramidDungeon_final_exit", 180, d.get_map_index())
		end
		
		--- 6. Floor - Getting reward
		when 9337.chat."Reward" with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 and d.getf("PyramidDungeon_CanTakeReward") == 1 begin
			local settings = PyramidDungeonLIB.Settings();
			if pc.getqf("PyramidDungeon_reward") == 0 then
				pc.setqf("PyramidDungeon_reward", 1)
				pc.give_item2(settings["Item_reward"], 1)
				addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(225, 150, "pyramid_npc7.tga")
				say("[ENTER][ENTER]")
				say_title("Reward[ENTER]")
				say_reward("You have recieved:")
				say_item(""..item_name(settings["Item_reward"]).."", settings["Item_reward"], "")
				return
			else
				setskin(NOWINDOW)
				syschat("Ancient pyramid: You have already picked up the reward")
			end
		end
		
		--- 6. Floor - PLayers can teleport out of dungeon before its closed
		when 9331.chat."Out of dungeon" with PyramidDungeonLIB.isActive() and d.getf("PyramidDungeon_level") == 6 begin
			say_size(350,350); addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(220, 200, "pyramid_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("It was hard, wasn't it?[ENTER]But you did it! Good job I have to say!")			
			wait()
			setskin(NOWINDOW)
			pc.warp(731300, 2310400)
		end
		
		--- After the full dungeon time is up, this timer notice you and set 3 seconds timer for exit
		when PyramidDungeon_full_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Ancient pyramid: You have failed!")
				
				server_timer("PyramidDungeon_final_exit", 3, d.get_map_index())
			end
		end
		
		--- After that timer, whole dungeon is closed
		when PyramidDungeon_final_exit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
	
		------------
		--Dungeon enter
		------------
		when 9331.chat."Inside of the pyramid" with not PyramidDungeonLIB.isActive() begin
			say_size(350,350); addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(220, 200, "pyramid_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("People have forgotten to majestic gods of[ENTER]the greatest empire ever existed! They have returned![ENTER]Dark power brought them back from the underworld.[ENTER]They are still stuck in this pyramid, but my power has limits.[ENTER]I feel them, they are stronger every day and trying[ENTER]to get out.")
			wait()
			say_size(350,350); addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(220, 200, "pyramid_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("It's extremly dangeours. Undiscovered forces rule to that place.")
			say_reward("Do you think you could stop it?")
			if (select("Yes", "No") == 1) then
				if PyramidDungeonLIB.checkEnter() then
					say_size(350,350); addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(225, 200, "pyramid_guard.tga")
					say_reward("[ENTER]You must finish the dungeon in 2 hours.[ENTER]Otherwise you will be teleported out[ENTER]of the dungeon.[ENTER][ENTER]I wish you best luck!")
					wait()
					PyramidDungeonLIB.CreateDungeon();
				end
			end
		end
		
		
		------------
		--Time reset - ONLY FOR GM 
		------------
		when 9331.chat."Time reset" with pc.is_gm() and not PyramidDungeonLIB.isActive() begin
			local settings = PyramidDungeonLIB.Settings();
			addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(225, 150, "pyramid_guard.tga")
			say("[ENTER][ENTER]")
			if select("Reset time","Close") == 2 then return end
				addimage(25, 10, "pyramid_dungeon_bg1.tga"); addimage(225, 150, "pyramid_guard.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
				say("[ENTER]The time has been reseted.")
				pc.setf("pyramid_dungeon","exit_pyramid_dungeon_time", 0)
				pc.setqf("rejoin_time", get_time() - settings["dungeon_cooldown"])
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with PyramidDungeonLIB.isActive() begin
			local settings = PyramidDungeonLIB.Settings();
			if not pc.is_gm() then
				pc.setf("pyramid_dungeon","exit_pyramid_dungeon_time", get_global_time())
				pc.setqf("pyramid_dungeon", get_time() + settings["dungeon_cooldown"])
			end
		end
	end
end	
		
		
