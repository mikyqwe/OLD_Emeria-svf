AndunDungeon01LIB = {};

AndunDungeon01LIB.Settings = function()
	if (AndunDungeon01LIB.data == nil) then
		AndunDungeon01LIB.data = {
			----------
			--- Requirements, map info, coordinates,  etc...
			----------
			["dungeon_cooldown"] = 1800,  --- Time within players can't enter the dungeon after they finish it (or were teleported out of dungeon)
			
			["minimumLevel"] = 180, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party, members need to be around)
			
			["onlyGroupDungeon"] = false, -- For solo dungeon, put "true" if you want only group dungeon
			
			["inside_index"] = 157, -- Dungeon index
			["1Floor_Pos"] = {35323, 23241}, -- Dungeon coordinates to 1. floor
			["2Floor_Pos"] = {35247, 22609}, -- Dungeon coordinates to 2. floor
			
			["outside_index"] = 156, -- Index of maps, where are players teleported from the dungeon (Andun catacombs)
			["outside_pos"] = {33336, 23771}, -- Coords of the maps where are players teleported from the dungeon (Andun catacombs)	
			
			--["outside_index"] = {1, 21, 41}, -- Index of maps, where are players teleported from the dungeon (Cities)
			--["outside_pos"] = {4693, 9642, 557, 1579, 9694, 2786}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["Item_ticket"] = 30897,
						
			----------
			--- Dungeon settings (IDs, etc..)
			----------			
			["MINIMUM_STONE_COUNT"] = 12, -- Minimum count of stones that players need to destroy in first floor 			
			["SPAWN_CHANCE_SEAL"] = 150, ---- 1/150 to drop item (30898) at first floor			
			["KILL_COUNT_1_WAVE"] = 168, ---- Count of monster in first wave at second floor
			["KILL_COUNT_2_WAVE"] = 187, ---- Count of monster in second wave at second floor
			
			["final_boss_defense_basic"] = 300,
			["final_boss_defense_ultra"] = 99999,
			
			---- IDs
			["2Floor_ticket"] = 30899,
			
			----------			
			---Positions
			----------
			["sealPosMin"] = {{282, 776, 7}, {282, 861, 7}, {218, 861, 3}, {224, 774, 3}},
			["sealPosMax"] = {{281, 767, 7}, {281, 805, 7}, {281, 834, 7}, {281, 876, 7}, {221, 867, 3}, {221, 834, 3}, {221, 805, 3}, {221, 767, 3}},

			----------
			--- Dungeon Timers 
			----------			
			["DungeonTimer"] = 1800,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["time_to_proceed"] = 10,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["time_to_destroy_stones"] = 600,  --- Time within players have to destroy minimum count of stones			
			["time_to_destroy_2nd_stone"] = 240, --- Time within players have to destroy stone in the start of second floor						
			["time_to_damage_final_boss"] = 30, --- Time within players can damage final boss until the protection stone is spawned (8721)						
			["time_to_get_high_chest"] = 15, --- Players must finish the dungeon in 15 minutes					
			["time_to_get_middle_chest"] = 10, --- Players must finish the dungeon in 20 minutes					
			["time_to_get_low_chest"] = 5, --- Players must finish the dungeon in 25 minutes					
			["timer_to_exit_dungeon"] = 120,  --- Time within players have to destroy second stone (8703), otherwise the finall boss is gonna have much higher defense
			
			};
	end
	
	return AndunDungeon01LIB.data;
end


AndunDungeon01LIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = AndunDungeon01LIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

AndunDungeon01LIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.kill_all();
		d.clear_regen();
		d.kill_all();
	end return false;
end

AndunDungeon01LIB.checkEnter = function()
	local settings = AndunDungeon01LIB.Settings();
	local ItemTicket = settings["Item_ticket"]	
	
	addimage(25, 10, "andun_dungeon01_bg1.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");
	say("[ENTER][ENTER]")
	say_title(mob_name(9435))
	
	if party.is_party() then
		local pids = party_get_member_pids();
		local minLev, minLevCheck, itemNeed, itemNeedCheck, Timetable, TimeNeedCheck = {}, true, {}, true, {}, true;
		
		if (not party.is_leader()) then
			say("If you want to enter the dungeon,[ENTER]let me talk with the group leader first.")
			return false;
		end
		
		if (party.get_near_count() < settings["minimumPartyMembers"]) then
			say(string.format("If you want to enter the dungeon,[ENTER]there must be atleast %d players with you...", settings["minimumPartyMembers"]))
			return false;
		end
		
		if (pc.count_item(ItemTicket) < 1) then
			say("If you want to enter the dungeon, you need")
			say_item(""..item_name(ItemTicket).."", ItemTicket, "")
			say("Only you as a leader need it. Other members[ENTER]of your group dont need it")
		end
		
		for index, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.get_level() < settings["minimumLevel"]) then
					table.insert(minLev, pc.get_name());
					minLevCheck = false;
				end
								
				local andundung1_time_flag = game.get_event_flag("andundun1_cooldown_"..pid.."");
				local current_time = get_time();
				
				if (andundung1_time_flag > current_time) then
					table.insert(Timetable, string.format("%s - %s", pc.get_name(), get_time_format(andundung1_time_flag - current_time)));
					TimeNeedCheck = false;
				end
			q.end_other_pc_block();
		end
		
		if (not minLevCheck) then
			say(string.format("If you want to enter the dungeon,[ENTER]every each group member must be level %d.[ENTER][ENTER]The next following players don't have the necessary level:", settings["minimumLevel"]))
			for i, str in next, minLev, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not itemNeedCheck) then
			say("If you wish to enter the dungeon,[ENTER]every each group memeber must have:")
			say_item(""..item_name(settings["Item_ticket"]).."", settings["Item_ticket"], "")
			say("The next following players don't have the required item:")
			for i, str in next, itemNeed, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		if (not TimeNeedCheck) then
			say(string.format("Some members of your group still has to wait:", get_time_format(settings["dungeon_cooldown"])))
			for i, str in next, Timetable, nil do
				say(string.format("- %s", str))
			end
			return false;
		end
		
		return true;
	end
	
	if (not settings["onlyGroupDungeon"]) then -- If its solo
	
		local ownPid = pc.get_player_id();
		local andundung1_time_flag = game.get_event_flag("andundun1_cooldown_"..ownPid.."");
		local current_time = get_time();
		
		if (andundung1_time_flag > current_time) then
			say(string.format("If you want to enter, you need to wait %s.", get_time_format(andundung1_time_flag - current_time)))
			return false;
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(ItemTicket) < 1) then
			say("If you want to enter the dungeon[ENTER]you must have:")
			say_item(""..item_name(ItemTicket).."", ItemTicket, "")
			return false;
		end
	end
	
	return true;
end

AndunDungeon01LIB.CreateDungeon = function()
	local settings = AndunDungeon01LIB.Settings();
	
	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["Item_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["1Floor_Pos"][1], settings["1Floor_Pos"][2]);
	else
		pc.remove_item(settings["Item_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["1Floor_Pos"][1]*100, settings["1Floor_Pos"][2]*100); 
	end
end


AndunDungeon01LIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = AndunDungeon01LIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
end

AndunDungeon01LIB.setReward = function()
	local settings = AndunDungeon01LIB.Settings();
	
	if party.is_party() then
		for _, pid in pairs({party.get_member_pids()}) do
			q.begin_other_pc_block(pid);
			
			d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 1);	
			
			q.end_other_pc_block();
		end
	else
		d.setf(string.format("player_%d_reward_state", pc.get_player_id()), 1);	
	end
end

AndunDungeon01LIB.setWaitingTime = function()
	local settings = AndunDungeon01LIB.Settings(); 
	local ownPid = pc.get_player_id();
	
	if party.is_party() then
		if (type(pids) != "table") then
			return game.set_event_flag("andundun1_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
		end
		
		for index, pid in next, pids, nil do
			return game.set_event_flag("andundun1_cooldown_"..pid.."", settings["dungeon_cooldown"] + get_time());
		end
	end
	return game.set_event_flag("andundun1_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
end

AndunDungeon01LIB.spawnMinSeal = function()
	local settings = AndunDungeon01LIB.Settings(); 
	local position = settings["sealPosMin"]; 
	local n = number(1,4); 			
				
	table_shuffle(position);

	for i = 1, 4 do
		if (i != n) then
			d.set_unique("fake"..i, d.spawn_mob_dir(9436, position[i][1], position[i][2], position[i][3]))
		end
	end

	d.set_unique ("real", d.spawn_mob_dir(9436, position[n][1], position[n][2], position[n][3]))
end

AndunDungeon01LIB.spawnMaxSeal = function()
	local settings = AndunDungeon01LIB.Settings(); 
	local position = settings["sealPosMax"]; 
	local n = number(1,8); 			
				
	table_shuffle(position);

	for i = 1, 8 do
		if (i != n) then
			d.set_unique("fake"..i, d.spawn_mob_dir(9436, position[i][1], position[i][2], position[i][3]))
		end
	end

	d.set_unique ("real", d.spawn_mob_dir(9436, position[n][1], position[n][2], position[n][3]))
end

AndunDungeon01LIB.jumpToNextFloor = function()
	local settings = AndunDungeon01LIB.Settings();
	local Item = settings["2Floor_ticket"]
	local RemainingTime = (d.getf("AndunDungeon01_DungeonTimer") - get_global_time())
	local minutes = math.floor(RemainingTime / 60)
	local TimeToDestroyStone = settings["time_to_destroy_2nd_stone"]
	local minutes_destroy = math.floor(TimeToDestroyStone / 60)
	
	d.set_item_group("required_item", 1, Item, 1);
	d.exit_all_by_item_group ("required_item"); d.delete_item_in_item_group_from_all ("required_item");
	
	d.setf("AndunDungeon01_stage", 2);
	d.setf("AndunDungeon01_SeconStone", 1);
	
	d.jump_all(settings["2Floor_Pos"][1], settings["2Floor_Pos"][2]);
	
	d.notice("------------------------------------")
	d.notice("Suffering souls dungeon: Remaining time - " ..minutes.. " minutes")
	d.notice("------------------------------------")
	d.notice(string.format("Suffering souls dungeon: Destroy %s in %s minutes!", mob_name(8720), minutes_destroy));
	d.notice("Suffering souls dungeon: Otherwise the dungeon is over!!!")
	
	d.spawn_mob(8720, 180, 159);
	
	server_timer("AndunDungeon01_Second_Stone_timer", TimeToDestroyStone, d.get_map_index())
end

AndunDungeon01LIB.FinalBossSpawn = function()
	local settings = AndunDungeon01LIB.Settings();
	local TimeToDamage = settings["time_to_damage_final_boss"]
	
	d.setf("AndunDungeon01_FinalBoss", 1);
	
	d.set_unique("Final_boss", d.spawn_mob_dir(4517, 191, 197, 5));
	d.unique_set_def_grade("Final_boss", settings["final_boss_defense_basic"])
	
	d.notice(string.format("Suffering souls dungeon: You have %s seconds to damage the %s as much as possible!", TimeToDamage, mob_name(4517)));
	d.notice("Suffering souls dungeon: Hurry up!");
	
	server_timer("AndunDungeon01_ProtectionStoneSpawn", TimeToDamage, d.get_map_index())
end

AndunDungeon01LIB.SpawnRewardChest = function()
	local settings = AndunDungeon01LIB.Settings();
	local RemainingTime = (d.getf("AndunDungeon01_DungeonTimer") - get_global_time())
	local minutes = math.floor(RemainingTime / 60)
	
	if minutes >= settings["time_to_get_high_chest"] then
		d.spawn_mob_dir(9439, 193, 236, 5)
		syschat("reamin" ..minutes.. "minutes");
	elseif minutes >= settings["time_to_get_middle_chest"] then
		d.spawn_mob_dir(9438, 193, 236, 5)
		syschat("reamin" ..minutes.. "minutes");
	elseif minutes >= settings["time_to_get_low_chest"] then
		d.spawn_mob_dir(9437, 193, 236, 5)
		syschat("reamin" ..minutes.. "minutes");
	end
end
