--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Notify.proto

local _msgType =
{
    [ 118101 ] = "Notify.ResNotifyPlayer", -- 提示消息
    [ 118102 ] = "Notify.ResNotify", -- 走马灯公告
}


local _msgID =
{
    SC_NOTIFY_RESNOTIFYPLAYER = 118101, -- 提示消息
    SC_NOTIFY_RESNOTIFY = 118102, -- 走马灯公告
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
