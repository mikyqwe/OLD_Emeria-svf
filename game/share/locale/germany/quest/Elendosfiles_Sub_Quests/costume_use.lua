quest login_costume_use begin
	state start begin
		when login with pc.getqf("block_quest") == 0 begin
			pc.setqf("block_quest", 1)
			pc.setf("costume", "costume", 1)
		end
	end
end