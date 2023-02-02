quest GrowthPetSystem begin
	state start begin
		function get_pet_info(itemVnum)
			pet_info_map = {
			--  [ITEM VNUM] MOB_VNUM, DEFAULT NAME, buff_idx, spawn_effect_idx
				[55701]     = { 34041, "'s Kleiner Affe", 0},
				[55702]     = { 34043, "'s Kleine Spinne", 0},
				[55703]     = { 34045, "'s Kleiner Razador", 0},
				[55704]     = { 34047, "'s Kleiner Nemere", 0},
				[55705]     = { 34049, "'s Kleiner Drache", 0},
				[55706]     = { 34051, "'s Kleine Meleys", 0},
				[55707]     = { 34053, "'s Kleines Azraelchen", 0},
				[55708]     = { 34055, "'s Kleiner Henkerchen", 0},
				[55709]     = { 34057, "'s Kleiner Baashido", 0},
				[55710]     = { 34059, "'s Kleine Nessi", 0},
				
			}
			itemVnum = tonumber(itemVnum)
			return pet_info_map[itemVnum]
		end
		
		when 55701.use or 55702.use or 55703.use or 55704.use or 55705.use or 55706.use or 55707.use or 55708.use or 55709.use or 55710.use begin
			
			if item.get_socket(1) - get_time(0) <= 0 then
				--syschat(gameforge[get_language()].growth_pet_system.is_dead)
				return
			end
			
			if item.get_socket(4) >= pc.get_level() and pc.get_gm_level() <= 2 then
				--syschat(gameforge[get_language()].growth_pet_system.over_level)
				return
			end

			local pet_info = GrowthPetSystem.get_pet_info(item.vnum)

			if null != pet_info then

				local mobVnum = pet_info[1]
				local petName = pet_info[2]
	
				if true == newpet.is_summon(mobVnum) then
					-- if spawn_effect_file_name != nil then
						-- pet.spawn_effect(mobVnum, spawn_effect_file_name)
					-- end
					newpet.unsummon(mobVnum)
					pc.setqf("newpet_summoned_vnum", 0)
					pc.setqf("newpet_summoned_item_id", 0)
				else
					if newpet.count_summoned() == 0 and pc.getqf("newpet_summoned_vnum") == 0 then
						pc.setqf("newpet_summoned_vnum", mobVnum)
						pc.setqf("newpet_summoned_item_id", item.get_id())
						newpet.summon(mobVnum, petName, false)
					elseif newpet.count_summoned() == 0 and pc.getqf("newpet_summoned_vnum") > 0 then
						pc.setqf("newpet_summoned_vnum", 0)
						pc.setqf("newpet_summoned_item_id", 0)
						newpet.summon(mobVnum, petName, false)
					elseif newpet.count_summoned() == 1 and pc.getqf("newpet_summoned_vnum") > 0 then
						newpet.unsummon(pc.getqf("newpet_summoned_vnum"))
						pc.setqf("newpet_summoned_item_id", item.get_id())
						pc.setqf("newpet_summoned_vnum", mobVnum)
						newpet.summon(mobVnum, petName, false)
					end					
				end -- if pet.is_summon
			end  -- if null != pet_info
		end -- when
		
		when login with pc.getqf("newpet_summoned_vnum") != 0 and item.select(pc.getqf("newpet_summoned_item_id")) begin
			if item.get_socket(1) - get_time(0) <= 0 then
				pc.setqf("newpet_summoned_vnum", 0)
				pc.setqf("newpet_summoned_item_id", 0)
				--syschat(gameforge[get_language()].growth_pet_system.is_dead)
				return
			end
			
			if item.get_socket(4) >= pc.get_level() and pc.get_gm_level() <= 2 then
				pc.setqf("newpet_summoned_vnum", 0)
				pc.setqf("newpet_summoned_item_id", 0)
				--syschat(gameforge[get_language()].growth_pet_system.over_level)
				return
			end

			local pet_info = GrowthPetSystem.get_pet_info(item.vnum)
			
			if null != pet_info and newpet.count_summoned() == 0 then
				local mobVnum = pet_info[1]
				local petName = pet_info[2]

				pc.setqf("newpet_summoned_vnum", mobVnum)
				pc.setqf("newpet_summoned_item_id", item.get_id())
				timer("pet_summon", 5)
				chat("Your Pet will be spawned in a few seconds.")
				--newpet.summon(mobVnum, petName, false)
			end
		end
		
		when pet_summon.timer begin
			if item.select(pc.getqf("newpet_summoned_item_id")) then
				local pet_info = GrowthPetSystem.get_pet_info(item.vnum)
				if null != pet_info and newpet.count_summoned() == 0 then
					local mobVnum = pet_info[1]
					local petName = pet_info[2]
					newpet.summon(mobVnum, petName, false)
				end
			end
		end

	end
end