quest lottery_open_window begin
	state start begin		
		when 9013.click begin
			setskin(NOWINDOW)
			pc.open_lottery()
		end
	end
end