quest slime_dungeon begin
	state start begin
	--QUEST FUNCTIONS
		function settings()
			return
			{
				["slime_dung_index"] = 27,
				["slime_dung_warp"] = {1735600, 127700},
				["owl_map_index_out"] = 134,
				["out_pos"] = {8592, 3591},
				["level_check"] = {
					["minimum"] = 30,
					["maximum"] = 50
				},
				["ticket"] = 30723,
				["slime_metin"] = 8430,
				["slime_metin_pos"] = {245, 256},
				["keys"] = {30721, 30722},
				["slime_queen"] = 768,
				["slime_queen_pos"] = {285, 260},
			};
		end
		
		function get_regens(level)
			local regens = {
				[1] = "data/dungeon/slime_cave/regen_1.txt",
				[2] = "data/dungeon/slime_cave/regen_2.txt",
				[3] = "data/dungeon/slime_cave/regen_3.txt"};
			return d.set_regen_file(regens[level])
		end
		
		function is_slimed()
			local pMapIndex = pc.get_map_index();
			local data = slime_dungeon.settings();
			local map_index = data["slime_dung_index"];

			return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
		end
		
		function clear_slimedungeon()
			d.clear_regen();
			d.kill_all();
		end
		
		function check_enter()
			addimage(25, 10, "slime_dungeon.tga")
			addimage(230, 150, "thurang.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9236))
			say("")
			local settings = slime_dungeon.settings()

			if pc.get_level() < settings["level_check"]["minimum"] then
				say("If you want to enter Slime queen nest,")
				say("you need the minimum level of 30.")
				say("")
				return
			end
			
			if pc.get_level() > settings["level_check"]["maximum"] then
				say("You have exceeded the maximum level of the")
				say("Dungeon. You must not be higher than 50")
				say("")
				return
			end
			
			if pc.count_item(settings.ticket) < 1 then
				say("If you want to enter the Slime queen nest,")
				say("you need the following item:")
				--say_reward(string.format("%s 1x", item_name(settings.ticket)))
				say_item(""..item_name(settings["ticket"]).."", settings["ticket"], "")
				say("")
				return
			end

			pc.remove_item(settings.ticket, 1)

			say("After you press continue,")
			say("You will be teleported immediately!")
			say("Be careful!")
			say("")
			say_reward("You have only 15 minutes to complete")
			say_reward("the whole dungeon.")
			say_reward("Be fast!")
			wait()
			slime_dungeon.create_dungeon()
		end
				
		function create_dungeon()
			local settings = slime_dungeon.settings()
			
			d.new_jump(settings["slime_dung_index"], settings["slime_dung_warp"][1], settings["slime_dung_warp"][2])
			d.setf("slimedung_level", 1)
			d.spawn_mob(settings["slime_metin"], settings["slime_metin_pos"][1], settings["slime_metin_pos"][2])
			server_timer("slime_dungeon_15minutesleft", 5*60, d.get_map_index())
		end
		--FUNCTIONS END

		--DUNGEON CHECK
		when login begin
			local indx = pc.get_map_index()
			local settings = slime_dungeon.settings()
						
			if indx == settings["slime_dung_index"] then
				if not pc.in_dungeon() then
					warp_to_village()
				end
			end
		end
		
		--MAP ENTER
		--DUNGEON ENTER
		when 9236.chat."Slime queen nest"  with not slime_dungeon.is_slimed() begin
			local settings = slime_dungeon.settings()
			addimage(25, 10, "slime_dungeon.tga")
			addimage(230, 150, "thurang.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9236))
			say("")
			say("Hi warrior!")
			say("I'm Thu-Rang, guardian of Slime queen")
			say("nest. I'm responsible that slime")
			say("slime monsters are not coming out from")
			say("the nest. Sometimes there are just too")
			say("many of them and we need some warriors")
			say("to kill them.")
			wait()
			addimage(25, 10, "slime_dungeon.tga")
			addimage(230, 150, "thurang.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9236))
			say("")
			say("Are you brave enough?")
			say("I hope that yes, Slime queen is")
			say("strong bitch.")
			say("")
			say_title("Do you really want to enter this place? ")
			if (select ("Yes", "No") == 1) then
				slime_dungeon.check_enter()
			end
		end
		
		when kill with slime_dungeon.is_slimed() and not npc.is_pc() and npc.get_race() == 8430 and d.getf("slimedung_level") == 1 begin
			d.notice("Slime queen nest: You succesfuly destroyed the metin!")
			d.notice("Slime queen nest: Monsters are coming!!")
			d.notice("Slime queen nest: Kill them all!")
			d.setf("slimedung_level", 2)
			timer("slime_wave_spawn", 6)
		end
		
		when 9237.chat."Open the stone" with slime_dungeon.is_slimed()  and d.getf("slimedung_level") == 3 begin
			local settings = slime_dungeon.settings()
			addimage(25, 10, "slime_dungeon.tga")
			say("")
			say("")
			say("")
			say("This stone has some magical power here.")
			say("It's a little hole right here.")
			say("I think we have to put some slime into")
			say("it and block the hole.")
			say("Oh yeah!")
			wait()
			d.setf("slimedung_level", 4)
			timer("slime_wave_spawn", 1)
		end
		
		when kill with slime_dungeon.is_slimed() and not npc.is_pc() and npc.get_race() == 8430 and d.getf("slimedung_level") == 4 begin
			local settings = slime_dungeon.settings()
			if d.getf("slime_stone") == 1 then
				d.notice("Slime queen nest: 3 metin stones left!")
				d.setf("slime_stone", 2)
			elseif d.getf("slime_stone") == 2 then
				d.notice("Slime queen nest: 2 metin stones left!")
				d.setf("slime_stone", 3)
			elseif d.getf("slime_stone") == 3 then
				d.notice("Slime queen nest: 1 metin stone left!")
				d.setf("slime_stone", 4)
			elseif d.getf("slime_stone") == 4 then
				d.notice("Slime queen nest: You've destroyed all metin stones.")
				d.notice("Slime queen nest: Pick up the phial and take some slime!")
				d.setf("slime_stone", 0)
				d.setf("slimedung_level", 5)
				game.drop_item(settings["keys"][1], 1)
			end
		end
		
		when 9238.take with item.get_vnum() == 30721 and slime_dungeon.is_slimed() and d.getf("slimedung_level") == 5 begin
			local settings = slime_dungeon.settings()
			pc.remove_item(settings["keys"][1], 1)
			pc.give_item2(settings["keys"][2], 1)
			npc.purge()
			d.notice("Slime queen nest: Now put the slime into the seal stone!!")
			d.setf("slimedung_level", 6)
		end
		
		when 9237.take with item.get_vnum() == 30722 and slime_dungeon.is_slimed() and d.getf("slimedung_level") == 6 begin
			local settings = slime_dungeon.settings()
			pc.remove_item(settings["keys"][2], 1)
			npc.kill(9237)
			slime_dungeon.clear_slimedungeon()
			d.notice("Slime queen nest: The evil power is gone!")
			d.notice("Slime queen nest: Monseters are coming!!")
			d.setf("slimedung_level", 7)
			timer("slime_wave_spawn", 5)
		end
		
		when kill with slime_dungeon.is_slimed() and not npc.is_pc() and npc.get_race() == 768 and d.getf("slimedung_level") == 8 begin
			slime_dungeon.clear_slimedungeon()
			notice_all(pc.get_name() .." killed the Slime Queen!")
			d.notice("Slime queen nest: You succesfully finished the dungeon!")
			d.notice("Slime queen nest: You will be teleported in 2 minutes")
			d.notice("Slime queen nest: out of dungeon.")
			server_timer("slime_dungeon_is_done", 115, d.get_map_index())
			d.setf("slimedung_level", 9)
		end

		-- SPAWN OR NOTICE TIMER
		when slime_wave_spawn.timer begin
			local settings = slime_dungeon.settings()
			if d.getf("slimedung_level") == 2 then
				slime_dungeon.get_regens(1)
				loop_timer("slime_wave_kill", 15);
			elseif d.getf("slimedung_level") == 4 then
				d.setf("slime_stone", 1)
				slime_dungeon.get_regens(3)
				d.notice("Slime queen nest: Destroy all metinstones and find a phial")
				d.notice("Slime queen nest: resist against this slime!")
			elseif d.getf("slimedung_level") == 7 then
				slime_dungeon.get_regens(1)
				loop_timer("slime_wave_kill", 15);
			elseif d.getf("slimedung_level") == 8 then
				d.spawn_mob(settings["slime_queen"], settings["slime_queen_pos"][1], settings["slime_queen_pos"][2])
			end
		end

		-- LOOP TIMER FOR KILLING MONSTERS
		when slime_wave_kill.timer begin
			local settings = slime_dungeon.settings()
			if d.getf("slimedung_level") == 2 then
				if (d.count_monster() == 0) then
					slime_dungeon.clear_slimedungeon()
					cleartimer("wave_kill");
					d.setf("slimedung_level", 3)
					d.notice("Slime queen nest: You have killed all monsetrs!");
					d.notice("Slime queen nest: A seal stone just appeared!");
					d.notice("Slime queen nest: Let's check it out!");
					slime_dungeon.get_regens(2)
				else
					d.notice(string.format("Slime queen nest: You still have to kill %d mobs to move on.", d.count_monster()));
				end
			elseif d.getf("slimedung_level") == 7 then
				if (d.count_monster() == 0) then
					cleartimer("wave_kill");
					d.setf("slimedung_level", 8)
					d.notice("Slime queen nest: You have killed all monsetrs!");
					d.notice("Slime queen nest: A slime queen is coming!!!");
					timer("slime_wave_spawn", 5)
				else
					d.notice(string.format("Slime queen nest: You still have to kill %d mobs to move on.", d.count_monster()));
				end
			end
		end
		
		when slime_dungeon_15minutesleft.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Slime queen nest: !!!!! ONLY 10 MINUTES LEFT!!!!!")
				server_timer("slime_dungeon_5minutesleft", 5*60, d.get_map_index())
			end
		end
		
		when slime_dungeon_5minutesleft.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Slime queen nest: !!!!! ONLY 5 MINUTES LEFT!!!!!")
				d.notice("Slime queen nest: You're running out of time!")
				server_timer("slime_dungeon_1minutesleft", 4*60, d.get_map_index())
			end
		end
		
		when slime_dungeon_1minutesleft.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Slime queen nest: !!!!! ONLY 1 MINUTES LEFT!!!!!")
				d.notice("Slime queen nest: You are almost failed!")
				server_timer("slime_dungeon_0minutesleft", 60, d.get_map_index())
			end
		end
		
		when slime_dungeon_0minutesleft.server_timer begin
			if d.select(get_server_timer_arg()) then
				server_timer("slime_dungeon_is_done", 1, d.get_map_index())
			end
		end
		
		when slime_dungeon_is_done.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Slime queen nest: You will be teleported out of dungeon!")
				slime_dungeon.clear_slimedungeon()
				d.set_warp_location(134, 8592, 3591)
			end
			
			server_timer("final_exit_slime", 2, d.get_map_index())
		end
		
		when final_exit_slime.server_timer begin
			if d.select(get_server_timer_arg()) then								
				d.exit_all()
			end
		end									
	end
end

