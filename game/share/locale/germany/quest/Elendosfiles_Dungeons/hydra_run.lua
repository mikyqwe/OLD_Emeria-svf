define ENTRY_NPC 37026
define REWARD_NPC 3965
define ENTRY_MAP_INDEX 320

quest hydra_dungeon begin
	state start begin
		function get_settings()
			return {
				["map_index"]	 = 319,
				["entry_x"] = 1670,
				["entry_y"] = 5254,
				
				["cooldown"] = 60*60,
				
				["access_item"] = 50342,
				["access_item_amount"] = 1,
				
				["regenfile_base"] = "data/dungeon/hydra/",
				
				["hydras"] = {3960, 3961, 3962},
				["hydra_egg"] = 20432,
				["big_hydra"] = 3964,
				
				["reward_npc"] = {
					["id"] = REWARD_NPC,
					["x"] = 385,
					["y"] = 418
				},
				["reward_item"] = 99100
			}
		end
		
		function is_in_dungeon()
			local settings = hydra_dungeon.get_settings()
			local local_map_index = pc.get_map_index()
			local dungeon_map_index = settings["map_index"]
			return pc.in_dungeon() and local_map_index >= dungeon_map_index * 10000 and local_map_index < (dungeon_map_index + 1) * 10000
		end
		
		function check_access()
			local pids = {party.get_member_pids()}
			local settings = hydra_dungeon.get_settings()
			local user_fail = {}
			for i=1, table.getn(pids), 1 do
				q.begin_other_pc_block(pids[i])
				if pc.count_item(settings.access_item) < settings.access_item_amount or pc.getf("hydra_dungeon", "hydra_dungeon_next_entry") > get_global_time() then
					table.insert(user_fail, table.getn(user_fail) + 1, pc.get_name())
				end
				q.end_other_pc_block(pids[i])
			end
			
			if table.getn(user_fail) > 0 then
				say("These people in your party do not have enough")
				say("acess items.")
				for x = 1, table.getn(user_fail), 1 do
					say(user_fail[x])
				end	
				say("")
				say("You need ".. settings.access_item_amount .." of:")
				say_item_vnum(settings.access_item)
				wait()
				return false
			else
				pids = {party.get_member_pids()}
				for i=1, table.getn(pids), 1 do 
					q.begin_other_pc_block(pids[i])
					pc.remove_item(settings.access_item, settings.access_item_amount)
					pc.setf("hydra_dungeon", "hydra_dungeon_next_entry", get_global_time() + settings.cooldown)
					pc.setf("hydra_dungeon", "hydra_dungeon_warp", 1)
					q.end_other_pc_block(pids[i])
				end
				say("All party members can enter the ship!")				
				wait()
				return true
			end
		end
		
		when login begin
			local settings = hydra_dungeon.get_settings()
			if pc.get_map_index() == settings["map_index"] then
				warp_to_village()
			elseif hydra_dungeon.is_in_dungeon() then
				if pc.getqf("hydra_dungeon_warp") == 1 then
					pc.setqf("hydra_dungeon_warp", 0)
				else
					warp_to_village()
				end
			end
		end
		
		when ENTRY_NPC.chat."Reset timer" with pc.get_map_index() == ENTRY_MAP_INDEX and pc.is_gm() begin
			say("Timer reset")
			pc.setqf("hydra_dungeon_next_entry", 0)
		end
		
		when ENTRY_NPC.chat."Set sail..." with pc.get_map_index() == ENTRY_MAP_INDEX begin
			local settings = hydra_dungeon.get_settings()
			
			say_title(""..mob_name(ENTRY_NPC).."")
			if pc.getqf("hydra_dungeon_next_entry") > get_global_time() then
				say("You can only enter this ship once an")
				say("hour.")
				say("Wait another ".. math.ceil((pc.getqf("hydra_dungeon_next_entry") - get_global_time()) / 60) .." minutes.")
				return
			elseif not party.is_party() then
				say("You need to be in a party to set sail.")
				return
			elseif not party.is_leader() then
				say("Only the party leader can book this trip.")
				return
			else
				say("Do you and you party want take the ship?")
				if select("Yes", "No") == 2 then
					return
				end
				say_title(gameforge.ghost_story._010_sayTitle)
				if not hydra_dungeon.check_access() then
					return
				end
				
				pc.setqf("hydra_dungeon_next_entry", get_global_time() + settings.cooldown)
				d.new_jump_party(settings.map_index, settings.entry_x, settings.entry_y)
				d.setf("hydra_dungeon_level", 0)
				server_timer("hydra_dungeon_next_wave", 10, d.get_map_index())
			end
		end
		
		when REWARD_NPC.chat."Your reward for saving this ship" with hydra_dungeon.is_in_dungeon() begin
			local settings = hydra_dungeon.get_settings()
			
			say_title(mob_name(REWARD_NPC))
			say("Thanks you very much for slaying the")
			say("hydra.")
			say("")
			say("Please take this as a sign of appreciation.")
			say_item_vnum(settings["reward_item"])
			pc.give_item2(settings["reward_item"], 1)
			wait()
			warp_to_village()
		end
		
		when kill with hydra_dungeon.is_in_dungeon() and not npc.is_pc() begin
			local settings = hydra_dungeon.get_settings()
			
			if d.getf("hydra_dungeon_level") == 1 then
				d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
				if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
					d.notice("You defeated all enemies!")
					server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
				else
					d.notice("There are ".. d.getf("hydra_dungeon_mobs_to_kill") .." mobs left!")
				end
			elseif d.getf("hydra_dungeon_level") == 2 then
				d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
				if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
					d.notice("You defeated all enemies!")
					server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
				else
					d.notice("There are ".. d.getf("hydra_dungeon_mobs_to_kill") .." mobs left!")
				end
			elseif d.getf("hydra_dungeon_level") == 3 then
				for index, value in ipairs(settings["hydras"]) do
					if value == npc.get_race() then
						d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
						if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
							d.notice("You defeated all hydras!")
							server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
						else
							d.notice("Good job! Slay the remaining ".. d.getf("hydra_dungeon_mobs_to_kill") .." hydras.")
						end
					end
				end
			elseif d.getf("hydra_dungeon_level") == 4 then
				if settings["hydra_egg"] == npc.get_race() then
					d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
					if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
						d.notice("You eliminated all eggs!")
						server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
					else
						d.notice("Good job! Slay the remaining ".. d.getf("hydra_dungeon_mobs_to_kill") .." eggs.")
					end
				end
			elseif d.getf("hydra_dungeon_level") == 5 then
				d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
				if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
					d.notice("You defeated all enemies!")
					server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
				else
					d.notice("There are ".. d.getf("hydra_dungeon_mobs_to_kill") .." mobs left!")
				end
			elseif d.getf("hydra_dungeon_level") == 6 then
				d.setf("hydra_dungeon_mobs_to_kill", d.getf("hydra_dungeon_mobs_to_kill") - 1)
				if d.getf("hydra_dungeon_mobs_to_kill") <= 0 then
					d.notice("You defeated all enemies!")
					server_timer("hydra_dungeon_next_wave", 12, d.get_map_index())
				else
					d.notice("There are ".. d.getf("hydra_dungeon_mobs_to_kill") .." mobs left!")
				end
			elseif d.getf("hydra_dungeon_level") == 7 then
				if settings["big_hydra"] == npc.get_race() then
					d.notice("You slayed the last hydra!")
					d.notice("Talk with abc to collect you reward for saving this ship.")
					notice_all("The group of ".. pc.get_name() .." saved a ship from the big hydra!")
					local reward_npc = settings["reward_npc"]
					d.spawn_mob(reward_npc["id"], reward_npc["x"], reward_npc["y"])
				end
			end
		end

		when hydra_dungeon_next_wave.server_timer begin
			if d.select(get_server_timer_arg()) then			
				local settings = hydra_dungeon.get_settings()
				
				d.setf("hydra_dungeon_level", d.getf("hydra_dungeon_level") +  1)
				if d.getf("hydra_dungeon_level") == 1 then
					d.regen_file(settings["regenfile_base"] .. "monsterwelle1.txt")
					d.setf("hydra_dungeon_mobs_to_kill", d.count_monster())
					d.notice("Kill all mobs on the ship!")
				elseif d.getf("hydra_dungeon_level") == 2 then
					d.notice("Kill all mobs on the ship!")			
					d.regen_file(settings["regenfile_base"] .. "monsterwelle2.txt")
					d.setf("hydra_dungeon_mobs_to_kill", d.count_monster())
				elseif d.getf("hydra_dungeon_level") == 3 then
					d.notice("I hear hydras breaking through the ship!")
					d.regen_file(settings["regenfile_base"] .. "dreihydra.txt")
					--d.spawn_mob(3960, 384, 428)
					--d.spawn_mob(3961, 406, 399)
					--d.spawn_mob(3962, 362, 399)
					d.setf("hydra_dungeon_mobs_to_kill", 3)
				elseif d.getf("hydra_dungeon_level") == 4 then	
					d.notice("They spawned their eggs, get rid of them.")			
					d.regen_file(settings["regenfile_base"] .. "metinhydra.txt")
					d.setf("hydra_dungeon_mobs_to_kill", 4)
				elseif d.getf("hydra_dungeon_level") == 5 then	
					d.notice("Kill all mobs on the ship!")			
					d.regen_file(settings["regenfile_base"] .. "monsterwelle2.txt")
					d.setf("hydra_dungeon_mobs_to_kill", d.count_monster())
				elseif d.getf("hydra_dungeon_level") == 6 then	
					d.notice("Kill all mobs on the ship!")			
					d.regen_file(settings["regenfile_base"] .. "monsterwelle3.txt")
					d.setf("hydra_dungeon_mobs_to_kill", d.count_monster())
				elseif d.getf("hydra_dungeon_level") == 7 then	
					d.notice("The big hydra entered the ship! Kill it!")			
					d.regen_file(settings["regenfile_base"] .. "bosshydra.txt")
					--d.spawn_mob(3964, 385, 373)
				end
			end
		end
	end
end