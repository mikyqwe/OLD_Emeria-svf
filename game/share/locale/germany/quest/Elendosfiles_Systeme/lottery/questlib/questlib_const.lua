




-- SERVER_NAME
SERVER_PANSOPHIA = 1
SERVER_ASTREGATE = 2

SERVER_LIST = {}
SERVER_LIST[1] = "Pansophia2"
SERVER_LIST[2] = "Astregate"


SERVER_ACTIVE = SERVER_ASTREGATE -- EDIT THIS FOR NEW SERVER

SERVER_NAME = SERVER_LIST[SERVER_ACTIVE]
SERVER_ID = SERVER_ACTIVE
-- END_OF_SERVER_NAME


-- NPC_VNUM
if SERVER_ID == SERVER_ASTREGATE then
	NPC_URIEL = 34150
else
	NPC_URIEL = 20011
end
-- END_OF_NPC_VNUM


-- TITLE_SYSTEM
TITLE_ENABLED = false

TITLE_MARATHON1_ID	= 1
TITLE_MARATHON2_ID	= 2
TITLE_MARATHON3_ID	= 3
TITLE_MARATHON4_ID	= 4
TITLE_MARATHON5_ID	= 5
TITLE_MARATHON6_ID	= 6
TITLE_FAME1_ID		= 7
TITLE_FAME2_ID		= 8
TITLE_FAME3_ID		= 9
TITLE_HOLDER1_ID	= 10
TITLE_HOLDER2_ID	= 11
TITLE_HOLDER3_ID	= 12
TITLE_QUEST1_ID		= 13
TITLE_QUEST2_ID		= 14
TITLE_QUEST3_ID		= 15
TITLE_QUEST4_ID		= 16
TITLE_ITEMSHOP1_ID	= 17
TITLE_ITEMSHOP2_ID	= 18
TITLE_ITEMSHOP3_ID	= 19
TITLE_ITEMSHOP4_ID	= 20
TITLE_EVENT1_ID	= 21
TITLE_EVENT2_ID	= 22
TITLE_EVENT3_ID	= 23
TITLE_EVENT4_ID	= 24
TITLE_SPECIAL1_ID = 25
TITLE_SPECIAL2_ID = 26

TITLE_NAME = {}
TITLE_NAME[1]		= "Astregate Anfanger"
TITLE_NAME[2]		= "Astregate Fan"
TITLE_NAME[3]		= "Astregate Liebhaber"
TITLE_NAME[4]		= "Astregate Zocker"
TITLE_NAME[5]		= "Astregate Workaholiker"
TITLE_NAME[6]		= "Astregate Zombie"
TITLE_NAME[7]		= "Schuler"
TITLE_NAME[8]		= "Peiniger"
TITLE_NAME[9]		= "Massenqualer"
TITLE_NAME[10]		= "Titel Anfanger"
TITLE_NAME[11]		= "Titelsammler"
TITLE_NAME[12]		= "Titelmeister"
TITLE_NAME[13]		= "Astregate Neuling"
TITLE_NAME[14]		= "Verzauberer"
TITLE_NAME[15]		= "Verrater"
TITLE_NAME[16]		= "Gildenmeister" -- TODO implement this title
TITLE_NAME[17]		= "Unterstützer" -- TODO implement this title
TITLE_NAME[18]		= "VIP"
TITLE_NAME[19]		= "Premium Käufer"
TITLE_NAME[20]		= "Schnäppchenjäger" -- TODO implement this title
TITLE_NAME[21]		= "Genie" -- TODO implement this title
TITLE_NAME[22]		= "Otaku" -- TODO implement this title
TITLE_NAME[23]		= "Partybär" -- TODO implement this title
TITLE_NAME[24]		= "Terminator" -- TODO implement this title
TITLE_NAME[25]		= "Beta Tester" -- TODO implement this title
TITLE_NAME[26]		= "Guardian" -- TODO implement this title
-- END_OF_TITLE_SYSTEM
