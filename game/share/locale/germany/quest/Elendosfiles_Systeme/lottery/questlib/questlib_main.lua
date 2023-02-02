-- Elendosfiles_QUESTLIB
dofile("locale/germany/quest/Systeme/lottery/questlib/questlib_const.lua")




-- set_level
function set_level(endlevel)
    if pc.get_level() > endlevel then
        return
    else
        local level = pc.get_level()
        local endlevels = endlevel
        local levelups = endlevels-level
        for i = 1, levelups do
            local give_exp = pc.get_next_exp()
            pc.give_exp2(give_exp)
        end
    end
end

-- warp player to (x,y)
function player_warp(name, x, y)
	local player = pc.select(find_pc_by_name(name))
	if player != 0 then
		pc.warp(x,y)
		pc.select(player)
	end
end

-- player exists
function player_exists(name)
	if check_p(name) == true then
		return false
	end
	
	local exists = mysql_query("SELECT name FROM player.player WHERE name = '"..name.."';")
	
	if exists.name != NULL then
		return true
	end
	
	return false
end

-- player name
function player_name(id)
	local playername = mysql_query("select * FROM player.player WHERE id = '"..id.."';")
	return playername.name[1]
end

-- pc warp map1
function pc.warp_map1()
	local empire = pc.get_empire()
	
	if SERVER_ID == SERVER_ASTREGATE then
		if empire == 1 then -- alpha
			pc.warp(13800, 325600)
		elseif empire == 3 then -- beta
			pc.warp(215400, 425200)
		end
	else
		if empire == 1 then
			pc.warp(473900, 954600)
		elseif empire == 2 then
			pc.warp(63200, 166700)
		else
			pc.warp(959600, 269700)
		end
	end

end

-- player ID
function player_id(name)
	local playerid = mysql_query("SELECT id FROM player.player WHERE name = '"..name.."';")
	return playerid.id[1]
end

-- get_daypart
function get_daypart()
	if os.date ("%H") > "17" then
		return "Abend"
	elseif os.date ("%H") > "11" then
		return "Tag"
	elseif os.date ("%H") > "5" then
		return "Morgen"
	else
		return "Nacht"
	end
end

-- set_acc_status()
function set_acc_status(name, status)
	local get_acc_id = mysql_query("select * FROM player.player WHERE name = '"..name.."';")
	acc_id = get_acc_id.account_id[1]
	mysql_query("UPDATE account.account SET status='"..status.."' WHERE id='"..acc_id.."';")
end

function getAccountIDbyPlayer(gPlayerName)
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	local accID = mysql_query("SELECT account_id FROM player.player WHERE name = '"..gPlayerName.."' LIMIT 1;")
	
	return accID.account_id[1]
end

function getAccountIDbyPlayerId(iPlayerId)
	
	-- sql return string
	if check_p(iPlayerId) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	local accID = mysql_query("SELECT account_id FROM player.player WHERE id = '"..iPlayerId.."' LIMIT 1;")
	return accID.account_id[1]
end

-- check_p(input)
function check_p(input)
	local check = string.find(input, '%p')
	if check != NULL then return true
	else return false
	end
end

-- get_empire_name()
function get_empire_name()
	local empire = pc.get_empire()
	local get_empire = {
		[1] = "Athadan",
		[2] = "",
		[3] = "Caderas",
	}
	return get_empire[empire]
end

-- get_empire_name_by_id()
function get_empire_name_by_id(id)
	local get_empire = {
		[0] = "",
		[1] = "Athadan",
		[2] = "",
		[3] = "Caderas",
	}
	return get_empire[id]
end

-- jobtoname()
function jobtoname()
	local get_job = {
		[0] = "Krieger",
		[1] = "Ninja",
		[2] = "Sura",
		[3] = "Schamane",
	}
	return get_job[pc.get_job()]
end

-- yang_out
function yang_out(yo) syschat("Du hast "..yo.." Yang ausgegeben.") end

-- Number to money string
function NumberToMoneyString(ntms)
	local sourceText = tostring(ntms)
	while true do  
		sourceText, k = string.gsub(sourceText, "^(-?%d+)(%d%d%d)", "%1.%2")
		if (k==0) then
			break
		end
	end
	return sourceText
end

-- npc.is_metin()
function npc.is_metin()
	local nr = mysql_query("select metin from player.mob_proto where vnum = '"..npc.get_race().."';")
	if tonumber(nr) == 1 then return true
	else return false
	end
end

-- map_name_by_number()
 function map_name_by_number(num)
	local map_nums = {
		[1] = "metin2_map_a1",
		[3] = "metin2_map_a3",
	}
	return map_nums[num]
 end
 
 -- can_warp_menu()
 function can_warp_menu()
	while pc.can_warp() != true do
		say_title("Teleportieren fehlgeschlagen")
		say("")
		say("Du kannst dich derzeit nicht teleportieren. Bitte")
		say("beende offene Handelsfenster und warte einen Moment.")
		say("")
		if select("Erneut versuchen", "(Abbrechen)") == 2 then return false end
	end
	return true
 end
 
 -- id_to_name()
function id_to_name(id)
	local get_name = mysql_query("SELECT * FROM player.player WHERE id = '"..id.."';")
	return get_name.name[1]
end


-- round a number
function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
 
 
function addPlayerToGmList(gPlayerName)
	
	-- add a normal player to gm list

	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	local getAuthority = "LOW_WIZARD"
	
	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player already in gmlist
	local query = mysql_query("SELECT mName FROM common.gmlist WHERE mName = '"..gPlayerName.."';")
	if query.mName != NULL then
		chat("Error 4 - player already exist in gmlist sql")
		return false
	end

	
	-- get player account name
	local query = mysql_query("SELECT login FROM account.account INNER JOIN player.player ON player.account_id = account.id WHERE player.name = '"..gPlayerName.."';")
	playerAccName = query.login[1]

	
	-- add player to gmlist
	local query = mysql_query("INSERT INTO common.gmlist (mAccount, mName, mAuthority) VALUES('"..playerAccName.."', '"..gPlayerName.."', '"..getAuthority.."')")


	command("reload a")
	
	
	-- successfully added
	return true
	
end


function removePlayerFromGmList(gPlayerName)
	
	-- remove a gm player from gm list
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player already in gmlist
	local query = mysql_query("SELECT mName FROM common.gmlist WHERE mName = '"..gPlayerName.."';")
	if query.mName == NULL then
		chat("Error 4 - player does not exist in gmlist sql")
		return false
	end

	
	-- remove player from gmlist
	local query = mysql_query("DELETE FROM common.gmlist WHERE mName = '"..gPlayerName.."'")


	command("reload a")
	
	
	-- successfully removed
	return true
end


function setPlayerAuthorityFromGmList(gPlayerName, gPlayerAuthority)
	
	-- update player authority
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player already in gmlist
	local query = mysql_query("SELECT mName FROM common.gmlist WHERE mName = '"..gPlayerName.."';")
	if query.mName == NULL then
		chat("Error 4 - player does not exist in gmlist sql")
		return false
	end
	

	-- update player authority from gmlist
	local query = mysql_query("UPDATE common.gmlist SET mAuthority = '"..gPlayerAuthority.."' WHERE mName = '"..gPlayerName.."'")


	command("reload a")
	
	
	-- successfully removed
	return true
	
end


function addPlayerToSupportList(gPlayerName)
	
	-- add player to support list sql
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end

	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end
	
	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player already in support sql
	local query = mysql_query("SELECT name FROM player.support WHERE name = '"..gPlayerName.."';")
	if query.name != NULL then
		chat("Error 4 - player already exist in support sql")
		return false
	end
	
	
	-- insert new player to support sql
	local query = mysql_query("INSERT INTO player.support (name) VALUES('"..gPlayerName.."')")
	
end


function removePlayerFromSupportList(gPlayerName)
	
	-- remove player from support list sql
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player in support sql
	local query = mysql_query("SELECT name FROM player.support WHERE name = '"..gPlayerName.."';")
	if query.name == NULL then
		chat("Error 4 - player not exist in support sql")
		addPlayerToSupportList(gPlayerName)
		return false
	end
	
	
	-- remove player from support sql
	local query = mysql_query("DELETE FROM player.support WHERE name = '"..gPlayerName.."' LIMIT 1")
	
end


function playerIsSupporting(gPlayerName)
	
	-- returns boolean if player from support list is supporting right now
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("playerIsSupporting: Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("playerIsSupporting: Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player in support sql
	local query = mysql_query("SELECT name FROM player.support WHERE name = '"..gPlayerName.."';")
	if query.name == NULL then
		chat("playerIsSupporting: Error 4 - player not exist in support sql")
		addPlayerToSupportList(gPlayerName)
		return false
	end
	
	
	-- check if player is supporting
	local query = mysql_query("SELECT isSupport FROM player.support WHERE name = '"..gPlayerName.."';")
	if query.isSupport == NULL then
		chat("playerIsSupporting: Error 5 - column: isSupport does not exist in support sql")
		return false
	end
	
	
	
	-- player is supporting
	if query.isSupport[1] == 1 then
		return true
	end
	
	
	-- player is not supporting
	return false

end


function playerSetSupport(gPlayerName, isSupport)
	
	-- set player support status
	
	
	-- sql return string
	if check_p(gPlayerName) == true then
		syschat("Error 1 - string is not possible")
		return false
	end
	
	
	-- check empty string
	if gPlayerName == "" then
		syschat("Error 2 - empty string is not possible")
		return false
	end

	
	-- check if player exist
	if player_exists(gPlayerName) == false then
		syschat("Error 3 - player does not exist")
		return false
	end
	
	
	-- check if player in support sql
	local query = mysql_query("SELECT name FROM player.support WHERE name = '"..gPlayerName.."';")
	if query.name == NULL then
		-- chat("Error 3 - player not exist in support sql")
		addPlayerToSupportList(gPlayerName)
		-- return false
	end
	
	
	-- convert isSupport parameter
	if isSupport == true then
		isSupport = 1
	elseif isSupport != 1 then
		isSupport = 0
	end
	
	
	-- update player support status
	local query = mysql_query("UPDATE player.support SET isSupport = '"..isSupport.."' WHERE name = '"..gPlayerName.."'")
	
end


function PlayerUpdateSupportList()
	
	-- check if player in support sql
	local query = mysql_query("SELECT name,isSupport FROM player.support;")
	if query.name == NULL or query.isSupport == NULL then
		return false
	end
	
	
	
	local iMax = table.getn(query.name)
	
	for i = 1,iMax,1
	do 
	   -- chat(query.name[i])
	   -- chat(query.isSupport[i])
	   
	   -- create team members to support list
		if query.isSupport[i] == 1 then
			cmdchat("Teamler_on "..query.name[i])
		else
			cmdchat("Teamler_off "..query.name[i])
		end
	   
	   
	end

end


function playerIsBanned(gPlayerName)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end
	
	
	local accountID = getAccountIDbyPlayer(gPlayerName)

	local query = mysql_query("SELECT availDt FROM account.account WHERE id = '"..accountID.."';")

	
	local getAccAvailDt = query.availDt[1]
	local getCurUnix = getTimestamp()

	local unixFromTimestamp = convertDateTimeToUnix(getAccAvailDt)

	
	if unixFromTimestamp > getCurUnix then
		return getAccAvailDt
	end
	
	return false

end


function playerUnban(gPlayerName)
	
	-- remove ban time
	
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end
	
	
	local accountID = getAccountIDbyPlayer(gPlayerName)

	local query = mysql_query("UPDATE account.account SET availDt = '0000-00-00 00:00:00' WHERE id = '"..accountID.."'")
	
	return true
	
end


function playerBan(gPlayerName, gBanTime)
	
	-- set ban time
	
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end
	
	local unixToDateTime = convertUnixToDateTime(gBanTime)
	
	local accountID = getAccountIDbyPlayer(gPlayerName)

	local query = mysql_query("UPDATE account.account SET availDt = '"..unixToDateTime.."' WHERE id = '"..accountID.."'")
	
	-- player dc
	if playerIsBanned(gPlayerName) then
	
		local player = pc.select(find_pc_by_name(gPlayerName))
		if player != 0 then
			syschat("Das Konto wurde gesperrt.")
			pc.delayed_dc(3)
			pc.select(player)
		end
	
		return true
	end
	
	
	return false
	
end


function getTimestamp()
	
	-- get current timestamp (unix)
	
	return os.time(os.date("!*t"))
end


function getDateTime()
	
	-- get current datetime (0000-00-00 00:00:00)
	
	local ts = os.time()
	
	return os.date('%Y-%m-%d %H:%M:%S', ts)
	
end


function convertDateTimeToUnix(gTimestamp)
	
	-- check datetime syntax
	if gTimestamp == "" or gTimestamp == "0000-00-00 00:00:00" then
		return 0
	end
	
	-- convert
	local sub1 = string.sub(gTimestamp, 1, 4)
	local sub2 = string.sub(gTimestamp, 6, 7)
	local sub3 = string.sub(gTimestamp, 9, 10)
	local sub4 = string.sub(gTimestamp, 12, 13)
	local sub5 = string.sub(gTimestamp, 15, 16)
	local sub6 = string.sub(gTimestamp, 18, 19)

	local dt = {year=sub1, month=sub2, day=sub3, hour=sub4, min=sub5, sec=sub6}
	local ut = os.time(dt)
	
	return ut
	
end


function convertUnixToDateTime(gTimestamp)
	
	return os.date('%Y-%m-%d %H:%M:%S', gTimestamp)
	
end


function syschat_sa(str)
	
	local pcGmLevel = pc.get_gm_level()
	
	if pcGmLevel < 5 then
		return
	end
	
	
	syschat(str)
	
end



-- PLAYER_COINS

-- coins getter
function getPlayerCoins(gPlayerName)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	local accountID = getAccountIDbyPlayer(gPlayerName)
	local query = mysql_query("SELECT coins FROM account.account WHERE id = '"..accountID.."';")
	local sqlCoins = query.coins[1]
	
	return sqlCoins
	
end

-- coins setter
function setPlayerCoins(gPlayerName, updateCoins)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	
	local accountID = getAccountIDbyPlayer(gPlayerName)
	local accountOldCoins = getPlayerCoins(gPlayerName)

	local query = mysql_query("UPDATE account.account SET coins = coins + '"..updateCoins.."' WHERE id = '"..accountID.."'")
	
	-- check if coins updated
	if getPlayerCoins(gPlayerName) != accountOldCoins + updateCoins then
		syschat("Error 3 - error in sql - coins could not update!")
		return false
	end
	
	
	-- update player coins view
	if pc.get_account_id() == accountID then
		updatePlayerCoins()
	else
		-- transfer message
		local player = pc.select(find_pc_by_name(gPlayerName))
		if player != 0 then
			syschat("Dem Konto wurden "..updateCoins.." Coins uberwiesen.")
			updatePlayerCoins()
			pc.select(player)
		end
	
	end
	
	
	return true
	
end


-- vote_coins getter
function getPlayerVoteCoins(gPlayerName)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	local accountID = getAccountIDbyPlayer(gPlayerName)
	local query = mysql_query("SELECT vote_coins FROM account.account WHERE id = '"..accountID.."';")
	local sqlCoins = query.vote_coins[1]
	
	return sqlCoins
	
end

-- vote_coins setter
function setPlayerVoteCoins(gPlayerName, updateCoins)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	
	local accountID = getAccountIDbyPlayer(gPlayerName)
	local accountOldCoins = getPlayerVoteCoins(gPlayerName)

	local query = mysql_query("UPDATE account.account SET vote_coins = vote_coins + '"..updateCoins.."' WHERE id = '"..accountID.."'")
	
	-- check if vote_coins updated
	if getPlayerVoteCoins(gPlayerName) != accountOldCoins + updateCoins then
		syschat("Error 3 - error in sql - vote_coins could not update!")
		return false
	end

	return true
	
end


-- coins getter
function getPlayerEventPoints(gPlayerName)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	local gPlayerId = player_id(gPlayerName)
	local query = mysql_query("SELECT achievement_points_actual FROM player.achievement_points WHERE id = '"..gPlayerId.."';")
	local sqlPoints = query.achievement_points_actual[1]
	
	return sqlPoints
	
end

-- coins setter
function setPlayerEventPoints(gPlayerName, updateCoins)
	
	-- check if valid player
	if not player_exists(gPlayerName) then
		syschat("Error 1 - player does not exist")
		return false
	end

	
	local gPlayerId = player_id(gPlayerName)
	local accountOldCoins = getPlayerEventPoints(gPlayerName)

	local query = mysql_query("UPDATE player.achievement_points SET achievement_points_actual = achievement_points_actual + '"..updateCoins.."' WHERE id = '"..gPlayerId.."'")
	
	-- check if coins updated
	if getPlayerEventPoints(gPlayerName) != accountOldCoins + updateCoins then
		syschat("Error 3 - error in sql - coins could not update!")
		return false
	end
	
	
	-- update player coins view
	if pc.get_player_id() == gPlayerId then
		updatePlayerEventPoints()
	else
		-- transfer message
		local player = pc.select(find_pc_by_name(gPlayerName))
		if player != 0 then
			syschat("Dem Konto wurden "..updateCoins.." Event Points uberwiesen.")
			updatePlayerEventPoints()
			pc.select(player)
		end
	
	end
	
	
	return true
	
end


-- coins update gui
function updatePlayerCoins()
	local coins = getPlayerCoins(pc.get_name())
	cmdchat("Coins "..coins)
end

-- event_points update gui
function updatePlayerEventPoints()
	local points = getPlayerEventPoints(pc.get_name())
	cmdchat("Event "..points)
end
-- END_OF_PLAYER_COINS



-- FAME_POINTS

-- fame_points setter
function setPlayerFamePoints(gPlayerID, updatePoints)
	
	-- check if valid player
	if gPlayerID == 0 then
		syschat("Error 1 - player does not exist")
		return false
	end
	
	-- check if points less than 0
	local curPoints = getPlayerFamePoints(gPlayerID)
	local nextPoints = curPoints + updatePoints
	if nextPoints < 0 then
		updatePoints = curPoints - curPoints
	end
	
	local query = mysql_query("UPDATE player.fame SET fame_points = fame_points + '"..updatePoints.."' WHERE pid = '"..gPlayerID.."'")
	-- local query = mysql_query("UPDATE player.player SET fame_points = fame_points + '"..updatePoints.."' WHERE name = '"..gPlayerName.."'")
	
	
	-- TITLE_CHECK
	local gPointsStep1 = 100
	local gPointsStep2 = 500
	local gPointsStep3 = 1000
	
	
	-- 7	Schuler
	if nextPoints >= gPointsStep1 and not titleIsUnlocked(TITLE_FAME1_ID) then
		titleUnlock(TITLE_FAME1_ID, TITLE_NAME[TITLE_FAME1_ID])
	end
	
	
	-- 8	Peiniger
	if nextPoints >= gPointsStep2 and not titleIsUnlocked(TITLE_FAME2_ID) then
		titleUnlock(TITLE_FAME2_ID, TITLE_NAME[TITLE_FAME2_ID])
	end
	
	
	-- 9	Massenqualer
	if nextPoints >= gPointsStep3 and not titleIsUnlocked(TITLE_FAME3_ID) then
		titleUnlock(TITLE_FAME3_ID, TITLE_NAME[TITLE_FAME3_ID])
	end
	-- END_OF_TITLE_CHECK
	
	
end

-- fame_points getter
function getPlayerFamePoints(gPlayerID)
	
	-- check if valid player
	if gPlayerID == 0 then
		syschat("Error 1 - player does not exist")
		return false
	end

	local query = mysql_query("SELECT fame_points FROM player.fame WHERE pid = '"..gPlayerID.."' LIMIT 1;")
	-- local query = mysql_query("SELECT fame_points FROM player.player WHERE name = '"..gPlayerID.."';")
	
	if query.fame_points == NULL then
		famePointsCreateTable(gPlayerID)
		query = mysql_query("SELECT fame_points FROM player.fame WHERE pid = '"..gPlayerID.."' LIMIT 1;")
	end
	

	local sqlPoints = query.fame_points[1]
	
	return sqlPoints
	
end

-- fame create table entry
function famePointsCreateTable(gPlayerID)
	local query = mysql_query("INSERT INTO player.fame (pid) VALUES('"..gPlayerID.."')")
end

function famePointsCreateKillLog(gPlayerID, gVictimID)
	local getCurUnix = getTimestamp()
	local query = mysql_query("INSERT INTO player.fame_log (victory_id, victim_id, timestamp) VALUES('"..gPlayerID.."', '"..gVictimID.."', '"..getCurUnix.."')")
end

function famePointsPlayerRecentlyKilledVictim(gPlayerID, gVictimID)
	local getCurUnix = getTimestamp()
	local unixRecentlyDelay = 60*30 -- 30 min.
	local unixNextTime = getCurUnix - unixRecentlyDelay
	local query = mysql_query("SELECT timestamp FROM player.fame_log WHERE victory_id = '"..gPlayerID.."' AND victim_id = '"..gVictimID.."' AND timestamp > '"..unixNextTime.."' LIMIT 1;")
	
	if query.timestamp != NULL then
	
		local unixKillDelay = query.timestamp[1] - unixNextTime
	
		return unixKillDelay
	end
	
	
	return 0
	
end

function famePointsGetVictoryPoints()
	return 10
end

function famePointsGetVictimPoints()
	return -5
end

function famePointsCalcVictoryPoints()
	return
end

function famePointsCalcVictimPoints()
	return
end

-- END_OF_FAME_POINTS



-- TITLE_SYSTEM

function titleUnlock(title_id, title_name)
	
	if TITLE_ENABLED == false then
		return
	end

	local gTitleStatus = pc.set_title(title_id, 1)
	
	if gTitleStatus then
		setTitleUnlockedCount(1)
		
		if title_name != nil then
			syschat("Du hast den Titel: '"..title_name.."' freigeschaltet.")
		end
		
	end
	
	return gTitleStatus
end

function titleLock(title_id)
	
	if TITLE_ENABLED == false then
		return
	end
	
	local gTitleStatus = pc.set_title(title_id, 0)
	
	if gTitleStatus then
		setTitleUnlockedCount(-1)
	end
	
	return gTitleStatus
end

function titleIsUnlocked(title_id)
	
	if TITLE_ENABLED == false then
		return false
	end
	
	return pc.get_title(title_id)
end

function getTitleUnlockedCount()
	
	local qflag = PlayerGetFlag(pc.get_player_id(), "title_count")
	if qflag == nil then
		qflag = 0
	end

	return qflag
end

function setTitleUnlockedCount(addValue)
	
	local qflag = PlayerGetFlag(pc.get_player_id(), "title_count")
	if qflag == nil then
		qflag = 0
	end
	
	local nextCount = qflag + addValue

	PlayerSetFlag(pc.get_player_id(), "title_count", nextCount)
	
	
	-- TITLE_CHECK
	local gPointsStep1 = 5
	local gPointsStep2 = 10
	local gPointsStep3 = 20
	
	-- 10	Titel Anfanger
	if nextCount >= gPointsStep1 and not titleIsUnlocked(TITLE_HOLDER1_ID) then
		titleUnlock(TITLE_HOLDER1_ID, TITLE_NAME[TITLE_HOLDER1_ID])
	end
	
	
	-- 11	Titelsammler
	if nextCount >= gPointsStep2 and not titleIsUnlocked(TITLE_HOLDER2_ID) then
		titleUnlock(TITLE_HOLDER2_ID, TITLE_NAME[TITLE_HOLDER2_ID])
	end
	
	
	-- 12	Titelmeister
	if nextCount >= gPointsStep3 and not titleIsUnlocked(TITLE_HOLDER3_ID) then
		titleUnlock(TITLE_HOLDER3_ID, TITLE_NAME[TITLE_HOLDER3_ID])
	end
	
	
	-- END_OF_TITLE_CHECK
	
end

-- END_OF_TITLE_SYSTEM



-- GLOBAL_FLAG_SYSTEM


-- local player flags

function PlayerSetFlag(gPlayerID, gFlagName, gFlagValue)
	
	if PlayerGetFlag(gPlayerID, gFlagName) != nil then
		mysql_query("UPDATE player.global_flags SET value='"..gFlagValue.."' WHERE pid='"..gPlayerID.."' AND flag='"..gFlagName.."';")
	else
		mysql_query("INSERT INTO player.global_flags (pid, flag, value) VALUES('"..gPlayerID.."', '"..gFlagName.."', '"..gFlagValue.."')")
	end
	
end

function PlayerDelFlag(gPlayerID, gFlagName)
	mysql_query("DELETE FROM player.global_flags WHERE pid = '"..gPlayerID.."' AND flag = '"..gFlagName.."'")
end

function PlayerGetFlag(gPlayerID, gFlagName)
	
	local query = mysql_query("SELECT value FROM player.global_flags WHERE pid = '"..gPlayerID.."' AND flag = '"..gFlagName.."';")
	
	if query.value != NULL then
		return query.value[1]
	end
	
	
	return nil
	
end


-- global player flags

function PlayerSetGlobalFlag(gFlagName, gFlagValue)
	mysql_query("UPDATE player.global_flags SET value='"..gFlagValue.."' WHERE flag='"..gFlagName.."';")
end

function PlayerDelGlobalFlag(gFlagName)
	mysql_query("DELETE FROM player.global_flags WHERE flag = '"..gFlagName.."' AND pid != 0")
end


-- event flags

function EventSetFlag(gFlagName, gFlagValue)
	
	if EventGetFlag(gFlagName) != nil then
		mysql_query("UPDATE player.global_flags SET value='"..gFlagValue.."' WHERE flag='"..gFlagName.."';")
	else
		mysql_query("INSERT INTO player.global_flags (flag, value) VALUES('"..gFlagName.."', '"..gFlagValue.."')")
	end
	
end

function EventDelFlag(gFlagName)
	mysql_query("DELETE FROM player.global_flags WHERE pid = '0' AND flag = '"..gFlagName.."")
end

function EventGetFlag(gFlagName)
	
	local query = mysql_query("SELECT value FROM player.global_flags WHERE pid = '0' AND flag = '"..gFlagName.."' LIMIT 1;")
	
	if query.value != NULL then
		return query.value[1]
	end
	
	
	return nil
	
end

-- END_OF_GLOBAL_FLAG_SYSTEM



function GuildAddLadderPoints(gGuildId, gValue)
	
	if check_p(gGuildId) == true or check_p(gValue) == true then
		return false
	end
	
	mysql_query("UPDATE player.guild SET ladder_point=ladder_point+'"..gValue.."' WHERE id='"..gGuildId.."';")
end

function GuildRemoveLadderPoints(gGuildId, gValue)
	
	if check_p(gGuildId) == true or check_p(gValue) == true then
		return false
	end
	
	mysql_query("UPDATE player.guild SET ladder_point=ladder_point-'"..gValue.."' WHERE id='"..gGuildId.."';")
end


function SoundPackPlaySound(iSoundpackId, sSoundType)
	
	if iSoundpackId < 1 then
		return
	end
		
	local sSoundpackName = sound_pack.GetSoundpackDir(iSoundpackId)
	local sSoundpackFile = sSoundpackName.."/"..sSoundType
	
	cmdchat("soundpack "..sSoundpackFile)
end


-- END_OF_Elendosfiles_QUESTLIB