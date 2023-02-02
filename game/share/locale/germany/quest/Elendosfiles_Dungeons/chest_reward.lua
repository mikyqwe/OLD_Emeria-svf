quest chest_reward begin
	state start begin
		when 50340.use begin
			local gold = number(1, 4)
			if gold == 1 then
				pc.change_gold(10000000)
			elseif gold == 3 then
				pc.change_gold(30000000)
			end
			
			local drop1vnum = {
									[1] = 27992,
									[2] = 27993,
									[3] = 27994
			}
			
			local drop1count = {
									[1] = 2,
									[2] = 2,
									[3] = 2
			}
			
			local drop1_chance = number(1, 5)
			if drop1_chance < 4 then
				pc.give_item2(drop1vnum[drop1_chance], drop1count[drop1_chance])
			end
			
			local drop2vnum = {
									[1] = 50513,
									[2] = 77264,
									[3] = 25041,
									[4] = 77263,
									[5] = 38056,
									[6] = 82120,
									[7] = 82121,
									[8] = 71051,
									[9] = 71052,
									[10] = 82106
			}
			
			local drop2count = {
									[1] = 5,
									[2] = 8,
									[3] = 10,
									[4] = 5,
									[5] = 10,
									[6] = 20,
									[7] = 15,
									[8] = 12,
									[9] = 2,
									[10] = 2,
									[11] = 2
			}
			
			local i = 1
			while i < 4 do
				local drop2_chance = number(1, 9)
				pc.give_item2(drop2vnum[drop2_chance], drop2count[drop2_chance])
				i = i + 1
			end
			
			local drop3vnum = {
									[1] = 12403,
									[2] = 12683,
									[3] = 12543,
									[4] = 12283,
									[5] = 25041
			}
			
			local drop3count = {
									[1] = 1,
									[2] = 1,
									[3] = 1,
									[4] = 1,
									[5] = 1
			}
			
			local j = 1
			while j < 3 do
				local upgrade = number(1, 3)
				local drop3_chance = number(1, 5)
				local item_vnum = drop3vnum[drop3_chance] + upgrade
				pc.give_item2(item_vnum, drop3count[drop3_chance])
				j = j + 1
			end
			
			pc.remove_item(50340, 1)
		end
		
		when 50341.use begin
			local gold = number(1, 4)
			if gold == 1 then
				pc.change_gold(10000000)
			elseif gold == 3 then
				pc.change_gold(30000000)
			end
			
			local drop1vnum = {
									[1] = 27992,
									[2] = 27993,
									[3] = 27994
			}
			
			local drop1count = {
									[1] = 2,
									[2] = 2,
									[3] = 2
			}
			
			local drop1_chance = number(1, 5)
			if drop1_chance < 4 then
				pc.give_item2(drop1vnum[drop1_chance], drop1count[drop1_chance])
			end
			
			local drop2vnum = {
									[1] = 50513,
									[2] = 77264,
									[3] = 25041,
									[4] = 77263,
									[5] = 38056,
									[6] = 82120,
									[7] = 82121,
									[8] = 71051,
									[9] = 71052,
									[10] = 82106
			}
			
			local drop2count = {
									[1] = 5,
									[2] = 8,
									[3] = 10,
									[4] = 5,
									[5] = 10,
									[6] = 20,
									[7] = 15,
									[8] = 12,
									[9] = 2,
									[10] = 2,
									[11] = 2
			}
			
			local i = 1
			while i < 4 do
				local drop2_chance = number(1, 9)
				pc.give_item2(drop2vnum[drop2_chance], drop2count[drop2_chance])
				i = i + 1
			end
			
			local drop3vnum = {
									[1] = 15413,
									[2] = 15433,
									[3] = 15373,
									[4] = 15393,
									[5] = 25041
			}
			
			local drop3count = {
									[1] = 1,
									[2] = 1,
									[3] = 1,
									[4] = 1,
									[5] = 1
			}
			
			local j = 1
			while j < 3 do
				local upgrade = number(1, 3)
				local drop3_chance = number(1, 5)
				local item_vnum = drop3vnum[drop3_chance] + upgrade
				pc.give_item2(item_vnum, drop3count[drop3_chance])
				j = j + 1
			end
			
			pc.remove_item(50341, 1)
		end
    end
end