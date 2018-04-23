--[[
-- Copyright (C), 2015, 
-- 文 件 名: FightDaerPlayer.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-27
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFightDaerPlayer.lua.log'

require "script.core.entity.FightPlayerBase"

CFightDaerPlayer = class('CFightDaerPlayer', CFightPlayerBase)

function CFightDaerPlayer:New()
    local o = CFightBase:New()
    o.m_getCardsGroupList = {}
    o.m_passCardsList = {}
    setmetatable(o, CFightPlayerBase)
    return o
end

function CFightDaerPlayer:Init(msg)
    CFightDaerPlayer.super.init(self, msg)
end

-- 设置托管
function CFightDaerPlayer:SetTuoGuan(bTuoguan)
    self.m_bTuoGuan = bTuoguan or false
end

-- 是否处于托管
function CFightDaerPlayer:IsTuoGuan()
    return self.m_bTuoGuan or false
end

-- 是否是庄
function CFightDaerPlayer:IsZhuang()
    return self.m_bZhuang
end

-- 是否是报
function CFightDaerPlayer:IsBao()
    return self.m_bBaoPai or false
end

-- 设置庄
function CFightDaerPlayer:SetZhuang(bZhuang)
    self.m_bZhuang = bZhuang or false
end

-- 设置报
function CFightDaerPlayer:SetBao(bBao)
    self.m_bBaoPai = bBao or false
end

-- 方位
function  CFightDaerPlayer:GetDirection()
    return self.m_direction
end

-- 插入获得的一组牌
function CFightDaerPlayer:AddOneGroupCards(list)
    for i, cards in ipairs(list) do
        table.insert(self.m_getCardsGroupList, cards)
    end
end

-- 获取拥有的列牌
function CFightDaerPlayer:GetGroupCardsList()
    return self.m_getCardsGroupList or {}
end

-- 插入过的牌
function CFightDaerPlayer:AddPassCard(card)
    table.insert(self.m_passCardsList, card)
end

-- 获取已经过的牌
function CFightDaerPlayer:GetPassCards()
    return self.m_passCardsList or {}
end

-- 是否可以出牌
function CFightDaerPlayer:IsCanOutCard()
   return self.m_canOutCard
end

-- 设置出牌状体
function CFightDaerPlayer:SetCanOutCard(bOutCard)
    self.m_canOutCard = bOutCard or false
end
