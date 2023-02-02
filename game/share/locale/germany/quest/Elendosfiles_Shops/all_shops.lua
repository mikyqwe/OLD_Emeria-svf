quest shops begin 
	state start begin
		when 9002.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(250, 200, "npcrussi.tga")
			say("[ENTER][ENTER]")
			local s = select("Warrior Armors", "Ninja Armors", "Sura Armors", "Shaman Armors", "Jewelry/Shields/Helmets", "Close")
			if s == 6 then return end
			npc.open_shop(90+s-1)
			setskin(NOWINDOW)
		end
		
		when 9001.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(240, 200, "npcwaffen.tga")
			say("[ENTER][ENTER]")
			if select("Weapons", "Close") == 2 then return end
			npc.open_shop(1)
			setskin(NOWINDOW)
		end
		
		when 9070.click begin
			say_size(380,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(240, 200, "Blademaster.tga")
			say("[ENTER][ENTER]")
			if select("Lucky Chests", "Close") == 2 then return end
			npc.open_shop(106)
			setskin(NOWINDOW)
		end
		
		when 9004.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(240, 200, "npcevent.tga")
			say("[ENTER][ENTER]")
			if select("Event Items", "Close") == 2 then return end
			npc.open_shop(105)
			setskin(NOWINDOW)
		end
		
		when 9003.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(250, 200, "npcgemi.tga")
			say("[ENTER][ENTER]")
			local s = select("Main Shop", "Itemshop", "Wedding Shop", "Close")
			if s == 4 then return end
			if s == 1 then
				npc.open_shop(3)
			elseif s == 2 then 
				npc.open_shop(88)
			elseif s == 3 then
				npc.open_shop(8)
			end
			setskin(NOWINDOW)
		end
		
		when 7181.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga")
			say("[ENTER][ENTER]")
			local s = select("Prestige (1) Costumes", "Prestige (2) Costumes", "Prestige (3) Costumes", "Prestige Pets", "Prestige Sash", "Close")
			if s == 6 then return end
			if s == 1 then
				npc.open_shop(115)
			elseif s == 2 then 
				npc.open_shop(116)
			elseif s == 3 then
				npc.open_shop(117)
			elseif s == 4 then
				npc.open_shop(118)
			elseif s == 5 then
				npc.open_shop(119)
			end
			setskin(NOWINDOW)
		end
		
		when 22810.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga")
			say("[ENTER][ENTER]")
			local s = select("Rare Pets", "Rare Costumes", "Rare Sashes", "Close")
			if s == 4 then return end
			if s == 1 then
				npc.open_shop(120)
			elseif s == 2 then 
				npc.open_shop(121)
			elseif s == 3 then 
				npc.open_shop(122)
			end
			setskin(NOWINDOW)
		end
		
		when 20094.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga"); addimage(250, 200, "npchairs.tga")
			say("[ENTER][ENTER]")
			local s = select("Warrior Hairstyles Shop", "Ninja Hairstyle Shop", "Sura Hairstyle Shop", "Shaman Hairstyle Shop", "Close")
			if s == 5 then return end
			if s == 1 then
				npc.open_shop(13)
			elseif s == 2 then 
				npc.open_shop(15)
			elseif s == 3 then
				npc.open_shop(14)
			elseif s == 4 then
				npc.open_shop(12)
			end
			setskin(NOWINDOW)
		end

		when 7726.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("Biologist", "Skill Costume", "Skill Costume (2)", "Potions and others", "Stones", "Fishes", "Close")
			if s == 7 then return end
			if s == 1 then
				npc.open_shop(110)
			elseif s == 2 then 
				npc.open_shop(111)
			elseif s == 3 then
				npc.open_shop(112)
			elseif s == 4 then
				npc.open_shop(113)
			elseif s == 5 then
				npc.open_shop(128)
			elseif s == 6 then
				npc.open_shop(134)
			end
			setskin(NOWINDOW)
		end
		
		when 7727.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("Shoulder Straps", "Belts", "Rings", "Ores", "Pets", "Costumes", "Close")
			if s == 7 then return end
			if s == 1 then
				npc.open_shop(114)
			elseif s == 2 then
				npc.open_shop(121)
			elseif s == 3 then
				npc.open_shop(135)
			elseif s == 4 then
				npc.open_shop(136)
			elseif s == 5 then
				npc.open_shop(137)
			elseif s == 6 then
				npc.open_shop(138)
			end
			setskin(NOWINDOW)
		end
		
		when 7728.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("Helmets", "Bracelets", "Necklaces", "Earrings", "Shoes", "Shields", "Close")
			if s == 7 then return end
			if s == 1 then
				npc.open_shop(115)
			elseif s == 2 then 
				npc.open_shop(116)
			elseif s == 3 then
				npc.open_shop(117)
			elseif s == 4 then
				npc.open_shop(118)
			elseif s == 5 then
				npc.open_shop(119)
			elseif s == 6 then
				npc.open_shop(120)
			end
			setskin(NOWINDOW)
		end
		
		when 7729.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("One Hands", "Two Hands", "Daggers", "Bows", "Fans", "Bells", "Close")
			if s == 7 then return end
			if s == 1 then
				npc.open_shop(122)
			elseif s == 2 then 
				npc.open_shop(123)
			elseif s == 3 then
				npc.open_shop(124)
			elseif s == 4 then
				npc.open_shop(125)
			elseif s == 5 then
				npc.open_shop(126)
			elseif s == 6 then
				npc.open_shop(127)
			end
			setskin(NOWINDOW)
		end
		
		when 7730.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("Krieger Rüstungen", "Ninja Rüstungen", "Sura Rüstungen", "Schamane Rüstungen", "Close")
			if s == 5 then return end
			if s == 1 then
				npc.open_shop(130)
			elseif s == 2 then 
				npc.open_shop(131)
			elseif s == 3 then
				npc.open_shop(132)
			elseif s == 4 then
				npc.open_shop(133)
			end
			setskin(NOWINDOW)
		end
		
		when 7731.click begin
			say_size(350,350)
			addimage(25, 10, "elendosfilesshop.tga");
			say("[ENTER][ENTER]")
			local s = select("Improvement", "Damage Boost", "Costumes (2)", "Costumes (3)", "Uppitems (1)", "Uppitems (2)", "Close")
			if s == 7 then return end
			if s == 1 then
				npc.open_shop(141)
			elseif s == 2 then 
				npc.open_shop(142)
			elseif s == 3 then 
				npc.open_shop(143)
			elseif s == 4 then 
				npc.open_shop(144)
			elseif s == 5 then 
				npc.open_shop(145)
			elseif s == 6 then 
				npc.open_shop(146)
			end
			setskin(NOWINDOW)
		end
	
		--[[when 9002.chat."Warrior Armors" begin
		say_size(350,350); addimage(25, 10, "shark_dungeon_bg1.tga"); addimage(220, 200, "shark_dungeon_npc1.tga")
			npc.open_shop(90) 
			setskin(NOWINDOW)
		end
		when 9002.chat."Ninja Armors" begin 
			npc.open_shop(91) 
			setskin(NOWINDOW)  
		end
		when 9002.chat."Sura Armors" begin 
			npc.open_shop(92) 
			setskin(NOWINDOW)  
		end
		when 9002.chat."Shaman Armors" begin 
			npc.open_shop(93) 
			setskin(NOWINDOW)
		end
		when 9002.chat."Jewelry/Shields/Helmets" begin 
			npc.open_shop(94) 
			setskin(NOWINDOW) 			
		end]]
	end 
end
