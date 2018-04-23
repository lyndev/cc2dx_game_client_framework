--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Player.proto

local _msgType =
{
    [ 103201 ] = "Player.ReqClientInitOver", -- 客户端初始化完成
    [ 103202 ] = "Player.ReqGMCommand", -- 临时命令消息
    [ 103203 ] = "Player.ReqSystemInfo", -- 客户端请求重新获取系统信息比如说将游戏切入后台再进来时，需要重新获取一些关键的系统信息
    [ 103205 ] = "Player.ReqSystemReset", -- 客户端请求系统重置
    [ 103206 ] = "Player.ReqTimestamp", -- 客户端请求时间戳
    [ 103101 ] = "Player.ResPlayerInfo", -- 登录完成服务器返回玩家游戏数据
    [ 103102 ] = "Player.ResChangePlayerAttribute", -- 改变角色属性消息
    [ 103103 ] = "Player.ResSystemInfo", -- 服务端返回系统信息
    [ 103105 ] = "Player.ResSystemReset", -- 服务端返回系统信息重置
    [ 103106 ] = "Player.ResTimestamp", -- 服务器返回请求时间戳
}


local _msgID =
{
    CS_PLAYER_REQCLIENTINITOVER = 103201, -- 客户端初始化完成
    CS_PLAYER_REQGMCOMMAND = 103202, -- 临时命令消息
    CS_PLAYER_REQSYSTEMINFO = 103203, -- 客户端请求重新获取系统信息比如说将游戏切入后台再进来时，需要重新获取一些关键的系统信息
    CS_PLAYER_REQSYSTEMRESET = 103205, -- 客户端请求系统重置
    CS_PLAYER_REQTIMESTAMP = 103206, -- 客户端请求时间戳
    SC_PLAYER_RESPLAYERINFO = 103101, -- 登录完成服务器返回玩家游戏数据
    SC_PLAYER_RESCHANGEPLAYERATTRIBUTE = 103102, -- 改变角色属性消息
    SC_PLAYER_RESSYSTEMINFO = 103103, -- 服务端返回系统信息
    SC_PLAYER_RESSYSTEMRESET = 103105, -- 服务端返回系统信息重置
    SC_PLAYER_RESTIMESTAMP = 103106, -- 服务器返回请求时间戳
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
