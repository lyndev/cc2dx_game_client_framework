--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Guide.proto

local _msgType =
{
    [ 123201 ] = "Guide.ReqGuidedIdList", -- 客户端请求获取当前引导进度
    [ 123202 ] = "Guide.ReqSaveGuideList", -- 客户端请求保存引导进度
    [ 123203 ] = "Guide.ReqRemoveGuideList", -- 客户端请求删除引导记录
    [ 123101 ] = "Guide.ResGuidedIdList", -- 服务端返回当前的引导进度
}


local _msgID =
{
    CS_GUIDE_REQGUIDEDIDLIST = 123201, -- 客户端请求获取当前引导进度
    CS_GUIDE_REQSAVEGUIDELIST = 123202, -- 客户端请求保存引导进度
    CS_GUIDE_REQREMOVEGUIDELIST = 123203, -- 客户端请求删除引导记录
    SC_GUIDE_RESGUIDEDIDLIST = 123101, -- 服务端返回当前的引导进度
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
