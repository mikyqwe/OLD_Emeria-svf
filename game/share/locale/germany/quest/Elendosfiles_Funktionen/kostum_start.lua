quest kostum_start begin
	state start begin
		when login begin
			if pc.getqf("first_step") == 0 then
				pc.setqf("first_step", 1)
				local items = { [0] = {  52354, 52357},	-- Krieger
						[1] = {  52354, 52355, 52356},	-- Ninja
						[2] = {  52354},	-- Sura
						[3] = {52358, 52359}}	-- Shaman
								
				for i = 1,4 do
					pc.give_item2(items[pc.job][i])			-- Locale Itms für die Rasse
				end
			end
		end
	end
end