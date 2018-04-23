--[[
-- Copyright (C), 2015, 
-- 文 件 名: FightBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-18
-- 完成日期: 
-- 功能描述: 战斗基类, 棋牌对战从这里继承
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFightBase.lua.log'

require "script.function.chat.FightChat"

SetGolbal("TIME_COUNT_DOWN", 3)
SetGolbal("ONE_SECOND", 1)

CFightBase = class("CFightBase")

function CFightBase:New()
    local self = {}
    SetGolbal("gFightMgr", self)
    setmetatable(self, CFightBase)
    self.m_changeDeskCountDown = 0
    self.m_fightChat           = CFightChat:New()
    self.m_fightState          = ENUM.GameFightState.Begin
    self.m_fightPlayers        = {}
    return self
end

function CFightBase:Init(msg)
    dump(msg, "初始化战斗基类", 10)
    if msg then
        self:SetPlayTimes(msg.times or 1)
        self:SetRoomType(msg.roomType or ENUM.RoomType.Normal)
        self:SetRoomID(msg.roomId or -1)
        self:SetFightState(msg.fightState or ENUM.GameFightState.Begin)
        self:SetRoomCoinType(msg.currencyType)
        self:SetDeskScore(msg.difen)
    end
    -- 离开普通比赛对战房间
    CMsgRegister:RegMsgListenerHandler(MSGID.SC_DAER_LEAVEROOMACK, function ( msgData )
        self:ResPlayerLeaveRoomHandler(msgData)
    end, "CFightBase_SC_DAER_LEAVEROOMACK")

    -- 离开自建房间
    CMsgRegister:RegMsgListenerHandler(MSGID.SC_PLAYER_LEAVECUSTOMROOMACK, function ( msgData )
        self:ResPlayerLeaveCustomRoomHandler(msgData)
    end, "CFightBase_SC_PLAYER_LEAVECUSTOMROOMACK")

    -- 离开比赛场
    -- TODO:
    
    self.m_fightChat:Init()
end

function CFightBase:GetChangeDeskCountDown()
    return self.m_changeDeskCountDown
end

function CFightBase:SetChangeDeskCountDown(v)
    self.m_changeDeskCountDown = v
end

function CFightBase:Update(dt)
    if self.m_changeDeskCountDown and self.m_changeDeskCountDown >=0 then
        ONE_SECOND = ONE_SECOND - dt
        if ONE_SECOND <= 0 then
            ONE_SECOND = 1
            self.m_changeDeskCountDown = self.m_changeDeskCountDown - 1
            if self.m_changeDeskCountDown <= 0 then
                self.m_changeDeskCountDown = 0
            end
        end
    end
end

function CFightBase:AddPlayer(roleId, player)
    if player then
        self.m_fightPlayers[roleId] = player
    else
        log_error(LOG_FILE_NAME, "添加战斗玩家失败,玩家对象为空")
    end
end

function CFightBase:RemovePlayer(roleId)
    if self.m_fightPlayers[roleId] then
        self.m_fightPlayers[roleId] = nil
    else
        log_info(LOG_FILE_NAME, "删除的玩家不存在,不需要删除")
    end
end

function CFightBase:SetDeskScore(score)
    self.m_mDeskScore = score or 0
end

function CFightBase:GetPlayer(roleId)
    return self.m_fightPlayers[roleId]
end

function CFightBase:GetPlayers()
    return self.m_fightPlayers
end

function CFightBase:GetFightState()
    return self.m_fightState or ENUM.GameFightState.Begin
end

function CFightBase:SetFightState(fightState)
    CPlayer:GetInstance():SetGameFightState(fightState)
    self.m_fightState = fightState
end

function CFightBase:SetRoomType(roomType)
    self.m_roomType = roomType
end

function CFightBase:GetGameType()
    return self.m_gameType
end

function CFightBase:SetGameType(gameType)
    self.m_gameType = gameType
end

function CFightBase:GetRoomType()
    return self.m_roomType
end

function CFightBase:GetFightChat()
    return self.m_fightChat
end

function CFightBase:SetStateEnd(bStageEnd)
    self.m_stageEnd = bStageEnd
end

function CFightBase:SetRoomCoinType(coinType)
    self.m_coinType = coinType or ENUM.CoinType.Coin 
end

function CFightBase:GetRoomCoinType()
    return self.m_coinType or ENUM.CoinType.Coin
end

function CFightBase:IsStateEnd()
    if self.m_stageEnd then
        return self.m_stageEnd
    else
        return true
    end
end

function CFightBase:ReqLeaveRoom(bChangeDesk)
    local sendData = {}
    sendData.roleId = CPlayer:GetInstance():GetRoleID()
    sendData.isChangeDesk = bChangeDesk or false
    SendMsgToServer(MSGID.CS_DAER_LEAVEROOMREQ, sendData)   
end

function CFightBase:ReqLeaveCustomRoom()
    local sendData = {}
    sendData.roleId = CPlayer:GetInstance():GetRoleID()
    SendMsgToServer(MSGID.CS_PLAYER_LEAVECUSTOMROOMREQ, sendData)   
end

function CFightBase:SetRoomID(roomId)
    self.m_roomID = roomId
end

function CFightBase:GetRoomID()
    return self.m_roomID
end

function CFightBase:GetFightPlayersInfo()
    return self.m_fightPlayerInfo
end

function CFightBase:SetPlayTimes(times)
    self.m_playeTiems = times or 1
end

function CFightBase:GetPlayTimes(times)
    return self.m_playeTiems or 1
end

function CFightBase:ResPlayerLeaveRoomHandler(msgData)

end

function CFightBase:ResPlayerLeaveCustomRoomHandler(msgData)

end

function CFightBase:Destroy()
    CPlayer:GetInstance():SetGameFightState(ENUM.GameFightState.None)
    CPlayer:GetInstance():SetHeartBeatInterval(G_HEART_BEAT_IDLE_INTERVAL)
    self.m_fightChat:Destroy()
    local event = {}
    event.name = CEvent.FightDestory
    gPublicDispatcher:DispatchEvent(event)
    log_info(LOG_FILE_NAME, "销毁管理器基类")
    SetGolbal("gFightMgr", false)
end