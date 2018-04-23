--[[
-- Copyright (C), 2015, 
-- 文 件 名: Goods.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-01-04
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CGoods.lua.log'

require "script.core.entity.Template"

CGoods = class("CGoods", CTemplate)

--[[
-- 函数类型: private
-- 函数功能: 获取一个时间点的时间戳
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
local function GetTimestampOfDate(nYear, nMonth, nDay, nHour, nMin, nSec)
    local tab = {year = nYear, month = nMonth, day = nDay, hour = nHour, min= nMin, sec = nSec, isdst = false}
    return os.time(tab)
end

--[[
-- 函数功能: 创建一个物品对象
-- 参    数: 
--   [IN] o: 要增加的成员变量
-- 返 回 值: 创建的物品对象
-- 备    注: 无
--]]
function CGoods:New(o)
    o = CTemplate:New(o)
    setmetatable(o, CGoods)
    o.m_nGridID             = 0                 -- 物品物品在背包中所在的格子ID
    o.m_nCurrentNum         = 0                 -- 物品当前数量
    o.m_strName             = ''                -- 物品名称    
    o.m_nIcon               = 0                 -- 物品图标编号
    o.m_nType               = 0                 -- 物品类型
    o.m_nGoodsStar          = 1                 -- 物品星级
    o.m_nQuality            = 1                 -- 物品品质
    o.m_nUseLevel           = 0                 -- 使用等级限制             
    o.m_strBuyPrice         = 0                 -- 购买价格(需要分解字符)   
    o.m_nSellPrice          = 0                 -- 出售单价                
    o.m_strDescription      = ''                -- 物品描述
    o.m_nCanTakeMaxNumber   = 1                 -- 最大携带数
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 判断是否是某个类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:Isa(eType)
    return eType == self:ClassType()
end

--[[
-- 函数类型: public
-- 函数功能: 获取类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:ClassType()
    return ENUM.CLASS_TYPE.CLASS_GOODS
end

--[[
-- 函数功能: 初始化实例数据接口
-- 参    数: 
--     [IN] pInst: 实例数据
-- 返 回 值: 无
-- 备    注: 无
--]]
function CGoods:InitInstance(pInst) 
    self:SetNum(pInst.num)
    return true
end

--[[
-- 函数类型: public
-- 函数功能: 获得道具在背包中的格子ID
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:GetGrid()
    return self.m_nGridID
end

--[[
-- 函数类型: public
-- 函数功能: 设置道具在背包中的格子ID
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:SetGrid(nGridID)
    if not tonumber(nGridID) then
        log_error(LOG_FILE_NAME, "SetGridID the param is not number")
        return
    end
    self.m_nGridID = tonumber(nGridID)
end

--[[
-- 函数类型: public
-- 函数功能: 获得当前物品的数量
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:GetNum()
    return self.m_nCurrentNum
end

--[[
-- 函数类型: public
-- 函数功能: 设置当前物品的数量
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:SetNum(nNum)
    self.m_nCurrentNum = tonumber(nNum)
end

--[[
-- 函数类型: public
-- 函数功能: 获取物品名称
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:GetName()
    return self.m_strName
end

--[[
-- 函数类型: public
-- 函数功能: 获取物品类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:GetType()
    return self.m_nType
end

--[[
-- 函数类型: public
-- 函数功能: 获取出售价格
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGoods:GetSellPrice()
    return self.m_nSellPrice
end

--[[
-- 函数功能: 获取购买价格
-- 参    数: 无
-- 返 回 值: 代币类型以及对应的金额
-- 备    注: 如果配置错误的话返回0, 0
--]]
function CGoods:GetBuyPrice()
    local tabPrice = StrSplit(self.m_strBuyPrice, "_")
    if #tabPrice ~= 2 then
        log_error(LOG_FILE_NAME, "价格配置错误 " .. self.m_nTemplateID)
        return 0, 0
    end
    return tonumber(tabPrice[1]), tonumber(tabPrice[2])
end

function CGoods:GetDescription()
    return self.m_strDescription or ''
end

function CGoods:GetIcon()
    return self.m_nIcon
end

function CGoods:GetQuality()
    return self.m_nQuality
end

function CGoods:GetLevel()
    return self.m_nLevel or 0
end

function CGoods:GetCanTakeNumber()
    return self.m_nCanTakeMaxNumber
end