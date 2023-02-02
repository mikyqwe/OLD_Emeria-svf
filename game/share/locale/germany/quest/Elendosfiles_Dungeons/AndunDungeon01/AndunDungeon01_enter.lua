quest AndunDungeon01_enter begin
	state start begin
		---Info about dungeon
		when 9435.chat."Who are you?" with not AndunDungeon01LIB.isActive() begin
			addimage(25, 10, "andun_dungeon01_bg1.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say("Hello![ENTER]I used to be part of a military patrol that[ENTER] patrolled the cities. One day, by complete accident,[ENTER]we found a crack in the ground and this[ENTER]vast complex of corridors, and unfortunately, what[ENTER]lives in them. None of us survived,[ENTER]but my friends were engulfed in darkness.[ENTER]I wasn't, but escaping these corridors is impossible.")
			wait()
			
			addimage(25, 10, "andun_dungeon01_bg1.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say("And that's my short story.[ENTER]Right now, I'm guarding entrance into even worse place than[ENTER]than these catacombs. I call it Dungeon of sufferring[ENTER]souls. For real![ENTER]This place is something between earth and hell.[ENTER]But if you will go there, you will see.")
		end		
			
		----Dungeon enter
		when 9435.chat."Suffering souls dungeon" with not AndunDungeon01LIB.isActive() and pc.get_channel_id() == 1 begin
			local settings = AndunDungeon01LIB.Settings();

			addimage(25, 10, "andun_dungeon01_bg1.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");			
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say_reward("Do you really want to enter the dungeon?")
			
			if (select("Yes!", "No") == 1) then
				if AndunDungeon01LIB.checkEnter() then
					AndunDungeon01LIB.CreateDungeon();
				end
			end
		end
		
		----Dungeon enter
		when 9435.chat."Suffering souls dungeon" with not AndunDungeon01LIB.isActive() and pc.get_channel_id() == 2 or pc.get_channel_id() == 3 or pc.get_channel_id() == 4 begin
			local settings = AndunDungeon01LIB.Settings();

			addimage(25, 10, "andun_dungeon01_bg1.tga"); addimage(225, 150, "andun_dungeon01_npc1.tga");			
			
			say_title(string.format("[ENTER][ENTER][ENTER]%s:[ENTER]", mob_name(npc.get_race())));
			say_reward("You must enter the dungeon from channel 1!")
			say_reward("Change your channel please.")
			
		end
	end
end	
		
		
