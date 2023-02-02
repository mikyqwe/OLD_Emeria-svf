quest shroppet begin
	state start begin
		when 62770.use begin
			if true == pet.is_summon(9014) then
					if spawn_effect_file_name != nil then
						pet.spawn_effect (9014, spawn_effect_file_name)
					end
					pet.summon(9015)
					pet.unsummon(9014)
					chat("Deine Händlerin wurde fortgeschickt.")
			end
			if true == pet.is_summon(9015) then
					if spawn_effect_file_name != nil then
						pet.spawn_effect (9015, spawn_effect_file_name)
					end
					pet.unsummon(9015)
					chat("Deine Händlerin wurde fortgeschickt.")
			else
			pet.summon(9015)
			chat("Deine Händlerin wurde gerufen.")
			end
		end
    end
end