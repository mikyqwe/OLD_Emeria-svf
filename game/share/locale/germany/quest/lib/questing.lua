print('Questlib by Mijago | 5.1.2012 - Happy new Year!')
ql   = {}
col  = {}
zt   = {}
proc = {}
do  -- Zur Nutzung auf Windoof | MySQL funktioniert auf Windoof nicht!
    local old_print = print
    if pc == nil then
        pc = {}
        pc.get_name = function() return '-name-' end
        pc.count_item = function() return 200 end
        pc.remove_item = function() return end
        pc.remove_item2 = pc.remove_item
        pc.give_item = function(i,l) print('<GiveItem>',i,l) end
        pc.give_item2 = pc.give_item
        pc.get_map_index = function() return 1 end
        pc.get_local_y = function() return 200 end
        pc.get_local_x = function() return 400 end
    end
    if cmdchat == nil then
        cmdchat = function() old_print('<cmdchat>') end 
    end
    if wait == nil then
        wait = function () old_print('<wait>') end
    end
    if input == nil then
        input = function () old_print('<input>'); return 101 end
    end
    if say == nil then
        say = function (txt) old_print('<say>',txt) end
    end
    if chat == nil then
        chat = function (txt) old_print('<Chat>',txt) end
    end
    if notice == nil then
        notice = function (txt) old_print('<notice>',txt) end
    end
    if setbg == nil then
        setbg = function (txt) old_print('<setbg>',txt) end
    end
    if say_size == nil then
        say_size = function (a,b) old_print('<say_size>',a,b) end
    end
    if notice_all == nil then
        notice_all = function (txt) old_print('<notice_all>',txt) end
    end
    if game == nil then
        game = {}
        game.set_event_flag = function(a,b) print('<game.set_event_flag>',a,b) end 
    end
    if select == nil then
        select = function(s) old_print('<select>',s); return 1 end
    end
end
doit = os.execute
ql.mysql = {
    ["user"] = "root",
    ["pass"] = "",
    ["ip"] = "localhost",
}
-------------------------------------------------------------------------------
--
function select2(tab1)
    local tab = tab1
    local max = tab[1]; table.remove(tab,1)
    local tablen,outputstr,outputcount,nextc,incit = table.getn(tab),"",0,0,0
    table.foreach(tab,
        function(i,l)
            outputcount = outputcount + 1
            if outputcount == 1 then
                outputstr=outputstr..'sel = select("'..l..'"'
            elseif outputcount == max and tablen > outputcount+incit  then
                if tablen ~= outputcount+incit+1 then
                    outputstr=outputstr..',"'..l..'","Nächste Seite") + '..incit..' '
                    if nextc > 0 then
                        outputstr = outputstr..'end '
                    end
                    outputstr=outputstr..'; if sel == '..(incit+max+1)..' then '        -- Anfangen der neuen Abfrage
                    nextc, outputcount, incit= nextc+1,0,incit+max
                else
                    outputstr=outputstr..',"'..l..'"'
                end
            else
                outputstr=outputstr..',"'..l..'"'
            end
        end
    )
    outputstr = outputstr..') + '..incit
    if nextc > 0 then
        outputstr = outputstr..' end'
    end
    outputstr= outputstr.. '; return sel'
    print(outputstr)
    local sel = assert(loadstring(outputstr))()
    tablen,outputstr,outputcount,nextc,incit = nil,nil,nil,nil,nil -- Speicher freimachen
    return sel
end

function arraytoselect(arr,abbr)
    local d = 'sel = select('
    local i = 0
    for i=1,getn(arr),1 do
        d = d..'\\"'..arr[i]..'\\",'
        if abbr ~= nil then 
            if i == getn(arr) then
                d = d..'\\"'..abbr..'\\"'
            end
        end
    end
    d = d..")\\nreturn sel"
    return assert(loadstring(d))()
end
function dostr(str)
    assert(loadstring(str))()
end
-------------------------------------------------------------------------------
-- Veränderte Lua-Funktionen
do
    local old_tonumber = tonumber
    tonumber = function(str)
        if old_tonumber(str) == nil then
            return 0,false
        else
            return old_tonumber(str),true
        end
    end
end
-------------------------------------------------------------------------------
-- Datenspeicherung
function writelog(text,var,file)
    if var == nil then
        var = 1
    end
    if var == 1 then
        local data = io.open('syserr','a+')
        data:write(os.date()..'::\t'..text.."\n")
        data:close()
    elseif var == 2 then
        local data = io.open('syslog','a+')
        data:write(os.date()..'::\t'..text.."\n")
        data:close()
    elseif var == 3 then
        local data = io.open(file,'a+')
        data:write(os.date()..'::\t'..text.."\n")
        data:close()
    end
end
function watch_table(tab)
    local meta,myname,tabn = {},pc.get_name(),tostring(tab)
    local lo = function(typ,index,wert) writelog(tabn..' - '..myname..': '..typ..' ['..index..'] = '..wert,3,'tables') end
    meta.__newindex = function(ta,index,wert)
            --writelog(tabn..' - '..myname..': Newindex ['..index..'] = '..wert,3,'tables')
            lo('newindex',index,wert)
            rawset(ta,index,wert)
        end
    meta.__index = function(ta,index,wert)
            lo('index',index,wert)
            error('Fehlerhafter Zugriff bei '..index)
        end
    meta.__call = function(ta,index,wert)
            lo('call',index,wert)
        end
    setmetatable(tab, meta)
end
-------------------------------------------------------------------------------
-- PCI
pci = {}
function pci:new(name)
  local out = {}
  if name == nil then
    name = pc.get_name()
  end
  local info = mysql_query("SELECT * FROM player.player WHERE name = \'"..name.."\' LIMIT 1",ql.mysql["user"],ql.mysql["pass"],ql.mysql["ip"])
  local reich = mysql_query("select player_index.empire FROM player.player INNER JOIN player.player_index ON player.account_id = player_index.id WHERE player.name = '"..pc.get_name().."'",ql.mysql["user"],ql.mysql["pass"],ql.mysql["ip"])
  out.name = name
  out.level = info.level[1]
  out.playtime = info.playtime[1]
  out.job = info.job[1]
  out.account_id = info.account_id[1]
  out.id = info.id[1]
  out.voice = info.voice[1]
  out.dir = info.dir[1]
  out.x = info.x[1]
  out.y = info.y[1]
  out.z = info.z[1]
  out.map_index = info.map_index[1]
  out.exit_y = info.exit_y[1]
  out.exit_x = info.exit_x[1]
  out.exit_map_index = info.exit_map_index[1]
  out.hp = info.hp[1]
  out.mp = info.mp[1]
  out.stamina = info.stamina[1]
  out.random_hp = info.random_hp[1]
  out.random_sp = info.random_sp[1]
  out.level_step = info.level_step[1]
  out.st = info.st[1]
  out.ht = info.ht[1]
  out.dx = info.dx[1]
  out.iq = info.iq[1]
  out.exp= info.exp[1]
  out.gold = info.gold[1]
  out.stat_point = info.stat_point[1]
  out.skill_point = info.skill_point[1]
  out.ip = info.ip[1]
  out.part_main = info.part_main[1]
  out.part_hair = info.part_hair[1]
  out.skill_group = info.skill_group[1]
  out.last_play = info.last_play[1]
  out.alignment = info.alignment[1]
  out.change_name = info.change_name[1]
  out.sub_skill_point = info.sub_skill_point[1]
  out.horse_skill_point = info.horse_skill_point[1]
  out.horse_riding = info.horse_riding[1]
  out.horse_hp_droptime = info.horse_hp_droptime[1]
  out.horse_level = info.horse_level[1]
  out.horse_stamina = info.horse_stamina[1]
  out.horse_hp = info.horse_hp[1]
  out.stat_reset_count = info.stat_reset_count[1]
  out.empire = reich.empire[1]
  setmetatable(out, { __index = pci }) 
  print('Daten für '..name..' erfolgreich geladen!')
  return out
end
function pci:update()
  local info = mysql_query("SELECT * FROM player.player WHERE name = \'"..self.name.."\' LIMIT 1",ql.mysql["user"],ql.mysql["pass"],ql.mysql["ip"])
  self.level = info.level[1]
  self.playtime = info.playtime[1]
  self.job = info.job[1]
  self.account_id = info.account_id[1]
  self.id = info.id[1]
  self.voice = info.voice[1]
  self.dir = info.dir[1]
  self.x = info.x[1]
  self.y = info.y[1]
  self.z = info.z[1]
  self.map_index = info.map_index[1]
  self.exit_y = info.exit_y[1]
  self.exit_x = info.exit_x[1]
  self.exit_map_index = info.exit_map_index[1]
  self.hp = info.hp[1]
  self.mp = info.mp[1]
  self.stamina = info.stamina[1]
  self.random_hp = info.random_hp[1]
  self.random_sp = info.random_sp[1]
  self.level_step = info.level_step[1]
  self.st = info.st[1]
  self.ht = info.ht[1]
  self.dx = info.dx[1]
  self.iq = info.iq[1]
  self.exp= info.exp[1]
  self.gold = info.gold[1]
  self.stat_point = info.stat_point[1]
  self.skill_point = info.skill_point[1]
  self.ip = info.ip[1]
  self.part_main = info.part_main[1]
  self.part_hair = info.part_hair[1]
  self.skill_group = info.skill_group[1]
  self.last_play = info.last_play[1]
  self.alignment = info.alignment[1]
  self.change_name = info.change_name[1]
  self.sub_skill_point = info.sub_skill_point[1]
  self.horse_skill_point = info.horse_skill_point[1]
  self.horse_riding = info.horse_riding[1]
  self.horse_hp_droptime = info.horse_hp_droptime[1]
  self.horse_level = info.horse_level[1]
  self.horse_stamina = info.horse_stamina[1]
  self.horse_hp = info.horse_hp[1]
  self.stat_reset_count = info.stat_reset_count[1]
  print('Daten für '..self.name..' erfolgreich geupdated!')
end
-------------------------------------------------------------------------------
--[[ iti
iti = {}
function iti:new(name)  -- The constructor
  local out = {}
  local info = mysql_query_on("SELECT * FROM player.item WHERE vnum = "..name.." LIMIT 1")
  out.vnum = tonumber(name)
  
  setmetatable(out, { __index = iti })  -- Inheritance
  print('Daten für Item '..name..' erfolgreich geladen!')
  return out
end
--]]
-------------------------------------------------------------------------------
-- Say CFG UNFINISHED - In Arbeit!
--[[
sayer = {}
function sayer:new()
    local out = {}
    out.maxlen = 50
    out.maxlines = 15
    out.lines=0
    out.text = 'say("'
    self.sayopen = 1
    setmetatable(out, { __index = sayer })
    return out
end
function sayer:add(txt)
    if self.lines >= self.maxlines then
        self.lines = 0
        self.text = self.text..'"); wait();'
        self.sayopen = 0
    end
    if self.sayopen == 0 then
        self.text = self.text..' say("'
        self.sayopen = 1
    end
    if self.lines ~= 0 then
        self.text = self.text ..'[ENTER]'
    end
    if string.len(txt) < self.maxlen then
        self.text = self.text ..txt
    end
    self.lines = self.lines+1
end
function sayer:send()
    if self.sayopen == 1 then
        self.text = self.text..'"); '
        self.sayopen = 1
    end
    --assert(loadstring(self.text))()
    s.out=loadstring(self.text)()
    print(self.text)
end 
function sayer:wait()
    if self.sayopen == 1 then
        self.text = self.text..'"); '
        self.sayopen = 0
    end
    self.text = self.text..' wait();'
    self.sayopen = 0
    self.lines=0
end
function sayer:input()
    if self.sayopen == 1 then
        self.text = self.text..'"); '
        self.sayopen = 0
    end
    self.text = self.text..'input();'
    self.sayopen = 0
    self.lines=0
end
function sayer:select(tab)
    if self.sayopen == 1 then
        self.text = self.text..'"); '
        self.sayopen = 0
    end
    local un = "'"..join("','",tab).."'"
    self.text = self.text..'select('..un..');'
    self.sayopen = 0
    self.lines=0
end
function sayer:clear()
    self.maxlen = 50
    self.maxlines = 6
    self.lines=0
    self.text = 'say("'
    self.sayopen = 1
end
--]]
-------------------------------------------------------------------------------
-- MYSQL - FUNKTIONEN
-- Einzelbefehle
function mysql_escape(str)
    str = string.gsub(str,"%\\", "\\\\")
--    str = string.gsub(str,"%\0", "\\0") Gibt einen fehler aus :o | Wer rausfindet, warum.. Bitte mir Schreiben (Mijago)
    str = string.gsub(str,"%\n", "\\n")
    str = string.gsub(str,"%\r", "\\r")
    str = string.gsub(str,"%\x1a", "\Z")
    str = string.gsub(str,"%\'", "\\'")
    str = string.gsub(str,'%\"', '\\"')
    return str
end
function backup_files()
    -- Backuppt den Share-Ordner
    local now = os.date('%d-%m-%Y_%H:%M:%S')
    -- Aus absicht einzelne Zeilen! (Zur besseren Kommentierung und dass nicht ein Fehler alle Scripts behindert)
    os.execute('mkdir /backup/ && mkdir /backup/share')  -- Ordner erstellen, falls nicht vorhanden
    os.execute('tar -cvzf ./locale/ /backup/share/'..now..'_locale.tar.gz')      -- Packen
    os.execute('tar -cvzf ./data/ /backup/share/'..now..'_data.tar.gz')      -- Packen
end
function backup_main()
    -- Backuppt die Hauptdatenbanken
    local now = os.date('%d-%m-%Y_%H:%M:%S')
    -- Aus absicht einzelne Zeilen! (Zur besseren Kommentierung und dass nicht ein Fehler alle Scripts behindert)
    os.execute('mkdir /backup/ && mkdir /backup/main')  -- Ordner erstellen, falls nicht vorhanden
    os.execute('mkdir /backup/main/'..now)              -- Ordner für das Backup erstellen
    os.execute('mkdir /backup/main/'..now..'/player/')  -- Player-DB vorbereiten
    os.execute('mkdir /backup/main/'..now..'/account/') -- Account-DB vorbereiten
    os.execute('cp /var/db/mysql/player/player* /backup/main/'..now..'/player/')   -- Player DBs Kopieren
    os.execute('cp /var/db/mysql/player/quest.* /backup/main/'..now..'/player/')    -- Quest DB Kopieren
    os.execute('cp /var/db/mysql/player/guild* /backup/main/'..now..'/player/')    -- Guild DBs Kopieren
    os.execute('cp /var/db/mysql/account/account.* /backup/main/'..now..'/account/')    -- Guild DBs Kopieren
    os.execute('tar -cvzf /backup/main/'..now..'/ /backup/main/'..now..'.tar.gz')      -- Packen
    os.execute('rm -R /backup/main/'..now..'/')                                         -- Daten wieder löschen
end
function backup()
    -- Backuppt alle Datenbanken
    local now = os.date('%d-%m-%Y_%H:%M:%S')
    -- Aus absicht einzelne Zeilen! (Zur besseren Kommentierung und dass nicht ein Fehler alle Scripts behindert)
    os.execute('mkdir /backup/ && mkdir /backup/all')  -- Ordner erstellen, falls nicht vorhanden
    os.execute('mkdir /backup/all/'..now)              -- Ordner für das Backup erstellen
    os.execute('tar -cvzf /var/db/mysql/ /backup/all/'..now..'.tar.gz')      -- Packen
end
function mysql_query(query,user,pw,db,ip) -- Gibt ALLE Werte als STR zurück.   
	local var = {}
	var.pre = ''
	if ip ~= nil then
		var.pre = var.pre..' -h'..ip
	end
	if user ~= nil then
		var.pre = var.pre..' -u'..user
	end
	if pw ~= nil then
		var.pre = var.pre..' -p'..pw
	end
	if db ~= nil then
		var.pre = var.pre..' -D'..db
	end
	var.scriptfile = 'sc_'..pc.get_name()
	var.outputfile = 'op_'..pc.get_name()
	query= string.gsub(query,'"',"'")
	var.str = "mysql "..var.pre.." < "..var.scriptfile.." > "..var.outputfile
	script = io.open(var.scriptfile,"w")
	script:write(query)
	script:close()
	os.execute(var.str)
	local g = {}
	local f = io.open(var.outputfile)
	g.i = 0
	g.li={}
	g.out= {}
    g.count = 0
	for line in f:lines() do
		g.i = g.i+1
		g.li[g.i] = line
	end
	f:close()
	os.execute("rm "..var.scriptfile)
	os.execute("rm "..var.outputfile)
    -- TESTDEBUG
    if g.li[1] == nil then
        return "ERROR"
    end
    if string.len(g.li[1]) == 0 then
        return "ERROR"
    end
    -- TESTDEBUG ENDE
    -- Abfrage später :  if out == "ERROR" then return end << Beispiel!!
	g.fields = split(g.li[1],'	')
	table.foreachi(g.fields,
			function(lb,ln)
				g.out[ln] = {}
			end)
	table.foreachi(g.li,
	function(ou1,ou2)
	if ou1 > 1 then
		local la = split(ou2,'	')
        g.count = g.count+1
		table.foreachi(g.fields,
			function(lb,ln)
				g.out[ln][(ou1-1)] = la[lb]
			end)
	end
	end
	)
    -- Alle Strings, die nur Zahlen beinhalten, in Zahlen umwandeln
    -- Zeigt gleichzeitig die Nutzungsmöglichkeit vom von mir modifizierten tonumber()
    table.foreach(g.out,
        function(i,l)
        table.foreach(l,
            function(i2,l2)
                local d,e = tonumber(l2)
                if e then
                    g.out[i][i2] = d
                end
            end
        )
        end
    )
	g.out.__data = {}                   -- Zur Ausgabe Queryspezifischer Daten
	g.out.__data.fields = g.fields
    g.out.__data.lines  = g.count
    g.out.__data.user = user
    g.out.__data.pass = pw
    g.out.__data.host = ip
    g.out.__data.db = db
    g.out.__data.query = query
	return g.out
end

function mysql_query2(query,user,pw,db,ip)
	local var = {}
	var.pre = ''
	if ip ~= nil then
		var.pre = var.pre..' -h'..ip
	end
	if user ~= nil then
		var.pre = var.pre..' -u'..user
	end
	if pw ~= nil then
		var.pre = var.pre..' -p'..pw
	end
	if db ~= nil then
		var.pre = var.pre..' -D'..db
	end
	query= string.gsub(query,'"',"'")
	os.execute("mysql -s"..var.pre..' -e=\\"'..query..'\\"')
end

-- Für mehrer CFG's
mysql = {}
function mysql:connect(ip,user,passwd,db)
    local out = {}
    out.ip = ip
    out.user = user
    out.pass = passwd
    if db == nil then db = 'player' end
    out.db = db
    out.querycount = 0
    out.querylist = {}
    out.ql = {}
    setmetatable(out, { __index = mysql })
    return out
end
function mysql:query(query)
    self.lastquery = mysql_query(query,self.user,self.pass,self.db,self.ip)
    self.lq = self.lastquery
        self.querycount = self.querycount +1
        self.querylist[self.querycount] = self.lq
        self.ql = self.querylist
    return self.lastquery, self.querycount
end
function mysql:setcfg(ip,user,pass,db)
    if ip ~= nil then
        self.ip = ip
    end
    if user ~= nil then
        self.user = user
    end
    if pass ~= nil then
        self.pass = pass
    end
    self.db = db
end
-------------------------------------------------------------------------------
-- FARBCODES
col.list= {
{ 'lightcoral', 240,128,128 },
{ 'rosybrown', 188,143,143 },
{ 'indianred', 205,92,92 },
{ 'red', 255,0,0 },
{ 'firebrick', 178,34,34 },
{ 'brown', 165,42,42 },
{ 'darkred', 139,0,0 },
{ 'maroon', 128,0,0 },
{ 'mistyrose', 255,228,225 },
{ 'salmon', 250,128,114 },
{ 'tomato', 255,99,71 },
{ 'darksalmon', 233,150,122 },
{ 'coral', 255,127,80 },
{ 'orangered', 255,69,0 },
{ 'lightsalmon', 255,160,122 },
{ 'sienna', 160,82,45 },
{ 'seashell', 255,245,238 },
{ 'chocolate', 210,105,30 },
{ 'saddlebrown', 139,69,19 },
{ 'sandybrown', 244,164,96 },
{ 'peachpuff', 255,218,185 },
{ 'peru', 205,133,63 },
{ 'linen', 250,240,230 },
{ 'bisque', 255,228,196 },
{ 'darkorange', 255,140,0 },
{ 'burlywood', 222,184,135 },
{ 'antiquewhite', 250,235,215 },
{ 'tan', 210,180,140 },
{ 'navajowhite', 255,222,173 },
{ 'blanchedalmond', 255,235,205 },
{ 'papayawhip', 255,239,213 },
{ 'moccasin', 255,228,181 },
{ 'orange', 255,165,0 },
{ 'wheat', 245,222,179 },
{ 'oldlace', 253,245,230 },
{ 'floralwhite', 255,250,240 },
{ 'darkgoldenrod', 184,134,11 },
{ 'goldenrod', 218,165,32 },
{ 'cornsilk', 255,248,220 },
{ 'gold', 255,215,0 },
{ 'lemonchiffon', 255,250,205 },
{ 'khaki', 240,230,140 },
{ 'palegoldenrod', 238,232,170 },
{ 'darkkhaki', 189,183,107 },
{ 'ivory', 255,255,240 },
{ 'lightyellow', 255,255,224 },
{ 'beige', 245,245,220 },
{ 'lightgoldenrodyellow', 250,250,210 },
{ 'yellow', 255,255,0 },
{ 'olive', 128,128,0 },
{ 'olivedrab', 107,142,35 },
{ 'yellowgreen', 154,205,50 },
{ 'darkolivegreen', 85,107,47 },
{ 'greenyellow', 173,255,47 },
{ 'chartreuse', 127,255,0 },
{ 'lawngreen', 124,252,0 },
{ 'darkseagreen', 143,188,139 },
{ 'honeydew', 240,255,240 },
{ 'palegreen', 152,251,152 },
{ 'lightgreen', 144,238,144 },
{ 'lime', 0,255,0 },
{ 'limegreen', 50,205,50 },
{ 'forestgreen', 34,139,34 },
{ 'green', 0,128,0 },
{ 'darkgreen', 0,100,0 },
{ 'seagreen', 46,139,87 },
{ 'mediumseagreen', 60,179,113 },
{ 'springgreen', 0,255,127 },
{ 'mintcream', 245,255,250 },
{ 'mediumspringgreen', 0,250,154 },
{ 'mediumaquamarine', 102,205,170 },
{ 'aquamarine', 127,255,212 },
{ 'turquoise', 64,224,208 },
{ 'lightseagreen', 32,178,170 },
{ 'mediumturquoise', 72,209,204 },
{ 'azure', 240,255,255 },
{ 'lightcyan', 224,255,255 },
{ 'paleturquoise', 175,238,238 },
{ 'aqua', 0,255,255 },
{ 'cyan', 0,255,255 },
{ 'darkcyan', 0,139,139 },
{ 'teal', 0,128,128 },
{ 'darkslategray', 47,79,79 },
{ 'darkturquoise', 0,206,209 },
{ 'cadetblue', 95,158,160 },
{ 'powderblue', 176,224,230 },
{ 'lightblue', 173,216,230 },
{ 'deepskyblue', 0,191,255 },
{ 'skyblue', 135,206,235 },
{ 'lightskyblue', 135,206,250 },
{ 'steelblue', 70,130,180 },
{ 'aliceblue', 240,248,255 },
{ 'dodgerblue', 30,144,255 },
{ 'lightslategray', 119,136,153 },
{ 'slategray', 112,128,144 },
{ 'lightsteelblue', 176,196,222 },
{ 'cornflowerblue', 100,149,237 },
{ 'royalblue', 65,105,225 },
{ 'ghostwhite', 248,248,255 },
{ 'lavender', 230,230,250 },
{ 'blue', 0,0,255 },
{ 'mediumblue', 0,0,205 },
{ 'darkblue', 0,0,139 },
{ 'midnightblue', 25,25,112 },
{ 'navy', 0,0,128 },
{ 'slateblue', 106,90,205 },
{ 'darkslateblue', 72,61,139 },
{ 'mediumslateblue', 123,104,238 },
{ 'mediumpurple', 147,112,219 },
{ 'blueviolet', 138,43,226 },
{ 'indigo', 75,0,130 },
{ 'darkorchid', 153,50,204 },
{ 'darkviolet', 148,0,211 },
{ 'mediumorchid', 186,85,211 },
{ 'thistle', 216,191,216 },
{ 'plum', 221,160,221 },
{ 'violet', 238,130,238 },
{ 'fuchsia', 255,0,255 },
{ 'magenta', 255,0,255 },
{ 'darkmagenta', 139,0,139 },
{ 'purple', 128,0,128 },
{ 'orchid', 218,112,214 },
{ 'mediumvioletred', 199,21,133 },
{ 'deeppink', 255,20,147 },
{ 'hotpink', 255,105,180 },
{ 'lavenderblush', 255,240,245 },
{ 'palevioletred', 219,112,147 },
{ 'crimson', 220,20,60 },
{ 'pink', 255,192,203 },
{ 'lightpink', 255,182,193 },
{ 'white', 255,255,255 },
{ 'snow', 255,250,250 },
{ 'whitesmoke', 245,245,245 },
{ 'gainsboro', 220,220,220 },
{ 'lightgray', 211,211,211 },
{ 'silver', 192,192,192 },
{ 'darkgray', 169,169,169 },
{ 'gray', 128,128,128 },
{ 'dimgray', 105,105,105 },
{ 'black', 0,0,0 },
{ 'aliceblue', 240,248,255 },
{ 'antiquewhite', 250,235,215 },
{ 'aqua', 0,255,255 },
{ 'aquamarine', 127,255,212 },
{ 'azure', 240,255,255 },
{ 'beige', 245,245,220 },
{ 'bisque', 255,228,196 },
{ 'black', 0,0,0 },
{ 'blanchedalmond', 255,235,205 },
{ 'blue', 0,0,255 },
{ 'blueviolet', 138,43,226 },
{ 'brown', 165,42,42 },
{ 'burlywood', 222,184,135 },
{ 'cadetblue', 95,158,160 },
{ 'chartreuse', 127,255,0 },
{ 'chocolate', 210,105,30 },
{ 'coral', 255,127,80 },
{ 'cornflowerblue', 100,149,237 },
{ 'cornsilk', 255,248,220 },
{ 'crimson', 220,20,60 },
{ 'cyan', 0,255,255 },
{ 'darkblue', 0,0,139 },
{ 'darkcyan', 0,139,139 },
{ 'darkgoldenrod', 184,134,11 },
{ 'darkgray', 169,169,169 },
{ 'darkgreen', 0,100,0 },
{ 'darkkhaki', 189,183,107 },
{ 'darkmagenta', 139,0,139 },
{ 'darkolivegreen', 85,107,47 },
{ 'darkorange', 255,140,0 },
{ 'darkorchid', 153,50,204 },
{ 'darkred', 139,0,0 },
{ 'darksalmon', 233,150,122 },
{ 'darkseagreen', 143,188,139 },
{ 'darkslateblue', 72,61,139 },
{ 'darkslategray', 47,79,79 },
{ 'darkturquoise', 0,206,209 },
{ 'darkviolet', 148,0,211 },
{ 'deeppink', 255,20,147 },
{ 'deepskyblue', 0,191,255 },
{ 'dimgray', 105,105,105 },
{ 'dodgerblue', 30,144,255 },
{ 'firebrick', 178,34,34 },
{ 'floralwhite', 255,250,240 },
{ 'forestgreen', 34,139,34 },
{ 'fuchsia', 255,0,255 },
{ 'gainsboro', 220,220,220 },
{ 'ghostwhite', 248,248,255 },
{ 'gold', 255,215,0 },
{ 'goldenrod', 218,165,32 },
{ 'gray', 128,128,128 },
{ 'green', 0,128,0 },
{ 'greenyellow', 173,255,47 },
{ 'honeydew', 240,255,240 },
{ 'hotpink', 255,105,180 },
{ 'indianred', 205,92,92 },
{ 'indigo', 75,0,130 },
{ 'ivory', 255,255,240 },
{ 'khaki', 240,230,140 },
{ 'lavender', 230,230,250 },
{ 'lavenderblush', 255,240,245 },
{ 'lawngreen', 124,252,0 },
{ 'lemonchiffon', 255,250,205 },
{ 'lightblue', 173,216,230 },
{ 'lightcoral', 240,128,128 },
{ 'lightcyan', 224,255,255 },
{ 'lightgoldenrodyellow', 250,250,210 },
{ 'lightgray', 211,211,211 },
{ 'lightgreen', 144,238,144 },
{ 'lightpink', 255,182,193 },
{ 'lightsalmon', 255,160,122 },
{ 'lightseagreen', 32,178,170 },
{ 'lightskyblue', 135,206,250 },
{ 'lightslategray', 119,136,153 },
{ 'lightsteelblue', 176,196,222 },
{ 'lightyellow', 255,255,224 },
{ 'lime', 0,255,0 },
{ 'limegreen', 50,205,50 },
{ 'linen', 250,240,230 },
{ 'magenta', 255,0,255 },
{ 'maroon', 128,0,0 },
{ 'mediumaquamarine', 102,205,170 },
{ 'mediumblue', 0,0,205 },
{ 'mediumorchid', 186,85,211 },
{ 'mediumpurple', 147,112,219 },
{ 'mediumseagreen', 60,179,113 },
{ 'mediumslateblue', 123,104,238 },
{ 'mediumspringgreen', 0,250,154 },
{ 'mediumturquoise', 72,209,204 },
{ 'mediumvioletred', 199,21,133 },
{ 'midnightblue', 25,25,112 },
{ 'mintcream', 245,255,250 },
{ 'mistyrose', 255,228,225 },
{ 'moccasin', 255,228,181 },
{ 'navajowhite', 255,222,173 },
{ 'navy', 0,0,128 },
{ 'oldlace', 253,245,230 },
{ 'olive', 128,128,0 },
{ 'olivedrab', 107,142,35 },
{ 'orange', 255,165,0 },
{ 'orangered', 255,69,0 },
{ 'orchid', 218,112,214 },
{ 'palegoldenrod', 238,232,170 },
{ 'palegreen', 152,251,152 },
{ 'paleturquoise', 175,238,238 },
{ 'palevioletred', 219,112,147 },
{ 'papayawhip', 255,239,213 },
{ 'peachpuff', 255,218,185 },
{ 'peru', 205,133,63 },
{ 'pink', 255,192,203 },
{ 'plum', 221,160,221 },
{ 'powderblue', 176,224,230 },
{ 'purple', 128,0,128 },
{ 'red', 255,0,0 },
{ 'rosybrown', 188,143,143 },
{ 'royalblue', 65,105,225 },
{ 'saddlebrown', 139,69,19 },
{ 'salmon', 250,128,114 },
{ 'sandybrown', 244,164,96 },
{ 'seagreen', 46,139,87 },
{ 'seashell', 255,245,238 },
{ 'sienna', 160,82,45 },
{ 'silver', 192,192,192 },
{ 'skyblue', 135,206,235 },
{ 'slateblue', 106,90,205 },
{ 'slategray', 112,128,144 },
{ 'snow', 255,250,250 },
{ 'springgreen', 0,255,127 },
{ 'steelblue', 70,130,180 },
{ 'tan', 210,180,140 },
{ 'teal', 0,128,128 },
{ 'thistle', 216,191,216 },
{ 'tomato', 255,99,71 },
{ 'turquoise', 64,224,208 },
{ 'violet', 238,130,238 },
{ 'wheat', 245,222,179 },
{ 'white', 255,255,255 },
{ 'whitesmoke', 245,245,245 },
{ 'yellow', 255,255,0 },
{ 'yellowgreen', 154,205,50 }
}
table.foreachi(col.list,
function(a,b)
	col[b[1]] = 	function(text) return "[COLOR r;"..(b[2]/255.0).."|g;"..(b[3]/255.0).."|b;"..(b[4]/255.0).."]"..text..'[/COLOR]' end
end
)
-------------------------------------------------------------------------------
-- ZEIT - FUNKTIONEN

--- Tage
zt.d_j = 	function(d)
				return d/365
			end
zt.d_mo = 	function(d)
				return d/12
			end
zt.d_h = 	function(d)
				return d*24
			end
zt.d_m = 	function(d)
				return d*24*60
			end
zt.d_s = 	function(d)
				return d*24*60*60
			end
zt.d_hs = 	function(d)
				return d*24*60*60*100
			end
zt.d_ms = 	function(d)
				return d*24*60*60*1000
			end
--- Stunden
zt.h_j = 	function(h)
				return h/24/365
			end
zt.h_mo = 	function(h)
				return h/24/12
			end
zt.h_d = 	function(h)
				return h/24
			end
zt.h_m = 	function(h)
				return h*60
			end
zt.h_s = 	function(h)
				return h*60*60
			end
zt.h_hs = 	function(h)
				return h*60*60*100
			end
zt.h_ms = 	function(h)
				return h*60*60*1000
			end
--- Minuten
zt.m_j = 	function(m)
				return m/60/24/365
			end
zt.m_mo = 	function(m)
				return m/60/24/12
			end
zt.m_d = 	function(m)
				return m/60/24
			end
zt.m_h = 	function(m)
				return m/60
			end
zt.m_s = 	function(m)
				return m*60
			end
zt.m_hs = 	function(m)
				return m*60*100
			end
zt.m_ms = 	function(m)
				return m*60*1000
			end
--- Sekunden
zt.s_j = 	function(s)
				return s/60/60/24/365
			end
zt.s_mo = 	function(s)
				return s/60/60/24/12
			end
zt.s_d = 	function(s)
				return s/60/60/24
			end
zt.s_h = 	function(s)
				return s/60/60
			end
zt.s_m = 	function(s)
				return s/60
			end
zt.s_hs = 	function(s)
				return s*100
			end
zt.s_ms = 	function(s)
				return s*1000
			end


-------------------------------------------------------------------------------
-- PC - Funktionen
function local_pc_warp(name, x, y,mid)
	local target = find_pc_by_name(name)
	local t = pc.select(target)
	if mid == nil then
		mid = pc.get_map_index()
	end
	pc.warp_local(mid, x*100, y*100)
	pc.select(t)
end
function local_pc_setqf(name, qf,wert) -- Für die aktuelle Quest
	local target = find_pc_by_name(name)
	local t = pc.select(target)
	pc.setqf(qf,wert)
	pc.select(t)
end
function do_for_other(name,ding)
	local t = pc.select(find_pc_by_name(name))
    assert(loadstring(ding))()
    pc.select(t)
end
-------------------------------------------------------------------------------
-- ALLGEMEINE  FUNKTIONEN
function dot(x)-- Führt alles zwischen $ $ aus. Verschachtelungen nicht in einem Aufruf möglich.
    return string.gsub(x, "%$(.-)%$", function (s) return loadstring(s)() end) 
end
function download(url) os.execute("cd data && fetch "..url.." && cd ..") end
ql.test = 	function() 
				print('Die Lib Funktioniert!')
				chat('Die Lib Funktioniert!')
			end
ql.about = 	function() 
				print('Diese Lib wurde von Mijago programmiert.')
				chat('Diese Lib wurde von Mijago programmiert.')
			end
			
function note(text)
	notice_all('|>~ '..text)
end
function split(str, delim, maxNb)
    -- Eliminate bad cases...
    if str == nil then
        return str
    end
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end
function getn(list)
	local i = 0
	table.foreachi(list, function(a,b) i = i+1 end)
	return i
end
function join(delimiter, list)
  local len = getn(list)
  if len == 0 then 
    return "" 
  end
  local string = list[1]
  for i = 2, len do 
    string = string .. delimiter .. list[i] 
  end
  return string
end

function is_table(var)
	if (type(var) == "table") then
		return true
	else
		return false
	end
end
function is_number(var)
	if (type(var) == "number") then
		return true
	else
		return false
	end
end
function is_string(var)
	if (type(var) == "string") then
		return true
	else
		return false
	end
end

function in_table ( e, t )
	for _,v in pairs(t) do
		if (v==e) then 
			return true 
		end
	end
	return false
end
function in_text(str,te)
    for i = 0,string.len(str) do
        if string.sub(str, i,i+string.len(te)-1) == te then
            return i
        end
    end
    return -1
end
function machweg(str,weg)
    while in_text(str,weg) == true do
        for i = 0,string.len(str) do
            if string.sub(str, i,i+string.len(weg)-1) == weg then
                str = string.sub(str,0,i-1)..string.sub(str,i+string.len(weg),string.len(str))
            end
        end
    end
    return str
end

function numlen(num)
	return string.len(tostring(num))
end

function delay_s(delay)
    delay = delay or 1
    local time_to = os.time() + delay
    while os.time() < time_to do end
end
function distance(x1,y1,x2,y2)

    dx=x2-x1
    dy=y2-y1
 
    dist=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
 
    return dist
end


function makereadonly(t)
    -- the metatable
    local mt = { __index = t,
                 __newindex = function(t, k, v)
                     error("trying to modify constant field " .. tostring(k), 2)
                 end
    }
    return setmetatable({}, mt)
end

function allwords ()
   local line = io.read()
   local pos = 1
   return function()
    while line do 
        local s, e = string.find(line, "%w+", pos)
        if s then
            pos = e + 1
            return string.sub(line, s, e)
        else
            line = io.read()
            pos = 1
        end
    end
    return nil
   end
end


-------------------------------------------------------------------------------
-- Iniparser & -writer
do
    -- Funktionen:
    -- var = ini.new() 
    -- var = ini.open(path)
    -- var:write_str(sub,name,wert)
    -- var:write_int(sub,name,wert)
    -- var:write_bool(sub,name,boolean)
    -- var:clear()
    -- var:read_str(sub,name,norm)   -- Gibt einen String zurück. -|
    -- var:read_int(sub,name,norm)   -- Gibt eine zahl zurück      -|  norm wird zurückgegeben, wenn sub[name] nicht existiert.
    -- var:read_bool(sub,name,norm)  -- Gibt true / False zurück  -|
    -- var:delete_key(sub,nm)
    -- var:delete_section(sub)
    local ini_f = {}
    ini = {}
    function ini_f:append(sub,nm,wert)
        if nm == '' or nm == nil then
            return
        end
        self:parse()
        if self.sub[sub] == nil then self.sub[sub] = {} end
        self.sub[sub][nm] = wert
        self:writeit()
    end
    function ini_f:write_str(sub,nm,wert)
        self:append(sub,nm,wert)
    end
    function ini_f:write_int(sub,nm,wert)
        self:append(sub,nm,wert)
    end
    function ini_f:write_bool(sub,nm,bool)
        if not type(bool) == "boolean" then
            return
        end
        local bin = 0
        if bool == true then bin = 1 end
        self:append(sub,nm,bin)
        return bin
    end
    function ini_f:clear()
        self.sub = {}
        self.path = ''
    end
    function ini_f:writeit()
        local out = ''
        table.foreach(self.sub,
            function(i,l)
                out = out..'['..i..']\n'
                table.foreach(l,
                    function(i2,l2)
                        out=out..i2..'='..l2..'\n'
                    end
                )
            end
        )
        local d = io.open(self.path,'w')
        d:write(out)
        d:close()
    end
    function ini_f:delete_key(sub,nm)
        if sub == '' or nm == '' or sub == nil or nm == nil then return end
        self:parse()
        self.sub[sub][nm] = nil
        self:writeit()
    end
    function ini_f:delete_section(sub)
        if sub == '' or sub == nil then return end
        self:parse()
        self.sub[sub]= nil
        self:writeit()
    end
    function ini_f:parse()
        self.sub = {}
        if self.path == '' or self.path == nil then return end
        local d,i = io.open(self.path,"r"),'non'
        for line in d:lines() do
            if string.sub(line,1,1) == "[" then
                i = string.sub(line,2,string.len(line)-1)
                self.sub[i] = {}
            else
                local inp = split(line,'=')
                self.sub[i][inp[1]] = inp[2]
            end
        end
        d:close()
    end
    function ini_f:read_str(sub,nm,norm)
        if sub == '' or nm == '' or sub == nil or nm == nil then return end
        self:parse()
        if self.sub[sub] == nil then return norm end
        if self.sub[sub][nm] == nil then return norm else return self.sub[sub][nm] end
    end
    function ini_f:read_int(sub,nm,norm)
        if sub == '' or nm == '' or sub == nil or nm == nil then return end
        self:parse()
        if self.sub[sub] == nil then return norm end
        if self.sub[sub][nm] == nil then return norm else return tonumber(self.sub[sub][nm]) end
    end
    function ini_f:read_bool(sub,nm,norm)   -- Norm wird zurückgegeben, wenn der Key nm nicht existiert
        if sub == '' or nm == '' or sub == nil or nm == nil then return end
        self:parse()
        if self.sub[sub] == nil then return norm end
        if self.sub[sub][nm] == nil then return norm end
        if self.sub[sub][nm] == "1" then return true else return false end
    end
    function ini_f:open(path)
        self.path = path
        self:parse()
    end
    function ini.new()
        local out = {}
        out.path = ''
        out.sub = {}
        setmetatable(out, { __index = ini_f })
        return out
    end
    function ini.open(path)
        local dat = ini.new()
        dat:clear()
        dat.path=path
        dat:open(path)
        return dat
    end
end
-------------------------------------------------------------------------------
-- Programmsteuerung
proc.apache_start = function()
				os.execute('apachectl start')
			end
proc.apache_stop = function()
				os.execute('apachectl stop')
			end
proc.apache_restart = function()
				os.execute('apachectl restart')
			end
proc.apache_graceful = function()
				os.execute('apachectl graceful')
			end
proc.ts3_start = function(path)
				os.execute('cd '..path..' && sh ts3server_startscript.sh start')
				end
proc.ts3_stop = function(path)
				os.execute('cd '..path..' && sh ts3server_startscript.sh stop')
				end
proc.ts3_restart = function(path)
				os.execute('cd '..path..' && sh ts3server_startscript.sh restart')
				end
				
-------------------------------------------------------------------------------
--[[ Funktionsliste
 download(url)                          -> lädt die Datei in den Data-Ordner
 ql.test()                              -> gibt einen Teststring aus. (Zum testen, ob die Lib funktionert)
 ql.about()                             -> Gibt Informationen über das Script aus
 col.[FARBNAME]                         -> Gibt Text in say() farbig aus. Englische Farbnamen! (Beinhaltet 281 Farben) [String]
 note(text)                             -> Entspricht notice_all('|>~ TEXT')
 local_pc_setqf(name,qf,wert)           -> Setzt bei einem Anderen Spieler eine Quest-flag
 local_pc_warp(name, x, y,mid)          -> Teleportiert den Spieler NAME an die Kooridinaten x & y auf der Map mit dem index mid. mid kann auch leer bleiben
 do_for_other(name,dot)                 -> Führt die Befehle in dot für den Spieler name aus. Mit ; trennen
 writelog(text,var,file)                -> Füllt die Logs. 1 = syserr, 2 = syslog, 3 = "file"
 doit(cmd)                              -> Führt einen FreeBSD Befehl aus (auch Befehlsketten mit &&)
--- Spezielle
 pci:new(name)                          -> erstellt auf der genutzten Variable (zb pt = pci:new('[SA]Mijago') ) eine Liste mit allen Info's über den Spieler (alle Spalten aus player.player)
 pci:update                             -> updatet die mit pci:new erstellte Variable
 select2(tab)                           -> Sortiert eine Tabelle in Selects; auf Seiten aufgeteilt. Der erste Tabelleneintrag muss eine Zahl sein; Sie gibt die maximale Anzahl der Select-Einträg / Seite an.
--- MySQL
 mysql_query(query,user,pw,db,ip)       -> wie php mysql_query (gibt es auch so aus: out.id[1] = 7754 zB)
 mysql_query2(query,user,pw,db,ip)      -> NUR für Query's wie Update, Insert etc. 
 mysql_escape(str)                      -> Equivalent  mit dem aus PHP bekannten mysql_escape_real_string
 backup()                               -> Backuppt alle MySQL-Datenbanken
 backup_main()                          -> Backuppt die wichtigsten MySQL-Datenbanken
 backup_files()                         -> Backuppt den Share - Ordner
--- Lua-erweiterung
 watch_table(tab)                       -> Schreibt alle Änderungen an der Tabelle in eine Datei. 
 arraytoselect(array,abbr)              -> erstellt aus einem Array eine Select()-Abfrage und gibt deren Auswahl zurück. Wenn "abbr" gesetzt ist, fügt die Funktion einen eintrag mit dem Wert von "abbr" ein.
 is_table(var)                          -> Prüft, ob eine Variable eine Tabelle ist [boolean]
 is_string(var)                         -> Prüft, ob eine Variable ein String ist [boolean]
 is_number(var)                         -> Prüft, ob eine Variable eine Zahl ist [boolean]
 in_table(e,t)                          -> Prüft, ob e in dem Array t vorhanden ist. [boolean]
 in_table(str,te)                       -> Prüft, ob te in dem string str vorhanden ist. [boolean]
 machweg(str,weg)                       -> Entfernt alle 'weg' aus 'str' [string]
 split(str, delim, maxNb)               -> Teilt den Text 'str' mit dem Delimenter 'delim' auf (in maximal 'maxNb' Teile). maxNb kann leer gelassen werden. [Array]
 join(delimiter, list)                  -> Gegenteil von Split. List ist ein Array. Bsp: s = join('|',{'a','b'}) -> s = 'a|b'
 getn(array)                            -> Gibt die Anzahl der Einträge eines Array's aus. [Integer]
 delay_s(delay)                         -> Scriptpause für -delay- Sekunden
 numlen(num)                            -> gibt die Anzahl der Ziffern in der Zahl num an [Integer]
 distance(x1,y1,x2,y2)                  -> Distanz zwischen 2 Punkten [Integer]
 makereadonly(t)                        -> Sperrt die Tabelle (ReadOnly)
 allwords()                             -> Liest alle Wörter aus einer Datei und gibt sie zurück. Vorher io.open!
--- Zeitrechnungen
 zt.d_j(d)                              -> Tage zu Jahre
 zt.d_mo(d)                             -> Tage zu Monate
 zt.d_h(d)                              -> Tage zu Stunden
 zt.d_m(d)                              -> Tage zu Minuten
 zt.d_s(d)                              -> Tage zu Sekunden
 zt.d_hs(d)                             -> Tage zu Hunderstelsekunden
 zt.d_ms(d)                             -> Tage zu Millisekunden
 zt.h_j(h)                              -> Stunden zu Jahre
 zt.h_mo(h)                             -> Stunden zu Monate
 zt.h_d(h)                              -> Stunden zu Tage
 zt.h_m(h)                              -> Stunden zu Minuten
 zt.h_s(h)                              -> Stunden zu Sekunden
 zt.h_hs(h)                             -> Stunden zu Hunderstelsekundne
 zt.h_ms(h)                             -> Stunden zu Millisekunden
 zt.m_j(m)                              -> Minuten zu Jahre
 zt.m_mo(m)                             -> Minuten zu Monate
 zt.m_d(m)                              -> Minuten zu Tage
 zt.m_h(m)                              -> Minuten zu Stunden
 zt.m_s(m)                              -> Minuten zu Sekunden
 zt.m_hs(m)                             -> Minuten zu Hunderstelsekunden
 zt.m_ms(m)                             -> Minuten zu Millisekunden
 zt.s_j(s)                              -> Sekunden zu Jahre
 zt.s_mo(s)                             -> Sekunden zu Monate
 zt.s_d(s)                              -> Sekunden zu Tage
 zt.s_h(s)                              -> Sekunden zu Stunden
 zt.s_m(s)                              -> Sekunden zu Minuten
 zt.s_hs(s)                             -> Sekunden zu Hunderstelsekunden
 zt.s_ms(s)                             -> Sekunden zu Millisekunden
 
--- Programmbasierende Befehle
 proc.apache_start()                    -> Startet Apache
 proc.apache_stop()                     -> Stoppt Apache
 proc.apache_restart()                  -> Startet Apache neu
 proc.apache_graceful()                 -> Startet Apache neu, ohne vorhandene Verbindungen zu kappen
 proc.ts3_start(path)                   -> Startet den Teamspeak3 Server im Pfad 'path'
 proc.ts3_stop(path)                    -> Startet den Teamspeak3 Server im Pfad 'path' neu
 proc.ts3_restart(path)                 -> Stopp den Teamspeak3 Server im Pfad 'path'
--]]	
makereadonly(col)
makereadonly(zt)
makereadonly(proc)
makereadonly(ql)
