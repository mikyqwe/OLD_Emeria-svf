quest ScorpionRuins_enter begin
	state start begin
		when 9414.chat."What is that place?" with not ScorpionRuinsLIB.isActive() begin
			say_size(350,350)
			addimage(25, 10, "scor_bg.tga"); addimage(225, 225, "scor_guard.tga");
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			
			say("This place is located in the east deserts,[ENTER]in the middle of deadly hot sands.[ENTER]Only God knows what happened, if its some kind[ENTER]of dark magic, or just some bad joke of nature.[ENTER]Giant scorpions that live there are now[ENTER]go out of this place and menace traders[ENTER]that walking through the desert.")
		end
			
		when 9414.chat."Scorpion ruins" with not ScorpionRuinsLIB.isActive() begin
			local settings = ScorpionRuinsLIB.Settings();

			addimage(25, 10, "scor_bg.tga"); addimage(225, 170, "scor_guard.tga");
			say("[ENTER][ENTER]")
			say_title(string.format("%s:[ENTER]", mob_name(npc.get_race())))
			say_reward("Do you really want to enter the dungeon?")
			
			if (select("Yes!", "No") == 1) then
				if ScorpionRuinsLIB.checkEnter() then
					ScorpionRuinsLIB.CreateDungeon();
				end
			end
		end
	end
end	
		
		
