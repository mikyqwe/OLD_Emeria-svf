Easter2020DungeonLIB = {};

Easter2020DungeonLIB.Settings = function()
	if (Easter2020DungeonLIB.data == nil) then
		Easter2020DungeonLIB.data = {
			-- [[ Requirements, Items, Map info ]]
			["minimumLevel"] = 50,
			["easter2020_pass"] = 30787,
			
			["inside_index"] = 159,
			["outside_index"] = {1, 21, 41},
			
			
			["insidePos"] = {4037, 22766, 4403, 22685},
			["outsidePos"] = {4693, 9642, 557, 1579, 9694, 2786},
			
			["CarrotPos"] = {{584, 156}, {536, 176}, {567, 198}, {563, 224}, {521, 228}, {523, 257}, {541, 256}, {564, 267}, {566, 307}, {587, 276}, {623, 301}, {619, 263}, {654, 269}, {637, 252}, {622, 231}, {656, 208}, {609, 213}, {608, 158}},
			["StonePos"] = {{575, 196}, {538, 242}, {553, 289}, {598, 285}, {639, 284}, {639, 239}, {632, 198}},
			["BasketPos"] = {{611, 382}, {613, 408}, {613, 428}, {614, 458}, {587, 462}, {594, 445}, {597, 426}, {597, 400}, {604, 418}, {603, 440}},
			["Boss1Pos"] = {{573, 523}, {565, 576}, {607, 586}, {625, 535}},
			};
	end
	
	return Easter2020DungeonLIB.data;
end

Easter2020DungeonLIB.clearTimers = function()
	clear_server_timer("EasterDungeon2020_30min_left", get_server_timer_arg())
	clear_server_timer("EasterDungeon2020_20min_left", get_server_timer_arg())
	clear_server_timer("EasterDungeon2020_10min_left", get_server_timer_arg())
	clear_server_timer("EasterDungeon2020_5min_left", get_server_timer_arg())
	clear_server_timer("EasterDungeon2020_1min_left", get_server_timer_arg())
	clear_server_timer("EasterDungeon2020_0min_left", get_server_timer_arg())
	clear_server_timer("Easter2020_Finalexit", get_server_timer_arg())
end

Easter2020DungeonLIB.isActive = function()
	local pMapIndex = pc.get_map_index(); local map_index = Easter2020DungeonLIB.Settings()["inside_index"];
	
	return pc.in_dungeon() and pMapIndex >= map_index*10000 and pMapIndex < (map_index+1)*10000;
end

Easter2020DungeonLIB.clearDungeon = function()
	if (pc.in_dungeon()) then
		d.clear_regen();
		d.kill_all();
	end return false;
end

Easter2020DungeonLIB.checkEnter = function()
	addimage(25, 10, "easter2020_bg1.tga"); addimage(225, 150, "easter2020_rabbit.tga")
	say("[ENTER][ENTER]")
	say_title(mob_name(9308))
	local settings = Easter2020DungeonLIB.Settings();
	
	if party.is_party() then
		say_reward("This place is protected. You can not go there in group.[ENTER]You have to finish it just by yourself.[ENTER]With your fear, with your courage.")
		return false;
	else
	
		if ((get_global_time() - pc.getf("easter2020_dungeon","exit_easter2020_dungeon_time")) < 60*30) then
		
			local remaining_wait_time = (pc.getf("easter2020_dungeon","exit_easter2020_dungeon_time") - get_global_time() + 60*30)
			say("You have to wait until you can enter the Rabbit hole again.")
			say_reward("You can go there again in: "..get_time_remaining(remaining_wait_time)..'[ENTER]')
			return
		end

		if (pc.get_level() < settings["minimumLevel"]) then
			say(string.format("The minimum level to enter the Rabbit hole is %d.", settings["minimumLevel"]))
			return false;
		end
		
		if (pc.count_item(settings["easter2020_pass"]) < 1) then
			say("If you want to enter the Rabbit hole[ENTER]you must have:")
			say_item(""..item_name(settings["easter2020_pass"]).."", settings["easter2020_pass"], "")
			return false;
		end
	end
	
	return true;
end

Easter2020DungeonLIB.CreateDungeon = function()
	local settings = Easter2020DungeonLIB.Settings();
	
	pc.remove_item(settings["easter2020_pass"], 1);	
	return d.new_jump(settings["inside_index"], settings["insidePos"][1]*100, settings["insidePos"][2]*100); 
end

Easter2020DungeonLIB.setOutCoords = function()
	local empire = pc.get_empire()
	local settings = Easter2020DungeonLIB.Settings();
	
	if empire == 1 then
		d.set_warp_location(settings["outside_index"][1], settings["outsidePos"][1], settings["outsidePos"][2]);
	elseif empire == 2 then
		d.set_warp_location(settings["outside_index"][2], settings["outsidePos"][3], settings["outsidePos"][4]);
	elseif empire == 3 then
		d.set_warp_location(settings["outside_index"][3], settings["outsidePos"][5], settings["outsidePos"][6]);
	end
end