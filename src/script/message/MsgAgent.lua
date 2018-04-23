--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Agent.proto

local _msgType =
{
    [ 925201 ] = "Agent.ReqLoginToAgent", -- 请求登录
    [ 925101 ] = "Agent.ResLoginToClient", -- 回复登录消息
    [ 925202 ] = "Agent.ReqUpdateLoginZone", -- 登录区域设置
    [ 925102 ] = "Agent.ResUpdateLoginZone", -- 回复登录区域设置
}


local _msgID =
{
    CS_AGENT_REQLOGINTOAGENT = 925201, -- 请求登录
    SC_AGENT_RESLOGINTOCLIENT = 925101, -- 回复登录消息
    CS_AGENT_REQUPDATELOGINZONE = 925202, -- 登录区域设置
    SC_AGENT_RESUPDATELOGINZONE = 925102, -- 回复登录区域设置
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
