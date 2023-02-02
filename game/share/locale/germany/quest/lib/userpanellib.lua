support = {}
			
support.get_frag = function()
	say_title("Support")
	say("Wonach möchtest du suchen?")
	local i = input()
	if i=="" then support.ask_questions({}, {}) return end
	local q, a = support.generate_tab(i)
	support.ask_questions(q, a)
end

support.ask_questions = function(tab, answer)
	if table.getn(tab)==0 then
		say_title("Support")
		say("Die Suche hat keine Treffer ergeben.")
		return
	elseif table.getn(tab)~=table.getn(answer) then
		say_title("Support")
		say("Ein Fehler ist aufgetreten.")
		return
	end
	local s = support.sel(tab, "Es konnten folgende verwandte Themen[ENTER]gefunden werden.", "Support")
	say_title(tab[s])
	say(answer[s])
end

support.generate_tab = function(q)
	local ret, pos, blocked_character = {}, {}, {",", ".", "?", "!", "(", ")", "{", "}", "/"} --"\\", "\"", "\'" raus
	local s = {}
	--Suchparameter ändern
	if string.find(q, " ") then
		s = split(q, " ")
		for i=1, table.getn(s) do
			s[i] = string.lower(s[i])
		end
	else
		s = {string.lower(q)}
	end

	--Verbotene Zeichen blockieren
	table.foreach(s, function(i,p)
		if table_is_in(blocked_character, p) or table_is_in({37, 34, 39, 92, 91, 93, 96}, string.byte(q)) then
			return ret, pos
		end
	end)
	
	--[[Ohne berücksichtigung der Trefferanzahl
	table.foreach(ingame_support_questions, function(i,p)				
		local check = 0
		for j=1, table.getn(s) do
			if (string.find(string.lower(p[1]), s[j])~=nil or string.find(string.lower(p[2]), s[j])~=nil) and check=0 then
				table.insert(ret, p[1])
				table.insert(pos, p[2])
			end
		end
	end)
	return ret, pos]]
	
	--Trefferanzahl ermitteln
	local hits = {}
	table.foreach(ingame_support_questions, function(i,p)
		local t = 0
		for j=1, table.getn(s) do
			if string.find(string.lower(p[1]), s[j]) then
				t = t+1
			end
			if string.find(string.lower(p[2]), s[j]) then
				t = t+1
			end
		end
		if t>0 then
			table.insert(hits, (t*1000)+i) 
		end
	end)
	
	--Keine Treffer zurückgeben
	if table.getn(hits)==0 then 
		return ret, pos
	end

	--Rückgabearrays erzeugen
	table.sort(hits, function(a,b) return a>b end)
	table.foreach(hits, function(i,p)
		local key = p-math.floor(p/1000)*1000
		table.insert(ret, ingame_support_questions[key][1])
		table.insert(pos, ingame_support_questions[key][2])
	end)
	return ret, pos
end

support.sel = function(tab, text, title)
	if table.getn(tab) < 6 then
		say_title(title)
		say(text)
		return select_table(tab)
	end
	local t, field  = {}, 1
	table.foreach(tab, function(i,p)
		if t[field]==nil then
			t[field] = {}
		end
		table.insert(t[field], p)
		if i==table.getn(tab) then 
			table.insert(t[field], "Zurück")
		end
		if math.floor(i/4) == math.ceil(i/4) then
			if i~=table.getn(tab) then
				table.insert(t[field], "Weiter")
			end
			if i~=4 and i~=table.getn(tab) then 
				table.insert(t[field], "Zurück")
			end
			field = field+1
		end	
	end)
	local ret,field = 0, 1
	repeat
		say_title(title)
		say(text)				
		local s = select_table(t[field])
		if t[field][s] == "Weiter" then
			field = field + 1
		elseif t[field][s] == "Zurück" then
			field = field - 1
		else
			ret = (field-1)*4 + s
		end
	until ret~=0
	return ret
end

support.make_sel = function(tab)
	local ret = {}
	table.foreach(tab, function(i,p) table.insert(ret, p[1]) end)
	table.insert(ret, "Abbrechen")
	return ret
end

