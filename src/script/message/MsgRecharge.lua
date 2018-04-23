--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Recharge.proto

local _msgType =
{
    [ 126201 ] = "Recharge.ReqRechargeVerify", -- 客户端请求验证充值结果
    [ 126202 ] = "Recharge.ReqGetFirstRechargeReward", -- 客户端请求领取首充奖励
    [ 126101 ] = "Recharge.ResVerifyResult", -- 服务端返回充值验证结果
    [ 126102 ] = "Recharge.ResRechargeInfo", -- 服务器返回充值信息以及首充奖励信息
    [ 126103 ] = "Recharge.ResGetFirstRewardResult", -- 服务器返回领取首充奖励结果
}


local _msgID =
{
    CS_RECHARGE_REQRECHARGEVERIFY = 126201, -- 客户端请求验证充值结果
    CS_RECHARGE_REQGETFIRSTRECHARGEREWARD = 126202, -- 客户端请求领取首充奖励
    SC_RECHARGE_RESVERIFYRESULT = 126101, -- 服务端返回充值验证结果
    SC_RECHARGE_RESRECHARGEINFO = 126102, -- 服务器返回充值信息以及首充奖励信息
    SC_RECHARGE_RESGETFIRSTREWARDRESULT = 126103, -- 服务器返回领取首充奖励结果
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
