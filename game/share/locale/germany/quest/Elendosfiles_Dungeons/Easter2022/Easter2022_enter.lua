quest Easter2022_enter begin
	state start begin
		---Info about dungeon
		when 9440.chat."Who are you?" with not Easter2022LIB.isActive() begin
			addimage(25, 10, "easter2022_bg1.tga"); addimage(225, 150, "easter2022_npc1.tga");
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say("Hi, my name is Rabini. I come from a very old[ENTER]tribe of hares who every year prepare all[ENTER]the towns or villages for the upcoming Spring Festival.[ENTER]We were just preparing the village[ENTER]for the upcoming Easter when suddenly[ENTER]it got dark, and in one place a big[ENTER]dark portal started to form.[ENTER]We could literally feel the darkness.[ENTER]But what happened next, no one understood.")
			
			wait()			
			addimage(25, 10, "easter2022_bg1.tga"); addimage(225, 150, "easter2022_npc1.tga");
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			
			say("All the creatures that were near the portal[ENTER]began to change in the front of us. [ENTER]And there were more than a few. [ENTER]They all fled and hid in a nearby burrow,[ENTER]but it's not just visible. They've taken[ENTER]many of us with them![ENTER]I can get you there, but it's[ENTER]not a very safe place.")
		end		
			
		----Dungeon enter
		when 9440.chat."Infected hole" with not Easter2022LIB.isActive() begin
			local settings = Easter2022LIB.Settings();

			addimage(25, 10, "easter2022_bg1.tga"); addimage(225, 150, "easter2022_npc1.tga");			
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say_reward("Do you really want to enter the dungeon?")
			
			if (select("Yes!", "No") == 1) then
				if Easter2022LIB.checkEnter() then
					Easter2022LIB.CreateDungeon();
				end
			end
		end
	end
end	
		
		
