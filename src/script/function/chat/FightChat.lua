--[[
-- Copyright (C), 2015, 
-- 文 件 名: FightChat.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-18
-- 完成日期: 
-- 功能描述: 战斗聊天，仅在棋牌战斗开始的创建
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFightChat.lua.log'

CFightChat = class("CEntity")

function CFightChat:New()
    local self = {}
    setmetatable( self, CFightChat )
    self.m_chatRecordList = {}
    return self
end

function CFightChat:Init(msg)
    CMsgRegister:RegMsgListenerHandler(MSGID.SC_PLAYER_FIGHT_CHAT, function ( msgData )
        self:ResAddChat(msgData)
    end, "CUIFightDaer_SC_PLAYER_FIGHT_CHAT")      
end

function CFightChat:ResAddChat(msgData)
    if msgData.fighChatinfo and msgData.fighChatinfo.chatType == 3 then
        print("添加一条自定义的聊天")
        table.insert(self.m_chatRecordList, msgData)
    end
    local event = {}
    event.name = CEvent.FightChat
    event.chatType      = msgData.fighChatinfo.chatType
    event.faceID        = msgData.fighChatinfo.faceID
    event.fixWordID     = msgData.fighChatinfo.fixWordID
    event.gameType      = msgData.fighChatinfo.gameType
    event.customContent = msgData.fighChatinfo.customContent
    event.roleId      = msgData.roleId
    gPublicDispatcher:DispatchEvent(event)
end

function CFightChat:GetCustomChats()
    return self.m_chatRecordList
end

function CFightChat:Destroy()
    self.m_chatRecordList = {}
    CMsgRegister:UnRegListenerHandler(MSGID.SC_PLAYER_FIGHT_CHAT, "CUIFightDaer_SC_PLAYER_FIGHT_CHAT")
end