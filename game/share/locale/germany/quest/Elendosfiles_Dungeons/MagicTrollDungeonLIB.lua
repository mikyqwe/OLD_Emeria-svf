MagicTrollDungeonLIB = {};

MagicTrollDungeonLIB.Settings = function()
	if (MagicTrollDungeonLIB.data == nil) then
		MagicTrollDungeonLIB.data = {
			-- [[ Requirements, Items, Map info ]]
			["minimumLevel"] = 140,
			["minimumPartyMembers"] = 2,
			["magictrollcave_ticket"] = 30781,
			
			["inside_index"] = 54,
			["outside_index"] = 134,
			
			
			["insidePos"] = {3337, 22744},
			["outsidePos"] = {{8592, 3591}, {8592, 3591}, {8592, 3591}},
			
			["CrystalPos1"] = {{258, 229}, {255, 254}, {258, 275}, {256, 296}, {275, 290}, {273, 268}, {267, 246}, {266, 221}},
			["ScrollPos"] = {{277, 339}, {294, 373}, {289, 401}, {269, 373}, {282, 411}, {256, 423}, {236, 423}, {214, 404}, {207, 387}, {213, 364}, {231, 340}, {232, 379}, {237, 388}},
			};
	end
	
	return MagicTrollDungeonLIB.data;
end


MagicTrollDungeonLIB.clearTimers = function()
	clear_server_timer("MagicTrollCave_30min_left", get_server_timer_arg())
	clear_server_timer("MagicTrollCave_10min_left", get_server_timer_arg())
	clear_server_timer("MagicTrollCave_5min_left", get_server_timer_arg())
	clear_server_timer("MagicTrollCave_1min_left", get_server_timer_arg())
	clear_server_timer("MagicTrollCave_0min_left", get_server_timer_arg())
	clear_server_timer("MagicTrollCave_final_exit", get_server_timer_arg())
end

MagicTrollDungeonLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = MagicTrollDungeonLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

MagicTrollDungeonLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.clear_regen();
		d.kill_all();
	end return false;
end

MagicTrollDungeonLIB.checkEnter = function()
	say_size(350,350)
	addimage(25, 10, "mt_quest_bg1.tga"); addimage(225, 200, "mt_guard.tga")
	say("[ENTER][ENTER]")
	say_title(mob_name(9302))
	local settings = MagicTrollDungeonLIB.Settings();
	
	if party.is_party() then
		say_reward("You can not enter this dungeon in group.")
		return false;
	else
	
		if ((get_global_time() - pc.getf("magictroll_dungeon","exit_magictroll_dungeon_time")) < 60*60) then
		
			local remaining_wait_time = (pc.getf("magictroll_dungeon","exit_magictroll_dungeon_time") - get_global_time() + 60*60)
			say("You have to wait until you can enter the dungeon again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the dungeon is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(settings["magictrollcave_ticket"]) < 1) then
			say("If you want to enter the magic troll cave[ENTER]you must have:")
			say_item(""..item_name(settings["magictrollcave_ticket"]).."", settings["magictrollcave_ticket"], "")
			return false;
		end
	end
	
	return true;
end

MagicTrollDungeonLIB.CreateDungeon = function()
	local settings = MagicTrollDungeonLIB.Settings();
	
	pc.remove_item(settings["magictrollcave_ticket"], 1);	
	return d.new_jump(settings["inside_index"], settings["insidePos"][1]*100, settings["insidePos"][2]*100); 
end

MagicTrollDungeonLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = MagicTrollDungeonLIB.Settings();
	
	d.set_warp_location(settings["outside_index"], settings["outsidePos"][empire][1], settings["outsidePos"][empire][2]);
	--[[if empire == 1 then
		d.set_warp_location(settings["outside_index"], settings["outsidePos"][1][1], settings["outsidePos"][1][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"], settings["outsidePos"][2][1], settings["outsidePos"][2][2]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"], settings["outsidePos"][3][1], settings["outsidePos"][3][2]);
	end]]
end