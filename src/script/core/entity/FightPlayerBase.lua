--[[
-- Copyright (C), 2015, 
-- 文 件 名: FightPlayerBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-27
-- 完成日期: 
-- 功能描述: 战斗玩家类 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFightPlayerBase.lua.log'

CFightPlayerBase = class("CFightPlayerBase")

function CFightPlayerBase:New()
    local self = {}
    setmetatable(self, CFightPlayerBase)
    return self
end

function CFightPlayerBase:Init(msg)
    self:SetSex(msg.sex)
    self:SetroleId(msg.uid)
    self:SetPlayerName(msg.name)
    self:SetLevel(msg.level)
    self:SetHeadURL(msg.headerUrl)
    self:SetCoin(msg.coin)
    self:SetIsRoomMaster(msg.isOwner)
    self:SetIsWechatPlayer(msg.accountType)
    self:SetVipDay(msg.vipLeftDay or 0)
end

function CFightPlayerBase:SetHeadSprite(headSprite)
    self.m_headSprite = headSprite or display.newSprite()    
end

function CFightPlayerBase:SetPlayerName(playerName)
    self.m_playerName = playerName
end

function CFightPlayerBase:SetIsWechatPlayer(accountType)
    self.m_wechatPlayerType = accountType
end

function CFightPlayerBase:IsWechatPlayer()
    if accountType == ENUM.AccountType.Wechat then
        return true
    end
    return false
end

function CFightPlayerBase:SetLevel(lv)
    self.m_level = lv
end

function CFightPlayerBase:GetLevel(lv)
    return self.m_level
end

function CFightPlayerBase:SetVipDay(vipDay)
    self.m_vipDay = vipDay
end

function CFightPlayerBase:GetVipDay(lv)
    return self.m_vipDay
end

function CFightPlayerBase:IsVIP()
    if self.m_vipDay > 0 then
        return true
    end
    return false
end

function CFightPlayerBase:GetPlayerName()
    return self.m_playerName
end

function CFightPlayerBase:SetroleId(roleId)
    self.m_roleId = roleId
end

function CFightPlayerBase:GetroleId()
    return self.m_roleId
end

function CFightPlayerBase:GetHeadSprite()
    return self.m_headSprite 
end

function CFightPlayerBase:SetHeadURL(headURL)
    self.m_headURL = headURL   
end

function CFightPlayerBase:GetHeadURL()
    return self.m_headURL 
end

function CFightPlayerBase:SetSex(sex)
    self.m_sex = sex or 1
end

function CFightPlayerBase:GetSex()
   return self.m_sex 
end

function CFightPlayerBase:SetCoin(coin)
    return self.m_curCoin or 0
end

function CFightPlayerBase:GetCoin()
   return self.m_curCoin 
end

function CFightPlayerBase:SetIsRoomMaster(bMaster)
    self.m_bRoomMaster = bMaster
end

function CFightPlayerBase:IsRoomMaster()
    return self.m_bRoomMaster
end

function CFightPlayerBase:Destroy()
    
end