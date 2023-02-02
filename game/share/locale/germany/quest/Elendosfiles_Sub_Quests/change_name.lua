quest change_name begin
	state start begin
		when 71055.use begin	
			say_title(string.format("%s:[ENTER]", item_name(item.get_vnum())), 400, 400)
			if (party.is_party()) then
				return say_reward("You must leave your party first.");

			elseif (pc.has_guild()) then
				return say_reward("You must leave your guild first.");
			end -- if/elseif
			
			say("By continuing, you will be able to change your name.[ENTER]")
			say("Insert the name you like:[ENTER]")
			local new_name = input();
			say_title(string.format("%s:[ENTER]", item_name(item.get_vnum())))
			local ret = pc.change_name(new_name);
			if (ret == 0) then
				say_reward("The name change is already ongoing, relog first.[ENTER]")

			elseif (ret == 3) then
				say_reward("The inserted name is already in use by another player.[ENTER]")

			elseif (ret == 4) then
				pc.remove_item(71055, 1);
				say("The name has been changed successfully.");
				say("Relog to see the changes.[ENTER]");
			else
				say_reward("Function blocked for the current locale.[ENTER]");
			end -- if/elseif/else
		end -- when
	end -- state
end -- quest