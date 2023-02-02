quest krieger_ninja_test2 begin
	state start begin
		when login begin
			if pc.getqf("bonis_nochmal") == 0 then
				pc.setqf("bonis_nochmal", 1)

				if pc.job == 1 then
					pc.give_item2_select(2009, 1)
					item.set_attr(0, 15, 20) --- 1 Boni --- 20% Chance auf Kritsichen treffer
					item.set_attr(1, 16, 20) --- 2 Boni --- 20% Chance auf durchbohrenden treffer
					item.set_attr(2, 5, 20) ---  3 Boni --- 20% Stärke
					item.set_attr(3, 13, 10) --- 4 Boni --- 10% Chance auf Ohnmacht
					item.set_attr(4, 18, 30) --- 5 Boni ---  30% Stark gegen Tiere
				end
			end
		end
	end
end