--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Rebate.proto

local _msgType =
{
    [ 129201 ] = "Rebate.ReqGetReward", -- 客户端请求领取奖励
    [ 129202 ] = "Rebate.ReqRebateInfo", -- 请求全部活动信息
    [ 129101 ] = "Rebate.ResRebateInfo", -- 全部活动信息
    [ 129102 ] = "Rebate.ResError", -- 错误码消息
    [ 129103 ] = "Rebate.ResGetReward", -- 
}


local _msgID =
{
    CS_REBATE_REQGETREWARD = 129201, -- 客户端请求领取奖励
    CS_REBATE_REQREBATEINFO = 129202, -- 请求全部活动信息
    SC_REBATE_RESREBATEINFO = 129101, -- 全部活动信息
    SC_REBATE_RESERROR = 129102, -- 错误码消息
    SC_REBATE_RESGETREWARD = 129103, -- 
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
