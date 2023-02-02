quest snow_dungeon begin
	state start begin
		function rejoinpos(i)
			local rejoinposes = 
				{
					{5291,1814},
					{5540,1797},
					{5882,1800},
					{5293,2071},
					{5540,2074},
					{5866,2076},
					{5423,2244},
					{5689,2237},
					{5969,2229},
					{6047,1924}
				}
			return rejoinposes[i]
		end
		
		function stonepos_lv5(i)
			local level5stones = 
				{
					{449, 488},
					{455, 445},
					{419, 422},
					{382, 444},
					{389, 488}
				}
			return level5stones[i]
		end
		
		function bosspos_lv7(i)
			local level7bosspos = 
				{
					{302, 678},
					{281, 657},
					{303, 635},
					{324, 656}
				}
			return level7bosspos[i]
		end
		
		function clear_timer(mapindex)
			clear_server_timer ('snow_dungeon_ticket_remove', mapindex)
			clear_server_timer ('snow_dungeon_0m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_1m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_5m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_10m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_15m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_30m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_45m_left_timer', mapindex)
			clear_server_timer ('snow_dungeon_end_timer', mapindex)
			clear_server_timer ('snow_dungeon_level2_start', mapindex)
			clear_server_timer ('snow_dungeon_level3_start', mapindex)
			clear_server_timer ('snow_dungeon_level4_start', mapindex)
			clear_server_timer ('snow_dungeon_level5_start', mapindex)
			clear_server_timer ('snow_dungeon_level6_start', mapindex)
			clear_server_timer ('snow_dungeon_level7_start', mapindex)
			clear_server_timer ('snow_dungeon_level8_start', mapindex)
			clear_server_timer ('snow_dungeon_level9_start', mapindex)
			clear_server_timer ('snow_dungeon_BOSS_start', mapindex)
			clear_server_timer ('snow_dungeon_killed_A_1', mapindex)
			clear_server_timer ('snow_dungeon_killed_A_2', mapindex)
			clear_server_timer ('snow_dungeon_killed_B_1', mapindex)
			clear_server_timer ('snow_dungeon_killed_B_2', mapindex)
			clear_server_timer ('snow_dungeon_leader_out_timer', mapindex)
		end
		function is_snowdungeon(mapindex) 
			return mapindex >= 352 * 10000 and mapindex < (352 + 1) *10000
		end
		function level_clear()
			d.clear_regen()
			d.purge_area(520000,155000,612000,228600)
		end
        when login begin
            if pc.count_item(30331) > 0 then
                pc.remove_item(30331, pc.count_item(30331))
			elseif d.getf('level') < 10 and pc.getqf('snow_reward') == 1 then
            pc.setqf('snow_reward', 0)
			-- elseif true == pc.is_riding() then
			-- horse.unride()
            end
			if pc.count_item(30332) > 0 then
				pc.remove_item(30332, pc.count_item(30332))
			end
			if pc.count_item(30333) > 0 then
				pc.remove_item(30333, pc.count_item(30333))
			end
			local idx = pc.get_map_index()
			if idx == 352 and not is_test_server() then 
				notice('Wrong Access')
				timer('snow_dungeon_warp_timer', 5)
			elseif snow_dungeon.is_snowdungeon(idx) then
				pc.set_warp_location(61, 4322, 1655)
				
				if d.getf('dungeon_enter') == 0 then
					if get_global_time() - pc.getf('snow_dungeon','exit_time') < 60 * 60 then
						d.notice("Your time is over. In ten seconds you will be teleported in front of the fortress gates.")
						say("You can't enter the run yet.")
						timer('snow_dungeon_warp_timer', 5)
					elseif pc.count_item(72052) < 1 then
						d.notice("A member does not have a pass and unfortunately has to leave the run!")
						say(locale.dungeon.no_ticket)
						timer('snow_dungeon_warp_timer', 5)
					elseif pc.get_level() < 100 then
						d.notice(pc.get_name().." is under Level 100. He has to leave the Run!")
						say("You are under Level 100. You have to leave the Run!")
						timer('snow_dungeon_warp_timer', 5)
					end
				else
					if pc.getf('snow_dungeon','ticket_delete') == 0 then
						if party.is_party() and party.is_leader() then
							clear_server_timer ('snow_dungeon_leader_out_timer', idx)
						end
						pc.remove_item(72052, 1)
						pc.setf('snow_dungeon','ticket_delete',1)
					end
				end
			else
				pc.setf('snow_dungeon','ticket_delete',0)
			end
		end
		when logout begin
			local idx = pc.get_map_index()
			if snow_dungeon.is_snowdungeon(idx) then 
				if d.getf('dungeon_enter') == 1 then
					pc.setf('snow_dungeon','exit_time',get_global_time())
				end
				
				if party.is_leader() then
					server_timer ('snow_dungeon_leader_out_timer',5*60, d.get_map_index())
				end
			end
		end
		when snow_dungeon_warp_timer.timer begin
			pc.warp(4322*100, 1655*100, 61)
		end
		when 20397.chat."Nemere's Watchtower" with pc.get_map_index() >= 352 * 10000 and pc.get_map_index() < (352 + 1) *10000 and d.getf('level') == 0 begin
			if party.is_leader() then
				d.setf('level',1)
				d.regen_file ('data/dungeon/snow_dungeon/id_1f.txt')
				server_timer('snow_dungeon_30m_left_timer', 15*60, get_server_timer_arg())
				server_timer ('snow_dungeon_killed_A_1', 6, d.get_map_index())
				server_timer ('snow_dungeon_45m_left_timer',15*60, d.get_map_index())
				d.say_diff_by_item_group ('ticket', "The first opponents have appeared.[ENTER]The Dragon God bless you. You don't want to get lost.", "")
				server_timer ('snow_dungeon_ticket_remove', 5, d.get_map_index())
				party.setf('dungeon_index', d.get_map_index())
				d.setf('party_leader_pid', party.get_leader_pid())
			else
				say("Only the group leader can do this.")
			end
		end
		when snow_dungeon_ticket_remove.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.exit_all_by_item_group('ticket')
				d.delete_item_in_item_group_from_all ('ticket')
				d.setqf2('snow_dungeon','ticket_delete',1)
				d.setf('dungeon_enter',1) 
				d.notice("You have to kill all Monsters.")
			end
		end
		when 20395.chat."Nemere's Watchtower" with pc.get_map_index() == 61 begin
			if party.is_party() then
				local party_check = 0
				if d.find(party.getf("dungeon_index")) then
					party_check = (d.getf_from_map_index("party_leader_pid", party.getf("dungeon_index")) == party.get_leader_pid())
				end
				
				if d.find(party.getf("dungeon_index")) and party_check then
					if get_global_time() - pc.getf("snow_dungeon","exit_time") < 5 * 60 then
						local dungeon_level = d.getf_from_map_index("level", party.getf("dungeon_index"))
						pc.warp(snow_dungeon.rejoinpos(dungeon_level)[1] * 100, snow_dungeon.rejoinpos(dungeon_level)[2] * 100, party.getf("dungeon_index"))
					else
						say("Join your group's run.")
						say("You are only allowed to re-enter in the first five minutes.")
					end
				else
					if party.is_leader() then
						say("Do you really want to enter the Nemere's Watchtower[ENTER]with your group? Don't forget you need a[ENTER]Dungeon pass.")
						local warp = select(locale.dungeon.enter_yes,locale.dungeon.enter_no)
						if warp == 1 then
							party.setf("snow_dungeon_boss_kill_count", 0)
							d.new_jump_party(352, 5291, 1814)
							d.set_item_group ('ticket', 1, 72052, 1)
							d.spawn_mob_ac_dir(20397, 171, 199, 1)
						end
					else
						say("You cant enter the Watchtower.")
					end
				end
			else
				say("You have to be in a Group.")
			end
		end
		when 20395.chat."TEST : Remove Time for entering" with is_test_server() and pc.get_map_index() == 61 begin
			pc.setf('snow_dungeon','exit_time',get_global_time()-1800)
			say("The wait time has been successfully removed.")
		end
		--[[ when 20395.chat."Premium: Wartezeit entfernen" with pc.get_premium_remain_sec(7) > 0 begin
			pc.setf('snow_dungeon','exit_time',0)
			say("Die Wartezeit wurde erfolgreich entfernt.")
		end ]]--
		when snow_dungeon_killed_A_1.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.count_monster() <= 0 then
					if d.getf('level') == 1 then
						d.notice("You will be taken to the second floor in 10 seconds")
						server_timer('snow_dungeon_level2_start',10,d.get_map_index())
					elseif d.getf('level') == 3 then
						d.notice("You will get to the fourth floor in 10 seconds")
						server_timer('snow_dungeon_level4_start',10,d.get_map_index())
					elseif d.getf('level') == 4 then
						if d.getf('level4_boss_gen') == 0 then
							d.setf('level4_boss_gen', 1)
							--d.notice("A malicious Szel has appeared")
							d.spawn_group(6063,171,496, 1, true, 1)
							server_timer ('snow_dungeon_killed_A_2', 6, get_server_timer_arg())
						elseif d.getf('level4_boss_gen') == 1 then
							d.notice("You will be teleported to the fifth floor in 10 seconds")
							server_timer('snow_dungeon_level5_start',10,d.get_map_index())
						end
					elseif d.getf('level') == 6 then
						d.notice("The Metin of the Cold has fallen")
						d.spawn_mob(8058,747,494)
					end
				else 
					server_timer ('snow_dungeon_killed_A_2', 6, get_server_timer_arg())
				end
			end
		end
		when snow_dungeon_killed_A_2.server_timer begin
			if d.select(get_server_timer_arg()) then
				if d.count_monster() <= 0 then
					if d.getf('level') == 1 then
						d.notice("You will be taken to the second floor in 10 seconds")
						server_timer('snow_dungeon_level2_start',10,d.get_map_index())
					elseif d.getf('level') == 3 then
						d.notice("You will get to the fourth floor in 10 seconds")
						server_timer('snow_dungeon_level4_start',10,d.get_map_index())
					elseif d.getf('level') == 4 then
						if d.getf('level4_boss_gen') == 0 then
							d.setf('level4_boss_gen', 1)
							--d.notice("A malicious Szel has appeared")
							d.spawn_group(6063,171,496, 1, true, 1)
							server_timer ('snow_dungeon_killed_A_1', 6, get_server_timer_arg())
						elseif d.getf('level4_boss_gen') == 1 then
							d.notice("You will be teleported to the fifth floor in 10 seconds")
							server_timer('snow_dungeon_level5_start',10,d.get_map_index())
						end
					elseif d.getf('level') == 6 then
						d.notice("The Metin of the Cold has fallen")
						d.spawn_mob(8058,747,494)
					end
				else 
					server_timer ('snow_dungeon_killed_A_1', 6, get_server_timer_arg())
				end
			end
		end
		when snow_dungeon_level2_start.server_timer begin 
			if d.select(get_server_timer_arg()) then
				d.setf('level',2)
				d.jump_all(5540,1797)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_2f.txt')
				d.notice("Find the right key")
			end
		end
		when kill with snow_dungeon.is_snowdungeon(pc.get_map_index()) and d.getf('level') == 2 begin
			local i = number(1, 75)
			if i == 1 then
				game.drop_item (30331, 1)
			end
		end
		when 30331.use with d.getf('level') == 2 and snow_dungeon.is_snowdungeon(pc.get_map_index()) begin
			if not is_test_server() then	
				-- if pc.get_job() == 3 then
					if d.getf('level2_clear') == 0 then
						local j = number(1,5)
						if j == 1 then
							pc.remove_item(30331, 1)
							snow_dungeon.level_clear()
							d.notice("You have found the right key")
							d.notice("You will get to the third floor in 10 seconds")
							server_timer('snow_dungeon_level3_start',10,d.get_map_index())
							d.setf('level2_clear', 1)
						else
							d.notice("This is a wrong key")
							pc.remove_item(30331, 1)
						end
					end
				-- else
					-- syschat("You are not a shaman")
				-- end
			else
				if d.getf('level2_clear') == 0 then
					local j = number(1,5)
					if j == 1 then
						pc.remove_item(30331, 1)
						snow_dungeon.level_clear()
						d.notice("You have found the right key")
						d.notice("You will get to the third floor in 10 seconds")
						server_timer('snow_dungeon_level3_start',10,d.get_map_index())
						d.setf('level2_clear', 1)
					else
						d.notice("This is a wrong key")
						pc.remove_item(30331, 1)
					end
				end
			end
		end
		when snow_dungeon_level3_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',3)
				d.jump_all(5882,1800)
				d.regen_file ('data/dungeon/snow_dungeon/id_3f.txt')
				server_timer ('snow_dungeon_killed_A_1', 6, d.get_map_index())
				d.notice("You have to kill all Monsters")
			end 
		end
		when snow_dungeon_level4_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',4)
				d.jump_all(5293,2071)
				d.regen_file ('data/dungeon/snow_dungeon/id_4f.txt')
				server_timer ('snow_dungeon_killed_A_1', 6, d.get_map_index())
				d.notice("You have to kill all Monsters, may the Power be with you.")
			end 
		end
		when snow_dungeon_level5_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',5)
				d.jump_all(5540,2074)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_5f.txt')
				d.notice("Now smash all the dices, you have to find the right order!")
				d.notice("The utensils for splitting the cubes carry the monsters with them.")
				
				local vis = { 0,0,0,0,0}
				for i = 1, 5 do
					local ran = number(1,5)
					local st = 0
					for j = 1, 50 do
						st = st + 1
						if st > 5 then
							st = 1
						end
						if vis[st] == 0 then
							ran = ran - 1
							if ran == 0 then
								vis[st] = 1
								d.set_unique('stone5_'..st, d.spawn_mob(20398, snow_dungeon.stonepos_lv5(i)[1], snow_dungeon.stonepos_lv5(i)[2]))
								break
							end
						end
					end
				end
			end
		end
		when kill with snow_dungeon.is_snowdungeon(pc.get_map_index()) and d.getf('level') == 5 begin
			local i = number(1, 75)
			if i == 1 then
				game.drop_item (30332, 1)
			end
		end
		when 20398.take with snow_dungeon.is_snowdungeon(d.get_map_index()) and item.vnum == 30332 and d.getf('level') == 5 begin
			if npc.get_vid() == d.get_unique_vid('stone5_1') then
				npc.purge()
				pc.remove_item(30332, 1)
				say("Destroy the second cube")
				d.setf('stonekill',2)
				
				if d.count_monster() < 100 then
					d.regen_file ('data/dungeon/snow_dungeon/id_5f.txt')
				end
			elseif npc.get_vid() == d.get_unique_vid('stone5_2') then 
				if d.getf('stonekill') == 2 then
					npc.purge()
					pc.remove_item(30332, 1)
					say("Destroy the third cube")
					d.setf('stonekill',3)
					if d.count_monster() < 100 then
						d.regen_file ('data/dungeon/snow_dungeon/id_5f.txt')
					end
				else
					pc.remove_item(30332, 1)
					say("The cube is not broken")
					if is_test_server() then
						say("Test : 2")
					end
				end
			elseif npc.get_vid() == d.get_unique_vid('stone5_3') then
				if d.getf('stonekill') == 3 then
					npc.purge()
					pc.remove_item(30332, 1)
					say("Destroy the fourth cube")
					d.setf('stonekill',4)
					if d.count_monster() < 100 then
						d.regen_file ('data/dungeon/snow_dungeon/id_5f.txt')
					end
				else
					pc.remove_item(30332, 1)
					say("The cube is not broken")
					if is_test_server() then
						say("Test : 3")
					end
				end
			elseif npc.get_vid() == d.get_unique_vid('stone5_4') then
				if d.getf('stonekill') == 4 then
					npc.purge()
					pc.remove_item(30332, 1)
					say("Destroy the fifth cube")
					d.setf('stonekill',5)
					if d.count_monster() < 100 then
						d.regen_file ('data/dungeon/snow_dungeon/id_5f.txt')
					end
				else
					pc.remove_item(30332, 1)
					say("The cube is not broken")
					if is_test_server() then
						say("Test : 4")
					end
				end
			else 
				if d.getf('stonekill') == 5 then
					npc.purge()
					pc.remove_item(30332, 1)
					d.notice("You will be taken to the sixth floor in 10 seconds")
					snow_dungeon.level_clear()
					server_timer('snow_dungeon_level6_start',10,d.get_map_index())
				else
					pc.remove_item(30332, 1)
					say("The cube is not broken")
					if is_test_server() then
						say("Test : 5")
					end
				end
			end
		end
		when snow_dungeon_level6_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',6)
				d.jump_all(5866,2076)
				d.regen_file ('data/dungeon/snow_dungeon/id_6f.txt')
				server_timer ('snow_dungeon_killed_A_1', 6, d.get_map_index())
				d.notice("Kill all Monsters!")
			end 
		end
		when 8058.kill with snow_dungeon.is_snowdungeon(d.get_map_index()) and d.getf('level') == 6 begin
			d.notice("You will be teleported to the seventh floor in 10 seconds")
			snow_dungeon.level_clear()
			server_timer('snow_dungeon_level7_start',10,d.get_map_index())
		end
		when snow_dungeon_level7_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',7)
				d.jump_all(5423,2244)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_7f.txt')
				d.notice("Find the right Boss!")

				local vis = { 0,0,0,0}
				for i=1,3 do
					vis[i] = 0
				end
				for i = 1, 4 do
					local ran = number(1,4)
					local st = 0
					for j = 1, 50 do
						st = st + 1
						if st > 4 then
							st = 1
						end
						if vis[st] == 0 then
							ran = ran - 1
							if ran == 0 then
								vis[st] = 1
								d.set_unique('boss7_'..st, d.spawn_mob(6151, snow_dungeon.bosspos_lv7(i)[1], snow_dungeon.bosspos_lv7(i)[2]))
								break
							end
						end
					end
				end
				server_timer('snow_dungeon_killed_B_1', 6, d.get_map_index())
			end 
		end
		when snow_dungeon_killed_B_1.server_timer begin
			if d.select(get_server_timer_arg()) then
				for i =1, 3 do
					if not d.is_unique_dead('boss7_'..i) then
						if d.unique_get_hp_perc('boss7_'..i) < 50 then
							d.purge_unique('boss7_'..i)
							d.notice("The enemy has dissolved into air")
						end
					end
				end
				if d.is_unique_dead('boss7_4') then
					snow_dungeon.level_clear()
					d.notice("You will get to the eighth floor in 10 seconds")
					server_timer('snow_dungeon_level8_start',10,d.get_map_index())
				else				
					server_timer ('snow_dungeon_killed_B_2', 3, get_server_timer_arg())
				end
			end
		end
		when snow_dungeon_killed_B_2.server_timer begin
			if d.select(get_server_timer_arg()) then
				for i =1, 3 do
					if not d.is_unique_dead('boss7_'..i) then
						if d.unique_get_hp_perc('boss7_'..i) < 50 then
							d.purge_unique('boss7_'..i)
							d.notice("The enemy has dissolved into air")
						end
					end
				end
				if d.is_unique_dead('boss7_4') then
					snow_dungeon.level_clear()
					d.notice("You will get to the eighth floor in 10 seconds")
					server_timer('snow_dungeon_level8_start',10,d.get_map_index())
				else				
					server_timer ('snow_dungeon_killed_B_1', 3, get_server_timer_arg())
				end
			end
		end
		when snow_dungeon_level8_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',8)
				d.jump_all(5689,2237)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_8f.txt')
				d.notice("Now find the right key")
			end
		end
		when kill with snow_dungeon.is_snowdungeon(pc.get_map_index()) and d.getf('level') == 8 begin
			local i = number(1, 75)
			if i == 1 then
				game.drop_item (30333, 1)
			end
		end
		when 30333.use with snow_dungeon.is_snowdungeon(d.get_map_index()) and d.getf('level') == 8 begin 
			if not is_test_server() then
				-- if pc.get_job() == 1 or pc.get_job() == 3 then
					if d.getf('level8_clear') == 0 then
						if number(1,5) == 1 then
							pc.remove_item(30333, 1)
							snow_dungeon.level_clear()
							d.notice("In 10 secons you will be taken to the last floor in front of Nemeres Chamber!")
							server_timer('snow_dungeon_level9_start',10,d.get_map_index())
							d.setf('level8_clear', 1) 
							if party.is_party() then
								party.setf('snow_dungeon_room_enter', 9)
							end
						else
							syschat("This is a wrong key")
							d.notice("This is a wrong key")
							pc.remove_item(30333, 1)
						end
					end
				-- else
					-- syschat("You are neither a shaman nor a ninja")
				-- end
			else
				if d.getf('level8_clear') == 0 then
					if number(1,5) == 1 then
						pc.remove_item(30333, 1)
						snow_dungeon.level_clear()
						d.notice("You will be taken to the last floor in 10 seconds in front of Nemeres Chamber")
						server_timer('snow_dungeon_level9_start',10,d.get_map_index())
						d.setf('level8_clear', 1) 
						if party.is_party() then
							party.setf('snow_dungeon_room_enter', 9)
						end
					else
						syschat("This is a wrong key")
						d.notice("This is a wrong key")
						pc.remove_item(30333, 1)
					end
				end
			end
		end
		when snow_dungeon_level9_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',9)
				d.jump_all(5969,2229)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_9f.txt')
				d.spawn_mob(20399,849,660)
				d.notice("Destroy the Column of the Northern Dragon")
			end
		end
		when 20399.kill with snow_dungeon.is_snowdungeon(pc.get_map_index()) and d.getf('level') == 9 begin
			snow_dungeon.level_clear()
			d.spawn_mob_ac_dir(20397,849, 641, 1)
		end
		when 20397.chat."Go to Nemeres Chamber!" with d.getf('level') == 9 and pc.get_map_index() >= 352 * 10000 and pc.get_map_index() < (352 + 1) *10000 begin
			if !party.is_leader() then
				say("Only the group leader can do this")
			else
				if pc.get_level() < 104 then
					say("You are below level 104 you can't get any further")
					say("In 10 seconds you will be put in front of the door")
					d.notice("You are below level 104 you can't get any further")
					d.notice("In 10 seconds you will be put in front of the door")
					
					server_timer('snow_dungeon_end_timer',10,d.get_map_index())	
				else
					if pc.get_level() > 103 then
						say("Your aura is strong enough to open the chamber")
						local warp = select("Open Chamber!","Wait")
						if warp == 1 then
							d.setf('level',10)
							d.jump_all(6047,1924)
							d.set_regen_file ('data/dungeon/snow_dungeon/id_boss.txt')
							d.spawn_mob(6191,927,333)
							d.notice("You now face Nemere personify.")
						end
					else 
						say("You have not completed the quest for the Chamber of Nemeres")
						say("In 10 seconds you will be put in front of the Door")
						d.notice("You have not completed the quest for the Chamber of Nemeres")
						d.notice("In 10 seconds you will be put in front of the Door")
						
						server_timer('snow_dungeon_end_timer',10,d.get_map_index())	
					end
				end
			end
		end
		when snow_dungeon_BOSS_start.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf('level',10)
				d.jump_all(6047,1924)
				d.set_regen_file ('data/dungeon/snow_dungeon/id_boss.txt')
				d.spawn_mob(6191,927,333)
				d.notice("You now face Nemere personally.")
				
			end
		end
		when 6191.kill with snow_dungeon.is_snowdungeon(d.get_map_index()) and d.getf('level') ==10 begin
			d.notice("Nemere has succumbed to your group")
			d.notice("In a minute you will be taken out")
			--d.spawn_mob(33002,928,316)
			notice_all("".. pc.get_name() .." has conquered Nemere with his group!")
			server_timer('snow_dungeon_end_timer', 60,d.get_map_index())
			pc.setqf("remove_items", 1)
			snow_dungeon.level_clear()
			if party.is_party() then
				party.setf("snow_dungeon_boss_kill_count", 1)
			end
		end
		when snow_dungeon_45m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Nemeres Watchtower: Remaining time 45 Minutes.")
				d.notice("As soon as the time has passed you will be transported out.")
				server_timer('snow_dungeon_30m_left_timer', 15*60, get_server_timer_arg())
			end
		end
		when snow_dungeon_30m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Nemeres Watchtower: Remaining time 30 Minutes.")
				d.notice("As soon as the time has passed you will be transported out.")
				server_timer('snow_dungeon_15m_left_timer', 15*60, get_server_timer_arg())
			end
		end
		when snow_dungeon_15m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Nemeres Watchtower: Remaining time 15 Minutes.")
				d.notice("As soon as the time has passed you will be transported out.")
				server_timer('snow_dungeon_5m_left_timer', 10*60, get_server_timer_arg())
			end
		end
		when snow_dungeon_5m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Nemeres Watchtower: Remaining time 5 Minutes.")
				d.notice("As soon as the time has passed you will be transported out.")
				server_timer('snow_dungeon_1m_left_timer', 4*60, get_server_timer_arg())
			end
		end
		when snow_dungeon_1m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.notice("Nemeres Watchtower: Remaining time 1 Minute.")
				d.notice("As soon as the time has passed you will be transported out.")
				server_timer ('snow_dungeon_0m_left_timer', 60, get_server_timer_arg())
			end
		end
		when snow_dungeon_0m_left_timer.server_timer begin
			if d.select(get_server_timer_arg()) then		
				d.notice("The time is over!")
				d.notice("In 10 seconds you will be put in front of the Door")
				server_timer('snow_dungeon_end_timer',10,d.get_map_index())	
			end
		end
		when snow_dungeon_end_timer.server_timer begin
			if d.select(get_server_timer_arg()) then
				d.setf("party_leader_pid", 0)
				snow_dungeon.clear_timer(d.get_map_index())		
				d.set_warp_location(61, 4322 , 1655)
				d.exit_all()
			end
		end
		when snow_dungeon_leader_out_timer.server_timer begin
			if d.select(get_server_timer_arg()) then		
				say_in_map(get_server_timer_arg()) "Without your group leader, you can't advance any further [ENTER]In 1 minute you will be put in front of the Door"
				server_timer("snow_dungeon_end_timer",60,d.get_map_index())	
			end
		end
        --when 33002.chat.'Belohnung abholen' with snow_dungeon.is_snowdungeon(d.get_map_index()) begin
        --    if pc.getqf('snow_reward') <= 0 then
        --        say_title('Truhe des Nordens')
        --        say()
        --        say('Deine Gruppe hat den Nemeres bezwungen.')
        --        say('Als Dank bekommst du eine Truhe des Nordens,')
        --        say('ihr Schloß scheint vereist und verostet!')
        --        say()
        --        timer('snow_dungeon_reward', 65)
        --        pc.setqf('snow_reward', 1)
        --        pc.give_item2(38057)
        --    else
        --        say_title('Truhe des Nordens')
        --        say()
        --        say('Du hast bereits eine Truhe des Nordens erhalten!')
        --        say('Eine zweite bekommst du nicht!')
        --        say()
        --    end
        --end
	end
end