--[[
-- Copyright (C), 2015, 
-- 文 件 名: FightMJPlayer.lua
-- 作    者: lyn
-- 创建日期: 2017-02-18
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 牌的排序根据排序优先级来, 初始化牌的时候，其他玩家可以初始化13或者14张无名牌主要是为了统一结构
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFightMJPlayer.lua.log'


require "script.core.entity.FightPlayerBase"
require("script.ui.UIMJHelper")

CFightMJPlayer = class('CFightMJPlayer', CFightPlayerBase)

local test_bottom_cards =
{
    {value = 1, cType = ENUM.MJ_CARDTYPE.WANZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 2, cType = ENUM.MJ_CARDTYPE.WANZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 3, cType = ENUM.MJ_CARDTYPE.WANZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 4, cType = ENUM.MJ_CARDTYPE.TONGZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 5, cType = ENUM.MJ_CARDTYPE.TONGZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 6, cType = ENUM.MJ_CARDTYPE.TONGZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 7, cType = ENUM.MJ_CARDTYPE.TONGZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 8, cType = ENUM.MJ_CARDTYPE.TONGZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 9, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 1, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 2, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 2, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 3, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
    {value = 3, cType = ENUM.MJ_CARDTYPE.TIAOZI, flag = ENUM.MJ_CARD_FLAG.CUnknown, id = IDMaker.GetID()},
}

function CFightMJPlayer:New()
    local o = CFightPlayerBase:New()
    o.m_getCardsGroupList   = {}
    o.m_handCards           = {}
    o.m_alreadyOutedCards   = {}
    o.m_alreadPengGangCount = 0
    setmetatable(o, CFightMJPlayer)
    return o
end

function CFightMJPlayer:Init(msg)
    CFightMJPlayer.super.Init(self, msg)
end

-- 设置托管
function CFightMJPlayer:SetTuoGuan(bTuoguan)
    self.m_playerBaseInfo.m_bTuoGuan = bTuoguan
end

-- 是否处于托管
function CFightMJPlayer:IsTuoGuan()
    return self.m_playerBaseInfo.m_bTuoGuan
end

-- 设置庄
function CFightMJPlayer:SetZhuang(bZhuang)
    self.m_playerBaseInfo.m_bZhuang = bZhuang
end

function CFightMJPlayer:IsZhuang()
    return self.m_playerBaseInfo.m_bZhuang
end

-- 是否是报
function CFightMJPlayer:IsBao()
    return self.m_playerBaseInfo.m_bBaoPai
end

-- 设置报
function CFightMJPlayer:SetBao(bBao)
    self.m_playerBaseInfo.m_bBaoPai = bBao
end

function CFightMJPlayer:SetPlayerBaseInfo(playerInfo)
    self.m_playerBaseInfo = playerInfo
end

function CFightMJPlayer:GetPlayerBaseInfo()
    return self.m_playerBaseInfo
end

function CFightMJPlayer:IsHu()
    return  self.m_huCard
end

function CFightMJPlayer:SetHuCard(card)
    self.m_huCard = card
end

function CFightMJPlayer:GetHuCard(card)
    return self.m_huCard
end

function CFightMJPlayer:GetroleId()
    return self.m_playerBaseInfo.uid
end

function CFightMJPlayer:Test_Get3Card()
    local _test = {}
    local _count = 0
    for i,v in ipairs(self.m_handCards) do
        if _count < 3 then
            table.insert(_test, v)
            _count = _count + 1
        end
    end
    return _test
end

function CFightMJPlayer:Test_Get4Card()
    local _test = {}
    local _count = 0
    for i,v in ipairs(self.m_handCards) do
        if _count < 4 then
            table.insert(_test, v)
            _count = _count + 1
        end
    end
    return _test
end

-- 用服务器发的实际牌初始化手牌
function CFightMJPlayer:InitHandCards(cards)
    local _cards = clone(cards)
    for i,v in ipairs(_cards) do
        v.id = IDMaker.GetID()
        -- 是否锁定牌
        if bit.band(v.flag or 0, CUIMJHelper.MJ_FLAG_TYPE.CLock) > 0 then
            v.bLock = true
        end
    end
    self.m_handCards = _cards
end

-- 用数量初始化手牌
function CFightMJPlayer:InitHandCardsByCardCount(cardNum)
    if cardNum then
        for i = 1, cardNum do
            local _card = CUIMJHelper.GetNoneCard()
            table.insert(self.m_handCards, _card)
        end
    else
        log_error(LOG_FILE_NAME, "初始玩家牌错误，数量参数为空")
    end
end

-- 获取方向
function CFightMJPlayer:GetDirection()
    return self.m_direction
end

-- 设置方向
function CFightMJPlayer:SetDirection(direction)
    self.m_direction = direction 
end

-- 获取方位
function CFightMJPlayer:GetOrientation()
    return self.m_orientationType
end

-- 设置方位
function CFightMJPlayer:SetOrientation(orientation)
    self.m_orientationType = orientation 
end

-- 重置玩家卡牌数据
function CFightMJPlayer:ResetCardData()
    self.m_getCardsGroupList = {}
    self.m_alreadyOutedCards = {}
    self.m_handCards = {}
    self.m_alreadPengGangCount = 0
    self.m_hu = false
    self.m_huCard = false
    log_error(LOG_FILE_NAME, "重置玩家数据")
end

-- 获取拥有的列牌
function CFightMJPlayer:GetGroupCardsList()
    return self.m_getCardsGroupList or {}
end

function CFightMJPlayer:AddOutedCard(card)
    table.insert(self.m_alreadyOutedCards, card)
end

function CFightMJPlayer:SetAlreadyOutedCard(cards)
    self.m_alreadyOutedCards = clone(cards)
end

function CFightMJPlayer:GetPengGangCountOffsetOfHand()
    return self:GetPengGangCountRef() * 3
end

function CFightMJPlayer:RemoveLastOutedCard(card)
    local _lastCard = self.m_alreadyOutedCards[#self.m_alreadyOutedCards]
    if _lastCard and _lastCard.value == card.value and card.cType == _lastCard.cType then
        table.remove(self.m_alreadyOutedCards, #self.m_alreadyOutedCards)
        return true
    end
    return false
end

function CFightMJPlayer:GetHandCards()
    if self.m_handCards then
        self.m_handCards = self.m_handCards
    end
    return self.m_handCards or {}
end

-- 插入一张牌
function CFightMJPlayer:AddOneCard(card)
    if card then
        table.insert(self.m_handCards, card)
    else
        log_error(LOG_FILE_NAME, "插入一张牌失败,插入的牌无效")
    end
end

-- 删除一张牌
function CFightMJPlayer:RemoveOneCard(card)
    for i, v in ipairs(self.m_handCards) do
        if not v.bLock then
            local _bEqual = self:IsEqualCard(card, v)
            if _bEqual then
                local _alreadyRemoveCard = clone(v)
               table.remove(self.m_handCards, i)
               dump(_alreadyRemoveCard, "CFightMJPlayer RemoveOneCard player 移除一张手里的牌")
               return _alreadyRemoveCard
            end
        end
    end
    dump(card, "没有找到能删除的牌")
    dump(self.m_handCards, "没有找到能删除的牌，手中的牌")
    return false
end

function CFightMJPlayer:RemoveOneCardFromEnd()
    table.remove(self.m_handCards, #self.m_handCards)
end

-- 判断两张牌是否相等
function CFightMJPlayer:IsEqualCard(cardA, cardB)
    if cardA and cardB then
        if cardA.cType == cardB.cType then
            if cardA.cType == ENUM.MJ_CARDTYPE.ZHONG and cardB.cType == ENUM.MJ_CARDTYPE.ZHONG then
                return true
            elseif cardA.value == cardB.value then
                return true
            else
                return false
            end
        else
            return false
        end 
    else
        log_error(LOG_FILE_NAME, "比较两张牌的时候，有一张牌是空的")
        return false
    end
end

function CFightMJPlayer:AddPengGangPatternCard(patternCard)
    if not self.m_pengGangPatternCard then
        self.m_pengGangPatternCard = {}
    end
    if patternCard then
        table.insert(self.m_pengGangPatternCard, patternCard)
    end
end

function CFightMJPlayer:LockAllCard()
    for i,v in ipairs(self.m_handCards) do
        v.bLock = true
    end
end

function CFightMJPlayer:GetPengGangPatternCard()
    return self.m_pengGangPatternCard or {}
end

-- 获取已经出过的牌
function CFightMJPlayer:GetAlreadyOutedCards()
    return self.m_alreadyOutedCards or {}
end

-- 获取总共出了多少张牌
function CFightMJPlayer:GetOutedCardCount()
    return #(self.m_alreadyOutedCards or {})
end

-- 增加一次碰牌统计
function CFightMJPlayer:IncreasePengGangCountRef()
    self.m_alreadPengGangCount = self.m_alreadPengGangCount + 1
end

-- 减少一次碰牌统计
function CFightMJPlayer:DecreasePengGangCountRef()
    self.m_alreadPengGangCount = self.m_alreadPengGangCount - 1
    if self.m_alreadPengGangCount < 0 then
        self.m_alreadPengGangCount = 0
    end
end

-- 获取碰牌次数
function CFightMJPlayer:GetPengGangCountRef()
    return  self.m_alreadPengGangCount
end

-- 是否可以出牌
function CFightMJPlayer:IsCanOutCard()
   return self.m_canOutCard
end

-- 设置出牌状体
function CFightMJPlayer:SetCanOutCard(bOutCard)
    self.m_canOutCard = bOutCard or false
end