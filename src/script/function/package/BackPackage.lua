-- 日志文件名
local LOG_FILE_NAME = 'CBackPackage.log'

require "script.function.package.Package"

CBackPackage = {}
CBackPackage.__index = CBackPackage

-- 代币类型枚举
CBackPackage.ECurrencyType = ENUM.CURRENCY_TYPE

--[[
-- 函数类型: public
-- 函数功能: 构造一个背包
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:New(o)
    o = o or {}
    setmetatable( o, CBackPackage )
    o.m_tbResource          = {}
    o.m_pPackage            = CPackage:New()    -- 背包数据
    o.m_tbTabRedPoint       = {}
    o.m_tbNoticeUIItem      = {}
    o.m_tbNoticeItemType    = {}
    return o
end

function CBackPackage:Init()
    self.m_pPackage:Init()
end

--[[
-- 函数类型: public
-- 函数功能: 解析包裹数据
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:ParseItemList(itemList)

    if itemList then
        for _,v in ipairs(itemList) do
            if v then
                self:CreateItem( v )
            end
        end
        -- 抛出数据更新事件
        local eveUpdate = CEvent:New(CEvent.BackPackageUpdate)
        gPublicDispatcher:DispatchEvent(eveUpdate)
    end
end


--[[
-- 函数类型: public
-- 函数功能: 移除物品
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:ResRemoveItem( nMsgID, pData, nLen )
end

-- 函数功能: 创建添加一个物品到背包数据 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CBackPackage:CreateItem(instanceData, itemType)

    -- 根据物品类型创建物品实例
    local _nItemType = itemType or ENUM.ItemType.Item
    local _classType = ENUM.CLASS_TYPE.CLASS_ITEM

    local _bHave = self.m_pPackage:IsHaveItem(instanceData.id)
    if not _bHave then
        -- 创建物品实例
        local pItem = CTemplateFactory.CreateObject(_classType, instanceData.id, instanceData)
        if pItem then
            self.m_pPackage:PushItem(pItem, instanceData.id)
        end
    else
        local _item =  self.m_pPackage:GetItemByTemplateID(nItemId)
        if _item then
            _item:ChangeItemNum(instanceData.id, instanceData.num)
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 获取包裹对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:GetPackage()
    return self.m_pPackage
end


--[[
-- 函数类型: public
-- 函数功能: 请求使用物品
-- 参数[IN]: nGridID: 物品所在的格子ID nNum: 物品数量
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:ReqUseItem( nGridID, nNum, nCardInstID )
    local tbParam = {}
    tbParam.num = nNum
    tbParam.gridId = nGridID
    if nCardInstID then
        tbParam.cardInstId = nCardInstID
    end

    tbParam = protobuf.encode(MSGTYPE[MSGID.CS_BACKPACK_REQITEMUSE_P], tbParam)
    SendMsgToServer(MSGID.CS_BACKPACK_REQITEMUSE_P, tbParam, #tbParam)

end

--[[
-- 函数类型: public
-- 函数功能: 请求出售物品
-- 参数[IN]: nGridID: 物品所在的格子ID nNum: 物品数量
-- 返 回 值: 无
-- 备    注:
--]]
function CBackPackage:ReqSellItem( nGridID, nNum )
    local tbParam = {}
    tbParam.number = nNum
    tbParam.configId = nGridID
    tbParam.roleId = CPlayer:GetInstance():GetRoleID()
    tbParam = protobuf.encode(MSGTYPE[MSGID.CS_BACKPACKAGE_REQSELLITEM], tbParam)
    SendMsgToServer(MSGID.CS_BACKPACKAGE_REQSELLITEM, tbParam, #tbParam)
end