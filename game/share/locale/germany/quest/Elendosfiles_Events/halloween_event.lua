define HALLOWEEN_NPC 22819
define HALLOWEEN_MAP_INDEX 50
define HALLOWEEN_METIN 8155
define HALLOWEEN_METIN_COUNT 180
define HALLOWEEN_ITEM 30322
define HALLOWEEN_ITEM_COUNT 2000
define HALLOWEEN_ITEM_CHANCE 100
define HALLOWEEN_MONSTER_COUNT 5000

define HALLOWEEN_REWARD1 71153
define HALLOWEEN_REWARD1_COUNT 3
define HALLOWEEN_REWARD2 77380
define HALLOWEEN_REWARD2_COUNT 2
define HALLOWEEN_REWARD3 77289
define HALLOWEEN_REWARD3_COUNT 2
define HALLOWEEN_REWARD4 55273
define HALLOWEEN_REWARD4_COUNT 1

quest halloween_event begin
	state start begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end			
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you into the Summer Beach")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			say("You will get several tasks to complete.")
			say("In the end, I have a surprise for you!")
			say("Run down the marked points and come back to me afterwards.")
			wait()
			pc.setqf("halloween_waypoint", 1)
			set_state(waypoint_sub)
		end
	end
	
	-- Waypoint subquest
	state waypoint_sub begin
		-- Get the next waypoint koordinates
		function getWaypointPosition()
			local pos = {
				{585, 144},
				{490, 174},
				{483, 216},
				{517, 279},
				{468, 327},
				{393, 345},
				{274, 369},
				{191, 433},
				{154, 487},
				{234, 631},
				{216, 420},
				{419, 460},
				{507, 494},
				{617, 507}
			}			
			if pc.getqf("halloween_waypoint")>table.getn(pos) then
				return -1, -1
			end
			return pos[pc.getqf("halloween_waypoint")][1], pos[pc.getqf("halloween_waypoint")][2]
		end
		
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you in the Summer Beach.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			say("Run the marked points down and come back to me afterwards")
		end
		
		when letter begin
			send_letter("Summer Event - Running Quest")
			if pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				local x,y = halloween_event.getWaypointPosition()
				target.pos("p", x, y, HALLOWEEN_MAP_INDEX, "Waypoint")
			end
		end
		
		when button or info begin
			say_title(mob_name(HALLOWEEN_NPC))
			say("Run the marked points down and come back to me afterwards.")
		end
		
		when p.target.arrive begin
			target.delete("p")
			syschat("You've reached the waypoint!")
			pc.setqf("halloween_waypoint", pc.getqf("halloween_waypoint")+1)
			local x,y = halloween_event.getWaypointPosition()
			if x==-1 and y==-1 then
				syschat("You've received a reward!")
				pc.give_item2(HALLOWEEN_REWARD1, HALLOWEEN_REWARD1_COUNT)
				setstate(kill_metin_sub)
			end
			target.pos("p", x, y, HALLOWEEN_MAP_INDEX, "Waypoint")
		end
	end
	
	-- Metin kill subquest
	state kill_metin_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you into the Summer Beach.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Destroy now %d Melon Metins!", HALLOWEEN_METIN_COUNT))
		end
		
		when letter begin
			send_letter("Summer Event - Melon Metins")
		end
		
		when button or info begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Destroy now %d Melon Metins!", HALLOWEEN_METIN_COUNT))
		end
		
		when kill with npc.get_race()==HALLOWEEN_METIN begin
			pc.setqf("halloween_metin", pc.getqf("halloween_metin")+1)
			if pc.getqf("halloween_metin")>=HALLOWEEN_METIN_COUNT then
				syschat("You received a reward!")
				pc.give_item2(HALLOWEEN_REWARD2, HALLOWEEN_REWARD2_COUNT)
				setstate(give_item_sub)
			end
			syschat(string.format("You destroyed %d of %d Melon Metins!", pc.getqf("halloween_metin"), HALLOWEEN_METIN_COUNT))
		end
	end
	
	state give_item_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you into the Summer Beach.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Get me %dx %s!", HALLOWEEN_ITEM_COUNT, item_name(HALLOWEEN_ITEM)))
			if pc.count_item(HALLOWEEN_ITEM)<HALLOWEEN_ITEM_COUNT then
				say(string.format("At the moment you have %d", pc.count_item(HALLOWEEN_ITEM)))	
			else
				say("Thank you!")
				pc.remove_item(HALLOWEEN_ITEM, HALLOWEEN_ITEM_COUNT)
				say("You received a reward!")
				pc.give_item2(HALLOWEEN_REWARD3, HALLOWEEN_REWARD3_COUNT)
				setstate(kill_monster_sub)
			end
		end
		
		when letter begin
			send_letter("Summer Event - Melon Metins")
		end
		
		when button or info begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Get me %dx %s!", HALLOWEEN_ITEM_COUNT, item_name(HALLOWEEN_ITEM)))
			say(string.format("At the moment you have %d", pc.count_item(HALLOWEEN_ITEM)))				
		end
		
		when kill with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			if number(1, HALLOWEEN_ITEM_CHANCE) == 1 then
				game.drop_item_with_ownership(HALLOWEEN_ITEM, 1)
			end
		end
	end
	
	-- Monster kill subquest
	state kill_monster_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you into the Summer Beach.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Now destroy %d Summer Monsters!", HALLOWEEN_MONSTER_COUNT))
		end
		
		when letter begin
			send_letter("Summer Event - Summer Monsters")
		end
		
		when button or info begin
			say_title(mob_name(HALLOWEEN_NPC))
			say(string.format("Now kill %d Monsters!", HALLOWEEN_MONSTER_COUNT))
		end
		
		when kill with pc.get_map_index()==HALLOWEEN_MAP_INDEX begin
			pc.setqf("halloween_monster", pc.getqf("halloween_monster")+1)
			if pc.getqf("halloween_monster")>=HALLOWEEN_MONSTER_COUNT then
				syschat("You've received a reward!")
				pc.give_item2(HALLOWEEN_REWARD4, HALLOWEEN_REWARD4_COUNT)
				setstate(finish)
			end
			syschat(string.format("You killed %d of %d Monsters!", pc.getqf("halloween_monster"), HALLOWEEN_MONSTER_COUNT))
		end
	end
	
	state finish begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("halloween_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(HALLOWEEN_NPC)))
			elseif game.get_event_flag("halloween_event_status")==0 and pc.get_map_index()==HALLOWEEN_MAP_INDEX then
				warp_to_village()
			end
		end			
		
		-- Info dialog and teleportation to map
		when HALLOWEEN_NPC.chat."Summer Event" with pc.get_map_index()!=HALLOWEEN_MAP_INDEX begin
			say_title(mob_name(HALLOWEEN_NPC))
			
			if game.get_event_flag("halloween_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("Currently the Summer Event is running!")
				say("Would you like to participate? For this I will")
				say("teleporte you into the Summer Beach.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
	end
end