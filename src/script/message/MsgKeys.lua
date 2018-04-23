--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Keys.proto

local _msgType =
{
    [ 132201 ] = "Keys.ReqUseKey", -- 客户端请求使用激活码兑换码
    [ 132101 ] = "Keys.ResUseKey", -- 服务端回复使用激活码兑换码
}


local _msgID =
{
    CS_KEYS_REQUSEKEY = 132201, -- 客户端请求使用激活码兑换码
    SC_KEYS_RESUSEKEY = 132101, -- 服务端回复使用激活码兑换码
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
