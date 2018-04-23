--[[
-- Copyright (C), 2015, 
-- 文 件 名: FriendManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-29
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFriendManager.lua.log'

CFriendManager = class("CFriendManager")

-- 在线状态
local ELineState =
{
    EType_Onffline  = 0,  -- 下线
    EType_Online    = 1,  -- 不在线
}

CFriendManager._instance = nil

function CFriendManager:New(o)
    local o = o or {}
    o.m_tFriendList   = {}          -- 好友列表
    o.m_tApplyForList = {}         -- 搜索的玩家信息
    o.m_chatList      = {}          -- 聊天记录
    setmetatable(o, CFriendManager)
    return o
end

-- 获取好友单件
function CFriendManager:GetInstance()
    if not CFriendManager._instance then
        CFriendManager._instance = CFriendManager:New()
    end
    return CFriendManager._instance
end

-- 初始化
function CFriendManager:Init(msg)
    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESALLFRIENDINFO, function( msgData )
        self:ResAllFriendListHandler(msgData)
    end, "CFriendManager_SC_FRIEND_RESALLFRIENDINFO")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESALLAPPLYFRIENDLIST, function( msgData )
        self:ResAllApplyFriendInfo(msgData)
    end, "CFriendManager_SC_FRIEND_RESALLAPPLYFRIENDLIST")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESADDFRIEND, function( msgData )
        if msgData.rst then
            print("申请成功")
        end
    end, "CFriendManager_SC_FRIEND_RESADDFRIEND")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESREMOVEFRIEND, function( msgData )
        self:ResRemoveFriendHandler(msgData)
    end, "CFriendManager_SC_FRIEND_RESREMOVEFRIEND")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_NOTIFYFRIENDONOFFLINE, function( msgData )
        self:ResFirendOnlineOrOfflineHandler(msgData)
    end, "CFriendManager_SC_FRIEND_NOTIFYFRIENDONOFFLINE")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESSEARCHFRIEND, function( msgData )
        self:ResSearchFriendHandler(msgData)
    end, "CFriendManager_SC_FRIEND_RESSEARCHFRIEND")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_RESFIRENDCHAT, function( msgData )
        self:ResFriendChatHandler(msgData)
    end, "CFriendManager_SC_FRIEND_RESFIRENDCHAT")

    CMsgRegister:RegMsgListenerHandler(MSGID.SC_FRIEND_OFFLINEMSGNOFITY, function( msgData )
        print("离线消息")
        for i, v in ipairs(msgData.chatInfo or {}) do
            self:ResFriendChatHandler(v)
        end
    end, "CFriendManager_SC_FRIEND_OFFLINEMSGNOFITY")

    
end

-- 更新函数
function CFriendManager:Update( ft )
   
end

-- 客户端请求删除好友
function CFriendManager:ReqDeleteFriend( roleId )
    if not roleId or roleId == '' then
        return
    end
    local msg = {}
    msg.id  = tostring(roleId)
    SendMsgToServer(MSGID.CS_FRIEND_REQREMOVEFRIEND, msg)
end

-- 同意/拒绝
function CFriendManager:ReqAgreeFriend(roleId, bAgree)
    if not roleId or roleId == "" then
        return
    end
    local msg = {}
    msg.uid  = roleId
    msg.bAccept = bAgree or false
    SendMsgToServer(MSGID.CS_FRIEND_REQFRIENDACTION, msg)
end

-- 发送聊天内容
function CFriendManager:ReqFriendChat(reciverroleId, content)
    if not reciverroleId or reciverroleId == "" then
        Notice("接收者不能为空")
        return
    end

    if not content or content == "" then
        Notice("不能发送空的聊天内容")
        return
    end

    local msg = {}
    msg.senderUid = CPlayer:GetInstance():GetRoleID()
    msg.receiverUid = reciverroleId
    msg.text = content
    local localSave = clone(msg)
    localSave.sendtime = CPlayer:GetInstance():GetServerTimeMs() * 0.001
    localSave.bRead = true
    self:PushMySendChat(localSave)
    local event = {} 
    event.name = CEvent.AddOneFriendMsg
    event.msg = localSave
    gPublicDispatcher:DispatchEvent(event)
    SendMsgToServer(MSGID.CS_FRIEND_REQFIRENDCHAT, msg)
end

function CFriendManager:PushMySendChat(sendData)
    if not self.m_chatList[sendData.receiverUid] then
        self.m_chatList[sendData.receiverUid] = {}
    end
    table.insert(self.m_chatList[sendData.receiverUid], sendData)
end

function CFriendManager:PushOtherChat(sendData)
    print("添加其他人发送的聊天到列表")
    if not self.m_chatList[sendData.senderUid] then
        self.m_chatList[sendData.senderUid] = {}
    end
    table.insert(self.m_chatList[sendData.senderUid], sendData)
end

function CFriendManager:SetChatReadWithFriend(roleId)
    local _chats = self.m_chatList[roleId]
    if _chats then
        for i,v in ipairs(_chats) do
            v.bRead = true
        end
    end
end

-- 客户端请求搜索好友
function CFriendManager:ReqSearchFriend(roleId)
    if not roleId or roleId == '' then
        return
    end
    local msg = {}
    msg.id = tonumber(roleId)
    SendMsgToServer(MSGID.CS_FRIEND_REQSEARCHFRIEND, msg)  
end

-- 客户端申请加好友
function CFriendManager:ReqApplyFriend(roleId)
    if not roleId or roleId == '' then
        return
    end
    local msg = {}
    msg.id = tostring(roleId)
    SendMsgToServer(MSGID.CS_FRIEND_REQAPPLYFRIEND, msg)  
end

-- 所有好友
function CFriendManager:ResAllFriendListHandler(msg)
    for i, v in ipairs(msg.friends or {}) do
        self.m_tFriendList[v.uid] = v
    end
    local event = {}
    event.name = CEvent.FriendsUpdate
    gPublicDispatcher:DispatchEvent(event)
end

-- 处理申请列表
function CFriendManager:ResAllApplyFriendInfo(msg)
    local event = {}
    event.name = CEvent.ApplyFriendsUpdate
    gPublicDispatcher:DispatchEvent(event)
    for i, v in ipairs(msg.friends or {}) do
        self.m_tApplyForList[v.uid] = v
    end
end

-- 好友上下线处理
function CFriendManager:ResFirendOnlineOrOfflineHandler(msg)
    if self.m_tFriendList[msg.uid] then
        self.m_tFriendList[msg.uid].bOnline = msg.bOnline
    end
end

-- 服务器返添加好友结果
function CFriendManager:ResAddFriendHandler(msg)
    if msg.rst == 0 then
        if self.m_tFriendList then
            self.m_tFriendList[self.m_searchPlayerinfo.uid] = self.m_searchPlayerinfo
            self.m_tApplyForList[self.m_searchPlayerinfo.uid] = nil
            self.m_searchPlayerinfo = nil
            --TODO:添加好友时间通知
        end
    end
end

-- 服务器返回删除好友结果
function CFriendManager:ResRemoveFriendHandler(msg)
    if msg.rst == 0 then
        self.m_tFriendList[msg.id] = nil
        --TODO:删除好友时间通知
    end
end

-- 服务器返回搜索到的玩家
function CFriendManager:ResSearchFriendHandler(msg)
    self.m_searchPlayerinfo = msg.player
end

-- 服务器返回搜索到的玩家
function CFriendManager:ResFriendChatHandler(msg)
    if msg then
        self:PushOtherChat(msg)
    end
end

-- 获取聊天
function CFriendManager:GetChat(roleId)
    return self.m_chatList[roleId] or {}
end

-- 获取所有好友列表
function CFriendManager:GetFriendList()
    return self.m_tFriendList
end

-- 获取一个好友的信息
function CFriendManager:GetFriend(roleId)
    if roleId then
        log_info(LOG_FILE_NAME, "获取好友信息的id:%s", roleId)
        return self.m_tFriendList[roleId]
    else
        log_error(LOG_FILE_NAME, "获取好友信息失败,roleId为空")
    end
end

function CFriendManager:IsOnline(roleId)
    local _friend = self:GetFriend(roleId)
    if _friend then
        return _friend.bOnline
    else
        return false
    end
end

function CFriendManager:GetApplys()
    return self.m_tApplyForList
end

function CFriendManager:GetAllNotReadChatPlayerInfo()
    local _notReadChatPlayerInfo = {}
    for id, chats in pairs(self.m_chatList) do
        for i,chat in ipairs(chats) do
            if not chat.bRead then
                table.insert(_notReadChatPlayerInfo, {roleId = id, sendtime = chat.sendtime})
                break
            end
        end
    end
    return _notReadChatPlayerInfo
end

function CFriendManager:IsFirend( roleId )
    return self.m_tFriendList[roleId]
end

function CFriendManager:OnDestroy()
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESALLFRIENDINFO, "CFriendManager_SC_FRIEND_RESALLFRIENDINFO")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESALLAPPLYFRIENDLIST, "CFriendManager_SC_FRIEND_RESALLAPPLYFRIENDLIST")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESADDFRIEND, "CFriendManager_SC_FRIEND_RESADDFRIEND")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESREMOVEFRIEND, "CFriendManager_SC_FRIEND_RESREMOVEFRIEND")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_NOTIFYFRIENDONOFFLINE, "CFriendManager_SC_FRIEND_NOTIFYFRIENDONOFFLINE")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESSEARCHFRIEND, "CFriendManager_SC_FRIEND_RESSEARCHFRIEND")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_RESFIRENDCHAT, "CFriendManager_SC_FRIEND_RESFIRENDCHAT")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_FRIEND_OFFLINEMSGNOFITY, "CFriendManager_SC_FRIEND_OFFLINEMSGNOFITY")
    

    CFriendManager._instance = nil
end