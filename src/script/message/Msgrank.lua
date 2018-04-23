--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Rank.proto

local _msgType =
{
    [ 122201 ] = "rank.ReqBattlefieldRankList", -- 客户端请求指定星级的战场（仙府）排行榜
    [ 122101 ] = "rank.ResBattlefieldRankList", -- 服务端返回指定星级的战场（仙府）排行榜
}


local _msgID =
{
    CS_RANK_REQBATTLEFIELDRANKLIST = 122201, -- 客户端请求指定星级的战场（仙府）排行榜
    SC_RANK_RESBATTLEFIELDRANKLIST = 122101, -- 服务端返回指定星级的战场（仙府）排行榜
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
