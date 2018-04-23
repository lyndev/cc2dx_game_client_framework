-- =========================================================================  
-- 文 件 名: FightQiPaiBase.lua
-- 作    者: lyn
-- 创建日期: 2016-12-18
-- 功能描述: 战斗基类, 棋牌对战从这里继承
-- 其它相关: 
-- 修改记录: 
-- =========================================================================  

-- 日志文件名
local LOG_FILE_NAME = 'CFightQiPaiBase.lua.log'

require "script.function.chat.FightChat"

SetGolbal("TIME_COUNT_DOWN", 3)
SetGolbal("ONE_SECOND", 1)

CFightQiPaiBase = class("CFightQiPaiBase")

function CFightQiPaiBase:New(o)
    local self = o or {}
    setmetatable(self, CFightQiPaiBase)
    self.m_changeDeskCountDown = 0
    self.m_fightChat           = CFightChat:New()
    self.m_fightState          = ENUM.GameFightState.Begin
    self.m_fightPlayers    = {}
    log_info(LOG_FILE_NAME, "初始棋牌管理器基类")
    return self
end

function CFightQiPaiBase:Init(msg)
    if msg then
        self:SetPlayTimes(msg.times or 1)
        self:SetRoomType(msg.roomType or ENUM.RoomType.Normal)
        self:SetRoomID(msg.roomId or -1)
        self:SetFightState(msg.fightState or ENUM.GameFightState.Begin)
        self:SetRoomCoinType(msg.currencyType or -1)
        self:SetDeskScore(msg.difen)
        if msg.isOwner and msg.playerInfo then
            self:SetRoomMasterID(msg.playerInfo.uid)
        end
    end
    -- 发送战斗开始事件
    local event = {}
    event.name = CEvent.FightBegin 
    gPublicDispatcher:DispatchEvent(event)
end

function CFightQiPaiBase:GetFightChat()
    return self.m_fightChat
end

function CFightQiPaiBase:GetChangeDeskCountDown()
    return self.m_changeDeskCountDown
end

function CFightQiPaiBase:SetChangeDeskCountDown(v)
    self.m_changeDeskCountDown = v
end

function CFightQiPaiBase:Update(dt)
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

function CFightQiPaiBase:AddPlayer(roleId, player)
    if player then
        self.m_fightPlayers[roleId] = player
    else
        log_error(LOG_FILE_NAME, "添加战斗玩家失败,玩家对象为空")
    end
end


function CFightQiPaiBase:RemovePlayer(roleId)
    if self.m_fightPlayers[roleId] then
        self.m_fightPlayers[roleId] = nil
    else
        log_info(LOG_FILE_NAME, "删除的玩家不存在,不需要删除")
    end
end

function CFightQiPaiBase:EmitEventPlayerLeaveRoom(locationType)
    local event = {}
    event.name = CEvent.PlayerEnterLeaveRoom
    event.locationType = locationType
    event.action = "leave"
    gPublicDispatcher:DispatchEvent(event)
end

function CFightQiPaiBase:EmitEventPlayerEnterRoom(locationType, playerInfo)
    local event = {}
    event.name = CEvent.PlayerEnterLeaveRoom
    event.locationType = locationType
    event.action = "enter"
    event.playerInfo = playerInfo or {}
    gPublicDispatcher:DispatchEvent(event)
end

function CFightQiPaiBase:SetDeskScore(score)
    self.m_mDeskScore = score or 0
end

function CFightQiPaiBase:GetPlayer(roleId)
    return self.m_fightPlayers[roleId]
end

function CFightQiPaiBase:GetPlayers()
    return self.m_fightPlayers
end

function CFightQiPaiBase:GetFightState()
    return self.m_fightState or ENUM.GameFightState.Begin
end

function CFightQiPaiBase:SetFightState(fightState)
    CPlayer:GetInstance():SetGameFightState(fightState)
    self.m_fightState = fightState
end

function CFightQiPaiBase:GetPlayerSex(roleId)
    local _playerInfo = self:GetPlayer(roleId)
    if _playerInfo then
        return _playerInfo.sex
    end
    return 0
end

function CFightQiPaiBase:ReqAction(sendData)
    --TODO:发送动作
end

function CFightQiPaiBase:SetRoomType(roomType)
    self.m_roomType = roomType
end

function CFightQiPaiBase:GetGameType()
    return self.m_gameType
end

function CFightQiPaiBase:SetGameType(gameType)
    self.m_gameType = gameType
end

function CFightQiPaiBase:GetRoomType()
    return self.m_roomType
end

function CFightQiPaiBase:SetStateEnd(bStageEnd)
    self.m_stageEnd = bStageEnd
end

function CFightQiPaiBase:SetRoomCoinType(coinType)
    self.m_coinType = coinType or ENUM.CoinType.Coin 
end

function CFightQiPaiBase:GetRoomCoinType()
    return self.m_coinType or ENUM.CoinType.Coin
end

function CFightQiPaiBase:IsStateEnd()
    return self.m_stageEnd
end

function CFightQiPaiBase:SetRoomID(roomId)
    self.m_roomID = roomId
end

function CFightQiPaiBase:GetRoomID()
    return self.m_roomID
end

function CFightQiPaiBase:SetRoomMasterID(roleId)
   self.m_roomMastgerID = roleId
end

function CFightQiPaiBase:GetRoomMasterID()
    return self.m_roomMastgerID
end

function CFightQiPaiBase:GetFightPlayersInfo()
    return self.m_fightPlayerInfo
end

function CFightQiPaiBase:SetPlayTimes(times)
    self.m_playeTiems = times or 1
end

function CFightQiPaiBase:GetPlayTimes(times)
    return self.m_playeTiems or 1
end

function CFightQiPaiBase:OnGameFightStartMsgHandler(msgData)
    self:SetGameFightData(msgData)
    SendLocalMsg(CC_FIGHT_GAME_FIGHT_START, msgData)
end

function CFightQiPaiBase:GetGameFightData()
    return self.m_gameFightData
end

function CFightQiPaiBase:SetGameFightData(fightData)
    self.m_gameFightData = fightData
end

function CFightQiPaiBase:EnterRoom(msgData)
    local _playerInfo = clone(msgData.playerBaseInfo)
    _playerInfo.locationIndex = msgData.locationIndex
    _playerInfo.bReady =  msgData.bReady
    _playerInfo.roleId = _playerInfo.roleId
    self:AddPlayer(_playerInfo.roleId, _playerInfo)
    self:EmitEventPlayerEnterRoom(msgData.locationIndex, _playerInfo)
end

function CFightQiPaiBase:LeaveRoom(roleId, bRemoveInfo)
    local _playerInfo = self:GetPlayer(roleId)
    if _playerInfo then
        self:EmitEventPlayerLeaveRoom(_playerInfo.locationIndex)
        if bRemoveInfo then
            self:RemovePlayer(roleId)
        end
    end
end

function CFightQiPaiBase:Destroy()    
    local event = {}
    event.name = CEvent.FightDestory
    gPublicDispatcher:DispatchEvent(event)
    SetGolbal("gFightMgr", false)
    log_info(LOG_FILE_NAME, "CFightQiPaiBase 销毁管理器基类")
end