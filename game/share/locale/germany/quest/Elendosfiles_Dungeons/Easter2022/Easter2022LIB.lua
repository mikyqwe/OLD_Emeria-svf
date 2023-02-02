Easter2022LIB = {};

Easter2022LIB.Settings = function()
	if (Easter2022LIB.data == nil) then
		Easter2022LIB.data = {
			----------
			--- Requirements, map info, coordinates,  etc...
			----------
			["dungeon_cooldown"] = 1800,  --- Time within players can't enter the dungeon after they finish it (or were teleported out of dungeon)
			
			["minimumLevel"] = 150, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party, members need to be around)
			
			["onlyGroupDungeon"] = false, -- For solo dungeon, put "true" if you want only group dungeon
			
			["inside_index"] = 158, -- Dungeon index
			["Dungeon_Pos"] = {36083, 22703}, -- Coordinates for warp to dungeon
			
			["outside_index"] = {1, 21, 41}, -- Index of maps, where are players teleported from the dungeon (Cities)
			["outside_pos"] = {4693, 9642, 557, 1579, 9694, 2786}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["Item_ticket"] = 30913,
						
			----------
			--- Dungeon settings (IDs, etc..)
			----------			
			["pillar"] = 9443,
			["first_boss"] = 4524,
			["main_boss"] = 4525,
			
			["KILL_COUNT_1_WAVE"] = 125, ---- Count of monsters needed to kill at first floor
			["KILL_COUNT_2_WAVE"] = 208, ---- Count of monsters needed to kill at second floor
			
			["stone_npc_position"] = {{243, 203}, {243, 219}, {240, 239}, {237, 260}},
			["pillar_position"] = {{236, 411, 5}, {276, 386, 6}, {189, 381, 4}},
			["boss_position"] = {229, 364, 5},
			["reward_chest_pos"] = {235, 393, 5},

			----------
			--- Dungeon Timers 
			----------			
			["DungeonTimer"] = 1200,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["time_to_proceed"] = 10,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["time_to_finish_first_floor"] = 300,  --- Time within boss or next waves of monsters are spawned in the dungeon			
			["timer_to_exit_dungeon"] = 120,  --- Time within players have to destroy second stone (8703), otherwise the finall boss is gonna have much higher defense
			["time_to_get_reward"] = 9, --- IN MINUTES --  If dungeon is finished within 11 minutes, rich chest is spawned, if not, low chest is spawned				

			};
	end
	
	return Easter2022LIB.data;
end


Easter2022LIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = Easter2022LIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

Easter2022LIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.kill_all();
		d.clear_regen();
		d.kill_all();
	end return false;
end

Easter2022LIB.checkEnter = function()
	local settings = Easter2022LIB.Settings();
	local ItemTicket = settings["Item_ticket"]	
	
	addimage(25, 10, "easter2022_bg1.tga"); addimage(225, 150, "easter2022_npc1.tga");
	say("[ENTER][ENTER]")
	say_title(mob_name(9440))
	
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
								
				local easter2022_time_flag = game.get_event_flag("easter2022_cooldown_"..pid.."");
				local current_time = get_time();
				
				if (easter2022_time_flag > current_time) then
					table.insert(Timetable, string.format("%s - %s", pc.get_name(), get_time_format(easter2022_time_flag - current_time)));
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
		local easter2022_time_flag = game.get_event_flag("easter2022_cooldown_"..ownPid.."");
		local current_time = get_time();
		
		if (easter2022_time_flag > current_time) then
			say(string.format("If you want to enter, you need to wait %s.", get_time_format(easter2022_time_flag - current_time)))
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

Easter2022LIB.CreateDungeon = function()
	local settings = Easter2022LIB.Settings();
	
	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["Item_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["Dungeon_Pos"][1], settings["Dungeon_Pos"][2]);
	else
		pc.remove_item(settings["Item_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["Dungeon_Pos"][1]*100, settings["Dungeon_Pos"][2]*100); 
	end
end


Easter2022LIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = Easter2022LIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
end

Easter2022LIB.setReward = function()
	local settings = Easter2022LIB.Settings();
	
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

Easter2022LIB.setWaitingTime = function()
	local settings = Easter2022LIB.Settings(); 
	local ownPid = pc.get_player_id();
	
	if party.is_party() then
		if (type(pids) != "table") then
			return game.set_event_flag("easter2022_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
		end
		
		for index, pid in next, pids, nil do
			return game.set_event_flag("easter2022_cooldown_"..pid.."", settings["dungeon_cooldown"] + get_time());
		end
	end
	return game.set_event_flag("easter2022_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
end

Easter2022LIB.SpawnRewardChest = function()
	local settings = Easter2022LIB.Settings();
	local RemainingTime = (d.getf("Easter2022_DungeonTimer") - get_global_time())
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

Easter2022LIB.spawnStoneNpc = function()
	local settings = Easter2022LIB.Settings(); 
	local npcStonePos = settings["stone_npc_position"];
	
	for i = 1, 4 do
		d.set_unique("npcStone_"..i, d.spawn_mob(9442, npcStonePos[i][1], npcStonePos[i][2]))
	end
end

Easter2022LIB.spawnfirstBoss = function()
	local settings = Easter2022LIB.Settings(); 
	local FirstBoss = settings["first_boss"];
	local bossPos = settings["boss_position"];
	
	d.spawn_mob_dir(FirstBoss, bossPos[1], bossPos[2], bossPos[3]);
end

Easter2022LIB.prepareNextFloor = function()
	local settings = Easter2022LIB.Settings();
	local pillar = settings["pillar"];
	local pillarPos = settings["pillar_position"];
	local FirstBoss = settings["first_boss"];
	
	d.setf("Easter2022_stage", 2);
	d.setf("Easter2022_canKillFirstBoss", 1);
	d.setf("Easter2022_pillar_c", 1);
	
	Easter2022LIB.spawnfirstBoss();
	
	for i = 1, 3 do
		d.set_unique("pillar_"..i, d.spawn_mob_dir(pillar, pillarPos[i][1], pillarPos[i][2], pillarPos[i][3]));
	end
	
	d.notice(string.format("Infected hole: You have to activate all %s!", mob_name(pillar)));
	d.notice(string.format("Infected hole: Kill %s to be able to activate the %s!", mob_name(FirstBoss), mob_name(pillar)));
end

Easter2022LIB.activateSeal = function()
	local settings = Easter2022LIB.Settings(); 
	local Position = settings["pillar_position"];
	local Status = d.getf("Easter2022_pillar_c")
	local n = d.getf("Easter2022_pillar_c") + 1
	
	d.setf("Easter2022_pillar_c", n);
	
	if npc.get_vid() == d.get_unique_vid("pillar_1") then
		d.spawn_mob_dir(9444, Position[1][1], Position[1][2], Position[1][3]);
		d.kill_unique("pillar_1");
	
	elseif npc.get_vid() == d.get_unique_vid("pillar_2") then
		d.spawn_mob_dir(9444, Position[2][1], Position[2][2], Position[2][3]);
		d.kill_unique("pillar_2");
	
	elseif npc.get_vid() == d.get_unique_vid("pillar_3") then
		d.spawn_mob_dir(9444, Position[3][1], Position[3][2], Position[3][3]);
		d.kill_unique("pillar_3");
	end

	if Status == 1 then
		d.setf("Easter2022_2w_monsters_k", 1);
		d.regen_file("data/dungeon/easter2022/regen_2f_mobs.txt");
		
		d.notice(string.format("Infected hole: Kill all monsters to spawn %s!", mob_name(settings["first_boss"])));
	
	elseif Status == 2 then
		d.setf("Easter2022_2w_monsters_k", 1);
		d.regen_file("data/dungeon/easter2022/regen_2f_mobs.txt");

		d.notice(string.format("Infected hole: Kill all monsters to spawn %s!", mob_name(settings["first_boss"])));

	elseif Status == 3 then
		d.notice(string.format("Infected hole: All %s were activated, the hiding spell of %s loses its effect!", mob_name(settings["pillar"]), mob_name(settings["main_boss"])));
		
		server_timer("Easter2022_FinalBossSpawn", settings["time_to_proceed"], d.get_map_index())
	end
end

Easter2022LIB.spawnFinalBoss = function()
	local settings = Easter2022LIB.Settings(); 
	local FinalBoss = settings["main_boss"];
	local bossPos = settings["boss_position"];
	local RemainingTime = (d.getf("Easter2022_DungeonTimer") - get_global_time())
	local minutes = math.floor(RemainingTime / 60)
	
	d.setf("Easter2022_canKillFinalBoss", 1)
	d.set_unique ("FinalBoss", d.spawn_mob(FinalBoss, bossPos[1], bossPos[2]))

	d.notice("Infected hole: Remaining time - " ..minutes.. " minutes")
end

Easter2022LIB.SpawnRewardChest = function()
	local settings = Easter2022LIB.Settings();
	local RemainingTime = (d.getf("Easter2022_DungeonTimer") - get_global_time())
	local minutes = math.floor(RemainingTime / 60)
	local Position = settings["reward_chest_pos"]
	
	if minutes >= settings["time_to_get_reward"] then
		d.spawn_mob_dir(9446, Position[1], Position[2], Position[3])
	elseif minutes < settings["time_to_get_reward"] then
		d.spawn_mob_dir(9445, Position[1], Position[2], Position[3])
	end
end

