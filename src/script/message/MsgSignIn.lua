--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/SignIn.proto

local _msgType =
{
    [ 117201 ] = "SignIn.ReqSignIn", -- 请求签到
    [ 117202 ] = "SignIn.ReqExtraGet", -- 请求补领
    [ 117101 ] = "SignIn.ResSignInInfo", -- 初始化玩家签到信息
    [ 117102 ] = "SignIn.ResSignInResult", -- 返回签到结果
    [ 117103 ] = "SignIn.ResResExtraGet", -- 返回补领结果
}


local _msgID =
{
    CS_SIGNIN_REQSIGNIN = 117201, -- 请求签到
    CS_SIGNIN_REQEXTRAGET = 117202, -- 请求补领
    SC_SIGNIN_RESSIGNININFO = 117101, -- 初始化玩家签到信息
    SC_SIGNIN_RESSIGNINRESULT = 117102, -- 返回签到结果
    SC_SIGNIN_RESRESEXTRAGET = 117103, -- 返回补领结果
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
