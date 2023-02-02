SharkDungeonLIB = {};

SharkDungeonLIB.Settings = function()
	if (SharkDungeonLIB.data == nil) then
		SharkDungeonLIB.data = {
			-- [[ Requirements, Items, Map info ]]
			["minimumLevel"] = 95, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party)
			["inside_index"] = 76, -- Dungeon index
			
			["outside_index"] = 134, -- Index of maps, where are players teleported from the dungeon (Cities)
			["outside_pos"] = {{8592, 3591}, {8592, 3591}, {8592, 3591}}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["shark_ticket"] = 30807,
			
			["insidePos_1f"] = {10573, 22812}, -- Dungeon first floor coordinates
			
			["clam_stone_position"] = {{328,278},{315,283},{305,293},{313,305},{327,309},{340,306},{349,294},{340,282}},	
			
						
			["monsters_killed_in_second_room"] = 500, -- Number of monsters needed to kill in second room
			
			["dungeon_cooldown"] = 1800, -- Time after player can enter the dungeon again (1 hour - 3600 sec)
			
			["dungeon_timer"] = 2400, -- Time whithin players have to finish the whole dungeon (40 minutes - 2400 sec)
			 
			["time_until_destroy_8_stones"] = 900, -- If the stones in second wave (8477) are not destroyed in 15 minutes (900 seconds), players will be teleported out
			
			["time_until_kill_first_boss"] = 240, -- If the first boss (4305) is not killed in 4 minutes (240 seconds), aggresive monster will be spawned
			
			["time_final_exit_after_boss_kill"] = 120,  -- After kill the final boss (4307), players are teleport to the city
						
			};
	end
	
	return SharkDungeonLIB.data;
end


SharkDungeonLIB.clearTimers = function()
	clear_server_timer("SharkDungeon_full_timer", get_server_timer_arg())
	clear_server_timer("SharkDungeon_6f_pillar_d", get_server_timer_arg())
	clear_server_timer("SharkDungeon_6th_PillarSpawn", get_server_timer_arg())
end

SharkDungeonLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = SharkDungeonLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

SharkDungeonLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.clear_regen();
		d.kill_all();
	end return false;
end

SharkDungeonLIB.checkEnter = function()
	local settings = SharkDungeonLIB.Settings();
	say_size(350,350)
	addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(225, 200, "shark_dungeon_npc1.tga")
	say("[ENTER][ENTER]")
	say_title(mob_name(9338))
	
	if party.is_party() then
		local pids = party_get_member_pids();
		local minLev, minLevCheck, itemNeed, itemNeedCheck = {}, true, {}, true;
		
		if not party.is_map_member_flag_lt("exit_pyramid_dungeon_time", get_global_time() - settings["dungeon_cooldown"] ) then
			say_reward("Some members still have to wait[ENTER]until they can join the dungeon again.")
			return false;
		end
		
		if (not party.is_leader()) then
			say("If you want to enter Ancient pyramid,[ENTER]let me talk with the group leader first.")
			return false;
		end
		
		if (party.get_near_count() < settings["minimumPartyMembers"]) then
			say(string.format("If you want to enter the Ancient pyramid,[ENTER]there must be atleast %d players with you...", settings["minimumPartyMembers"]))
			return false;
		end
		
		for index, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.get_level() < settings["minimumLevel"]) then
					table.insert(minLev, pc.get_name());
					minLevCheck = false;
				end
				
				if (pc.count_item(settings["shark_ticket"]) < 1) then
					table.insert(itemNeed, string.format("%s", pc.get_name()));
					itemNeedCheck = false;
				end
			q.end_other_pc_block();
		end
		
		if (not minLevCheck) then
			say(string.format("If you want to enter the Ancient pyramid,[ENTER]every each group member must be level %d.[ENTER][ENTER]The next following players don't have the necessary level:", settings["minimumLevel"]))
			for i, str in next, minLev, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not itemNeedCheck) then
			say("If you wish to enter the Ancient pyramid,[ENTER]every each group memeber must have:")
			say_item(""..item_name(settings["shark_ticket"]).."", settings["shark_ticket"], "")
			say("The next following players don't have the required item:")
			for i, str in next, itemNeed, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		return true;
	else  --- if its solo
	
		if ((get_global_time() - pc.getf("pyramid_dungeon","exit_pyramid_dungeon_time")) < settings["dungeon_cooldown"]) then
		
			local remaining_wait_time = (pc.getf("pyramid_dungeon","exit_pyramid_dungeon_time") - get_global_time() + settings["dungeon_cooldown"])
			say("You have to wait until you can enter the dungeon again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(settings["shark_ticket"]) < 1) then
			say("If you want to enter the Ancient pyramid[ENTER]you must have:")
			say_item(""..item_name(settings["shark_ticket"]).."", settings["shark_ticket"], "")
			return false;
		end
	end
	
	return true;
end

SharkDungeonLIB.CreateDungeon = function()
	local settings = SharkDungeonLIB.Settings();
	
	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["shark_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["insidePos_1f"][1], settings["insidePos_1f"][2]);
	else
		pc.remove_item(settings["shark_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["insidePos_1f"][1]*100, settings["insidePos_1f"][2]*100); 
	end
end

SharkDungeonLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = SharkDungeonLIB.Settings();
	
	d.set_warp_location(settings["outside_index"], settings["outside_pos"][empire][1], settings["outside_pos"][empire][2]);
	--[[
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
	]]
end
