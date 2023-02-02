-- Quest by Dynastie for Mystical2

quest autopull begin
    state start begin
        when login begin
			if pc.getqf("pull") == 1 then
				pc.setqf("pull", 0)
			end
			pc.delqf("pull_counter")
			pc.delqf("pull_toggle_count")
        end
        when 90027.use begin
			if pc.getqf("pull") == 0 then
				
				-- check toggle count
				local iPullToggler = pc.getqf("pull_toggle_count") + 1
				
				if iPullToggler < 5 then
					pc.setqf("pull_toggle_count", iPullToggler)
				else
					chat("Auto puller has been used too often. Please relog your character.")
					return
				end
				
				-- enable autopuller
				pc.setqf("pull", 1)
				pc.setqf("pull_counter", 1)
				
				chat("Automatically monster pull was activated")
				
				loop_timer("aggregate_monster", 3)
				pc.aggregate_monster()
			else
			
				-- disable autopuller
				pc.setqf("pull", 0)
				loop_timer("aggregate_monster", 0)
				chat("Automatically monster pull was disabled")
			end
        end
		
		when aggregate_monster.timer with pc.getqf("pull") == 1 begin
		
			-- aggregate monster if HP > 50%
			if pc.get_hp()/pc.get_max_hp() >= 0.5 then
				pc.aggregate_monster()
				
				local iPullCounter = pc.getqf("pull_counter") + 1
				pc.setqf("pull_counter", iPullCounter)
				
				if iPullCounter > 500 then
					pc.setqf("pull", 0)
					notice("Automatically monster pull is exhausted and has been disabled")
				end
			end
		end
    end
end