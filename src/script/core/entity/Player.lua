-- [[
-- Copyright (C), 2015, 
-- 文 件 名: Player.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-28
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]
  
-- 日志文件名
local LOG_FILE_NAME = 'CPlayer.log'

require "script.function.package.BackPackage"

CPlayer = {}
CPlayer.__index = CPlayer
CPlayer._instance = nil

G_HEART_BEAT_IDLE_INTERVAL     = 30
G_HEART_BEAT_FIGHT_INTERVAL    = 15


function CPlayer:New(o)
    o = o or {}
    setmetatable(o, CPlayer)
    o.m_nHeartBeatInterval = 10                     -- 心跳间隔时间
    o.m_sNickName          = ''                     -- 用户昵称
    o.m_userId            = 0                      -- 用户ID
    o.m_nLoginTimeMs       = 0                      -- 登陆时间(服务器)
    o.m_nLevel             = 1                      -- 等级(可以获取军衔)
    o.m_nCoinNum           = 0                      -- 金币的数量
    o.m_nGem               = 0                      -- 钻石的数量
    o.m_nAccountType       = 0                      -- 账号类型(0:游客 1:微信)
    o.m_nSex               = 0                      -- 性别 (0：男 1：女)
    o.m_nCurServerTimeMs   = 0                      -- 当前服务器时间 (毫秒)
    o.m_nCurInterval       = 0                      -- 当前间隔时间
    o.m_nHeartBeatState    = 0                      -- 0: 正常   1：等待回复中
    o.m_gameFightState     = ENUM.GameFightState.None
    o.m_backpackge         = CBackPackage:New()
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 玩家单例对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPlayer:GetInstance()
    if not CPlayer._instance then
        CPlayer._instance = CPlayer:New()
    end
    return CPlayer._instance
end

function CPlayer:Init(msg)

end

function CPlayer:GetGold()
    return self.m_nCoinNum or 0
end

function CPlayer:SetGold(num)
    self.m_nCoinNum = num
end

function CPlayer:GetHeadURL(  )
    return self.m_sHeadUrl
end

function CPlayer:SetGem(num)
    return self.m_nGemNum
end

function CPlayer:GetGem()
    self.m_nGemNum = num
end

function CPlayer:SetGameFightState(fightState)
    self.m_gameFightState = fightState
end

function CPlayer:GetGameFightState()
    return self.m_gameFightState
end

function CPlayer:SetHeartBeatInterval( interval )
    self.m_nHeartBeatInterval = interval
end

function CPlayer:Update(dt)
    if CLuaLogic.LoginState == 1 then
        --本地时间更新
        local dt_ms = dt * 1000
        self.m_nCurServerTimeMs = self.m_nCurServerTimeMs + dt_ms
        --心跳时间检测
        self.m_nCurInterval = self.m_nCurInterval + dt
        if self.m_nCurInterval >= self.m_nHeartBeatInterval then
            self.m_nCurInterval = 0
            self:SendHearBeatMsg()
        end
    end
end

function CPlayer:SetPlayerBaseInfo(playerInfo)
    assert(playerInfo)
    self.m_userId       = playerInfo.userId
    self.m_roleId       = playerInfo.roleId
    self.m_sNickName    = playerInfo.roleName
    self.m_nSex         = playerInfo.gender
    self.m_nLevel       = playerInfo.roleLevel
end

--设置登录时间
function CPlayer:SetLoginTime( server_time )
    self.m_nLoginTimeMs = server_time
    self.m_nCurServerTimeMs = server_time

end

--获取登录时间
function CPlayer:GetLoginTime(  )
    return self.m_nLoginTimeMs
end

-- 获取当前服务器时间
function CPlayer:GetServerTimeMs(  )
    return self.m_nCurServerTimeMs
end

function CPlayer:SetUserID( userID )
    assert(userID)
    if userID ~=0 then
        self.m_userId  = userID
    else
        log_error(LOG_FILE_NAME, '设置用户id错误:%d', userID)
    end
end

function CPlayer:GetUserID()
    return self.m_userId
end

function CPlayer:SetRoleID( userID )
    assert(userID)
    if userID ~=0 then
        self.m_roleId  = userID
    else
        log_error(LOG_FILE_NAME, '设置玩家id错误:%d', userID)
    end
end

function CPlayer:GetRoleID()
    return self.m_roleId
end

function CPlayer:SetUserName( nickName )
    self.m_sNickName = nickName
end

function CPlayer:GetUserNickName()
    return self.m_sNickName
end

function CPlayer:GetLevel()
    return self.m_nLevel or 1
end

function CPlayer:SetLevel( level )
    self.m_nLevel = level
end

function CPlayer:GetBackPackage()
    return self.m_backpackge
end

function CPlayer:Destroy()

    CPlayer._instance = nil
end