quest MagicTrollCave_zone begin
	state start begin
		when login with MagicTrollDungeonLIB.isActive() begin
			local settings = MagicTrollDungeonLIB.Settings();
			
			MagicTrollDungeonLIB.setOutCoords()
			if (party.is_party() and party.is_leader() or not party.is_party()) then
				d.setf("MagicTrollCave_level", 1);
				d.spawn_mob_dir(9303, 258, 308, 5);
				d.spawn_mob_dir(9302, 262, 223, 5);
				
				server_timer("MagicTrollCave_20min_left", 10*60, d.get_map_index())
				
				d.notice(string.format("Magic troll cave: Speak with %s", mob_name(9302)))
			end
		end
		
		------------
		-- First floor - Speaking with npc 9302
		------------
		
		when 9302.chat."Is this the place?" with MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 1 begin
			addimage(25, 10, "mt_quest_bg2.tga"); addimage(225, 150, "mt_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			if party.is_party() and not party.is_leader() then
				say("I can tell that only to group leader")
				return
			end
			say(string.format("The cave is splitted into[ENTER]2 patrs. This is the first one.[ENTER]To get to the second stage you need[ENTER]to break a spell and destroy a door[ENTER]over there. This is the only[ENTER]way to the %s.", mob_name(4095)))
			wait()
			setskin(NOWINDOW)
			npc.purge()
			d.spawn_mob_dir(9304, 241, 296, 7);
			d.regen_file("data/dungeon/magic_troll_cave/regen_1a.txt");
			d.notice("Magic troll cave: Kill all monsters!")
			d.setf("MagicTroll_mobs1", d.count_monster())
		end
		
		------------
		-- First floor - Killing 2 waves of monsters
		------------
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and d.getf("MagicTrollCave_level") == 1 begin
			local settings = MagicTrollDungeonLIB.Settings();
			
			d.setf("MagicTroll_mobs1", d.getf("MagicTroll_mobs1")-1)
			if d.getf("MagicTroll_mobs1") < 1 then
				d.notice("Magic troll cave: Another wave is coming!")
				d.setf("MagicTrollCave_level", 2);
				server_timer("MagicTroll_wave2", 13, d.get_map_index())
			end
		end
				
		when MagicTroll_wave2.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/magic_troll_cave/regen_1a.txt");
				d.setf("MagicTroll_mobs2", d.count_monster())
			end
		end
		
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and d.getf("MagicTrollCave_level") == 2 begin
			local settings = MagicTrollDungeonLIB.Settings(); local position = settings["CrystalPos1"]; local n = number(1,8)
			
			d.setf("MagicTroll_mobs2", d.getf("MagicTroll_mobs2")-1)
			if d.getf("MagicTroll_mobs2") < 1 then
				d.notice("Magic troll cave: You've killed all monsters.")
				d.notice("Magic troll cave: Destroy crystals until you find real key!")
				d.notice("Magic troll cave: You have to do it within 5 minutes!!!")
				server_timer("MagicTroll_crystaltimer", 5*60, d.get_map_index())
				
				d.setf("MagicTrollCave_level", 3); d.setf("MagicTrollCave_CrystalClear", 0);

				for i = 1, 8 do
					if (i != n)
					then
						d.set_unique("fake_crystal"..i, d.spawn_mob(8459, position[i][1], position[i][2]))
					end
				end
			
				local vid = d.spawn_mob(8459, position[n][1], position[n][2])
				d.set_unique ("real_crystal",vid)
			end
		end
		------------
		-- First floor - Destroying crystals and getting the key 30782, 30783
		------------
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 8459 begin
			local settings = MagicTrollDungeonLIB.Settings();
			if d.getf("MagicTrollCave_level") == 3 then
				if d.is_unique_dead("real_crystal") then			
					game.drop_item(30783, 1)
				else
					game.drop_item(30782, 1)
				end
			elseif d.getf("MagicTrollCave_level") == 8 then
				local CrystalCount = 7;	
				d.setf("MagicTroll_Crystal2", d.getf("MagicTroll_Crystal2")+1);
				if (d.getf("MagicTroll_Crystal2") < CrystalCount) then
					d.notice(string.format("Magic troll cave: %d %s has left!", CrystalCount-d.getf("MagicTroll_Crystal2"), mob_name(8459)))
				else
					game.drop_item(30786, 1)
					d.setf("MagicTrollCave_level", 9); d.setf("CanOpenSeal", 1);
					d.notice(string.format("Magic troll cave: You've got a another key! Let's insert it into %s", mob_name(9306)))
				end
			end
		end
				
		when 9304.take with  MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 3 begin
			if item.get_vnum() == 30782 then			
				item.remove()
				d.notice("Magic troll cave: This key was just an illusion.")
				d.notice("Magic troll cave: Find the real one!")
			elseif item.get_vnum() == 30783 then
				clear_server_timer("MagicTroll_crystaltimer", get_server_timer_arg())		
				d.setf("MagicTrollCave_level", 4); d.setf("MagicTrollCave_CrystalClear", 1);
				item.remove()
				d.purge_area(332400, 2273900, 335100, 2283000)
				npc.kill()
				d.spawn_mob(9305, 245, 295)
			end
		end
		
		when MagicTroll_crystaltimer.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.getf("MagicTrollCave_CrystalClear") == 0 then
					d.kill_all()					
					d.notice("Magic troll cave: You failed!")
					d.notice("Magic troll cave: You will be teleported out of dungeon.")
					
					server_timer("MagicTrollCave_final_exit", 5, d.get_map_index())
				else
					return
				end
			end
		end
		
		when 9305.click with MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 4 begin
			npc.purge()
			game.drop_item(30784, 1)
			d.notice("Magic troll cave: Open the door to proceed!")
		end
		
		when 9303.take with item.get_vnum() == 30784 and MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 4 begin
			item.remove()
			d.kill_all()
			d.setf("MagicTrollCave_level", 5);
			d.spawn_mob_dir(9302, 258, 343, 5);
		end
		
		when 9302.chat."Nothing is here" with MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 5 begin
			say_size(350,350)
			addimage(25, 10, "mt_quest_bg3.tga"); addimage(225, 200, "mt_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			if party.is_party() and not party.is_leader() then
				say("I need to talk to you leader.")
				return
			end
			say(string.format("This place is protected by magic.[ENTER]To kill the troll you need to destroy[ENTER]3x %s. But first we need to[ENTER]uncover them. I need a specific piece[ENTER]of scroll from here. It was lying[ENTER]somewhere here on the ground.[ENTER]Bring it to me and i say the formula.", mob_name(9306)))
			wait()
			local settings = MagicTrollDungeonLIB.Settings(); local ScrollPos = settings["ScrollPos"]; local scroll_count = table.getn(ScrollPos); local randomNumber = number(1, table.getn(ScrollPos));
			d.spawn_mob(9307, ScrollPos[randomNumber][1], ScrollPos[randomNumber][2]);			
			d.setf("MagicTrollCave_level", 6);
			d.notice(string.format("Magic troll cave: Find a %s !!", item_name(30785)))
		end

		when 9307.click with MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 6 begin
			npc.purge()
			game.drop_item(30785, 1)
			d.setf("MagicTrollCave_level", 7);
			d.notice(string.format("Magic troll cave: Give it to the %s", mob_name(9302)))
		end
		
		when 9302.take with item.get_vnum() == 30785 and MagicTrollDungeonLIB.isActive() and d.getf("MagicTrollCave_level") == 7 begin
			item.remove()
			addimage(25, 10, "mt_quest_bg3.tga"); addimage(225, 150, "mt_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Thank you![ENTER]I'm gonna uncover the seals. Be prepared![ENTER]I'm not really sure what is going to[ENTER]happen.")
			wait()
			npc.purge()
			d.regen_file("data/dungeon/magic_troll_cave/regen_2a.txt");
			d.set_regen_file("data/dungeon/magic_troll_cave/regen_2b.txt");
			d.notice("Magic troll cave: Kill monsters until you got a key!")
		end
			
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and d.getf("MagicTrollCave_level") == 7 begin
			local settings = MagicTrollDungeonLIB.Settings();
			if number(1,150) == 1 then
				d.setf("MagicTrollCave_level", 8); d.setf("CanOpenSeal", 1);
				game.drop_item(30786, 1);
				d.clear_regen();
				d.notice("Magic troll cave: You've got the key!")
				d.notice(string.format("Magic troll cave: Insert it into %s!", mob_name(9306)))
			end
		end
		
		when 9306.take with item.get_vnum() == 30786 and MagicTrollDungeonLIB.isActive() begin
			if d.getf("CanOpenSeal") == 1 then
				item.remove()
				npc.kill()
				d.setf("CanOpenSeal", 0);
			else
				chat("Magic troll cave: You can not do that right now.")
			end
		end
		
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 4094 begin
			local settings = MagicTrollDungeonLIB.Settings();
			if d.getf("MagicTrollCave_level") == 8 then
				d.notice(string.format("Magic troll cave: Great job! Destroy all %s now!", mob_name(8459)))	
				d.regen_file("data/dungeon/magic_troll_cave/regen_2c.txt");
			elseif d.getf("MagicTrollCave_level") == 9 then
				d.notice(string.format("Magic troll cave: Great job! Destroy all %s now!", mob_name(8460)))	
				d.regen_file("data/dungeon/magic_troll_cave/regen_2d.txt");
			elseif d.getf("MagicTrollCave_level") == 10 then
				d.notice("Magic troll cave: Great job! Monsters are coming! Kill them!")
				d.setf("MagicTrollCave_level", 11);				
				server_timer("MagicTrollCave_last_wave", 13, d.get_map_index())
			end
		end
		
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 8460  and d.getf("MagicTrollCave_level") == 9 begin
			local settings = MagicTrollDungeonLIB.Settings(); local StoneCount = 10;	
			d.setf("MagicTroll_Stone", d.getf("MagicTroll_Stone")+1);
			if (d.getf("MagicTroll_Stone") < StoneCount) then
				d.notice(string.format("Magic troll cave: %d %s has left!", StoneCount-d.getf("MagicTroll_Stone"), mob_name(8460)))
			else
				game.drop_item(30786, 1)
				d.setf("MagicTrollCave_level", 10); d.setf("CanOpenSeal", 1);
				d.notice(string.format("Magic troll cave: You've got the last key! Let's insert it into %s", mob_name(9306)))
			end
		end

		when MagicTrollCave_last_wave.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.regen_file("data/dungeon/magic_troll_cave/regen_2b.txt");
				d.setf("MagicTroll_mobs3", d.count_monster())
			end
		end
		
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and d.getf("MagicTrollCave_level") == 11 begin
			local settings = MagicTrollDungeonLIB.Settings();
			
			d.setf("MagicTroll_mobs3", d.getf("MagicTroll_mobs3")-1)
			if d.getf("MagicTroll_mobs3") < 1 then
				d.notice("Magic troll cave: The ground is shaking!")
				d.notice("Magic troll cave: Real beast is coming!")
				d.setf("MagicTrollCave_level", 12);
				d.kill_all()
				server_timer("MagicTroll_BossSpawn", 7, d.get_map_index())
			end
		end
				
		when MagicTroll_BossSpawn.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.spawn_mob(4095, 247, 403);
			end
		end
		
		when kill with MagicTrollDungeonLIB.isActive() and not npc.is_pc() and npc.get_race() == 4095  and d.getf("MagicTrollCave_level") == 12 begin
			notice_all(pc.get_name() .." killed the Magic troll!")
			d.notice(string.format("Magic troll cave: You've succesfully killed the %s", mob_name(4095)))
			d.notice("Magic troll cave: You will be teleported out of dungeon in 2 minutes.")
			MagicTrollDungeonLIB.clearTimers()
			server_timer("MagicTrollCave_0min_left", 115, d.get_map_index())
		end
		------------
		-- Dungeon time
		------------
		
		
		when MagicTrollCave_20min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Magic troll cave: 20 minutes left!")
				server_timer("MagicTrollCave_10min_left", 10*60, d.get_map_index())
			end
		end
		
		when MagicTrollCave_10min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Magic troll cave: 10 minutes left! Hurry up!!")
				server_timer("MagicTrollCave_5min_left", 5*60, d.get_map_index())
			end
		end
		
		when MagicTrollCave_5min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Magic troll cave: 5 minutes left! The clock is ticking!")
				server_timer("MagicTrollCave_1min_left", 4*60, d.get_map_index())
			end
		end
		
		when MagicTrollCave_1min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Magic troll cave: Only 1 minute left!!! You almost failed!!")
				server_timer("MagicTrollCave_0min_left", 60, d.get_map_index())
			end
		end
		
		when MagicTrollCave_0min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Magic troll cave: You are going to be teleported out of dungeon!")
				server_timer("MagicTrollCave_final_exit", 5, d.get_map_index())
			end
		end
		
		when MagicTrollCave_final_exit.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all()
			end
		end
		------------
		--Dungeon enter
		------------
		when 9302.chat."Magic troll cave" with not MagicTrollDungeonLIB.isActive() begin
			say_size(350,350)
			addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 200, "mt_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Hello![ENTER]Nice to meet you! Few months ago,[ENTER]very strange creature was appeared[ENTER]in a cave on north. Big purple[ENTER]kind of troll. I was huning[ENTER]this beast since its there, but its[ENTER]so strong. Its protected by many[ENTER]agrresive monsters and by magic![ENTER]Souls of dead bodies live again and they[ENTER]are very strong and powerful.")
			wait()
			say_size(350,350)
			addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 200, "mt_guard.tga")
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say("Those monsters are starting to leave[ENTER]the cave because there are too many of them.[ENTER]Its very dangerous for all regions.[ENTER]We need to kill this beast!")			
			say_reward("Do you think you can help me with that?")
			if (select("Yes", "No") == 1) then
				if MagicTrollDungeonLIB.checkEnter() then
					addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 200, "mt_guard.tga")
					say_reward("[ENTER]You must finish the dungeon in 30 minutes.[ENTER]Otherwise you will be teleported out[ENTER]of the dungeon.[ENTER][ENTER]I wish you best luck!")
					wait()
					MagicTrollDungeonLIB.CreateDungeon();
				end
			end
		end
		
		------------
		--Time reset - ONLY FOR GM 
		------------
		when 9302.chat."Time reset" with pc.is_gm() and not MagicTrollDungeonLIB.isActive() begin
			addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 150, "mt_guard.tga")
			say("[ENTER][ENTER]")
			if select("Reset time","Close") == 2 then return end
				addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 150, "mt_guard.tga")
				say("[ENTER][ENTER]")
				say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
				say("[ENTER]The time has been reseted.")
				pc.setf("magictroll_dungeon","exit_magictroll_dungeon_time", 0)
				pc.setqf("rejoin_time", get_time() - 3600)
		end
		
		------------
		-- Set waiting time for next enter (1 hour - 3600 seconds)
		------------
		
		when logout with MagicTrollDungeonLIB.isActive() begin 
			pc.setf("magictroll_dungeon","exit_magictroll_dungeon_time", get_global_time())
			pc.setqf("magictroll_dungeon", get_time() + 3600)
		end
	end
end	
		
		
