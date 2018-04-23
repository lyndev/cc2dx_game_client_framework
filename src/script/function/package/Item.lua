-- [[
-- Copyright (C), 2015, ChuangJuTianHe Tech. Co., Ltd.
-- 文 件 名: Item.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-05-11
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CItem.lua'

require "script/Entity/Templet"

CItem = CreateClass(CItemplet)

CItem.EShowType = 
{
    EShowType_Invisible = 0,        -- 不显示
    EShowType_Visible   = 1         -- 显示
}

-- 物品在背包中的标签类型
CItem.EItemMainType = 
{
    EType_Comsuem       = {1,2,3,4,7},      -- 消耗类型
    EType_SoulStone     = {5},              -- 魂石
    EType_Equip         = {6,10},           -- 装备
    EType_Scroll        = {8,11},           -- 卷轴
    EType_Gem           = {9},              -- 宝石
}

-- 物品类型枚举
CItem.EItemSubType = 
{
    EMin                            = 0,          
    ESUBTYPE_GIFT                   = 1,            -- 礼包 (消耗)
    ESUBTYPE_BOX                    = 2,            -- 宝箱 (消耗)
    ESUBTYPE_BOX_KEY                = 3,            -- 钥匙 (消耗)
    ESUBTYPE_EXPPOTION              = 4,            -- 经验药水(消耗)
    ESUBTYPE_SOULSTONE              = 5,            -- 英雄魂石(魂石)
    ESUBTYPE_EQUIPMENT              = 6,            -- 装备(装备)
    ESUBTYPE_PROP                   = 7,            -- 道具
    ESUBTYPE_SCROLL                 = 8,            -- 卷轴
    ESUBTYPE_GEM                    = 9,            -- 宝石
    ESUBTYPE_EQUIPMENT_FRAGMENT     = 10,           -- 装备碎片
    ESUBTYPE_SOULSTONE_FRAGMENT     = 11,           -- 卷轴碎片
    EMax                            = 12,
}

-- 物品品质颜色枚举
CItem.EItemQualityColor =
{
    EQUALITYCOLOR_WHITE     = 1,          -- 白色
    EQUALITYCOLOR_GREEN     = 2,          -- 绿色
    EQUALITYCOLOR_BLUE      = 3,          -- 蓝色
    EQUALITYCOLOR_PURPLE    = 4,          -- 紫色
    EQUALITYCOLOR_ORANGE    = 5,          -- 橙色
}

-- 完整物品品质边框
CItem.tbQualityImg =
{
    [CItem.EItemQualityColor.EQUALITYCOLOR_WHITE]  = "67001.png",  -- 黄色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_GREEN]  = "67002.png",  -- 绿色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_BLUE]   = "67003.png",  -- 蓝色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_PURPLE] = "67004.png",  -- 紫色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_ORANGE] = "67005.png",  -- 橙色边框
}

-- 缺角物品品质边框
CItem.tbQualityImgTwo = 
{
    [CItem.EItemQualityColor.EQUALITYCOLOR_WHITE]  = "00001.png",  -- 黄色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_GREEN]  = "00002.png",  -- 绿色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_BLUE]   = "00003.png",  -- 蓝色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_PURPLE] = "00004.png",  -- 紫色边框
    [CItem.EItemQualityColor.EQUALITYCOLOR_ORANGE] = "00005.png",  -- 橙色边框
}

-- 装备强化等级背景图片
local EquipLevelQualityImg = 
{
    [CItem.EItemQualityColor.EQUALITYCOLOR_WHITE]  = "66002.png",  -- 黄色背景
    [CItem.EItemQualityColor.EQUALITYCOLOR_GREEN]  = "66003.png",  -- 绿色背景
    [CItem.EItemQualityColor.EQUALITYCOLOR_BLUE]   = "66004.png",  -- 蓝色背景
    [CItem.EItemQualityColor.EQUALITYCOLOR_PURPLE] = "66005.png",  -- 紫色背景
    [CItem.EItemQualityColor.EQUALITYCOLOR_ORANGE] = "66006.png",  -- 橙色背景    
}

-- 代币资源图标图片名字 | 背包中【代币类型有变动需要修改此处】
CItem.tbResourceImg = 
{
    [1] = "pub_gold_small1.png",      -- 金币
    [2] = "pub_diamond.png",          -- 钻石
    [3] = "pub_tili.png",             -- 体力
    [4] = "common_img004.png",        -- 技能点 
    [5] = "common_img004.png",        -- 星星
    [6] = "pub_rongyu.png",           -- 荣耀点
    [7] = "104.png",                  -- 远征币
    [8] = "pub_rongyu.png",           -- 灵魂碎片    
}

-- 代币名字
CItem.tbResourceName =
{
    [1]  = 100003,        -- 金币
    [2]  = 100004,        -- 钻石
    [3]  = 100005,        -- 体力
    [4]  = 100006,        -- 技能点
    [5]  = 100007,        -- 星星
    [6]  = 100008,        -- 荣耀点
    [7]  = 100009,        -- 远征币
    [8]  = 100010,        -- 灵魂碎片  
}


-- 函数功能: 获取一个时间点的时间戳
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
local function GetTimestampOfDate(nYear, nMonth, nDay, nHour, nMin, nSec)
    local tab = {year=nYear, month=nMonth, day=nDay, hour=nHour,min=nMin,sec=nSec,isdst=false}
    return os.time(tab)
end

-- 函数功能: 创建一个物品对象
-- 参    数: 
--   [IN] o: 要增加的成员变量
-- 返 回 值: 创建的物品对象
-- 备    注: 无
function CItem:New( o )
    o = CItemplet:New(o)
    setmetatable(o, CItem)
    o.m_nGridID      = 0              -- 物品物品在背包中所在的格子ID
    o.m_nCurrentNum  = 0              -- 物品当前数量
    o.m_strOtherInfo = ""             -- 额外参数
    return o
end


-- 函数功能: 数据拷贝函数
-- 参    数: 
--    [IN] pData: 模板数据
-- 返 回 值: 无
-- 备    注: 无

function CItem:Copy(nItemID)
    self.m_nTemplateID   = q_item.GetTempData(nItemID, "q_id") or 0                                -- 物品ID
    self.m_strName       = Language(q_item.GetTempData(nItemID, "q_name") or 0)                    -- 物品名称
    self.m_nTinyIcon     = q_item.GetTempData(nItemID, "q_tiny_icon") or 1                         -- 物品微图标编号
    self.m_nType         = q_item.GetTempData(nItemID, "q_type") or 1                              -- 物品类型
    self.m_nGoodsStar    = q_item.GetTempData(nItemID, "q_goods_star") or 1                        -- 物品星级
    self.m_nQuality      = q_item.GetTempData(nItemID, "q_default") or 1                           -- 物品品质
    self.m_nUseLevel     = q_item.GetTempData(nItemID, "q_level") or 0                             -- 使用等级限制
    self.m_nCardLevel    = q_item.GetTempData(nItemID, "q_cardlevel") or 0                         -- 使用卡牌等级限制
    self.m_strNeedGoods  = q_item.GetTempData(nItemID, "q_goods") or ""                            -- 使用物品需求
    self.m_nCanUse       = q_item.GetTempData(nItemID, "q_can_use") or 0                           -- 是否可以使用(0:不可使用,1:可以使用)
    self.m_nRoleObject   = q_item.GetTempData(nItemID, "q_role_object") or 0                       -- 作用对象(0: 无对象, 1: 玩家, 2:英雄)
    self.m_strAddRes     = q_item.GetTempData(nItemID, "q_add_resources") or ""                    -- 使用效果
    self.m_nUI           = q_item.GetTempData(nItemID, "q_ui") or 0                                -- 打开的对应UI ID
    self.m_nMax          = q_item.GetTempData(nItemID, "q_max") or 1                               -- 物品叠加数量上限
    self.m_nAddExp       = q_item.GetTempData(nItemID, "q_add_exp") or 0                           -- 使用增加卡牌经验
    self.m_nSellPrice    = q_item.GetTempData(nItemID, "q_sell_price") or 0                        -- 出售单价
    self.m_nSellConfirm  = q_item.GetTempData(nItemID, "q_sell_confirm") or 0                      -- 出售时是否弹出确认框
    self.m_nCanSynthetic = q_item.GetTempData(nItemID, "q_can_synthetic") or 0                     -- 是否可合成
    self.m_strGetPath    = q_item.GetTempData(nItemID, "q_get_path") or ""                         -- 获取途径
    self.m_strDescription= string.format(Language(q_item.GetTempData(nItemID, "q_describe") or  0), self.m_strName)    -- 物品描述
    self.m_nScript       = q_item.GetTempData(nItemID, "q_script") or 0                            -- 使用时对应的脚本ID
    self.m_nItemDayLimit = q_item.GetTempData(nItemID, "q_daily_num") or 0                         -- 单日物品使用上限
    self.m_strUseTimeLimit = q_item.GetTempData(nItemID, "q_usetime_limit") or ""                  -- 使用期限
    self.m_nShowBag      =  q_item.GetTempData(nItemID, "q_show") or 0                             -- 是否显示
    self.m_nLog          = q_item.GetTempData(nItemID, "q_log") or 0                               -- 是否记录产出日志
end

-- 函数功能: 实例数据 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:InitInstance(pInst)
    self.m_nCurrentNum = pInst.num
    return true
end

-- 函数功能: 获得道具在背包中的格子ID 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetGridID()
    return self.m_nGridID
end

-- 函数功能: 设置道具在背包中的格子ID 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:SetGridID(nGridID)
    if not tonumber(nGridID) then
        log_error("CItem.log", "SetGridID the param is not number")
        return
    end

    self.m_nGridID = tonumber(nGridID)
end

-- 函数功能: 获得当前物品的数量 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetCurrentNum()
    local _,bIsLost = self:GetUseTimeLimit()

    -- 如果已经过期，返回0
    if bIsLost then
        return 0
    end
    return self.m_nCurrentNum
end


-- 函数功能: 是否已经快要达到上限 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsOverLimit(nAddNum)
    if not nAddNum then
        nAddNum = 0
    end

    return (self:GetCurrentNum() + nAddNum) >= 99980
end

-- 函数功能: 设置当前物品的数量 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:SetCurrentNum(nNum)
    if not tonumber(nNum) then
        log_error("CItem.log", "SetCurrentNum the param is not number~~~")
        return
    end

    self.m_nCurrentNum = tonumber(nNum)
end

-- 函数功能: 获取物品名称 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetItemName()
    return self.m_strName
end

-- 函数功能: 获取物品类型 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetItemType()
    return self.m_nType
end

-- 函数功能: 获取出售价格 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetSellPrice()
    return self.m_nSellPrice
end

-- 函数功能: 是否在背包显示 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetIsShowBag()
    if self.m_nShowBag == CItem.EShowType.EShowType_Visible then
        return true
    end
    return false
end

-- 函数功能: 获取购买价格
-- 参    数: nType = 代币类型
-- 返 回 值: 价格
-- 备    注: 如果配置错误的话返回0,0
function CItem:GetBuyPrice( nType )
    -- local _tabPrice = StrSplit(self.m_strBuyPrice, ";")
    -- local _bFind = false
    -- if _tabPrice then
    --     for _, sPrice in pairs( _tabPrice ) do
    --         local _tValue = StrSplit( _tabPrice, "_" )
    --         local _type, _price =  tonumber(_tValue[ 1 ]), _tValue(tabPrice[ 2 ])
    --         if nType == _type then
    --             _bFind = true
    --             return _price
    --         end
    --     end
    --     log_error( LOG_FILE_NAME, 'item nType error:%d', nType )
    -- end
    -- return 0
end

-- 函数功能: 获取物品描述 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetDescription()
    return self.m_strDescription
end


-- 函数功能: 获取物品获得途径
-- 参    数: 无
-- 返 回 值: 关卡ID table
-- 备    注: 无
function CItem:GetGetPath()
    return StrSplit(self.m_strGetPath, ",")
end


-- 函数功能:获取资源微图标编号 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetTinyIcon()
    return self.m_nTinyIcon .. ".png"
end


-- 函数功能: 获取物品品质
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetQuality()
    return self.m_nQuality
end


-- 函数功能: 获取物品品质图片名称 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetQualityImage()
    -- 品质边框图片名称
    if self.m_nType == CItem.EItemSubType.ESUBTYPE_MATERIAL then
        return CItem.tbQualityImgTwo[self:GetQuality()]
    else
        return CItem.tbQualityImg[self:GetQuality()]
    end
    
end

-- 函数功能: 获取使用等级限制 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetUseLevel()
    return self.m_nUseLevel
end

-- 函数功能: 获取基地等级限制
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetBaseLevel()
    return self.m_nBaseLevel
end

-- 函数功能: 获取卡牌等级限制 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetCardLevel()
    return self.m_nCardLevel
end

-- 函数功能: 判断能否使用 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsCanUse()
    return tonumber(self.m_nCanUse) == 1
end

-- 函数功能: 获取最大堆叠数 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetMaxNum()
    return self.m_nMax
end

-- 函数功能: 获取出售时是否弹出确认框 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsSellConfirm()
    return tonumber(self.m_nSellConfirm) == 1
end

-- 函数功能: 获取是否可合成 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsCanCombine()
    return tonumber(self.m_nCanSynthetic) == 1
end

-- 函数功能: 获取是否可拆分 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsCanCell()
    return tonumber(self.m_nDecomposition) == 1
end

-- 函数功能: 获取每日可使用的最大数量 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetDayUseMax()
    return self.m_nItemDayLimit
end

-- 返 回 值: 
-- 函数功能: 获取使用期限 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注: 到期时间字符串, 是否过期
function CItem:GetUseTimeLimit()
    if self.m_strUseTimeLimit == "0" then
        return nil, false
    end
    local tbTime = StrSplit(self.m_strUseTimeLimit or "", ";")
    if #tbTime <= 0 then
        return nil, false
    end
    local tbEndTime = StrSplit(tbTime[2], ",")
    local nTime = GetTimestampOfDate(tbEndTime[1],tbEndTime[2],tbEndTime[3],tbEndTime[4],tbEndTime[5],0)
    return os.date(Language(10012), nTime), (CPlayer:GetInstance():GetClientTime() >= nTime)
end

-- 函数功能: 获取对应的UI界面
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetUIId()
    return self.m_nUI
end

-- 函数功能: 获取使用等级 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetUseLevel()
    return self.m_nUseLevel
end

-- 函数功能: 获取装备属性 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetEquipAttr()
    local tbAttr = {}
    local tbData = StrSplit(self.m_strEquipAttr, ";")
    for i=1,#tbData do
        local tbTmp = StrSplit(tbData[i], ",")
        if #tbTmp >= 2 then
            tbAttr[tonumber(tbTmp[1])] = tonumber(tbTmp[2])
        end
    end
    return tbAttr
end

-- 函数功能: 获取物品模版数据 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetItemData(nItemID)
    local itemData = q_item[nItemID]
    if not itemData then
        log_error("CItem.log", "wrong item nModuleID:%d", nItemID)
    end
    return itemData
end

-- 函数功能: 根据货币类型获取图标 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetResourceImgByType(nType)
    local sImg = CItem.tbResourceImg[nType] or CItem.tbResourceImg[1]
    return sImg
end

-- 函数功能: 根据资源类型获取资源名字 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem.GetResourceNameByType( nType )
    local nLang = CItem.tbResourceName[nType] or CItem.tbResourceName[1]
    return Language(nLang)
end

-- 函数功能: 获取使用物品所需要的物品 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:GetNeedGoods()
    return self.m_strNeedGoods
end

-- 功能: 是否为套装
-- 参数: 无
-- 返回值: 否
function CItem:IsSuit()
    return false
end

-- 函数功能: 获取是否需要显示碎片图标 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CItem:IsSuiPian()
    if self.m_nType == CItem.EItemSubType.ESUBTYPE_SUIPIAN or 
       self.m_nType == CItem.EItemSubType.ESUBTYPE_SIPINSUIPIAN or
       self.m_nType == CItem.EItemSubType.ESUBTYPE_EQUIPMENT or
       self.m_nType == CItem.EItemSubType.ESUBTYPE_WUHUN then
       return true
    end

    return false
end

return CItem