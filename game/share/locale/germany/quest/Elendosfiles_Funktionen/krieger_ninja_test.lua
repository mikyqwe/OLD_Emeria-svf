quest krieger_ninja_test begin
	state start begin
		when login begin
			if pc.getqf("bonis_geben") == 0 then
				pc.setqf("bonis_geben", 1)

				if pc.job == 0 then
					pc.give_item2_select(3009, 1)
					item.set_attr(0, 15, 20) --- 1 Boni --- 20% Chance auf Kritsichen treffer
					item.set_attr(1, 16, 20) --- 2 Boni --- 20% Chance auf durchbohrenden treffer
					item.set_attr(2, 5, 20) ---  3 Boni --- 20% Stärke
					item.set_attr(3, 13, 10) --- 4 Boni --- 10% Chance auf Ohnmacht
					item.set_attr(4, 18, 30) --- 5 Boni ---  30% Stark gegen Tiere
				elseif pc.job == 1 then
					pc.give_item2_select(19, 1)
					item.set_attr(0, 15, 20) --- 1 Boni --- 20% Chance auf Kritsichen treffer
					item.set_attr(1, 16, 20) --- 2 Boni --- 20% Chance auf durchbohrenden treffer
					item.set_attr(2, 5, 20) ---  3 Boni --- 20% Stärke
					item.set_attr(3, 13, 10) --- 4 Boni --- 10% Chance auf Ohnmacht
					item.set_attr(4, 18, 30) --- 5 Boni ---  30% Stark gegen Tiere
					affect.add_collect_point(POINT_ATTBONUS_MONSTER, 10, 60*60*24*365*60)
				elseif pc.job == 2 then
					affect.add_collect_point(POINT_ATTBONUS_MONSTER, 10, 60*60*24*365*60)
				elseif pc.job == 3 then
					pc.give_item2_select(7009, 1)
					item.set_attr(0, 15, 20) --- 1 Boni --- 20% Chance auf Kritsichen treffer
					item.set_attr(1, 16, 20) --- 2 Boni --- 20% Chance auf durchbohrenden treffer
					item.set_attr(2, 4, 20) ---  3 Boni --- 20% Int
					item.set_attr(3, 13, 10) --- 4 Boni --- 10% Chance auf Ohnmacht
					item.set_attr(4, 18, 30) --- 5 Boni ---  30% Stark gegen Tiere
					affect.add_collect_point(POINT_ATTBONUS_MONSTER, 10, 60*60*24*365*60)
				end
			end
		end
	end
end