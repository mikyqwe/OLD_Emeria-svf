quest costume begin
	state start begin
		when login begin
			cmdchat("costume "..q.getcurrentquestindex())
			if pc.getqf("costume") == 1 then
				pc.costume(1)
			end
		end
		when button or info begin
			if pc.getqf("costume") == 1 then
				pc.setqf("costume", 2)
				pc.costume(0)
			elseif pc.getqf("costume") == 2 then
				pc.setqf("costume", 1)
				pc.costume(1)
			end
		end
	end
end