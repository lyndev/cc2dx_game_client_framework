--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Login.proto

local _msgType =
{
    [ 100201 ] = "Login.ReqLogin", -- 客户端请求登录消息
    [ 100202 ] = "Login.ReqCreateRole", -- 客户端请求创建角色
    [ 100105 ] = "Login.ResCreateRoleFailed", -- 创建角色失败
    [ 100101 ] = "Login.ResLoginFailed", -- 服务端回复登录失败
    [ 100102 ] = "Login.ResLoginSuccess", -- 服务端回复登录成功
    [ 100203 ] = "Login.ReqReconnect", -- 客户端请求重连消息
    [ 100103 ] = "Login.ResReconnetFialed", -- 服务端回复重连失败
    [ 100104 ] = "Login.ResReconnetSuccess", -- 服务端回复重连成功
    [ 100105 ] = "Login.ResNotLogin", -- 服务端回复玩家没有登录（或者会话过期）
    [ 100106 ] = "Login.ResCloseSocket", -- 
    [ 100198 ] = "Login.ResPingPong", -- 
    [ 100199 ] = "Login.ResAck", -- 
}


local _msgID =
{
    CS_LOGIN_REQLOGIN = 100201, -- 客户端请求登录消息
    CS_LOGIN_REQCREATEROLE = 100202, -- 客户端请求创建角色
    SC_LOGIN_RESCREATEROLEFAILED = 100105, -- 创建角色失败
    SC_LOGIN_RESLOGINFAILED = 100101, -- 服务端回复登录失败
    SC_LOGIN_RESLOGINSUCCESS = 100102, -- 服务端回复登录成功
    CS_LOGIN_REQRECONNECT = 100203, -- 客户端请求重连消息
    SC_LOGIN_RESRECONNETFIALED = 100103, -- 服务端回复重连失败
    SC_LOGIN_RESRECONNETSUCCESS = 100104, -- 服务端回复重连成功
    SC_LOGIN_RESNOTLOGIN = 100105, -- 服务端回复玩家没有登录（或者会话过期）
    SC_LOGIN_RESCLOSESOCKET = 100106, -- 
    SC_LOGIN_RESPINGPONG = 100198, -- 
    SC_LOGIN_RESACK = 100199, -- 
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
