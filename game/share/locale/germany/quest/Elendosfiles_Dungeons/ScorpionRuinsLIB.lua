ScorpionRuinsLIB = {};

ScorpionRuinsLIB.Settings = function()
	if (ScorpionRuinsLIB.data == nil) then
		ScorpionRuinsLIB.data = {
			----------
			--- Requirements, map info, coordinates,  etc...
			----------
			["dungeon_cooldown"] = 1800,  --- Time within players can't enter the dungeon after they finish it (or were teleported out of dungeon)
			
			["minimumLevel"] = 180, -- Minimum level for enter the dungeon
			["minimumPartyMembers"] = 2, -- Minimum count of players (If its party, members need to be around)
			
			["inside_index"] = 150, -- Dungeon index
			["inside_pos"] = {24974, 22836}, -- Dungeon coordinates to 1. floor
			
			["outside_index"] = {1, 21, 41}, -- Index of maps, where are players teleported from the dungeon (Cities)
			["outside_pos"] = {4693, 9642, 557, 1579, 9694, 2786}, -- Coords of the maps where are players teleported from the dungeon (Cities)	
			
			["Item_ticket"] = 30877,
			
			----------
			--- Items
			----------			
			["Item_crystal"] = 30878,
			["FalseSkillBook"] = 30879,
			["TrueSkillBook"] = 30880,
			
			----------
			--- IDs
			----------
			
			--NPC
			["crystal"] = 9415,  ---	
			["crystal_activated"] = 9416,  ---
			
			---Monsters, Bosses, Stones...
			["first_boss"] = 4429,  --- 
			["second_boss"] = 4430,  --- 
			["metinstone"] = 8708,  --- 
						
			---Positions
			["crystal_pos"] = {{240, 204, 1}, {297, 204, 1}, {297, 251, 1}, {240, 251, 1}},  --- Position of crystal that players have to activate		
			["boss_pos"] = {268, 227},  --- Position where all boses are spawned		
			["first_stone_wave_pos"] = {{215, 191}, {202, 216}, {212, 264}, {232, 284}, {313, 279}, {336, 241}, {332, 206}, {312, 175}},  --- Position where all boses are spawned		
			
			----------
			--- Dungeon settings
			----------			

			["KILL_COUNT_1_WAVE"] = 318, --- Count of monsters players have to kill in first wave
			["KILL_COUNT_2_WAVE"] = 269, --- Count of monsters players have to kill to drop a key (Last four waves)
						
			["FirstBoss_HP_1"] = 2134543,  --- HP of first boss when players need to activate first crystal
			["FirstBoss_HP_2"] = 2134543,  --- HP of first boss when players need to activate second crystal
			["FirstBoss_HP_3"] = 2134543,  --- HP of first boss when players need to activate third crystal
			["FirstBoss_HP_4"] = 2134543,  --- HP of first boss when players need to activate fourth crystal

			----------
			--- Timers (in dungeon)
			----------			
			["time_to_finish_dungeon"] = 1200,  --- Time withing players have to finish the dungeon
			
			["time_to_proceed"] = 10,  --- Time within boss or next waves of monsters are spawned in the dungeon
			
			["time_to_kill_first_wave"] = 300,  --- Time within players have to kill all monsters from first wave
			
			["timer_to_exit_dungeon"] = 300,  --- Time within players have to destroy second stone (8703), otherwise the finall boss is gonna have much higher defense
												
			};
	end
	
	return ScorpionRuinsLIB.data;
end


ScorpionRuinsLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = ScorpionRuinsLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

ScorpionRuinsLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.kill_all();
		d.clear_regen();
		d.kill_all();
	end return false;
end

ScorpionRuinsLIB.checkEnter = function()
	local settings = ScorpionRuinsLIB.Settings();
	say_size(350,350)
	addimage(25, 10, "scor_bg.tga"); addimage(225, 225, "aj_guard.tga")
	say("[ENTER][ENTER]")
	say_title(mob_name(9414))
	
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
		
		for index, pid in ipairs(pids) do
			q.begin_other_pc_block(pid);
				if (pc.get_level() < settings["minimumLevel"]) then
					table.insert(minLev, pc.get_name());
					minLevCheck = false;
				end
				
				if (pc.count_item(settings["Item_ticket"]) < 1) then
					table.insert(itemNeed, string.format("%s", pc.get_name()));
					itemNeedCheck = false;
				end
				
				local scorp_flag = game.get_event_flag("scorpruins_cooldown_"..pid.."");
				local current_time = get_time();
				
				if (scorp_flag > current_time) then
					table.insert(Timetable, string.format("%s - %s", pc.get_name(), get_time_format(scorp_flag - current_time)));
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
	else  --- if its solo
	
		--[[if ((get_global_time() - pc.getf("easter2021_dungeon","exit_easter2021_time")) < settings["dungeon_cooldown"]) then
		
			local remaining_wait_time = (pc.getf("easter2021_dungeon","exit_easter2021_time") - get_global_time() + settings["dungeon_cooldown"])
			say("You have to wait until you can enter the dungeon again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end]]--
		local ownPid = pc.get_player_id();
		local scorp_flag = game.get_event_flag("scorpruins_cooldown_"..ownPid.."");
		local current_time = get_time();
		
		if (scorp_flag > current_time) then
			say(string.format("If you want to enter, you need to wait %s.", get_time_format(scorp_flag - current_time)))
			return false;
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(settings["Item_ticket"]) < 1) then
			say("If you want to enter the dungeon[ENTER]you must have:")
			say_item(""..item_name(settings["Item_ticket"]).."", settings["Item_ticket"], "")
			return false;
		end
	end
	
	return true;
end

ScorpionRuinsLIB.CreateDungeon = function()
	local settings = ScorpionRuinsLIB.Settings();
	
	if party.is_party() then
		local pids = party_get_member_pids();
		
		for i, pid in next, pids, nil do
			q.begin_other_pc_block(pid);
			pc.remove_item(settings["Item_ticket"], 1);
			q.end_other_pc_block();
		end
		return d.new_jump_party(settings["inside_index"], settings["inside_pos"][1], settings["inside_pos"][2]);
	else
		pc.remove_item(settings["Item_ticket"], 1);	
		return d.new_jump(settings["inside_index"], settings["inside_pos"][1]*100, settings["inside_pos"][2]*100); 
	end
end

ScorpionRuinsLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = ScorpionRuinsLIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outside_pos"][1], settings["outside_pos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outside_pos"][3], settings["outside_pos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outside_pos"][5], settings["outside_pos"][6]);
	end
end

ScorpionRuinsLIB.setReward = function()
	local settings = ScorpionRuinsLIB.Settings();
	
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

ScorpionRuinsLIB.setWaitingTime = function()
	local settings = ScorpionRuinsLIB.Settings(); 
	local ownPid = pc.get_player_id();
	
	if party.is_party() then
		if (type(pids) != "table") then
			return game.set_event_flag("scorpruins_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
		end
		
		for index, pid in next, pids, nil do
			return game.set_event_flag("scorpruins_cooldown_"..pid.."", settings["dungeon_cooldown"] + get_time());
		end
	end
	return game.set_event_flag("scorpruins_cooldown_"..ownPid.."", settings["dungeon_cooldown"] + get_time());
end

ScorpionRuinsLIB.spawnCrystals = function()
	local settings = ScorpionRuinsLIB.Settings(); 
	local CrystalPosition = settings["crystal_pos"];
	local Crystal = settings["crystal"];
	
	for i = 1, 4 do
		d.set_unique("crystal_"..i, d.spawn_mob_dir(Crystal, CrystalPosition[i][1], CrystalPosition[i][2], CrystalPosition[i][3]))
	end
end

ScorpionRuinsLIB.spawnBoss = function()
	local settings = ScorpionRuinsLIB.Settings(); 
	local position = settings["boss_pos"];
	local x = position[1] + number(1, 55)
	local y = position[2] + number(1, 55)
	local Boss = settings["first_boss"];
	local BossStage = d.getf("ScorpionRuins_FirstBoss_stage")
	
	d.set_unique("FirstBoss", d.spawn_mob(Boss, x, y));
	
	if BossStage == 1 then
		d.unique_set_maxhp("FirstBoss", settings["FirstBoss_HP_1"])
	elseif BossStage == 2 then
		d.unique_set_maxhp("FirstBoss", settings["FirstBoss_HP_2"])
	elseif BossStage == 3 then
		d.unique_set_maxhp("FirstBoss", settings["FirstBoss_HP_3"])
	elseif BossStage == 4 then
		d.unique_set_maxhp("FirstBoss", settings["FirstBoss_HP_4"])
	end
end

ScorpionRuinsLIB.spawnFirstStones = function()
	local settings = ScorpionRuinsLIB.Settings(); 
	local Position = settings["first_stone_wave_pos"];
	local Stone = settings["metinstone"];
	local n = number(1,8); 
	
	table_shuffle(Position);
	
	for i = 1, 8 do
		if (i != n) then
			d.set_unique("fake"..i, d.spawn_mob(Stone, Position[i][1], Position[i][2]))
		end
	end

	d.set_unique ("real", d.spawn_mob(Stone, Position[n][1], Position[n][2]))
end

ScorpionRuinsLIB.spawnFinalBoss = function()
	local settings = ScorpionRuinsLIB.Settings(); 
	local position = settings["boss_pos"];
	local Boss = settings["second_boss"];
	
	d.setf("ScorpionRuins_FinalBoss_kill", 1)
	d.spawn_mob(Boss, position[1], position[2]);
end
