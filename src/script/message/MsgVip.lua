--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Vip.proto

local _msgType =
{
    [ 128202 ] = "Vip.ReqGetRewards", -- 领取奖励
    [ 128100 ] = "Vip.ResVipLevel", -- 等级变化消息
    [ 128101 ] = "Vip.ResVipRewardsInfo", -- 奖励状态
    [ 128102 ] = "Vip.ResGetRewards", -- 请求领奖结果
}


local _msgID =
{
    CS_VIP_REQGETREWARDS = 128202, -- 领取奖励
    SC_VIP_RESVIPLEVEL = 128100, -- 等级变化消息
    SC_VIP_RESVIPREWARDSINFO = 128101, -- 奖励状态
    SC_VIP_RESGETREWARDS = 128102, -- 请求领奖结果
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
