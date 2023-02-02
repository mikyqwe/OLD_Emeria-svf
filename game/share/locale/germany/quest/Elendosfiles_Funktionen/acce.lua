quest acce begin
	state start begin
		when 20406.chat."What is a Shoulder Strap?" begin
			say_title("-- "..mob_name(20406).." --")
			say("")
			say("You have two options with the Shoulder strap:")
			say("Combination and inclusion.")
			say("")
			say("You can only combine this between bands")
			say("of the same degree. Two combined bands")
			say("can make a high Shoulder strap.")
			say("")
			say("The shoulder strap takes over the bonuses when they")
			say("are admitted from a Weapon or Armor.")
			say("The recording rate (%) depends on the degree of manufacture")
			say("of the Shoulder strap. At the recording becomes")
			say("the weapon or armor completely destroyed.")
			say("")
		end
		
		when 20406.chat."Combine" begin
			say_title("-- "..mob_name(20406).." --")
			say("")
			say("Do you want to combine two bands?")
			say("")
			local confirm = select("Yes", "No")
			if confirm == 2 then
				return
			end
			
			setskin(NOWINDOW)
			pc.open_sash(true)
		end
		
		when 20406.chat."Admission of an object" begin
			say_title("-- "..mob_name(20406).." --")
			say("")
			say("Do you want the bonuses from your Weapon or Armor")
			say("take up in the Shoulder strap?")
			say("")
			local confirm = select("Yes", "No")
			if confirm == 2 then
				return
			end
			
			setskin(NOWINDOW)
			pc.open_sash(false)
		end
	end
end