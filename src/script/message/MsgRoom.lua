--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Room.proto

local _msgType =
{
    [ 150201 ] = "Room.ReqCreateRoom", -- 
    [ 150202 ] = "Room.ReqEnterRoom", -- 
    [ 150203 ] = "Room.ReqLeaveRoom", -- 
    [ 150204 ] = "Room.ReqAction", -- 
    [ 150101 ] = "Room.ResEnterRoom", -- 
    [ 150102 ] = "Room.ResLeaveRoom", -- 
    [ 150103 ] = "Room.ResAction", -- 
    [ 150104 ] = "Room.ResWillExcuteAction", -- 
    [ 150105 ] = "Room.ResFightResult", -- 
    [ 150106 ] = "Room.ResGameStartFightData", -- 
    [ 151210  ] = "Room.ReqMoveKeyData", --
    [ 151211  ] = "Room.ReqLogicKeyData", --
    [ 151110  ] = "Room.ResMoveKeyDatas", --
    [ 151111  ] = "Room.ResLogicKeyDatas", --
    [ 151212  ] = "Room.ReqUDPEnterRoom", --
}


local _msgID =
{
    CS_ROOM_REQCREATEROOM = 150201, -- 
    CS_ROOM_REQENTERROOM = 150202, -- 
    CS_ROOM_REQLEAVEROOM = 150203, -- 
    CS_ROOM_REQACTION = 150204, -- 
    SC_ROOM_RESENTERROOM = 150101, -- 
    SC_ROOM_RESLEAVEROOM = 150102, -- 
    SC_ROOM_RESACTION = 150103, -- 
    SC_ROOM_RESWILLEXCUTEACTION = 150104, -- 
    SC_ROOM_RESFIGHTRESULT = 150105, -- 
    SC_ROOM_RESGAMESTARTFIGHTDATA = 150106, -- 

    CS_ROOM_REQMOVEKEYDATA   = 151210,
    CS_ROOM_REQLOGICKEYDATA  = 151211,
    SC_ROOM_RESMOVEKEYDATAS  = 151110,
    SC_ROOM_RESLOGICKEYDATAS = 151111,
    CS_ROOM_REQUDPENTERROOM  = 151212, 

}

if not MSGTYPE then
	MSGTYPE = {}
	rawset(_G, "MSGTYPE", MSGTYPE)
end
if not MSGID then
	MSGID = {}
	rawset(_G, "MSGID", MSGID)
end
TableMerge(_msgType, MSGTYPE)
TableMerge(_msgID, MSGID)
