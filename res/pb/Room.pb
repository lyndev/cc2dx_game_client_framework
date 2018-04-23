
Ú

Room.protoRoomPlayer.proto"H
KeyMoveData
posX (
posY (
angle (
roleId (	"?
KeyLogicData
skillId (
propId (
roleId (	"]
ReqMoveKeyData$
	_moveData (2.Room.KeyMoveData
userId (	"
MsgID
eMsgID™ù	"b
ReqLogicKeyData(
logicKeyData (2.Room.KeyLogicData
userId (	"
MsgID
eMsgID´ù	"O
ResMoveKeyDatas%

_moveDatas (2.Room.KeyMoveData"
MsgID
eMsgID∆ú	"T
ResLogicKeyDatas)
logicKeyDatas (2.Room.KeyLogicData"
MsgID
eMsgID«ú	"L
ReqUDPEnterRoom

roomNumber (
userId (	"
MsgID
eMsgID¨ù	"O
RoomInfo
roomId (	
roomNum (
roomType (
gameType ("J
ReqCreateRoom
roomType (
gameType ("
MsgID
eMsgIDπï	"m
ReqEnterRoom

roomNumber (
roomType (
bQuick (
gameType ("
MsgID
eMsgID∫ï	"G
ReqLeaveRoom 
roomInfo (2.Room.RoomInfo"
MsgID
eMsgIDªï	"Q
ZJH_AddScore
compareState (
addScoreCount (
currentTimes ("g
ZJH_CompareCard
comparePlayerId (	
compareResult (
cards (
comparedCards	 ("
ZJH_LookCard
cards ("≤
Action

actionType (
playerId (	(
zjh_addScore (2.Room.ZJH_AddScore.
zjh_comparecard (2.Room.ZJH_CompareCard(
zjh_lookcard	 (2.Room.ZJH_LookCard"A
	ReqAction
actions (2.Room.Action"
MsgID
eMsgIDºï	"æ
ResEnterRoom 
roomInfo (2.Room.RoomInfo
playerId (	*
playerBaseInfo (2.Player.PlayerInfo
locationIndex (
bReady	 (
gameType ("
MsgID
eMsgID’î	"7
ResLeaveRoom
playerId (	"
MsgID
eMsgID÷î	"@
	ResAction
action (2.Room.Action"
MsgID
eMsgID◊î	"J
ResWillExcuteAction
action (2.Room.Action"
MsgID
eMsgIDÿî	"ê
ZJHDeskData
maxScore (
	cellScore (
currentTimes (
maxScoreLimit (
bankerPlayerId (	
currentPlayerId (	"8
FightDeskData'
zjh_DeskData (2.Room.ZJHDeskData"F
ZJHPlayerFightData
playerId (	
isReady (
cards (	"G
PlayerFightData4
zjhPlayerFightData (2.Room.ZJHPlayerFightData"ó
ZJH_GameResult
gameTax (3

playerCard (2.Room.ZJH_GameResult.PlayerCard?

PlayerCard
playerId (	
cards (	
getScore ("'
ResFightResult"
MsgID
eMsgIDŸî	"û
ResGameStartFightData.
playerFightData (2.Room.PlayerFightData*
fightDeskData (2.Room.FightDeskData

fightState ("
MsgID
eMsgID⁄î	B
game.messageBRoomMessage