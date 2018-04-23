--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/OperActivity.proto

local _msgType =
{
    [ 139201 ] = "OperActivity.ReqReward", -- 请求领取奖励
    [ 139101 ] = "OperActivity.ResActivityInfo", -- 初始化消息
    [ 139102 ] = "OperActivity.ResReward", -- 领取奖励结果
    [ 139103 ] = "OperActivity.ResNewActivity", -- 有新活动开启
    [ 139104 ] = "OperActivity.ResHaveRewardCanGet", -- 有奖励可以领取
}


local _msgID =
{
    CS_OPERACTIVITY_REQREWARD = 139201, -- 请求领取奖励
    SC_OPERACTIVITY_RESACTIVITYINFO = 139101, -- 初始化消息
    SC_OPERACTIVITY_RESREWARD = 139102, -- 领取奖励结果
    SC_OPERACTIVITY_RESNEWACTIVITY = 139103, -- 有新活动开启
    SC_OPERACTIVITY_RESHAVEREWARDCANGET = 139104, -- 有奖励可以领取
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
