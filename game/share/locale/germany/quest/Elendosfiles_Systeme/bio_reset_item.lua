quest bio_reset_item begin
	state start begin
		function point_to_str(str, value)
			if str == "MOVE_SPEED" then
				return string.format("Movement speed +%d",value)
			elseif str == "ATTACK_SPEED" then
				return string.format("Attack speed +%d",value)
			elseif str == "DEF_BONUS" then
				return string.format("Defence +%d",value)
			elseif str == "ATT_BONUS" then
				return string.format("Attack Value +%d",value)
			elseif str == "RESIST_WARRIOR" then
				return string.format("Defence chance against warrior attacks: %d",value)
			elseif str == "RESIST_ASSASSIN" then
				return string.format("Defence chance against assassin attacks: %d",value)
			elseif str == "RESIST_SURA" then
				return string.format("Defence chance against sura attacks: %d",value)
			elseif str == "RESIST_SHAMAN" then
				return string.format("Defence chance against shaman attacks: %d",value)
			elseif str == "ATT_BONUS_TO_WARRIOR" then
				return string.format("Strong against Warrior %d",value)
			elseif str == "ATT_BONUS_TO_ASSASSIN" then
				return string.format("Strong against Assassin %d",value)
			elseif str == "ATT_BONUS_TO_SURA" then
				return string.format("Strong against Sura %d",value)
			elseif str == "ATT_BONUS_TO_SHAMAN" then
				return string.format("Strong against Shaman %d",value)
			elseif str == "MAX_HP" then
				return string.format("Max Hp +%d",value)
			else
				return string.format("None Bonus: %d",value)
			end
		end

		when 70028.use begin
			if pc.is_busy() then
				say_title(item_name(70028))
				say("")
				syschat("You can't do while another window is open.")
				return
			end

			local level = pc.getf("bio","level")
			if level == 0 then
				say_title(item_name(70028))
				say("")
				say("You don't have any task that you can change.")
				return
			end

			--if level > 10 then
			--	level = level -1
			--end

			local datalist = {}
			local select_list = {}

			for i = 1,level,1
			do 
				if i < level  then
					local index = bio_data[i][15]
					if index > 0 then
						table.insert(datalist,i)
					end
				end
			end

			local len = table.getn(datalist)
			if len == 0 then
				say_title(item_name(70028))
				say("")
				say("You don't have any task that you can change.")
				return
			else
				for i = 1, len, 1
				do
					table.insert(select_list,item_name(bio_data[datalist[i]][2]).."("..bio_data[datalist[i]][1]..")")
				end
				say_title(item_name(70028))
				say("")
				say("Click on the task you want to change the bonus for.")

				table.insert(select_list,"Cancel")
				local listofMissions = select_table(select_list)

				if listofMissions == table.getn(select_list) then
					return
				else
					local affect_list = {}
					local j = datalist[listofMissions]
					local oldBonus = pc.getf("bio",string.format("bonus%d",j))
					if oldBonus == 0 or oldBonus > 3 then
						return
					end
					say_title(item_name(70028))
					say("")
					if oldBonus == 1 then
						say(string.format("Your was get bonus in this task: %s",bio_reset_item.point_to_str(bio_data[j][7],bio_data[j][8])))
					end
					table.insert(affect_list, bio_reset_item.point_to_str(bio_data[j][7],bio_data[j][8]))
					if oldBonus == 2 then
						say(string.format("Your was get bonus in this task: %s",bio_reset_item.point_to_str(bio_data[j][9],bio_data[j][10])))
					end
					table.insert(affect_list, bio_reset_item.point_to_str(bio_data[j][9],bio_data[j][10]))
					if oldBonus == 3 then
						say(string.format("Your was get bonus in this task: %s",bio_reset_item.point_to_str(bio_data[j][11],bio_data[j][12])))
					end
					table.insert(affect_list, bio_reset_item.point_to_str(bio_data[j][11],bio_data[j][12]))
					table.insert(affect_list,"Cancel")
					local listofApply = select_table(affect_list)
					if listofApply == table.getn(affect_list) then
						return
					else
						if oldBonus == listofApply then
							say("You cannot choose the same bonus!")
							return
						end
						item.set_count(item.get_count()-1) -- remove item 1 count
						if oldBonus == 1 then
							affect.remove_aff_value(affect.str_to_apply(bio_data[j][7]),bio_data[j][8])
						elseif oldBonus == 2 then
							affect.remove_aff_value(affect.str_to_apply(bio_data[j][9]),bio_data[j][10])
						elseif oldBonus == 3 then
							affect.remove_aff_value(affect.str_to_apply(bio_data[j][11]),bio_data[j][12])
						end
						pc.setf("bio",string.format("bonus%d",j),listofApply)
						if listofApply == 1 then
							affect.add_collect(affect.str_to_apply(bio_data[j][7]),bio_data[j][8],60*60*24*7*3600)
							say(string.format("%s committed to your character.",bio_reset_item.point_to_str(bio_data[j][7],bio_data[j][8])))
						elseif listofApply == 2 then
							affect.add_collect(affect.str_to_apply(bio_data[j][9]),bio_data[j][10],60*60*24*7*3600)
							say(string.format("%s committed to your character.",bio_reset_item.point_to_str(bio_data[j][9],bio_data[j][10])))
							say(bio_reset_item.point_to_str(bio_data[j][9],bio_data[j][10]))
						elseif listofApply == 3 then
							affect.add_collect(affect.str_to_apply(bio_data[j][11]),bio_data[j][12],60*60*24*7*3600)
							say(string.format("%s committed to your character.",bio_reset_item.point_to_str(bio_data[j][11],bio_data[j][12])))
						end
					
					end
				end
			end
		end
	end
end


