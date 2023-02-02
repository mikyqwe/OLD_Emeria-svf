quest halloween2019_dungeon begin
	state start begin
	function settings()
		return
		{
			["halloween2019_dungeon_index"] = 37,
			["halloween2019_dungeon_warp"] = {27371, 1651, 27610, 1302},
			["halloween2019_dungeon_index_out"] = 41,
			["out_pos"] = {9694, 2786},
			["level_check"] = {
				["minimum"] = 45,
				["maximum"] = 125 ---65
			},
			["pass"] = 30760,
			["Items"] = {30761, 30762, 30763, 30764, 30765},
			
			["door"] = 9280, 				
			["door_pos"] = {[1] = {237, 552, 4}, [2] = {311, 447, 4}},
			["npc"] = 9279, 				
			["npc_pos"] = {[1] = {266, 518, 8}, [2] = {285, 472, 7}, [3] = {488, 277, 7}},
			["pumpkin"] = 9282, 				
			["cannon"] = 9284, 				
			["cannon_pos"] = {302, 459, 4},
			["bridge"] = 9283, 				
			["bridge_pos"] = {414, 281, 1},
			["skeleton"] = 9285, 				
			["skeleton_pos"] = {[1] = {321, 433, 8}, [2] = {403, 280, 7}, [3] = {580, 249, 8}},
			["stone1"] = 8450, 				
			["stone1_pos"] = {236, 566},
			["evil_pumpkin"] = 8451, 				
			["evil_pumpkin_pos"] = {354, 277},
			["first_boss"] = 4060, 				
			["first_boss_pos"] = {353, 285},
			["final_boss"] = 4061, 				
			["final_boss_pos"] = {509, 276},
			["mobs_per_level"] = {
				[1] = 74,
				[2] = 74,
				[5] = 163,
				[11] = 171,
				[14] = 171,
				[19] = 179
			}
		};
	end	
	
	function set_mobs_to_kill()
		local data = halloween2019_dungeon.settings()
		if halloween2019_dungeon.is_mob_count_level() then
			d.setf("halloween2019_dungeon_kill_count", data["mobs_per_level"][d.getf("halloween2019_dungeon_level")])
		end
	end
	
	function decrement_mobs_to_kill()
		d.setf("halloween2019_dungeon_kill_count", d.getf("halloween2019_dungeon_kill_count") - 1)
	end
	
	function get_remaining_mobs()
		return d.getf("halloween2019_dungeon_kill_count")
	end
	
	function is_mob_count_level()
		local data = halloween2019_dungeon.settings();
		return data["mobs_per_level"][d.getf("halloween2019_dungeon_level")] ~= nil
	end
	--------PARTY AND ENTER
	function party_get_member_pids()
		local pids = {party.get_member_pids()}
		
		return pids
	end
	
	function is_halloweened()
		local pMapIndex = pc.get_map_index();
		local data = halloween2019_dungeon.settings();
		local map_index = data["halloween2019_dungeon_index"];

		return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
	end
	
	function clear_halloweendungeon()
		d.clear_regen();
		d.kill_all();
	end
	
	function clear_h2019timers()
		clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_25min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_20min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_10min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_5min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_1min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_0min_left", get_server_timer_arg())
		clear_server_timer("halloween2019_dungeon_final", get_server_timer_arg())
	end
	
	function check_enter()
		addimage(25, 10, "h2019_bg01.tga")
		addimage(225, 150, "h2019_npc.tga")
		say("")
		say("")
		say("")
		say_title(mob_name(9279))
		local settings = halloween2019_dungeon.settings()
		
		if ((get_global_time() - pc.getf("halloween2019_dungeon","exit_halloween2019_dungeon_time")) < 60*60) then
		
			local remaining_wait_time = (pc.getf("halloween2019_dungeon","exit_halloween2019_dungeon_time") - get_global_time() + 60*60)
			say("You have to wait until you can enter the dungeon again.")
			say("")
			say_reward("You can enter Halloween ravine again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end
		
		if party.is_party() then			
			if not party.is_leader() then
				say_reward("Let me talk with your leader first.")
				return
			end

			if party.get_near_count() < 2 then
				say_reward("Your group must have atleast 2 players and")
				say_reward("they have to be around.")
				say_reward("Otherwise i can not let you there. ")
				return false;
			end
			
			local levelCheck = true
			local passCheck = true
			local MemberHaveLowLevel = {}
			local MemberHaveHighLevel = {}
			local MemberHaveNoTicket = {}
			local pids = {party.get_member_pids()}
			
			if not party.is_map_member_flag_lt("exit_halloween2019_dungeon_time", get_global_time() - 60 * 60 ) then
				say_reward("Some people of the group still")
				say_reward("have to wait.")
				return false;
			end
						
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.get_level() < settings["level_check"]["minimum"] then
					table.insert(MemberHaveLowLevel, pc.get_name())
					levelCheck = false
				end

				q.end_other_pc_block()
			end

			if not levelCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have atleast level 30.")
				say_reward("")
				say_reward("These members has not required level: ")
				for i, n in next, MemberHaveLowLevel, nil do
					say_title("- "..n)
				end
				return
			end
			
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.get_level() > settings["level_check"]["maximum"] then
					table.insert(MemberHaveHighLevel, pc.get_name())
					levelCheck = false
				end

				q.end_other_pc_block()
			end

			if not levelCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have maximum level 65.")
				say("")
				say_reward("Next members do not have enough level:")
				for i, n in next, MemberHaveHighLevel, nil do
					say_title("- "..n)
				end
				return
			end
			
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				if pc.count_item(settings.pass) < 1 then
					table.insert(MemberHaveNoTicket, pc.get_name())
					passCheck = false
				end

				q.end_other_pc_block()
			end

			if not passCheck then
				say_reward("If you want to enter the dungeon,")
				say_reward("every each member must have:")
				say_item("Halloween pass", settings["pass"], "")
				say("")
				say_reward("These members don't have the")
				say_reward("Halloween pass:")
				for i, n in next, MemberHaveNoTicket, nil do
					say_title("- "..n)
				end
				return
			end
	
		else
		
			if ((get_global_time() - pc.getf("halloween2019_dungeon","exit_halloween2019_dungeon_time")) < 60*60) then
			
				local remaining_wait_time = (pc.getf("halloween2019_dungeon","exit_halloween2019_dungeon_time") - get_global_time() + 60*60)
				say("You have to wait until you can enter the dungeon again.")
				say("")
				say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
				return
			end
			
			if (pc.get_level() < settings["level_check"]["minimum"]) then
				say(string.format("The minimum level to enter the dungeon is %d.", settings["level_check"]["minimum"]))
				return false;
			end
			
			if (pc.get_level() > settings["level_check"]["maximum"]) then
				say(string.format("The maximum level to enter the dungeon is %d.", settings["level_check"]["maximum"]))
				return false;
			end
			
			if (pc.count_item(settings["pass"]) < 1) then
				say_reward("If you want to enter the dungeon")
				say_reward("you must have ")
				say_item("Halloween pass", settings["pass"], "")
				return false;
			end
		end
		
		return true;
	end
	
	------------CREATE DUNGEON
	function create_dungeon()
		local setting = halloween2019_dungeon.settings()
		local pids = {party.get_member_pids()}
		
		if party.is_party() then
			for i, pid in next, pids, nil do
				q.begin_other_pc_block(pid)
				pc.remove_item(setting["pass"], 1)
				q.end_other_pc_block()
			end
			d.new_jump_party(setting["halloween2019_dungeon_index"], setting["halloween2019_dungeon_warp"][1], setting["halloween2019_dungeon_warp"][2])
			d.spawn_mob_dir(setting["door"], setting["door_pos"][1][1], setting["door_pos"][1][2], setting["door_pos"][1][3])
			d.regen_file("data/dungeon/halloween2019/regen_1.txt")
			d.setf("halloween2019_dungeon_level", 1)
			halloween2019_dungeon.set_mobs_to_kill()
			server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
			server_timer("halloween2019_dungeon_25min_left", 5*60, d.get_map_index())
			halloween2019_dungeon.clear_h2019timers()
		else
			pc.remove_item(setting["pass"], 1)
			d.new_jump(setting["halloween2019_dungeon_index"], setting["halloween2019_dungeon_warp"][1]*100, setting["halloween2019_dungeon_warp"][2]*100)
			d.spawn_mob_dir(setting["door"], setting["door_pos"][1][1], setting["door_pos"][1][2], setting["door_pos"][1][3])
			d.regen_file("data/dungeon/halloween2019/regen_1.txt")
			d.setf("halloween2019_dungeon_level", 1)
			halloween2019_dungeon.set_mobs_to_kill()
			server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
			server_timer("halloween2019_dungeon_25min_left", 5*60, d.get_map_index())
			halloween2019_dungeon.clear_h2019timers()
		end
	end
		
-----------LOGIN IN DUNGEON [OUT COORDS SETTING]
		when login with halloween2019_dungeon.is_halloweened() begin
			local settings = halloween2019_dungeon.settings()
						
			d.set_warp_location(settings["halloween2019_dungeon_index_out"], settings["out_pos"][1], settings["out_pos"][2]);
			if not pc.is_gm() then
				if not pc.in_dungeon() then
					pc.warp(settings["halloween2019_dungeon_index_out"], settings["out_pos"][1]*100, settings["out_pos"][2]*100)
				end
			end
		end


		--DUNGEON ENTER
		when 9279.chat."Halloween ravine" with not halloween2019_dungeon.is_halloweened() begin
			local settings = halloween2019_dungeon.settings()
			addimage(25, 10, "h2019_bg01.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			say("Hello warrior!")
			say("The creepy time of the year is here")
			say("again. Halloween ravine just opened")
			say("his gates and you can enter the fight!")
			say("This year its different. It's not that")
			say("easy. Portal is too strong and some monsters")
			say("are even come from the ravine here.")
			say("We have to stop it!")
			wait()
			addimage(25, 10, "h2019_bg01.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			say("Can you help me with that?")
			say("It's not going to be easy.")
			say("")
			say("DO you want to join the ravine?")
			if (select ("Yes", "No") == 1) then
				if halloween2019_dungeon.check_enter() then
					say_reward("Be careful!")
					say_reward("You have 25 minutes to finish whole")
					say_reward("dungeon.")
					wait()
					halloween2019_dungeon.create_dungeon()
				end
			end
		end
		
		---TIME RESET - ONLY FOR GM
		when 9279.chat."Time reset" with pc.is_gm() and not halloween2019_dungeon.is_halloweened() begin
			addimage(25, 10, "h2019_bg01.tga")
			say("")
			say("")
			say("")
			if select('Reset time','Close') == 2 then return end
				addimage(25, 10, "h2019_bg01.tga")
				say("")
				say("")
				say("")
				say_title(mob_name(9279))
				say("")
				say("Time has been reseted.")
				pc.setf('halloween2019_dungeon','exit_halloween2019_dungeon_time', 0)
				
				-- Dungeon Info
				pc.setqf("rejoin_time", get_time() - 3600)
		end	
-----------------------------------------------------------------------------
---------Dungeon
-----------------------------------------------------------------------------
		when kill with halloween2019_dungeon.is_halloweened() and not npc.is_pc() and halloween2019_dungeon.is_mob_count_level() begin
			halloween2019_dungeon.decrement_mobs_to_kill()
		end
		
		when kill with halloween2019_dungeon.is_halloweened() and not npc.is_pc() and npc.get_race() == 8450 begin
			local settings = halloween2019_dungeon.settings()
			if d.getf("halloween2019_dungeon_level") == 3 then
				d.setf("halloween2019_dungeon_level", 4)
				game.drop_item(settings["Items"][1], 1)
				d.notice("Halloween ravine: You've got the key! Destroy the wall now!")
			elseif d.getf("halloween2019_dungeon_level") == 6 then
				local kills = 4;
				local pumpkinpos = {{269, 548}, {293, 553}, {287, 520}, {226, 511}, {227, 480}, {241, 446}, {271, 439}, {289, 448}, {280, 503}, {264, 488}}
				local pumpkin_count = table.getn(pumpkinpos)
				local randomNumber = number(1, table.getn(pumpkinpos))
				d.setf("h2019_stone1a", d.getf("h2019_stone1a")+1);
				if (d.getf("h2019_stone1a") < kills) then
					d.notice(string.format("Halloween ravine: %d stones has left!", kills-d.getf("h2019_stone1a")))
				else
					d.notice("Halloween ravine: All stones were destroyed!")
					d.notice("Halloween ravine: Can you see the pumpkins?")
					d.notice("Halloween ravine: Find the right one!")
					d.setf("halloween2019_dungeon_level", 7)
					for index = 1, pumpkin_count, 1 do
						local realpumpkinVID = d.spawn_mob(settings["pumpkin"], pumpkinpos[index][1], pumpkinpos[index][2])
						if index == randomNumber then
							d.set_unique("real_pumpkin", realpumpkinVID)
						end
					end
				end -- if/else
			end
		end

		when 9282.click with halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 7 begin
			local settings = halloween2019_dungeon.settings()
			if (npc.get_vid() == d.get_unique_vid("real_pumpkin")) then
				game.drop_item(settings["Items"][2], 1)
				d.notice("Halloween ravine: You've found the right pumpkin!")
				d.notice(string.format("Halloween ravine: Give it to %s", mob_name(9279)))
				npc.kill()
				d.setf("halloween2019_dungeon_level", 8)
				d.spawn_mob_dir(settings["npc"], settings["npc_pos"][2][1], settings["npc_pos"][2][2], settings["npc_pos"][2][3])
			else
				d.notice("Halloween ravine: This pumpkin is completly rotten.")
				npc.kill()
			end
		end

		when 9280.take with item.get_vnum() == 30761 and halloween2019_dungeon.is_halloweened() begin
			local settings = halloween2019_dungeon.settings()
			npc.kill()
			if d.getf("halloween2019_dungeon_level") == 4 then
				pc.remove_item(settings["Items"][1], 1)
				halloween2019_dungeon.clear_halloweendungeon()
				d.setf("halloween2019_dungeon_level", 5)
				halloween2019_dungeon.set_mobs_to_kill()
				d.spawn_mob_dir(settings["door"], settings["door_pos"][2][1], settings["door_pos"][2][2], settings["door_pos"][2][3])
				d.spawn_mob_dir(settings["cannon"], settings["cannon_pos"][1], settings["cannon_pos"][2], settings["cannon_pos"][3])
				d.spawn_mob_dir(settings["npc"], settings["npc_pos"][1][1], settings["npc_pos"][1][2], settings["npc_pos"][1][3])
				d.notice(string.format("Halloween ravine: Let's talk with %s", mob_name(9279)))
			end
		end

		when 9279.chat."What next?" with halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 5 begin
			local settings = halloween2019_dungeon.settings()
			addimage(25, 10, "h2019_bg02.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			if party.is_party() then
				if not party.is_leader() then
					say_reward("I need to talk with your leader!")
					return
				end
			end
			say("Something is wrong.")
			say("I know this place, it never was so dark and lonely.")
			say("Even its Halloween ravine.")
			say("I can feel an evil here, but i don't know")
			say("what kind of evil. It's like some very powerful")
			say("monster is control this place.")
			wait()
			addimage(25, 10, "h2019_bg02.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			say("I can help you to go forward.")
			say("I need you to bring me one pumpkin.")
			say("I can transform it using my skills..")
			say("")
			say("Oh no... Monsters are coming.. I have to hide!")
			wait()
			npc.purge()
			server_timer("halloween2019_dungeon_spawner", 5, d.get_map_index())
		end
		
		when 9282.click with halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 7 begin
			local settings = halloween2019_dungeon.settings()
			if (npc.get_vid() == d.get_unique_vid("real_pumpkin")) then
				game.drop_item(settings["Items"][2], 1)
				d.notice("Halloween ravine: You've found the right pumpkin!")
				d.notice(string.format("Halloween ravine: Give it to %s", mob_name(9279)))
				npc.kill()
				d.setf("halloween2019_dungeon_level", 8)
				d.spawn_mob_dir(settings["npc"], settings["npc_pos"][2][1], settings["npc_pos"][2][2], settings["npc_pos"][2][3])
			else
				d.notice("Halloween ravine: This pumpkin is completly rotten.")
				npc.kill()
			end
		end

		when 9279.take with item.get_vnum() == 30762 and halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 8 begin
			local settings = halloween2019_dungeon.settings()
			pc.remove_item(settings["Items"][2], 1)
			addimage(25, 10, "h2019_bg02.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			say("Great! Give me a second, i need")
			say("to transform the pumpkin..")
			say("")
			say("")
			say("")
			wait()
			addimage(25, 10, "h2019_bg02.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			say("Here we go!")
			say_item(item_name(30763), settings["Items"][3], "")
			say("")
			say("Put it to the cannon and just watch!")
			say("I'm proud of myself..")
			pc.give_item2(settings["Items"][3])
			d.setf("halloween2019_dungeon_level", 9)
			wait()
			setskin(NOWINDOW)
			npc.purge()
		end
		
		when 9284.take with item.get_vnum() == 30763 and halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 9 begin
			local settings = halloween2019_dungeon.settings()
			pc.remove_item(settings["Items"][3], 1)
			halloween2019_dungeon.clear_halloweendungeon()
			d.setf("halloween2019_dungeon_level", 10)
			d.spawn_mob_dir(settings["bridge"], settings["bridge_pos"][1], settings["bridge_pos"][2], settings["bridge_pos"][3])
			d.spawn_mob_dir(settings["skeleton"], settings["skeleton_pos"][1][1], settings["skeleton_pos"][1][2], settings["skeleton_pos"][1][3])
			d.regen_file("data/dungeon/halloween2019/pumpkin2.txt")
		end

		when 9285.chat."Who are you?" with halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 10 begin
			local settings = halloween2019_dungeon.settings()
			addimage(25, 10, "h2019_bg03.tga")
			addimage(225, 150, "h2019_skeleton.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9285))
			say("")
			if party.is_party() then
				if not party.is_leader() then
					say_reward("I need to talk with your leader!")
					return
				end
			end
			say("I used to be a warrior!")
			say("Discovering this place I was captured")
			say("by strong power of Halloween knight.")
			say("This horrbile creature is pure evil!")
			say("A chance i can be a normal human still")
			say("exist! Can you help me?")
			say("Pleeaseee!")
			wait()
			addimage(25, 10, "h2019_bg03.tga")
			addimage(225, 150, "h2019_skeleton.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9285))
			say("")
			say("I knew it!!")
			say("Thank you! I will need a potion.")
			say("Special potion! Monsters here use")
			say("this potion as some kind of power")
			say("potion. They are much stronger after")
			say("they drink it. I know how to change")
			say("it to medicine which can help me!")
			say_item(item_name(30764), settings["Items"][4], "")
			wait()
			npc.purge()
			d.setf("halloween2019_dungeon_level", 11)
			halloween2019_dungeon.set_mobs_to_kill()
			d.notice("Halloween ravine: Kill all monsters to move on!")
			d.regen_file("data/dungeon/halloween2019/regen_3a.txt")
			server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
		end
		
		when kill with halloween2019_dungeon.is_halloweened() and not npc.is_pc() and npc.get_race() == 4060 begin
			local settings = halloween2019_dungeon.settings()
			if d.getf("halloween2019_dungeon_level") == 12 then
				d.setf("halloween2019_dungeon_level", 13)
				game.drop_item(settings["Items"][4], 1)
				d.notice("Halloween ravine: You've got the potion!")
				d.notice(string.format("Halloween ravine: Let's give it to %s", mob_name(9285)))
				d.spawn_mob_dir(settings["skeleton"], settings["skeleton_pos"][2][1], settings["skeleton_pos"][2][2], settings["skeleton_pos"][2][3])
			elseif d.getf("halloween2019_dungeon_level") == 18 then
				local kills = 2;
				d.setf("h2019_boss1", d.getf("h2019_boss1")+1);
				if (d.getf("h2019_boss1") < kills) then
					d.notice("Halloween ravine: One more is left")
				else
					d.notice("Halloween ravine: Great job!!")
					d.notice("Halloween ravine: Monsters are coming!!")
					d.setf("halloween2019_dungeon_level", 19)
					halloween2019_dungeon.set_mobs_to_kill()
					server_timer("halloween2019_dungeon_spawner", 5, d.get_map_index())
				end -- if/else
			end
		end
		
		when 9285.take with item.get_vnum() == 30764 and halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 13 begin
			local settings = halloween2019_dungeon.settings()
			pc.remove_item(settings["Items"][4], 1)
			d.setf("halloween2019_dungeon_level", 14)
			halloween2019_dungeon.set_mobs_to_kill()
			addimage(25, 10, "h2019_bg04.tga")
			addimage(225, 150, "h2019_skeleton.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9285))
			say("")
			say("Thank you!!!")
			say("Now just watch!")
			wait()
			setskin(NOWINDOW)
			npc.purge()
			d.kill_all()
			d.notice("Halloween skeleton: You foool!!!")
			d.notice("Halloween skeleton: You will never get out of here!!")
			server_timer("halloween2019_dungeon_spawner", 5, d.get_map_index())
		end

		when kill with halloween2019_dungeon.is_halloweened() and not npc.is_pc() and npc.get_race() == 8451 begin
			local settings = halloween2019_dungeon.settings()
			if d.getf("halloween2019_dungeon_level") == 15 then
				d.setf("halloween2019_dungeon_level", 16)
				d.notice("Halloween ravine: Great job! You still have a chance!")
				d.notice("Halloween ravine: You will be teleported to next stage in few seconds.")
				server_timer("halloween2019_dungeon_spawner", 10, d.get_map_index())
			elseif d.getf("halloween2019_dungeon_level") == 17 then
				local kills = 7;
				d.setf("h2019_stone2a", d.getf("h2019_stone2a")+1);
				if (d.getf("h2019_stone2a") < kills) then
					d.notice(string.format("Halloween ravine: %d pumpkins has left!", kills-d.getf("h2019_stone2a")))
				else
					d.notice("Halloween ravine: All pumpkins were destroyed!")
					d.notice(string.format("Halloween ravine: Be aware! %s are coming! Kill them!", mob_name(4060)))
					d.setf("halloween2019_dungeon_level", 18)
					server_timer("halloween2019_dungeon_spawner", 5, d.get_map_index())
				end -- if/else
			end
		end
		
		when 9279.chat."The skeleton" with halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 16 begin
			local settings = halloween2019_dungeon.settings()
			addimage(25, 10, "h2019_bg05.tga")
			addimage(225, 150, "h2019_npc.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9279))
			say("")
			if party.is_party() then
				if not party.is_leader() then
					say_reward("I need to talk with your leader!")
					return
				end
			end
			say("I know... I've forgotten to tell you about")
			say("him. He is very insidious!")
			say("But it doesn't matter. Here, take it and if")
			say("you see him, give it to him!!")
			say("This candy can kill him forever.")
			say("I love my skills!! Hahahahaha...")
			say_item(item_name(30765), settings["Items"][5], "")
			wait()
			pc.give_item2(settings["Items"][5], 1)
			d.setf("halloween2019_dungeon_level", 17)
			setskin(NOWINDOW)
			npc.purge()
			server_timer("halloween2019_dungeon_spawner", 5, d.get_map_index())
		end
		

		when 9285.take with item.get_vnum() == 30765 and halloween2019_dungeon.is_halloweened() and d.getf("halloween2019_dungeon_level") == 20 begin
			local settings = halloween2019_dungeon.settings()
			addimage(25, 10, "h2019_bg05.tga")
			addimage(225, 150, "h2019_skeleton.tga")
			say("")
			say("")
			say("")
			say_title(mob_name(9285))
			say("")
			say("What!!")
			say("You poisoned me?")
			say("How is that possible?!!")
			say("Maybe you can kill me, but you can not")
			say("kill my lord!!")
			say("See you in hell!!")
			wait()
			setskin(NOWINDOW)
			d.setf("halloween2019_dungeon_level", 21)
			npc.kill()
			pc.remove_item(settings["Items"][5], 1)
			halloween2019_dungeon.clear_halloweendungeon()
			d.spawn_mob(settings["final_boss"], settings["final_boss_pos"][1], settings["final_boss_pos"][2])
			d.notice(string.format("Halloween ravine: %s has come!!", mob_name(4061)))
			d.notice("Halloween ravine: Kill him!!")
		end
		
		when kill with halloween2019_dungeon.is_halloweened() and not npc.is_pc() and npc.get_race() == 4061 and d.getf("halloween2019_dungeon_level") == 21 begin
			local settings = halloween2019_dungeon.settings()
			d.setf("halloween2019_dungeon_level", 22)
			d.notice("Halloween ravine: You succesfully finished the dungeon!")
			d.notice("Halloween ravine: You are going to be teleported in 2 minutes.")
			server_timer("halloween2019_dungeon_0min_left", 115, d.get_map_index())
		end
-----------------
----------TIMERS
----------------------------------------------------------------------------------------------------------------		
		when halloween2019_dungeon_wave_kill.server_timer begin
			local settings = halloween2019_dungeon.settings()
			if d.select(get_server_timer_arg()) then
				if d.getf("halloween2019_dungeon_level") == 1 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 2)
						halloween2019_dungeon.set_mobs_to_kill()
						d.notice("Halloween ravine: Next monsters are coming!")
						server_timer("halloween2019_dungeon_spawner", 4, d.get_map_index())
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				elseif d.getf("halloween2019_dungeon_level") == 2 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 3)
						d.notice("Halloween ravine: You've killed all monsters!")
						d.notice("Halloween ravine: Destroy the stone now!")
						d.spawn_mob(settings["stone1"], settings["stone1_pos"][1], settings["stone1_pos"][2])
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				elseif d.getf("halloween2019_dungeon_level") == 5 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 6)
						d.notice("Halloween ravine: You've killed all monsters!")
						d.notice("Halloween ravine: Now destroy all stones!")
						d.regen_file("data/dungeon/halloween2019/regen_2b.txt")
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				elseif d.getf("halloween2019_dungeon_level") == 11 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 12)
						d.notice("Halloween ravine: You've killed all monsters!")
						d.notice("Halloween ravine: Be careful! Something stronger is coming!!")
						server_timer("halloween2019_dungeon_spawner", 4, d.get_map_index())
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				elseif d.getf("halloween2019_dungeon_level") == 14 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 15)
						d.notice("Halloween ravine: You've killed all monsters!")
						d.notice("Halloween ravine: Destroy the evil pumpkin now!")
						d.spawn_mob(settings["evil_pumpkin"], settings["evil_pumpkin_pos"][1], settings["evil_pumpkin_pos"][2])
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				elseif d.getf("halloween2019_dungeon_level") == 19 then
					if halloween2019_dungeon.get_remaining_mobs() <= 0 then
						clear_server_timer("halloween2019_dungeon_wave_kill", get_server_timer_arg())
						d.setf("halloween2019_dungeon_level", 20)
						d.notice("Halloween ravine: You've killed all monsters!")
						d.notice(string.format("Halloween ravine: Look! The %s!! Give the candy to him!!", mob_name(9285)))
						d.spawn_mob_dir(settings["skeleton"], settings["skeleton_pos"][3][1], settings["skeleton_pos"][3][2], settings["skeleton_pos"][3][3])
					else
						d.notice(string.format("Halloween ravine:  You still have to defeat %d monsters to move on.", halloween2019_dungeon.get_remaining_mobs()));
					end
				end
			end
		end

		when halloween2019_dungeon_spawner.server_timer begin
			local settings = halloween2019_dungeon.settings()
			if d.select(get_server_timer_arg()) then
				if d.getf("halloween2019_dungeon_level") == 2 then
					d.regen_file("data/dungeon/halloween2019/regen_1.txt")
					d.notice("Halloween ravine: Kill them all!")
					server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
				elseif d.getf("halloween2019_dungeon_level") == 5 then
					d.regen_file("data/dungeon/halloween2019/regen_2a.txt")
					d.regen_file("data/dungeon/halloween2019/pumpkin1.txt")
					server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
				elseif d.getf("halloween2019_dungeon_level") == 12 then
					d.spawn_mob(settings["first_boss"], settings["first_boss_pos"][1], settings["first_boss_pos"][2])
				elseif d.getf("halloween2019_dungeon_level") == 14 then
					d.regen_file("data/dungeon/halloween2019/regen_3a.txt")
					d.notice("Halloween ravine: Oh no.. Next monsters.. kill them!")
					server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
				elseif d.getf("halloween2019_dungeon_level") == 16 then
					d.jump_all(settings["halloween2019_dungeon_warp"][3], settings["halloween2019_dungeon_warp"][4])
					d.spawn_mob_dir(settings["npc"], settings["npc_pos"][3][1], settings["npc_pos"][3][2], settings["npc_pos"][3][3])
					d.regen_file("data/dungeon/halloween2019/pumpkin3.txt")
				elseif d.getf("halloween2019_dungeon_level") == 17 then
					d.regen_file("data/dungeon/halloween2019/regen_4a.txt")
				elseif d.getf("halloween2019_dungeon_level") == 18 then
					d.regen_file("data/dungeon/halloween2019/regen_4b.txt")
				elseif d.getf("halloween2019_dungeon_level") == 19 then
					d.regen_file("data/dungeon/halloween2019/regen_4c.txt")
					server_loop_timer("halloween2019_dungeon_wave_kill", 15, d.get_map_index())
				end
			end
		end

		when halloween2019_dungeon_25min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  20 minutes left!!!")
				server_timer("halloween2019_dungeon_15min_left", 5*60, d.get_map_index())
			end
		end
		
		when halloween2019_dungeon_15min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  15 minutes left!! Hurry up!")
				server_timer("halloween2019_dungeon_10min_left", 5*60, d.get_map_index())
			end
		end
		
		when halloween2019_dungeon_10min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  10 minutes left!! The clock is ticking!!")
				server_timer("halloween2019_dungeon_5min_left", 4*60, d.get_map_index())
			end
		end
		
		when halloween2019_dungeon_5min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  5 minutes left!! Hurry up!")
				server_timer("halloween2019_dungeon_1min_left", 60, d.get_map_index())
			end
		end
		when halloween2019_dungeon_1min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  1 minute left!! You almost failed!")
				server_timer("halloween2019_dungeon_0min_left", 60, d.get_map_index())
			end
		end
		
		when halloween2019_dungeon_0min_left.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Halloween ravine:  You will be teleported out of dungeon.")
				server_timer("halloween2019_dungeon_final", 5, d.get_map_index())
			end
		end
		
		when halloween2019_dungeon_final.server_timer begin
			if d.select(get_server_timer_arg()) then								
				d.exit_all()
			end
		end
		
		when logout with halloween2019_dungeon.is_halloweened() begin 
			pc.setf("halloween2019_dungeon","exit_halloween2019_dungeon_time", get_global_time())
			pc.setqf("halloween2019_dungeon", get_time() + 3600)
		end
	end
end	
		
		
