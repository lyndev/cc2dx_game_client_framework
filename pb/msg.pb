
∏i
	msg.protorpc"∑
PlayerBaseInfo
uid (	
name (	
sex (
level (
exp (

vipLeftDay (
header (
coin (
gem	 (
roleId
 (
gameType (	
roomType (
	insurCoin (
accountType (

friendUids (	
	headerUrl (	
phone (	
bModifyName (

bModifySex (
lastLoginTime (
profits (
expTotal (
vipOpenTime (
lastRechargeTime ("¨
PlayerExtraInfo
items (2.rpc.BagItem
sign (2.rpc.Signature
tasks (2.rpc.DailyTask
scores (2
.rpc.Score#
bankrupt (2.rpc.BankruptInfo""
BagItem

id (	
num (",
BagItemNofity
items (2.rpc.BagItem"x
	Signature
month (
signs (
lastSign (
contiDay (
contiRewardTms (
	hasSigned ("œ
	DailyTask
	resetTime (
doneIds (
getIds (
shares (
	shareFris (
daerTms (
mjTms (
pokerTms (

winDaerTms	 (
winMjTms
 (
winPokerTms ("0
Score
name (	
win (
loss ("1
BankruptInfo
time (
rewardTimes (")
ScoreNofify
scores (2
.rpc.Score"5
Request
method (	
serialized_request ("~
LoginCnsInfo
cnsIp (	
gsInfo (	

versionOld (

versionNew (
downloadUrl (	

versionMid ("}
Login
uid (	
openid (	
roleId (
	headerUrl (	
nickName (	
sex (
clientVersion (	"o
LoginResult
result (	
server_time (
errmsg (	
openid (	
uid (	
roleId ("T

PlayerInfo!
base (2.rpc.PlayerBaseInfo#
extra (2.rpc.PlayerExtraInfo"Z
ResourceNotify
coin (
gem (
	insurCoin (
level (
exp (")

OnlineBody
roomId (
num ("+

OnlineInfo
info (2.rpc.OnlineBody""
OnlinePlayerReq
partIds ("y
OnlinePlayerMsg!
daerInfo (2.rpc.OnlineInfo
mjInfo (2.rpc.OnlineInfo"
	pokerInfo (2.rpc.OnlineInfo"
	NotifyMsg
txtId (	"
	HeartBeat"
HeartBeatRst
time ("8
PlayerInRoomNotify
gameType (	
roomType ("4
RoleInfo
name (	
sex (
phone (	"ê
SysMail
mailId (	
version (
title (	
content (	
sendtime (
attach (	
overduetime (
bRead ("I
PlayerMailInfo
sysmail_version (
maillist (2.rpc.SysMail" 
ReqReadOneMail
mailId (	"#
RemoveMailNotify
mailIds ("/
AddMailNotify
maillist (2.rpc.SysMail"S
ReqBroadCast
playerID (	
content (	
bVip (

playerName (	"|
BroadCastNotify
broadCastID (
sysBroad (
content (	

playerName (	
playerID (	
vip ("ì
	FightChat
chatType (
faceID (
	fixWordID (
gameType (	
customContent (	
itemId (	
receiverPlayerID (	"J
ReqFightRoomChat
playerID (	$
fighChatinfo (2.rpc.FightChat"^
FightRoomChatNotify
playerID (	$
fighChatinfo (2.rpc.FightChat
offline ("
Notice
content (	"5
ReqInsurenceMoney
	bWithdraw (
value ("À
Player
name (	
sex (
level (
header (
roleId (
	headerUrl (	
uid (	
bOnline (
exp	 (
coin
 (
scores (2
.rpc.Score
diamond ("+
FriendsList
friends (2.rpc.Player"2
RequestFriendsList
friends (2.rpc.Player"
	ReqString

id (	"
ReqInt

id ("1
SearchFriendNofify
player (2.rpc.Player"4
ReqResponseAddFriend
uid (	
bAccept ("
AddFriendNofify
rst ("*
DelFriendNofity
rst (

id (	" 
FriendsIdList
friends (	"X
SendFriendChat
	senderUid (	
receiverUid (	
text (	
sendtime ("9
OfflineMsgNofity%
chatInfo (2.rpc.SendFriendChat"2
FriendStatusNofify
uid (	
bOnline ("
ErrorCodeNofify
code (""
TaskFinishNofity
taskId (	"%
ReqTaskShare
bShare2Friend ("
ReqRankList
rankType ("æ
RankInfo
uid (	
roleId (
sex (
name (	
level (
exp (
bVip (
coin (
gem	 (
	headerUrl
 (	
	rankValue (
rankNum ("=
RankList
rankList (2.rpc.RankInfo
rankType ("6
FormatedMsg
code (	
args (2.rpc.MsgArg"!
Msg
code (	
text (	"
	NumberMsg
value ("
MsgArg	
s (		
i ("
GuestBindOk
success ("
Ping

ClientTime ("!

PingResult
server_time ("
KickPlayerMsg
time ("5

C2SChatP2P

ToPlayerId (	
ChatContent (	"H
C2SChatAlliance
ChatContent (	
useIM (
	voiceTime (	"E
C2SChatWorld
ChatContent (	
useIM (
	voiceTime (	"h

S2CChatP2P
FromPlayerId (	
FromPlayerName (	
FromPlayerLevel (
ChatContent (	"±
S2CChatWorld
FromPlayerId (	
FromPlayerName (	
FromPlayerLevel (
ChatTime (
ChatContent (	
useIM
 (
	voiceTime (	
	messageId ("M
Card
value (
bBig (
bLock (
bChi (
bHu (">
Pattern
ptype (
cards (2	.rpc.Card

hu ("a
UserInfo
playeID (	
name (	
coins (
bVip (
head (	
sex ("2
EnterRoomREQ
gameType (	
roomType ("
QuickEnterRoomREQ"™
EnterRoomACK'

playerInfo (2.rpc.PlayerBaseInfo
shangjiaType (
bReady (
code (
roomId (
isNormalReqEnterRoom (
roomNum ("6
LeaveRoomREQ
playerID (	
isChangeDesk ("6
LeaveRoomACK
playerID (	
isChangeDesk ("7
	CountDown
playerID (	
currentCountDown ("∂
FightPlayerInfo
playerID (	
	handCards (2	.rpc.Card!
longPattern (2.rpc.Pattern 

kanPattern (2.rpc.Pattern
erLongTouYi (2	.rpc.Card
chuGuoCards (2	.rpc.Card*
chiPengZhaoLongCards (2.rpc.Pattern
	currentHu (
bZhuang	 (
bBao
 (
bTuoGuan ("≈
FightCurrentStateInfo"
currentDeskCard (2	.rpc.Card,
currentCountDownInfo (2.rpc.CountDown
currentDeskCardPlayerID (	
currentDeskRemainCard (
bCurrentDeskCardMo ("â
GameStartACK.
fightPlayersInfo (2.rpc.FightPlayerInfo5
currentFightState (2.rpc.FightCurrentStateInfo

fightState ("∑
	ActionREQ
action (
playerID (	
chiCards (2.rpc.Pattern
biCards (2.rpc.Pattern
chuPai (2	.rpc.Card
cardArgs
 (2.rpc.MJCard
sysType ("q
ChiAtionArgs!
canChiCards (2.rpc.Pattern!
needBiCards (2.rpc.Pattern
cardArgs (2	.rpc.Card"∂
	ActionACK
action (
playerID (	
cardArgs (2	.rpc.Card*
chiPengZhaoLongCards (2.rpc.Pattern
updateHu (
currenDeskRemianCard (
result	 ("J
ActionNotifyACK
action ('
chiAtionArgs (2.rpc.ChiAtionArgs"7
CountdownNotifyACK!
	countDown (2.rpc.CountDown">
PassCardNotifyACK
playerID (	
card (2	.rpc.Card"*
PassedNotifyACK
card (2	.rpc.Card"+
MingTang
mingTang (
value (":
JieSuanCoin
playerID (	
coin (
tag ("£
DaerPlayerJieSuanPattern
playerID (	

hu (
score (
patterns (2.rpc.Pattern
mingTang	 (2.rpc.MingTang
coin (
tag ("¨
JieSuanNotifyACK?
daerPlayerJieSuanPattern (2.rpc.DaerPlayerJieSuanPattern
diCards (2	.rpc.Card
huangZhuang	 (&
addi (2.rpc.JieSuanAdditionData"¶
JieSuanAdditionData
sysType (
stageEnd (
success (
coin (2.rpc.JieSuanCoin
jieSuanTime (
curTimes (
continueTime ("F
FinalJieSuanNotifyACK-
jieSuanInfo (2.rpc.JieSuanAdditionData"D
MJCard
value (
cType (
rcType (
flag ("U
	MJPattern
ptype (
cType (
cards (2.rpc.MJCard
isShow ("
MJQuickEnterRoomREQ"®
MJEnterRoomACK'

playerInfo (2.rpc.PlayerBaseInfo
location (
bReady (
code (
roomId (
isNormalReqEnterRoom (
roomNum ("8
MJLeaveRoomREQ
playerID (	
isChangeDesk ("8
MJLeaveRoomACK
playerID (	
isChangeDesk ("9
MJCountDown
playerID (	
currentCountDown ("˜
MJFightPlayerInfo
playerID (	
	handCards (2.rpc.MJCard$
showPatterns (2.rpc.MJPattern
chuCards (2.rpc.MJCard
bZhuang	 (
bBao
 (
bTuoGuan (
handCardCount (#
alreadyCardArg (2.rpc.MJCard"Ü
MJFightCurrentStateInfo
currentCountDown (
activePlayerID (	
lastActivePlayerID (	
currentDeskRemainCard ("è
MJGameStartACK0
fightPlayersInfo (2.rpc.MJFightPlayerInfo7
currentFightState (2.rpc.MJFightCurrentStateInfo

fightState ("•
MJActionACK
action (
playerID (	
cardArgs (2.rpc.MJCard'
pengGangPattern (2.rpc.MJPattern
currenDeskRemianCard (
result	 (">
MJActionArgs
action (
	cardsArgs (2.rpc.MJCard"7
MJActionNotifyACK"
actions (2.rpc.MJActionArgs";
MJCountdownNotifyACK#
	countDown (2.rpc.MJCountDown"Y
MJRemoveCardNotifyACK
playerID (	
card (2.rpc.MJCard
removedType ("A
MJTieGuiREQ
bTieGui (
playerID (	
sysType ("-

MJMingTang
mingTang (
value ("á
MJPlayerJieSuanInfo
playerID (	
coin ( 
patterns (2.rpc.MJPattern!
mingTang
 (2.rpc.MJMingTang
tag ("Ü
MJJieSuanNotifyACK3
playerJieSuanInfo (2.rpc.MJPlayerJieSuanInfo
huangZhuang	 (&
addi (2.rpc.JieSuanAdditionData"ª
CreateRoomREQ
currencyType (
gameType (
difen (
	limitCoin (
times (
maxMultiple (
isDaiGui (
tiYongAmount	 (
qiHuKeAmount
 ("¬
RoomInfo

id (
currencyType (
gameType (
difen (
	limitCoin (
times (
maxMultiple (
isDaiGui (
tiYongAmount	 (
qiHuKeAmount
 (":
CreateRoomACK
room (2.rpc.RoomInfo
code ("
RoomListREQ".
RoomListACK
roomList (2.rpc.RoomInfo"'
JieSanRoomREQ
operatorStatus ("4
JieSanPlayerInfo
playerID (	
status ("W
JieSanRoomNotify/
jieSanPlayerInfo (2.rpc.JieSanPlayerInfo

remainTime ("O
JieSanRoomUpdateStatusNotify/
jieSanPlayerInfo (2.rpc.JieSanPlayerInfo"?
EnterCustomRoomREQ
gameType (	

id (
pwd (	"…
EnterCustomRoomACK'

playerInfo (2.rpc.PlayerBaseInfo
shangjiaType (
location (
bReady (
code (
roomId (
gameType (
times (
curTimes (
isOwner	 (
currencyType
 (
difen (
qiHuKeAmount (
tiYongAmount (
roomInfo (2.rpc.RoomInfo"&
LeaveCustomRoomREQ
playerID (	"&
LeaveCustomRoomACK
playerID (	"'
FindRoomREQ

id (
name (	"8
FindRoomACK
room (2.rpc.RoomInfo
code ("B
ForceLeaveRoomREQ

id (	
sysType (
gameType ("H
InviteFirendsJionCustomRoomREQ
playerID (	
currencyType ("É
!InviteFirendsJionCustomRoomNotify
code (
gameType (	
roomID (
invitePlayerName (	
currencyType ("ù
OtherPlayerInfo
userID (
userName (

userHeadID (
userwechatHeadURL (
winNum (
loseNum (

lv (
coin ("&
OtherPlayerInfoREQ
playerID (	"
MatchListREQ"+
MatchListACK
matches (2
.rpc.Match"<
Match

id (
enrollAmount (
	countdown ("
	EnrollREQ

id ("
	EnrollACK
result ("
WithdrawREQ

id ("
WithdrawACK
result ("4
AmountChangeNotifyACK
matches (2
.rpc.Match"-
StartEntranceACK
match (2
.rpc.Match"â
OrderInfoNofity
	partnerId (	
prepayId (	
package (	
nonceStr (	
	timeStamp (
sign (	
appId (	"X
PayResultNotify
	partnerId (	
result (

error_desc (	
vipDay ("
PokerQuickEnterRoomREQ"B
CreatePockerRoomReq
uid (	
BlindId (
LimId ("%
CreatePockerRoomAck
roomNo ("W
	C2SAction
act (
uid (	
raise (!
base (2.rpc.PlayerBaseInfo"ô
	S2CAction
operater (	
act (
raise (
pockers (2.rpc.Pocker

combineNum (
countdownEnd (
pots (
winners (	!
infos	 (2.rpc.PockerManBase#
	beginInfo
 (2.rpc.PockerBegin/
comparePlayers (2.rpc.ComparePokerPlayer"x
ComparePokerPlayer
uid (	
pockers (2.rpc.Pocker#
combinePockers (2.rpc.Pocker

combineNum ("]
PockerBegin
	dealerUid (	

smBlindUid (	
bigBlindUid (	

attendUids (	"ã
S2CPockerManInfo
	headerUrl (	
name (	
sex (
coin (
gem (
roleId (

bestPocker (

lv ("ª
PockerManBase
uid (	
	headerUrl (	
coin (
drops (
status (
pockers (2.rpc.Pocker
deskIdx (
nickName (	
endTime	 (
sex
 ("$
Pocker
eType (
num ("ï
PockerRoomBase
pockers (2.rpc.Pocker
pots (
	dealerUid (	
roomId (

smallBlind (
bigBlind (
roomNo ("j
PockerRoomInfo#
players (2.rpc.PockerManBase%
roombase (2.rpc.PockerRoomBase
code ("
LeavePockerRoom
uid (	