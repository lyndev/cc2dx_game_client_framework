--[[
-- Copyright (C), 2015, 
-- 文 件 名: Item.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-03-14
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CItem.log'

require "script.core.entity.Goods"

CItem = CreateClass(CGoods)

--[[
-- 函数功能: 创建一个物品对象
-- 参    数: 
--   [IN] o: 要增加的成员变量
-- 返 回 值: 创建的物品对象
-- 备    注: 无
--]]
function CItem:New(o)
    o = CGoods:New(o)
    setmetatable(o, CItem)
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 判断是否是某个类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CItem:Isa(eType)
    if eType == ENUM.CLASS_TYPE.CLASS_ITEM  then
        return true
    else
       return CGoods.Isa(self,eType)
    end
    return false
end

--[[
-- 函数类型: public
-- 函数功能: 获取类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CItem:ClassType()
    return ENUM.CLASS_TYPE.CLASS_ITEM
end

--[[
-- 函数功能: 数据拷贝函数
-- 参    数: 
--    [IN] pData: 模板数据
-- 返 回 值: 无
-- 备    注: 无
--]]
function CItem:Copy(nItemID)
    self.m_strName           = q_item.GetTempData(nItemID, "Name") or "unknow"                      -- 物品名称
    self.m_nIcon             = q_item.GetTempData(nItemID, "Icon") or 1                             -- 物品微图标编号
    self.m_nTinyEffect       = q_item.GetTempData(nItemID, "AnimationID") or 1                      -- 物品特效编号
    self.m_nType             = q_item.GetTempData(nItemID, "Type")                                  -- 物品类型
    self.m_nQuality          = q_item.GetTempData(nItemID, "Quality") or 1                          -- 物品品质
    self.m_nUseLevel         = q_item.GetTempData(nItemID, "UseNeedLevel") or 0                     -- 使用等级限制 
    self.m_nCanUse           = q_item.GetTempData(nItemID, "CanUse") or 0                           -- 是否可以使用(0:不可使用,1:可以使用)
    self.m_strAddResources   = q_item.GetTempData(nItemID, "AddItem") or ""                         -- 使用后能够获取的资源
    self.m_nMax              = q_item.GetTempData(nItemID, "Max") or 1                              -- 物品叠加数量上限
    self.m_strBuyPrice       = q_item.GetTempData(nItemID, "BuyPrice") or ""                        -- 购买单价
    self.m_nSellPrice        = q_item.GetTempData(nItemID, "SellPrice") or 0                        -- 出售单价
    self.m_strUseTimeLimit   = q_item.GetTempData(nItemID, "UseTimeLimit") or ""                    -- 使用期限 
    self.m_nShow             = q_item.GetTempData(nItemID, "ShowInbag") or 0                        -- 是否在背包            
    self.m_strDescription    = q_item.GetTempData(nItemID, "Describe")                              -- 物品描述
    self.m_nCanTakeMaxNumber = q_item.GetTempData(nItemID, "TakeMaxMumber") or 1                    -- 最大可携带数量
end

--[[
-- 函数功能: 初始化实例数据接口
-- 参    数: 
--     [IN] pInst: 实例数据
-- 返 回 值: 无
-- 备    注: 无
--]]
function CItem:InitInstance(pInst)
    CItem.super.InitInstance(self, pInst)
    return true
end