-----WICHTIG!!!!-----
--ES DARF KEIN BONUS 2x mit dem gleichen Wert vorkommen!!!--
-- BONI BEZEICHNUNGEN IN 'questlib.lua' UNTER 'apply = {' ZU FINDEN

define bonus_01 ATT_SPEED
define bstep_01 2

define bonus_02 CON
define bstep_02 2

define bonus_03 RESIST_MAGIC
define bstep_03 2

define bonus_04 STR
define bstep_04 2

define bonus_05 ATT_GRADE_BONUS
define bstep_05 10

define bonus_06 DEX
define bstep_06 2

define bonus_07 CRITICAL_PCT
define bstep_07 2

define bonus_08 PENETRATE_PCT
define bstep_08 2

define bonus_09 MAX_HP
define bstep_09 250

define bonus_10 SKILL_DAMAGE_BONUS
define bstep_10 1

define bonus_11 NORMAL_HIT_DAMAGE_BONUS
define bstep_11 1

define bonus_12 INT
define bstep_12 2

define bonus_13 MAX_HP_PCT
define bstep_13 10

define bonus_14 BLOCK
define bstep_14 2

define bonus_15 POISON_PCT
define bstep_15 1

define permanent 60*60*24*365*60

quest talenttree begin
	state start begin
		when login begin
			cmdchat(string.format("TALENTTREE_V1 SET_QUEST_ID(%d)", q.getcurrentquestindex()))
			if pc.getqf("skilltree_first_login") == 0 then
				pc.setqf("skilltree_first_login", 1)
				pc.setqf("skill_01", 1) pc.setqf("skill_02", 1) pc.setqf("skill_03", 1) pc.setqf("skill_04", 1) pc.setqf("skill_05", 1)
				pc.setqf("skill_06", 1) pc.setqf("skill_07", 1) pc.setqf("skill_08", 1) pc.setqf("skill_09", 1) pc.setqf("skill_10", 1)
				pc.setqf("skill_11", 1) pc.setqf("skill_12", 1) pc.setqf("skill_13", 1) pc.setqf("skill_14", 1) pc.setqf("skill_15", 1)
			end
		end
		
		when 50056.use begin
			if pc.is_gm() then
				get_skill_01 = pc.getqf("skill_01") get_skill_06 = pc.getqf("skill_06") get_skill_11 = pc.getqf("skill_11")
				get_skill_02 = pc.getqf("skill_02") get_skill_07 = pc.getqf("skill_07") get_skill_12 = pc.getqf("skill_12")
				get_skill_03 = pc.getqf("skill_03") get_skill_08 = pc.getqf("skill_08") get_skill_13 = pc.getqf("skill_13")
				get_skill_04 = pc.getqf("skill_04") get_skill_09 = pc.getqf("skill_09") get_skill_14 = pc.getqf("skill_14")
				get_skill_05 = pc.getqf("skill_05") get_skill_10 = pc.getqf("skill_10") get_skill_15 = pc.getqf("skill_15")
				rm_skill_01 = get_skill_01*(bstep_01) - (bstep_01)
				rm_skill_02 = get_skill_02*(bstep_02) - (bstep_02)
				rm_skill_03 = get_skill_03*(bstep_03) - (bstep_03)
				rm_skill_04 = get_skill_04*(bstep_04) - (bstep_04)
				rm_skill_05 = get_skill_05*(bstep_05) - (bstep_05)
				rm_skill_06 = get_skill_06*(bstep_06) - (bstep_06)
				rm_skill_07 = get_skill_07*(bstep_07) - (bstep_07)
				rm_skill_08 = get_skill_08*(bstep_08) - (bstep_08)
				rm_skill_09 = get_skill_09*(bstep_09) - (bstep_09)
				rm_skill_10 = get_skill_10*(bstep_10) - (bstep_10)
				rm_skill_11 = get_skill_11*(bstep_11) - (bstep_11)
				rm_skill_12 = get_skill_12*(bstep_12) - (bstep_12)
				rm_skill_13 = get_skill_13*(bstep_13) - (bstep_13)
				rm_skill_14 = get_skill_14*(bstep_14) - (bstep_14)
				rm_skill_15 = get_skill_15*(bstep_15) - (bstep_15)
				say_title("What do you want to do?")
				local s = select("Reset points", "All skills at MAX", "Cancel")
				if 1 == s then
					affect.remove_collect(apply.bonus_01, rm_skill_01, (permanent))
					affect.remove_collect(apply.bonus_02, rm_skill_02, (permanent))
					affect.remove_collect(apply.bonus_03, rm_skill_03, (permanent))
					affect.remove_collect(apply.bonus_04, rm_skill_04, (permanent))
					affect.remove_collect(apply.bonus_05, rm_skill_05, (permanent))
					affect.remove_collect(apply.bonus_06, rm_skill_06, (permanent))
					affect.remove_collect(apply.bonus_07, rm_skill_07, (permanent))
					affect.remove_collect(apply.bonus_08, rm_skill_08, (permanent))
					affect.remove_collect(apply.bonus_09, rm_skill_09, (permanent))
					affect.remove_collect(apply.bonus_10, rm_skill_10, (permanent))
					affect.remove_collect(apply.bonus_11, rm_skill_11, (permanent))
					affect.remove_collect(apply.bonus_12, rm_skill_12, (permanent))
					affect.remove_collect(apply.bonus_13, rm_skill_13, (permanent))
					affect.remove_collect(apply.bonus_14, rm_skill_14, (permanent))
					affect.remove_collect(apply.bonus_15, rm_skill_15, (permanent))
					talenttree.ResetAll()
					syschat("Du hast deine Punkte zurückgesetzt.")
				elseif 2 == s then
					affect.remove_collect(apply.bonus_01, rm_skill_01, (permanent))
					affect.remove_collect(apply.bonus_02, rm_skill_02, (permanent))
					affect.remove_collect(apply.bonus_03, rm_skill_03, (permanent))
					affect.remove_collect(apply.bonus_04, rm_skill_04, (permanent))
					affect.remove_collect(apply.bonus_05, rm_skill_05, (permanent))
					affect.remove_collect(apply.bonus_06, rm_skill_06, (permanent))
					affect.remove_collect(apply.bonus_07, rm_skill_07, (permanent))
					affect.remove_collect(apply.bonus_08, rm_skill_08, (permanent))
					affect.remove_collect(apply.bonus_09, rm_skill_09, (permanent))
					affect.remove_collect(apply.bonus_10, rm_skill_10, (permanent))
					affect.remove_collect(apply.bonus_11, rm_skill_11, (permanent))
					affect.remove_collect(apply.bonus_12, rm_skill_12, (permanent))
					affect.remove_collect(apply.bonus_13, rm_skill_13, (permanent))
					affect.remove_collect(apply.bonus_14, rm_skill_14, (permanent))
					affect.remove_collect(apply.bonus_15, rm_skill_15, (permanent))
					talenttree.BaumVoll()
				end
			else
				talenttree.ResetAll()
				syschat("You have reset your Skill Points.")
			end
		end
		
		when logout begin
			talenttree.Logout()
		end
		
		when login begin
			talenttree.LoadAll()
		end
		
		when 63720.use begin --Item vnum
			local s = select ("Get Skill Point", "Cancel")
			if 1 == s then
				talenttree.LevelUp()
				pc.remove_item(63720, 1)
			end
		end
		
		-- when levelup begin
			-- talenttree.LevelUp()
		-- end
		
		-- when levelup with pc.is_gm() begin
			-- local gm_level = pc.get_level()
			-- pc.setf("talent_tree", "current_points", gm_level-1)
			-- cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
		-- end

		when button begin
			local cmd = talenttree.split_(talenttree.getinput("TALENTTREE_V1 GET_QUEST_CMD()"), "/")
			local t_points = pc.getf("talent_tree", "current_points")
			local t_skill_01_points  = pc.getf("skill_01", "skill_01_points")
			local t_skill_02_points  = pc.getf("skill_02", "skill_02_points")
			local t_skill_03_points  = pc.getf("skill_03", "skill_03_points")
			local t_skill_04_points  = pc.getf("skill_04", "skill_04_points")
			local t_skill_05_points  = pc.getf("skill_05", "skill_05_points")
			local t_skill_06_points  = pc.getf("skill_06", "skill_06_points")
			local t_skill_07_points  = pc.getf("skill_07", "skill_07_points")
			local t_skill_08_points  = pc.getf("skill_08", "skill_08_points")
			local t_skill_09_points  = pc.getf("skill_09", "skill_09_points")
			local t_skill_10_points  = pc.getf("skill_10", "skill_10_points")
			local t_skill_11_points  = pc.getf("skill_11", "skill_11_points")
			local t_skill_12_points  = pc.getf("skill_12", "skill_12_points")
			local t_skill_13_points  = pc.getf("skill_13", "skill_13_points")
			local t_skill_14_points  = pc.getf("skill_14", "skill_14_points")
			local t_skill_15_points  = pc.getf("skill_15", "skill_15_points")
			skill_lv_01 = pc.getqf("skill_01")	step_01 = (bstep_01) * skill_lv_01	remove_step_01 = step_01 - (bstep_01)
			skill_lv_02 = pc.getqf("skill_02")	step_02 = (bstep_02) * skill_lv_02	remove_step_02 = step_02 - (bstep_02)
			skill_lv_03 = pc.getqf("skill_03")	step_03 = (bstep_03) * skill_lv_03	remove_step_03 = step_03 - (bstep_03)
			skill_lv_04 = pc.getqf("skill_04")	step_04 = (bstep_04) * skill_lv_04	remove_step_04 = step_04 - (bstep_04)
			skill_lv_05 = pc.getqf("skill_05")	step_05 = (bstep_05) * skill_lv_05	remove_step_05 = step_05 - (bstep_05)
			skill_lv_06 = pc.getqf("skill_06")	step_06 = (bstep_06) * skill_lv_06	remove_step_06 = step_06 - (bstep_06)
			skill_lv_07 = pc.getqf("skill_07")	step_07 = (bstep_07) * skill_lv_07	remove_step_07 = step_07 - (bstep_07)
			skill_lv_08 = pc.getqf("skill_08")	step_08 = (bstep_08) * skill_lv_08	remove_step_08 = step_08 - (bstep_08)
			skill_lv_09 = pc.getqf("skill_09")	step_09 = (bstep_09) * skill_lv_09	remove_step_09 = step_09 - (bstep_09)
			skill_lv_10 = pc.getqf("skill_10")	step_10 = (bstep_10) * skill_lv_10	remove_step_10 = step_10 - (bstep_10)
			skill_lv_11 = pc.getqf("skill_11")	step_11 = (bstep_11) * skill_lv_11	remove_step_11 = step_11 - (bstep_11)
			skill_lv_12 = pc.getqf("skill_12")	step_12 = (bstep_12) * skill_lv_12	remove_step_12 = step_12 - (bstep_12)
			skill_lv_13 = pc.getqf("skill_13")	step_13 = (bstep_13) * skill_lv_13	remove_step_13 = step_13 - (bstep_13)
			skill_lv_14 = pc.getqf("skill_14")	step_14 = (bstep_14) * skill_lv_14	remove_step_14 = step_14 - (bstep_14)
			skill_lv_15 = pc.getqf("skill_15")	step_15 = (bstep_15) * skill_lv_15	remove_step_15 = step_15 - (bstep_15)
			
			if cmd[1] == "TALENT_UP_01" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_01", "skill_01_points") < 5 then
						if pc.getqf("skill_01") > 1 then
							talenttree.bonus01_remove()
						end
						talenttree.bonus01_give()
						cmdchat("SKILLUP_BUTTON_01 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_01", "skill_01_points", t_skill_01_points+1)
						pc.setqf("skill_01", skill_lv_01+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_01 "..pc.getf("skill_01", "skill_01_points").."")
						if pc.getf("skill_01", "skill_01_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_01 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_01", "skill_01_points") == 5 and pc.getf("skill_02", "skill_02_points") == 5 then
						if pc.getf("skill_06", "skill_06_points") < 5 then
							cmdchat("SKILLUP_BUTTON_06 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
------------------------------------------------------------------------------------------
			if cmd[1] == "TALENT_UP_02" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_02", "skill_02_points") < 5 then
						if pc.getqf("skill_02") > 1 then
							talenttree.bonus02_remove()
						end
						talenttree.bonus02_give()
						cmdchat("SKILLUP_BUTTON_02 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_02", "skill_02_points", t_skill_02_points+1)
						pc.setqf("skill_02", skill_lv_02+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_02 "..pc.getf("skill_02", "skill_02_points").."")
						if pc.getf("skill_02", "skill_02_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_02 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_02", "skill_02_points") == 5 and pc.getf("skill_01", "skill_01_points") == 5 then
						if pc.getf("skill_06", "skill_06_points") < 5 then
							cmdchat("SKILLUP_BUTTON_06 1")
						end
					end
					
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_02", "skill_02_points") == 5 and pc.getf("skill_03", "skill_03_points") == 5 then
						if pc.getf("skill_07", "skill_07_points") < 5 then
							cmdchat("SKILLUP_BUTTON_07 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_03" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_03", "skill_03_points") < 5 then
						if pc.getqf("skill_03") > 1 then
							talenttree.bonus03_remove()
						end
						talenttree.bonus03_give()
						cmdchat("SKILLUP_BUTTON_03 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_03", "skill_03_points", t_skill_03_points+1)
						pc.setqf("skill_03", skill_lv_03+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_03 "..pc.getf("skill_03", "skill_03_points").."")
						if pc.getf("skill_03", "skill_03_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_03 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_03", "skill_03_points") == 5 and pc.getf("skill_02", "skill_02_points") == 5 then
						if pc.getf("skill_07", "skill_07_points") < 5 then
							cmdchat("SKILLUP_BUTTON_07 1")
						end
					end
					
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_03", "skill_03_points") == 5 and pc.getf("skill_04", "skill_04_points") == 5 then
						if pc.getf("skill_08", "skill_08_points") < 5 then
							cmdchat("SKILLUP_BUTTON_08 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_04" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_04", "skill_04_points") < 5 then
						if pc.getqf("skill_04") > 1 then
							talenttree.bonus04_remove()
						end
						talenttree.bonus04_give()
						cmdchat("SKILLUP_BUTTON_04 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_04", "skill_04_points", t_skill_04_points+1)
						pc.setqf("skill_04", skill_lv_04+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_04 "..pc.getf("skill_04", "skill_04_points").."")
						if pc.getf("skill_04", "skill_04_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_04 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_04", "skill_04_points") == 5 and pc.getf("skill_03", "skill_03_points") == 5 then
						if pc.getf("skill_08", "skill_08_points") < 5 then
							cmdchat("SKILLUP_BUTTON_08 1")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_04", "skill_04_points") == 5 and pc.getf("skill_05", "skill_05_points") == 5 then
						if pc.getf("skill_09", "skill_09_points") < 5 then
							cmdchat("SKILLUP_BUTTON_09 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_05" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_05", "skill_05_points") < 5 then
						if pc.getqf("skill_05") > 1 then
							talenttree.bonus05_remove()
						end
						talenttree.bonus05_give()
						cmdchat("SKILLUP_BUTTON_05 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_05", "skill_05_points", t_skill_05_points+1)
						pc.setqf("skill_05", skill_lv_05+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_05 "..pc.getf("skill_05", "skill_05_points").."")
						if pc.getf("skill_05", "skill_05_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_05 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_05", "skill_05_points") == 5 and pc.getf("skill_04", "skill_04_points") == 5 then
						if pc.getf("skill_09", "skill_09_points") < 5 then
							cmdchat("SKILLUP_BUTTON_09 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_06" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_06", "skill_06_points") < 5 then
						if pc.getqf("skill_06") > 1 then
							talenttree.bonus06_remove()
						end
						talenttree.bonus06_give()
						cmdchat("SKILLUP_BUTTON_06 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_06", "skill_06_points", t_skill_06_points+1)
						pc.setqf("skill_06", skill_lv_06+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_06 "..pc.getf("skill_06", "skill_06_points").."")
						if pc.getf("skill_06", "skill_06_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_06 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_06", "skill_06_points") == 5 and pc.getf("skill_07", "skill_07_points") == 5 then
						if pc.getf("skill_10", "skill_10_points") < 5 then
							cmdchat("SKILLUP_BUTTON_10 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_07" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_07", "skill_07_points") < 5 then
						if pc.getqf("skill_07") > 1 then
							talenttree.bonus02_remove()
						end
						talenttree.bonus07_give()
						cmdchat("SKILLUP_BUTTON_07 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_07", "skill_07_points", t_skill_07_points+1)
						pc.setqf("skill_07", skill_lv_07+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_07 "..pc.getf("skill_07", "skill_07_points").."")
						if pc.getf("skill_07", "skill_07_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_07 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_07", "skill_07_points") == 5 and pc.getf("skill_08", "skill_08_points") == 5 then
						if pc.getf("skill_19", "skill_19_points") < 5 then
							cmdchat("SKILLUP_BUTTON_11 1")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_07", "skill_07_points") == 5 and pc.getf("skill_06", "skill_06_points") == 5 then
						if pc.getf("skill_10", "skill_10_points") < 5 then
							cmdchat("SKILLUP_BUTTON_10 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_08" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_08", "skill_08_points") < 5 then
						if pc.getqf("skill_08") > 1 then
							talenttree.bonus08_remove()
						end
						talenttree.bonus08_give()
						cmdchat("SKILLUP_BUTTON_08 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_08", "skill_08_points", t_skill_08_points+1)
						pc.setqf("skill_08", skill_lv_08+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_08 "..pc.getf("skill_08", "skill_08_points").."")
						if pc.getf("skill_08", "skill_08_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_08 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_08", "skill_08_points") == 5 and pc.getf("skill_09", "skill_09_points") == 5 then
						if pc.getf("skill_12", "skill_12_points") < 5 then
							cmdchat("SKILLUP_BUTTON_12 1")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_08", "skill_08_points") == 5 and pc.getf("skill_07", "skill_07_points") == 5 then
						if pc.getf("skill_11", "skill_11_points") < 5 then
							cmdchat("SKILLUP_BUTTON_11 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_09" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_09", "skill_09_points") < 5 then
						if pc.getqf("skill_09") > 1 then
							talenttree.bonus09_remove()
						end
						talenttree.bonus09_give()
						cmdchat("SKILLUP_BUTTON_09 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_09", "skill_09_points", t_skill_09_points+1)
						pc.setqf("skill_09", skill_lv_09+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_09 "..pc.getf("skill_09", "skill_09_points").."")
						if pc.getf("skill_09", "skill_09_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_09 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_09", "skill_09_points") == 5 and pc.getf("skill_08", "skill_08_points") == 5 then
						if pc.getf("skill_12", "skill_12_points") < 5 then
							cmdchat("SKILLUP_BUTTON_12 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_10" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_10", "skill_10_points") < 5 then
						if pc.getqf("skill_10") > 1 then
							talenttree.bonus10_remove()
						end
						talenttree.bonus10_give()
						cmdchat("SKILLUP_BUTTON_10 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_10", "skill_10_points", t_skill_10_points+1)
						pc.setqf("skill_10", skill_lv_10+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_10 "..pc.getf("skill_10", "skill_10_points").."")
						if pc.getf("skill_10", "skill_10_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_10 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_10", "skill_10_points") == 5 and pc.getf("skill_11", "skill_11_points") == 5 then
						if pc.getf("skill_14", "skill_14_points") < 5 then
							cmdchat("SKILLUP_BUTTON_14 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_11" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_11", "skill_11_points") < 5 then
						if pc.getqf("skill_11") > 1 then
							talenttree.bonus11_remove()
						end
						talenttree.bonus11_give()
						cmdchat("SKILLUP_BUTTON_11 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_11", "skill_11_points", t_skill_11_points+1)
						pc.setqf("skill_11", skill_lv_11+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_11 "..pc.getf("skill_11", "skill_11_points").."")
						if pc.getf("skill_11", "skill_11_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_11 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_11", "skill_11_points") == 5 and pc.getf("skill_12", "skill_12_points") == 5 then
						if pc.getf("skill_14", "skill_14_points") < 5 then
							cmdchat("SKILLUP_BUTTON_14 1")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_11", "skill_11_points") == 5 and pc.getf("skill_10", "skill_10_points") == 5 then
						if pc.getf("skill_13", "skill_13_points") < 5 then
							cmdchat("SKILLUP_BUTTON_13 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_12" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_12", "skill_12_points") < 5 then
						if pc.getqf("skill_12") > 1 then
							talenttree.bonus12_remove()
						end
						talenttree.bonus12_give()
						cmdchat("SKILLUP_BUTTON_12 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_12", "skill_12_points", t_skill_12_points+1)
						pc.setqf("skill_12", skill_lv_12+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_12 "..pc.getf("skill_12", "skill_12_points").."")
						if pc.getf("skill_12", "skill_12_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_12 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_12", "skill_12_points") == 5 and pc.getf("skill_11", "skill_11_points") == 5 then
						if pc.getf("skill_14", "skill_14_points") < 5 then
							cmdchat("SKILLUP_BUTTON_14 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_13" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_13", "skill_13_points") < 5 then
						if pc.getqf("skill_13") > 1 then
							talenttree.bonus13_remove()
						end
						talenttree.bonus13_give()
						cmdchat("SKILLUP_BUTTON_13 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_13", "skill_13_points", t_skill_13_points+1)
						pc.setqf("skill_13", skill_lv_13+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_13 "..pc.getf("skill_13", "skill_13_points").."")
						if pc.getf("skill_13", "skill_13_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_13 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_13", "skill_13_points") == 5 and pc.getf("skill_14", "skill_14_points") == 5 then
						if pc.getf("skill_15", "skill_15_points") < 5 then
							cmdchat("SKILLUP_BUTTON_15 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_14" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_14", "skill_14_points") < 5 then
						if pc.getqf("skill_14") > 1 then
							talenttree.bonus14_remove()
						end
						talenttree.bonus14_give()
						cmdchat("SKILLUP_BUTTON_14 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_14", "skill_14_points", t_skill_14_points+1)
						pc.setqf("skill_14", skill_lv_14+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_14 "..pc.getf("skill_14", "skill_14_points").."")
						if pc.getf("skill_14", "skill_14_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_14 0")
						end
					end
					if pc.getf("talent_tree", "current_points") > 0 and pc.getf("skill_14", "skill_14_points") == 5 and pc.getf("skill_13", "skill_13_points") == 5 then
						if pc.getf("skill_15", "skill_15_points") < 5 then
							cmdchat("SKILLUP_BUTTON_15 1")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
			if cmd[1] == "TALENT_UP_15" then
				if pc.getf("talent_tree", "current_points") > 0 then
					if pc.getf("skill_15", "skill_15_points") < 5 then
						if pc.getqf("skill_15") > 1 then
							talenttree.bonus15_remove()
						end
						talenttree.bonus15_give()
						cmdchat("SKILLUP_BUTTON_15 1")
						pc.setf("talent_tree", "current_points", t_points-1)
						pc.setf("skill_15", "skill_15_points", t_skill_15_points+1)
						pc.setqf("skill_15", skill_lv_15+1)
						cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
						cmdchat("SkillValue_15 "..pc.getf("skill_15", "skill_15_points").."")
						if pc.getf("skill_15", "skill_15_points") >= 5 then
							cmdchat("SKILLUP_BUTTON_15 0")
						end
					end
					if pc.getf("talent_tree", "current_points") < 1 then
						talenttree.AllButtonZero()
					end
				end
			end
		end
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
		function Logout()
			cmdchat("SKILL_LEARNED_01 0")
			cmdchat("SKILL_LEARNED_02 0")
			cmdchat("SKILL_LEARNED_03 0")
			cmdchat("SKILL_LEARNED_04 0")
			cmdchat("SKILL_LEARNED_05 0")
			cmdchat("SKILL_LEARNED_06 0")
			cmdchat("SKILL_LEARNED_07 0")
			cmdchat("SKILL_LEARNED_08 0")
			cmdchat("SKILL_LEARNED_09 0")
			cmdchat("SKILL_LEARNED_10 0")
			cmdchat("SKILL_LEARNED_11 0")
			cmdchat("SKILL_LEARNED_12 0")
			cmdchat("SKILL_LEARNED_13 0")
			cmdchat("SKILL_LEARNED_14 0")
			cmdchat("SKILL_LEARNED_15 0")
			cmdchat("SKILLUP_BUTTON_01 0")
			cmdchat("SKILLUP_BUTTON_02 0")
			cmdchat("SKILLUP_BUTTON_03 0")
			cmdchat("SKILLUP_BUTTON_04 0")
			cmdchat("SKILLUP_BUTTON_05 0")
			cmdchat("SKILLUP_BUTTON_06 0")
			cmdchat("SKILLUP_BUTTON_07 0")
			cmdchat("SKILLUP_BUTTON_08 0")
			cmdchat("SKILLUP_BUTTON_09 0")
			cmdchat("SKILLUP_BUTTON_10 0")
			cmdchat("SKILLUP_BUTTON_11 0")
			cmdchat("SKILLUP_BUTTON_12 0")
			cmdchat("SKILLUP_BUTTON_13 0")
			cmdchat("SKILLUP_BUTTON_14 0")
			cmdchat("SKILLUP_BUTTON_15 0")
		end

		function LevelUp()
			if pc.get_level() == 1 then
				pc.setf("talent_tree", "current_points", 0)
				cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
				cmdchat("SKILLUP_BUTTON_01 0")
				cmdchat("SKILLUP_BUTTON_02 0")
				cmdchat("SKILLUP_BUTTON_03 0")
				cmdchat("SKILLUP_BUTTON_04 0")
				cmdchat("SKILLUP_BUTTON_05 0")
			else
				local t_points = pc.getf("talent_tree", "current_points")
				pc.setf("talent_tree", "current_points", t_points+1)
				cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
				if pc.getf("skill_01", "skill_01_points") < 5 then
					cmdchat("SKILLUP_BUTTON_01 1")
				end
				if pc.getf("skill_02", "skill_02_points") < 5 then
					cmdchat("SKILLUP_BUTTON_02 1")
				end
				if pc.getf("skill_03", "skill_03_points") < 5 then
					cmdchat("SKILLUP_BUTTON_03 1")
				end
				if pc.getf("skill_04", "skill_04_points") < 5 then
					cmdchat("SKILLUP_BUTTON_04 1")
				end
				if pc.getf("skill_05", "skill_05_points") < 5 then
					cmdchat("SKILLUP_BUTTON_05 1")
				end
	----------------------------------------------------------------------------
				if pc.getf("skill_01", "skill_01_points") == 5 and pc.getf("skill_02", "skill_02_points") == 5 and pc.getf("skill_06", "skill_06_points") < 5 then
					cmdchat("SKILLUP_BUTTON_06 1")
				end
				if pc.getf("skill_02", "skill_02_points") == 5 and pc.getf("skill_03", "skill_03_points") == 5 and pc.getf("skill_07", "skill_07_points") < 5 then
					cmdchat("SKILLUP_BUTTON_07 1")
				end
				if pc.getf("skill_03", "skill_03_points") == 5 and pc.getf("skill_04", "skill_04_points") == 5 and pc.getf("skill_08", "skill_08_points") < 5 then
					cmdchat("SKILLUP_BUTTON_08 1")
				end
				if pc.getf("skill_04", "skill_04_points") == 5 and pc.getf("skill_05", "skill_05_points") == 5 and pc.getf("skill_09", "skill_09_points")< 5 then
					cmdchat("SKILLUP_BUTTON_09 1")
				end
				-------------
				if pc.getf("skill_06", "skill_06_points") == 5 and pc.getf("skill_07", "skill_07_points") == 5 and pc.getf("skill_10", "skill_10_points")< 5 then
					cmdchat("SKILLUP_BUTTON_10 1")
				end
				if pc.getf("skill_07", "skill_07_points") == 5 and pc.getf("skill_08", "skill_08_points") == 5 and pc.getf("skill_11", "skill_11_points")< 5 then
					cmdchat("SKILLUP_BUTTON_11 1")
				end
				if pc.getf("skill_08", "skill_08_points") == 5 and pc.getf("skill_09", "skill_09_points") == 5 and pc.getf("skill_12", "skill_12_points")< 5 then
					cmdchat("SKILLUP_BUTTON_12 1")
				end
				-------------
				if pc.getf("skill_10", "skill_10_points") == 5 and pc.getf("skill_11", "skill_11_points") == 5 and pc.getf("skill_13", "skill_13_points")< 5 then
					cmdchat("SKILLUP_BUTTON_13 1")
				end
				if pc.getf("skill_11", "skill_11_points") == 5 and pc.getf("skill_12", "skill_12_points") == 5 and pc.getf("skill_14", "skill_14_points")< 5 then
					cmdchat("SKILLUP_BUTTON_14 1")
				end
				-------------
				if pc.getf("skill_13", "skill_13_points") == 5 and pc.getf("skill_14", "skill_14_points") == 5 and pc.getf("skill_15", "skill_15_points")< 5 then
					cmdchat("SKILLUP_BUTTON_15 1")
				end
			end
		end

		function LoadAll()
			cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
			cmdchat("SkillValue_01 "..pc.getf("skill_01", "skill_01_points").."")
			cmdchat("SkillValue_02 "..pc.getf("skill_02", "skill_02_points").."")
			cmdchat("SkillValue_03 "..pc.getf("skill_03", "skill_03_points").."")
			cmdchat("SkillValue_04 "..pc.getf("skill_04", "skill_04_points").."")
			cmdchat("SkillValue_05 "..pc.getf("skill_05", "skill_05_points").."")
			cmdchat("SkillValue_06 "..pc.getf("skill_06", "skill_06_points").."")
			cmdchat("SkillValue_07 "..pc.getf("skill_07", "skill_07_points").."")
			cmdchat("SkillValue_08 "..pc.getf("skill_08", "skill_08_points").."")
			cmdchat("SkillValue_09 "..pc.getf("skill_09", "skill_09_points").."")
			cmdchat("SkillValue_10 "..pc.getf("skill_10", "skill_10_points").."")
			cmdchat("SkillValue_11 "..pc.getf("skill_11", "skill_11_points").."")
			cmdchat("SkillValue_12 "..pc.getf("skill_12", "skill_12_points").."")
			cmdchat("SkillValue_13 "..pc.getf("skill_13", "skill_13_points").."")
			cmdchat("SkillValue_14 "..pc.getf("skill_14", "skill_14_points").."")
			cmdchat("SkillValue_15 "..pc.getf("skill_15", "skill_15_points").."")
			if pc.getf("talent_tree", "current_points") > 0 then
				if pc.getf("skill_01", "skill_01_points") < 5 then
					cmdchat("SKILLUP_BUTTON_01 1")
				else
					cmdchat("SKILLUP_BUTTON_01 0")
				end
				if pc.getf("skill_02", "skill_02_points") < 5 then
					cmdchat("SKILLUP_BUTTON_02 1")
				else
					cmdchat("SKILLUP_BUTTON_02 0")
				end
				if pc.getf("skill_03", "skill_03_points") < 5 then
					cmdchat("SKILLUP_BUTTON_03 1")
				else
					cmdchat("SKILLUP_BUTTON_03 0")
				end
				if pc.getf("skill_04", "skill_04_points") < 5 then
					cmdchat("SKILLUP_BUTTON_04 1")
				else
					cmdchat("SKILLUP_BUTTON_04 0")
				end
				if pc.getf("skill_05", "skill_05_points") < 5 then
					cmdchat("SKILLUP_BUTTON_05 1")
				else
					cmdchat("SKILLUP_BUTTON_05 0")
				end
				if pc.getf("skill_06", "skill_06_points") < 5 then
					if pc.getf("skill_01", "skill_01_points") > 4 and pc.getf("skill_02", "skill_02_points") > 4 then
						cmdchat("SKILLUP_BUTTON_06 1")
					else
						cmdchat("SKILLUP_BUTTON_06 0")
					end
				end
				if pc.getf("skill_07", "skill_07_points") < 5 then
					if pc.getf("skill_02", "skill_02_points") > 4 and pc.getf("skill_03", "skill_03_points") > 4 then
						cmdchat("SKILLUP_BUTTON_07 1")
					else
						cmdchat("SKILLUP_BUTTON_07 0")
					end
				end
				if pc.getf("skill_08", "skill_08_points") < 5 then
					if pc.getf("skill_03", "skill_03_points") > 4 and pc.getf("skill_04", "skill_04_points") > 4 then
						cmdchat("SKILLUP_BUTTON_08 1")
					else
						cmdchat("SKILLUP_BUTTON_08 0")
					end
				end
				if pc.getf("skill_09", "skill_09_points") < 5 then
					if pc.getf("skill_04", "skill_04_points") > 4 and pc.getf("skill_05", "skill_05_points") > 4 then
						cmdchat("SKILLUP_BUTTON_09 1")
					else
						cmdchat("SKILLUP_BUTTON_09 0")
					end
				end
				if pc.getf("skill_10", "skill_10_points") < 5 then
					if pc.getf("skill_06", "skill_06_points") > 4 and pc.getf("skill_07", "skill_07_points") > 4 then
						cmdchat("SKILLUP_BUTTON_10 1")
					else
						cmdchat("SKILLUP_BUTTON_10 0")
					end
				end
				if pc.getf("skill_11", "skill_11_points") < 5 then
					if pc.getf("skill_07", "skill_07_points") > 4 and pc.getf("skill_08", "skill_08_points") > 4 then
						cmdchat("SKILLUP_BUTTON_11 1")
					else
						cmdchat("SKILLUP_BUTTON_11 0")
					end
				end
				if pc.getf("skill_12", "skill_12_points") < 5 then
					if pc.getf("skill_08", "skill_08_points") > 4 and pc.getf("skill_09", "skill_09_points") > 4 then
						cmdchat("SKILLUP_BUTTON_12 1")
					else
						cmdchat("SKILLUP_BUTTON_12 0")
					end
				end
				if pc.getf("skill_13", "skill_13_points") < 5 then
					if pc.getf("skill_10", "skill_10_points") > 4 and pc.getf("skill_11", "skill_11_points") > 4 then
						cmdchat("SKILLUP_BUTTON_13 1")
					else
						cmdchat("SKILLUP_BUTTON_13 0")
					end
				end
				if pc.getf("skill_14", "skill_14_points") < 5 then
					if pc.getf("skill_11", "skill_11_points") > 4 and pc.getf("skill_12", "skill_12_points") > 4 then
						cmdchat("SKILLUP_BUTTON_14 1")
					else
						cmdchat("SKILLUP_BUTTON_14 0")
					end
				end
				if pc.getf("skill_15", "skill_15_points") < 5 then
					if pc.getf("skill_13", "skill_13_points") > 4 and pc.getf("skill_14", "skill_14_points") > 4 then
						cmdchat("SKILLUP_BUTTON_15 1")
					else
						cmdchat("SKILLUP_BUTTON_15 0")
					end
				end
			end
			if pc.getf("talent_tree", "current_points") < 1 then
				cmdchat("SKILLUP_BUTTON_01 0")
				cmdchat("SKILLUP_BUTTON_02 0")
				cmdchat("SKILLUP_BUTTON_03 0")
				cmdchat("SKILLUP_BUTTON_04 0")
				cmdchat("SKILLUP_BUTTON_05 0")
			end
			if pc.getf("skill_01", "skill_01_points") > 0 then
				cmdchat("SKILL_LEARNED_01 1")
			end
			if pc.getf("skill_02", "skill_02_points") > 0 then
				cmdchat("SKILL_LEARNED_02 1")
			end
			if pc.getf("skill_03", "skill_03_points") > 0 then
				cmdchat("SKILL_LEARNED_03 1")
			end
			if pc.getf("skill_04", "skill_04_points") > 0 then
				cmdchat("SKILL_LEARNED_04 1")
			end
			if pc.getf("skill_05", "skill_05_points") > 0 then
				cmdchat("SKILL_LEARNED_05 1")
			end
			if pc.getf("skill_06", "skill_06_points") > 0 then
				cmdchat("SKILL_LEARNED_06 1")
			end
			if pc.getf("skill_07", "skill_07_points") > 0 then
				cmdchat("SKILL_LEARNED_07 1")
			end
			if pc.getf("skill_08", "skill_08_points") > 0 then
				cmdchat("SKILL_LEARNED_08 1")
			end
			if pc.getf("skill_09", "skill_09_points") > 0 then
				cmdchat("SKILL_LEARNED_09 1")
			end
			if pc.getf("skill_10", "skill_10_points") > 0 then
				cmdchat("SKILL_LEARNED_10 1")
			end
			if pc.getf("skill_11", "skill_11_points") > 0 then
				cmdchat("SKILL_LEARNED_11 1")
			end
			if pc.getf("skill_12", "skill_12_points") > 0 then
				cmdchat("SKILL_LEARNED_12 1")
			end
			if pc.getf("skill_13", "skill_13_points") > 0 then
				cmdchat("SKILL_LEARNED_13 1")
			end
			if pc.getf("skill_14", "skill_14_points") > 0 then
				cmdchat("SKILL_LEARNED_14 1")
			end
			if pc.getf("skill_15", "skill_15_points") > 0 then
				cmdchat("SKILL_LEARNED_15 1")
			end
		end
		
		function ResetAll()
			pc.setqf("skill_01", 1) pc.setqf("skill_02", 1) pc.setqf("skill_03", 1) pc.setqf("skill_04", 1) pc.setqf("skill_05", 1)
			pc.setqf("skill_06", 1) pc.setqf("skill_07", 1) pc.setqf("skill_08", 1) pc.setqf("skill_09", 1) pc.setqf("skill_10", 1)
			pc.setqf("skill_11", 1) pc.setqf("skill_12", 1) pc.setqf("skill_13", 1) pc.setqf("skill_14", 1) pc.setqf("skill_15", 1)
			pc.setf("skill_01", "skill_01_points", 0)
			pc.setf("skill_02", "skill_02_points", 0)
			pc.setf("skill_03", "skill_03_points", 0)
			pc.setf("skill_04", "skill_04_points", 0)
			pc.setf("skill_05", "skill_05_points", 0)
			pc.setf("skill_06", "skill_06_points", 0)
			pc.setf("skill_07", "skill_07_points", 0)
			pc.setf("skill_08", "skill_08_points", 0)
			pc.setf("skill_09", "skill_09_points", 0)
			pc.setf("skill_10", "skill_10_points", 0)
			pc.setf("skill_11", "skill_11_points", 0)
			pc.setf("skill_12", "skill_12_points", 0)
			pc.setf("skill_13", "skill_13_points", 0)
			pc.setf("skill_14", "skill_14_points", 0)
			pc.setf("skill_15", "skill_15_points", 0)
			cmdchat("SkillValue_01 "..pc.getf("skill_01", "skill_01_points").."")
			cmdchat("SkillValue_02 "..pc.getf("skill_02", "skill_02_points").."")
			cmdchat("SkillValue_03 "..pc.getf("skill_03", "skill_03_points").."")
			cmdchat("SkillValue_04 "..pc.getf("skill_04", "skill_04_points").."")
			cmdchat("SkillValue_05 "..pc.getf("skill_05", "skill_05_points").."")
			cmdchat("SkillValue_06 "..pc.getf("skill_06", "skill_06_points").."")
			cmdchat("SkillValue_07 "..pc.getf("skill_07", "skill_07_points").."")
			cmdchat("SkillValue_08 "..pc.getf("skill_08", "skill_08_points").."")
			cmdchat("SkillValue_09 "..pc.getf("skill_09", "skill_09_points").."")
			cmdchat("SkillValue_10 "..pc.getf("skill_10", "skill_10_points").."")
			cmdchat("SkillValue_11 "..pc.getf("skill_11", "skill_11_points").."")
			cmdchat("SkillValue_12 "..pc.getf("skill_12", "skill_12_points").."")
			cmdchat("SkillValue_13 "..pc.getf("skill_13", "skill_13_points").."")
			cmdchat("SkillValue_14 "..pc.getf("skill_14", "skill_14_points").."")
			cmdchat("SkillValue_15 "..pc.getf("skill_15", "skill_15_points").."")
			cmdchat("SKILL_LEARNED_01 0")
			cmdchat("SKILL_LEARNED_02 0")
			cmdchat("SKILL_LEARNED_03 0")
			cmdchat("SKILL_LEARNED_04 0")
			cmdchat("SKILL_LEARNED_05 0")
			cmdchat("SKILL_LEARNED_06 0")
			cmdchat("SKILL_LEARNED_07 0")
			cmdchat("SKILL_LEARNED_08 0")
			cmdchat("SKILL_LEARNED_09 0")
			cmdchat("SKILL_LEARNED_10 0")
			cmdchat("SKILL_LEARNED_11 0")
			cmdchat("SKILL_LEARNED_12 0")
			cmdchat("SKILL_LEARNED_13 0")
			cmdchat("SKILL_LEARNED_14 0")
			cmdchat("SKILL_LEARNED_15 0")
			pc.setf("talent_tree", "current_points", pc.get_level()-1)
			cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
			if pc.getf("talent_tree", "current_points") > 0 then
				cmdchat("SKILLUP_BUTTON_01 1")
				cmdchat("SKILLUP_BUTTON_02 1")
				cmdchat("SKILLUP_BUTTON_03 1")
				cmdchat("SKILLUP_BUTTON_04 1")
				cmdchat("SKILLUP_BUTTON_05 1")
				cmdchat("SKILLUP_BUTTON_06 0")
				cmdchat("SKILLUP_BUTTON_07 0")
				cmdchat("SKILLUP_BUTTON_08 0")
				cmdchat("SKILLUP_BUTTON_09 0")
				cmdchat("SKILLUP_BUTTON_10 0")
				cmdchat("SKILLUP_BUTTON_11 0")
				cmdchat("SKILLUP_BUTTON_12 0")
				cmdchat("SKILLUP_BUTTON_13 0")
				cmdchat("SKILLUP_BUTTON_14 0")
				cmdchat("SKILLUP_BUTTON_15 0")
			end
		end
		
		
		
		function AllButtonZero()
			cmdchat("SKILLUP_BUTTON_01 0")
			cmdchat("SKILLUP_BUTTON_02 0")
			cmdchat("SKILLUP_BUTTON_03 0")
			cmdchat("SKILLUP_BUTTON_04 0")
			cmdchat("SKILLUP_BUTTON_05 0")
			cmdchat("SKILLUP_BUTTON_06 0")
			cmdchat("SKILLUP_BUTTON_07 0")
			cmdchat("SKILLUP_BUTTON_08 0")
			cmdchat("SKILLUP_BUTTON_09 0")
			cmdchat("SKILLUP_BUTTON_10 0")
			cmdchat("SKILLUP_BUTTON_11 0")
			cmdchat("SKILLUP_BUTTON_12 0")
			cmdchat("SKILLUP_BUTTON_13 0")
			cmdchat("SKILLUP_BUTTON_14 0")
			cmdchat("SKILLUP_BUTTON_15 0")
		end
		
		function BaumVoll()
			pc.setqf("skill_01", 6) pc.setqf("skill_02", 6) pc.setqf("skill_03", 6) pc.setqf("skill_04", 6) pc.setqf("skill_05", 6)
			pc.setqf("skill_06", 6) pc.setqf("skill_07", 6) pc.setqf("skill_08", 6) pc.setqf("skill_09", 6) pc.setqf("skill_10", 6)
			pc.setqf("skill_11", 6) pc.setqf("skill_12", 6) pc.setqf("skill_13", 6) pc.setqf("skill_14", 6) pc.setqf("skill_15", 6)
			pc.setf("skill_01", "skill_01_points", 5)
			pc.setf("skill_02", "skill_02_points", 5)
			pc.setf("skill_03", "skill_03_points", 5)
			pc.setf("skill_04", "skill_04_points", 5)
			pc.setf("skill_05", "skill_05_points", 5)
			pc.setf("skill_06", "skill_06_points", 5)
			pc.setf("skill_07", "skill_07_points", 5)
			pc.setf("skill_08", "skill_08_points", 5)
			pc.setf("skill_09", "skill_09_points", 5)
			pc.setf("skill_10", "skill_10_points", 5)
			pc.setf("skill_11", "skill_11_points", 5)
			pc.setf("skill_12", "skill_12_points", 5)
			pc.setf("skill_13", "skill_13_points", 5)
			pc.setf("skill_14", "skill_14_points", 5)
			pc.setf("skill_15", "skill_15_points", 5)
			cmdchat("SkillValue_01 "..pc.getf("skill_01", "skill_01_points").."")
			cmdchat("SkillValue_02 "..pc.getf("skill_02", "skill_02_points").."")
			cmdchat("SkillValue_03 "..pc.getf("skill_03", "skill_03_points").."")
			cmdchat("SkillValue_04 "..pc.getf("skill_04", "skill_04_points").."")
			cmdchat("SkillValue_05 "..pc.getf("skill_05", "skill_05_points").."")
			cmdchat("SkillValue_06 "..pc.getf("skill_06", "skill_06_points").."")
			cmdchat("SkillValue_07 "..pc.getf("skill_07", "skill_07_points").."")
			cmdchat("SkillValue_08 "..pc.getf("skill_08", "skill_08_points").."")
			cmdchat("SkillValue_09 "..pc.getf("skill_09", "skill_09_points").."")
			cmdchat("SkillValue_10 "..pc.getf("skill_10", "skill_10_points").."")
			cmdchat("SkillValue_11 "..pc.getf("skill_11", "skill_11_points").."")
			cmdchat("SkillValue_12 "..pc.getf("skill_12", "skill_12_points").."")
			cmdchat("SkillValue_13 "..pc.getf("skill_13", "skill_13_points").."")
			cmdchat("SkillValue_14 "..pc.getf("skill_14", "skill_14_points").."")
			cmdchat("SkillValue_15 "..pc.getf("skill_15", "skill_15_points").."")
			cmdchat("SKILL_LEARNED_01 1")
			cmdchat("SKILL_LEARNED_02 1")
			cmdchat("SKILL_LEARNED_03 1")
			cmdchat("SKILL_LEARNED_04 1")
			cmdchat("SKILL_LEARNED_05 1")
			cmdchat("SKILL_LEARNED_06 1")
			cmdchat("SKILL_LEARNED_07 1")
			cmdchat("SKILL_LEARNED_08 1")
			cmdchat("SKILL_LEARNED_09 1")
			cmdchat("SKILL_LEARNED_10 1")
			cmdchat("SKILL_LEARNED_11 1")
			cmdchat("SKILL_LEARNED_12 1")
			cmdchat("SKILL_LEARNED_13 1")
			cmdchat("SKILL_LEARNED_14 1")
			cmdchat("SKILL_LEARNED_15 1")
			cmdchat("SKILLUP_BUTTON_01 0")
			cmdchat("SKILLUP_BUTTON_02 0")
			cmdchat("SKILLUP_BUTTON_03 0")
			cmdchat("SKILLUP_BUTTON_04 0")
			cmdchat("SKILLUP_BUTTON_05 0")
			cmdchat("SKILLUP_BUTTON_06 0")
			cmdchat("SKILLUP_BUTTON_07 0")
			cmdchat("SKILLUP_BUTTON_08 0")
			cmdchat("SKILLUP_BUTTON_09 0")
			cmdchat("SKILLUP_BUTTON_10 0")
			cmdchat("SKILLUP_BUTTON_11 0")
			cmdchat("SKILLUP_BUTTON_12 0")
			cmdchat("SKILLUP_BUTTON_13 0")
			cmdchat("SKILLUP_BUTTON_14 0")
			cmdchat("SKILLUP_BUTTON_15 0")
			pc.setf("talent_tree", "current_points", 0)
			cmdchat("SendCurrentPoints "..pc.getf("talent_tree", "current_points").."")
			max_level_per_skill = 5
			multi_01 = (bstep_01)*max_level_per_skill
			multi_02 = (bstep_02)*max_level_per_skill
			multi_03 = (bstep_03)*max_level_per_skill
			multi_04 = (bstep_04)*max_level_per_skill
			multi_05 = (bstep_05)*max_level_per_skill
			multi_06 = (bstep_06)*max_level_per_skill
			multi_07 = (bstep_07)*max_level_per_skill
			multi_08 = (bstep_08)*max_level_per_skill
			multi_09 = (bstep_09)*max_level_per_skill
			multi_10 = (bstep_10)*max_level_per_skill
			multi_11 = (bstep_11)*max_level_per_skill
			multi_12 = (bstep_12)*max_level_per_skill
			multi_13 = (bstep_13)*max_level_per_skill
			multi_14 = (bstep_14)*max_level_per_skill
			multi_15 = (bstep_15)*max_level_per_skill
			affect.add_collect(apply.bonus_01, multi_01, (permanent))
			affect.add_collect(apply.bonus_02, multi_02, (permanent))
			affect.add_collect(apply.bonus_03, multi_03, (permanent))
			affect.add_collect(apply.bonus_04, multi_04, (permanent))
			affect.add_collect(apply.bonus_05, multi_05, (permanent))
			affect.add_collect(apply.bonus_06, multi_06, (permanent))
			affect.add_collect(apply.bonus_07, multi_07, (permanent))
			affect.add_collect(apply.bonus_08, multi_08, (permanent))
			affect.add_collect(apply.bonus_09, multi_09, (permanent))
			affect.add_collect(apply.bonus_10, multi_10, (permanent))
			affect.add_collect(apply.bonus_11, multi_11, (permanent))
			affect.add_collect(apply.bonus_12, multi_12, (permanent))
			affect.add_collect(apply.bonus_13, multi_13, (permanent))
			affect.add_collect(apply.bonus_14, multi_14, (permanent))
			affect.add_collect(apply.bonus_15, multi_15, (permanent))
		end
		
		function bonus01_give()
			affect.add_collect(apply.bonus_01, step_01, (permanent))
		end
		function bonus02_give()
			affect.add_collect(apply.bonus_02, step_02, (permanent))
		end
		function bonus03_give()
			affect.add_collect(apply.bonus_03, step_03, (permanent))
		end
		function bonus04_give()
			affect.add_collect(apply.bonus_04, step_04, (permanent))
		end
		function bonus05_give()
			affect.add_collect(apply.bonus_05, step_05, (permanent))
		end
		function bonus06_give()
			affect.add_collect(apply.bonus_06, step_06, (permanent))
		end
		function bonus07_give()
			affect.add_collect(apply.bonus_07, step_07, (permanent))
		end
		function bonus08_give()
			affect.add_collect(apply.bonus_08, step_08, (permanent))
		end
		function bonus09_give()
			affect.add_collect(apply.bonus_09, step_09, (permanent))
		end
		function bonus10_give()
			affect.add_collect(apply.bonus_10, step_10, (permanent))
		end
		function bonus11_give()
			affect.add_collect(apply.bonus_11, step_11, (permanent))
		end
		function bonus12_give()
			affect.add_collect(apply.bonus_12, step_12, (permanent))
		end
		function bonus13_give()
			affect.add_collect(apply.bonus_13, step_13, (permanent))
		end
		function bonus14_give()
			affect.add_collect(apply.bonus_14, step_14, (permanent))
		end
		function bonus15_give()
			affect.add_collect(apply.bonus_15, step_15, (permanent))
		end
		
		function bonus01_remove()
			affect.remove_collect(apply.bonus_01, remove_step_01, (permanent))
		end
		function bonus02_remove()
			affect.remove_collect(apply.bonus_02, remove_step_02, (permanent))
		end
		function bonus03_remove()
			affect.remove_collect(apply.bonus_03, remove_step_03, (permanent))
		end
		function bonus04_remove()
			affect.remove_collect(apply.bonus_04, remove_step_04, (permanent))
		end
		function bonus05_remove()
			affect.remove_collect(apply.bonus_05, remove_step_05, (permanent))
		end
		function bonus06_remove()
			affect.remove_collect(apply.bonus_06, remove_step_06, (permanent))
		end
		function bonus07_remove()
			affect.remove_collect(apply.bonus_07, remove_step_07, (permanent))
		end
		function bonus08_remove()
			affect.remove_collect(apply.bonus_08, remove_step_08, (permanent))
		end
		function bonus09_remove()
			affect.remove_collect(apply.bonus_09, remove_step_09, (permanent))
		end
		function bonus10_remove()
			affect.remove_collect(apply.bonus_10, remove_step_10, (permanent))
		end
		function bonus11_remove()
			affect.remove_collect(apply.bonus_11, remove_step_11, (permanent))
		end
		function bonus12_remove()
			affect.remove_collect(apply.bonus_12, remove_step_12, (permanent))
		end
		function bonus13_remove()
			affect.remove_collect(apply.bonus_13, remove_step_13, (permanent))
		end
		function bonus14_remove()
			affect.remove_collect(apply.bonus_14, remove_step_14, (permanent))
		end
		function bonus15_remove()
			affect.remove_collect(apply.bonus_15, remove_step_15, (permanent))
		end
		
		
		function getinput(par)
			cmdchat("GET_INPUT_BEGIN")
			local ret = input(cmdchat(par))
			cmdchat("GET_INPUT_END")
			return ret
		end

		function split_(string_, sep)
			local sep, fields = sep or ":", {}
			local pattern = string.format("([^%s]+)", sep)
			string.gsub(string_,pattern, function(c) fields[table.getn(fields)+1] = c end)
			return fields
		end
	end
end
