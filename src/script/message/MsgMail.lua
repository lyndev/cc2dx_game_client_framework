--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Mail.proto

local _msgType =
{
    [ 113201 ] = "Mail.ReqMailList", -- 
    [ 113202 ] = "Mail.ReqGetAccessory", -- 
    [ 113203 ] = "Mail.ReqMailRead", -- 
    [ 113204 ] = "Mail.ReqMailDelete", -- 
    [ 113101 ] = "Mail.ResMailList", -- 
    [ 113102 ] = "Mail.ResMailDelete", -- 
}


local _msgID =
{
    CS_MAIL_REQMAILLIST = 113201, -- 
    CS_MAIL_REQGETACCESSORY = 113202, -- 
    CS_MAIL_REQMAILREAD = 113203, -- 
    CS_MAIL_REQMAILDELETE = 113204, -- 
    SC_MAIL_RESMAILLIST = 113101, -- 
    SC_MAIL_RESMAILDELETE = 113102, -- 
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
