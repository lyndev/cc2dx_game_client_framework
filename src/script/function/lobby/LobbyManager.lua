-- =========================================================================
-- 文 件 名: LobbyManager.lua
-- 作    者: lyn
-- 创建日期: 2017-05-03
-- 功能描述: 大厅游戏管理器
-- 其它相关:  
-- 修改记录: 
-- =========================================================================  

-- 日志文件名
local LOG_FILE_NAME = 'CLobbyManager.lua.log'

require "script.function.fight.FightManagerFactory"

CLobbyManager = class('CLobbyManager')
CLobbyManager._instance = nil

function CLobbyManager:New()
    local o = {}
    setmetatable(o, CLobbyManager)
    return o
end

function CLobbyManager:GetInstance(msg)
    if not CLobbyManager._instance then
        CLobbyManager._instance = CLobbyManager:New()
    end
    return  CLobbyManager._instance
end

function CLobbyManager:Init(msg)

    -- 房间创建(进入)成功
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESENTERROOM, function(msgData)
        self:EnterFightRoomHandler(msgData)
    end, "CLobbyManager")

    -- 房间创建离开房间
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESLEAVEROOM, function(msgData)
        self:LeaveFightRoomHandler(msgData)
    end, "CLobbyManager")
end

function CLobbyManager:SetCurrentPlayingGameType(gameType)
    self.m_currentPlayGame = gameType
end

function CLobbyManager:GetCurrentPlayingGameType()
    return self.m_currentPlayGame
end

function CLobbyManager:EnterFightRoomHandler(msgData)
    --TODO:检测游戏是否易经下载,下载后进入
    if not gFightMgr then

        CloseUI("CUIPlayerCreateRoom")
        --self:SetCurrentPlayingGameType(msgData.gameType)
        msgData.mapId = 3
        gFightMgr = FightManagerFactory:GetInstance():CreateFightManager(ENUM.GameType.TANK, msgData)
        CloseUI("CUIMain") 
    end
    gFightMgr:EnterRoom(msgData)
    
end

function CLobbyManager:LeaveFightRoomHandler(msgData)
    if gFightMgr then
        gFightMgr:LeaveRoom(msgData)
    end
end

function CLobbyManager:Destroy()
    CMsgRegister:RemoveMsgListenerHandler(MSGID.SC_ROOM_RESENTERROOM, "CLobbyManager")
    CMsgRegister:RemoveMsgListenerHandler(MSGID.SC_ROOM_RESLEAVEROOM, "CLobbyManager")
    CLobbyManager._instance = nil
end