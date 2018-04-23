--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Chat.proto

local _msgType =
{
    [ 131501 ] = "Chat.ReqSendTextMessage", -- 发送文本信息
    [ 131502 ] = "Chat.ReqSendAudioMessage", -- 发送语音信息
    [ 131503 ] = "Chat.ReqFetchAudioMessage", -- 请求获取语音信息
    [ 131601 ] = "Chat.ResSendTextMessage", -- 返回发送文本消息
    [ 131602 ] = "Chat.ResSendAudioMessage", -- 返回发送语音消息
    [ 131603 ] = "Chat.ResFetchAudioMessage", -- 返回获取语音消息
    [ 131604 ] = "Chat.NotifyTextMessage", -- 
    [ 131605 ] = "Chat.NotifyAudioMessage", -- 
    [ 131606 ] = "Chat.ResInitChatRecordMessag", -- 初始化聊天记录消息
    [ 131699 ] = "Chat.ResError", -- 
}


local _msgID =
{
    _CHAT_REQSENDTEXTMESSAGE = 131501, -- 发送文本信息
    _CHAT_REQSENDAUDIOMESSAGE = 131502, -- 发送语音信息
    _CHAT_REQFETCHAUDIOMESSAGE = 131503, -- 请求获取语音信息
    _CHAT_RESSENDTEXTMESSAGE = 131601, -- 返回发送文本消息
    _CHAT_RESSENDAUDIOMESSAGE = 131602, -- 返回发送语音消息
    _CHAT_RESFETCHAUDIOMESSAGE = 131603, -- 返回获取语音消息
    _CHAT_NOTIFYTEXTMESSAGE = 131604, -- 
    _CHAT_NOTIFYAUDIOMESSAGE = 131605, -- 
    _CHAT_RESINITCHATRECORDMESSAG = 131606, -- 初始化聊天记录消息
    _CHAT_RESERROR = 131699, -- 
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
