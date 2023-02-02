function monarch_log(text)
	local f = io.open("data/monarch_log", "a")
	f:write(os.date("%d.%m.%Y %H:%M:%S")..":\t"..text.."\n")
	f:close()
end
function change_monarch_money(empire, dif)
	local f = io.open("data/monarch", "r")
	local save = {}
	for line in f:lines() do
		table.insert(save, split(line, "\t"))
	end
	f:close()
	local f = io.open("data/monarch", "w+")
	table.foreach(save,function(i,p)
		if tonumber(p[4])==empire then
			p[3]=tonumber(p[3])+dif			
		end
		f:write(p[1].."\t"..p[2].."\t"..p[3].."\t"..p[4].."\t"..p[5].."\n")
	end)
	f:close()
end
function get_monarch_data(empire)
	local res = {}
	local f = io.open("data/monarch", "r")
	for line in f:lines() do
		if line == "" then break end
		local dat = split(line, "\t")		
		if tonumber(dat[4]) == empire then
			-- Reich = Name, PID, Geld, Date 
			res = {["name"]=dat[1],["pid"]=tonumber(dat[2]),["money"]=tonumber(dat[3]),["date"]=dat[5]}
			break
		end
	end
	f:close()
	return res
end
function set_monarch(name, pid, empire)
	local f = io.open("data/monarch", "a+")
	f:write(name.."\t"..pid.."\t10000000\t"..empire.."\t"..os.date("%d.%m.%Y").."\n")
	f:close()
end
function clear_monarch()
	local f = io.open("data/monarch", "w+")
	f:close()
end
function is_monarch()
	local res = false
	local f = io.open("data/monarch", "r")
	for line in f:lines() do
		local dat = split(line, "\t")
		if tonumber(dat[2])==pc.get_player_id() then
			res = true
			break
		end
	end
	f:close()
	return res
end