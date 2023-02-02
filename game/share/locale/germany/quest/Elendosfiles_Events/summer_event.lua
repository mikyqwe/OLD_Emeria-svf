define SUMMER_NPC 22819
define SUMMER_MAP_INDEX 50
define SUMMER_METIN 8155
define SUMMER_METIN_COUNT 300
define SUMMER_ITEM 30322
define SUMMER_ITEM_COUNT 2000
define SUMMER_ITEM_CHANCE 100
define SUMMER_MONSTER_COUNT 5000

define SUMMER_REWARD1 71153
define SUMMER_REWARD1_COUNT 3
define SUMMER_REWARD2 77380
define SUMMER_REWARD2_COUNT 2
define SUMMER_REWARD3 77289
define SUMMER_REWARD3_COUNT 2
define SUMMER_REWARD4 55273
define SUMMER_REWARD4_COUNT 1

quest summer_event begin
	state start begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end			
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when SUMMER_NPC.chat."Launch the Summer Event" with pc.get_map_index()==SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			say_reward("You will get several tasks to complete.")
			say_reward("In the end, I have a surprise for you!")
			say_reward("Run down the marked points and come back to me afterwards.")
			say_reward("Elendos wishes you lots of fun!")
			wait()
			pc.setqf("summer_waypoint", 1)
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
			if pc.getqf("summer_waypoint")>table.getn(pos) then
				return -1, -1
			end
			return pos[pc.getqf("summer_waypoint")][1], pos[pc.getqf("summer_waypoint")][2]
		end
		
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()==SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			say("Run the marked points down and come back to me afterwards")
		end
		
		when letter begin
			send_letter("Summer Event - Running Quest")
			if pc.get_map_index()==SUMMER_MAP_INDEX then
				local x,y = summer_event.getWaypointPosition()
				target.pos("p", x, y, SUMMER_MAP_INDEX, "Waypoint")
			end
		end
		
		when button or info begin
			say_title(mob_name(SUMMER_NPC))
			say("Run the marked points down and come back to me afterwards.")
		end
		
		when p.target.arrive begin
			target.delete("p")
			syschat("You've reached the waypoint!")
			pc.setqf("summer_waypoint", pc.getqf("summer_waypoint")+1)
			local x,y = summer_event.getWaypointPosition()
			if x==-1 and y==-1 then
				syschat("You've received a reward!")
				pc.give_item2(SUMMER_REWARD1, SUMMER_REWARD1_COUNT)
				setstate(kill_metin_sub)
			end
			target.pos("p", x, y, SUMMER_MAP_INDEX, "Waypoint")
		end
	end
	
	-- Metin kill subquest
	state kill_metin_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()==SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Destroy now %d Melon Metins!", SUMMER_METIN_COUNT))
		end
		
		when letter begin
			send_letter("Summer Event - Melon Metins")
		end
		
		when button or info begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Destroy now %d Melon Metins!", SUMMER_METIN_COUNT))
		end
		
		when kill with npc.get_race()==SUMMER_METIN begin
			pc.setqf("summer_metin", pc.getqf("summer_metin")+1)
			if pc.getqf("summer_metin")>=SUMMER_METIN_COUNT then
				syschat("You received a reward!")
				pc.give_item2(SUMMER_REWARD2, SUMMER_REWARD2_COUNT)
				setstate(give_item_sub)
			end
			syschat(string.format("You destroyed %d of %d Melon Metins!", pc.getqf("summer_metin"), SUMMER_METIN_COUNT))
		end
	end
	
	state give_item_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()==SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Get me %dx %s!", SUMMER_ITEM_COUNT, item_name(SUMMER_ITEM)))
			if pc.count_item(SUMMER_ITEM)<SUMMER_ITEM_COUNT then
				say(string.format("At the moment you have %d", pc.count_item(SUMMER_ITEM)))	
			else
				say("Thank you!")
				pc.remove_item(SUMMER_ITEM, SUMMER_ITEM_COUNT)
				say("You received a reward!")
				pc.give_item2(SUMMER_REWARD3, SUMMER_REWARD3_COUNT)
				setstate(kill_monster_sub)
			end
		end
		
		when letter begin
			send_letter("Summer Event - Strawberry")
		end
		
		when button or info begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Get me %dx %s!", SUMMER_ITEM_COUNT, item_name(SUMMER_ITEM)))
			say(string.format("At the moment you have %d", pc.count_item(SUMMER_ITEM)))				
		end
		
		when kill with pc.get_map_index()==SUMMER_MAP_INDEX begin
			if number(1, SUMMER_ITEM_CHANCE) == 1 then
				game.drop_item_with_ownership(SUMMER_ITEM, 1)
			end
		end
	end
	
	-- Monster kill subquest
	state kill_monster_sub begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end	
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
		
		-- Info dialog
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()==SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Now destroy %d Summer Monsters!", SUMMER_MONSTER_COUNT))
		end
		
		when letter begin
			send_letter("Summer Event - Summer Monsters")
		end
		
		when button or info begin
			say_title(mob_name(SUMMER_NPC))
			say(string.format("Now kill %d Monsters!", SUMMER_MONSTER_COUNT))
		end
		
		when kill with pc.get_map_index()==SUMMER_MAP_INDEX begin
			pc.setqf("summer_monster", pc.getqf("summer_monster")+1)
			if pc.getqf("summer_monster")>=SUMMER_MONSTER_COUNT then
				syschat("You've received a reward!")
				pc.give_item2(SUMMER_REWARD4, SUMMER_REWARD4_COUNT)
				setstate(finish)
			end
			syschat(string.format("You killed %d of %d Monsters!", pc.getqf("summer_monster"), SUMMER_MONSTER_COUNT))
		end
	end
	
	state finish begin
		-- Info on login if the event is active
		when login begin
			if game.get_event_flag("summer_event_status")==1 then
				syschat(string.format("The Summer Event is currently active! Contact %s", mob_name(SUMMER_NPC)))
			elseif game.get_event_flag("summer_event_status")==0 and pc.get_map_index()==SUMMER_MAP_INDEX then
				warp_to_village()
			end
		end			
		
		-- Info dialog and teleportation to map
		when SUMMER_NPC.chat."Summer Event" with pc.get_map_index()!=SUMMER_MAP_INDEX begin
			say_title(mob_name(SUMMER_NPC))
			
			if game.get_event_flag("summer_event_status")==0 then
				say("The Summer Event is currently deactivated.")
				say("Come back later!")
			else 
				say("")
				say_reward("Currently the Summer Event is running!")
				say_reward("Would you like to participate? For this I will")
				say_reward("teleporte you into the Summer Beach.")
				say_reward("When you are on the Event Map, talk to me again.")
				if select("Take me there!", "I'd rather not.")==2 then return end
				pc.warp(617200, 288900)
			end
		end
	end
end