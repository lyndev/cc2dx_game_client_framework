--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Backpack.proto

local _msgType =
{
    [ 104201 ] = "Backpack.ReqBackpackList", -- 客户端请求背包数据
    [ 104202 ] = "Backpack.ReqItemUse", -- 客户端请求使用物品
    [ 104203 ] = "Backpack.ReqItemSell", -- 客户端请求出售物品
    [ 104204 ] = "Backpack.ReqItemCell", -- 客户端请求分解物品
    [ 104205 ] = "Backpack.ReqItemCombine", -- 客户端请求合成物品
    [ 104206 ] = "Backpack.ReqExpPropUse", -- 客户端请求使用经验道具
    [ 104207 ] = "Backpack.ReqDebrisCombine", -- 客户端请求融合碎片
    [ 104208 ] = "Backpack.ReqTestAddAllItem", -- 测试方法：客户端添加所有道具消息
    [ 104101 ] = "Backpack.ResBackpackList", -- 服务端返回背包数据
    [ 104102 ] = "Backpack.ResItemUse", -- 服务端返回物品使用结果
    [ 104103 ] = "Backpack.ResItemSell", -- 服务器返回物品出售结果
    [ 104104 ] = "Backpack.ResItemCell", -- 服务器返回物品分解结果
    [ 104105 ] = "Backpack.ResItemCombine", -- 服务器返回物品合成结果
    [ 104106 ] = "Backpack.ResExpPropUse", -- 服务器返回经验道具的使用结果
    [ 104108 ] = "Backpack.ResBackpackUpdate", -- 服务端回复背包变化
    [ 104109 ] = "Backpack.ResResourceUpdate", -- 服务端回复资源变化
    [ 104110 ] = "Backpack.ResOpenBox", -- 服务端回复开宝箱的结果（开宝箱的消息和使用一般物品一样：，这个消息是单独返回，用于客户端播放开箱动画）
}


local _msgID =
{
    CS_BACKPACK_REQBACKPACKLIST = 104201, -- 客户端请求背包数据
    CS_BACKPACK_REQITEMUSE = 104202, -- 客户端请求使用物品
    CS_BACKPACK_REQITEMSELL = 104203, -- 客户端请求出售物品
    CS_BACKPACK_REQITEMCELL = 104204, -- 客户端请求分解物品
    CS_BACKPACK_REQITEMCOMBINE = 104205, -- 客户端请求合成物品
    CS_BACKPACK_REQEXPPROPUSE = 104206, -- 客户端请求使用经验道具
    CS_BACKPACK_REQDEBRISCOMBINE = 104207, -- 客户端请求融合碎片
    CS_BACKPACK_REQTESTADDALLITEM = 104208, -- 测试方法：客户端添加所有道具消息
    SC_BACKPACK_RESBACKPACKLIST = 104101, -- 服务端返回背包数据
    SC_BACKPACK_RESITEMUSE = 104102, -- 服务端返回物品使用结果
    SC_BACKPACK_RESITEMSELL = 104103, -- 服务器返回物品出售结果
    SC_BACKPACK_RESITEMCELL = 104104, -- 服务器返回物品分解结果
    SC_BACKPACK_RESITEMCOMBINE = 104105, -- 服务器返回物品合成结果
    SC_BACKPACK_RESEXPPROPUSE = 104106, -- 服务器返回经验道具的使用结果
    SC_BACKPACK_RESBACKPACKUPDATE = 104108, -- 服务端回复背包变化
    SC_BACKPACK_RESRESOURCEUPDATE = 104109, -- 服务端回复资源变化
    SC_BACKPACK_RESOPENBOX = 104110, -- 服务端回复开宝箱的结果（开宝箱的消息和使用一般物品一样：，这个消息是单独返回，用于客户端播放开箱动画）
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
