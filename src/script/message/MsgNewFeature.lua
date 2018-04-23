--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/NewFeature.proto

local _msgType =
{
    [ 115101 ] = "NewFeature.ResFeatureInfo", -- 服务器发送功能状态
    [ 115102 ] = "NewFeature.ResUpdateFeature", -- 服务器发送功能更新
}


local _msgID =
{
    SC_NEWFEATURE_RESFEATUREINFO = 115101, -- 服务器发送功能状态
    SC_NEWFEATURE_RESUPDATEFEATURE = 115102, -- 服务器发送功能更新
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
