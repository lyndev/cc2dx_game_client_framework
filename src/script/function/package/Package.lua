--[[
-- Copyright (C), 2015, 
-- 文 件 名: Package.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-03-14
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CPackage.log'

CPackage = {}
CPackage.__index = CPackage

function CPackage:New(o)
    o = o or {}
    setmetatable(o, CPackage)

    o.m_ItemTbl     = {}            -- 物品表
    o.m_nUsedCnt    = 1             -- 已用格子数
    o.m_tbItemNum   = {}            -- 物品数量表

    return o
end

--[[
-- 函数类型: public
-- 函数功能: 初始化包裹
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:Init(nSize)
    self.m_ItemTbl = {}
end

--[[
-- 函数类型: public
-- 函数功能: 获取所有物品
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:GetAllItem()
    return self.m_ItemTbl
end

--[[
-- 函数类型: public
-- 函数功能: 放入物品
-- 参数[IN]: item 物品事例, 格子号
-- 返 回 值: 是否成功
-- 备    注:
--]]
function CPackage:PushItem(item, templateID)
    -- 参数检查
    if not item then
        log_info(LOG_FILE_NAME, 'PushItem nil item')
        return false
    end

    if not templateID then
        log_info(LOG_FILE_NAME, 'the templateID is is error:'..nCell)
        return false
    end

    if self.m_ItemTbl[nCell] ~= nil then
        log_info(LOG_FILE_NAME, 'the sell is hava item cell:'..nCell)
        return false
    end

    -- 存入包裹
    self.m_ItemTbl[templateID] = item
    item:SetGrid(self.m_nUsedCnt)
    self.m_nUsedCnt = self.m_nUsedCnt + 1
    log_info(LOG_FILE_NAME, "添加了一个道具:%d, %d", templateID, item:GetNum())
    return true
end

--[[
-- 函数类型: public
-- 函数功能: nCell格子号
-- 参数[IN]: 无
-- 返 回 值: 成功返回item，失败返回nil
-- 备    注: 
--]]
function CPackage:PopItem(templateID)
    local _item = self.m_ItemTbl[templateID]
    self.m_ItemTbl[templateID] = nil
    self.m_nUsedCnt = self.m_nUsedCnt - 1
    return _item
end


--[[
-- 函数类型: public
-- 函数功能: 根据物品模板ID取出物品
-- 参数[IN]: nTemplateID 模板ID
-- 返 回 值: 成功返回item, 失败返回nil
-- 备    注:
--]]
function CPackage:GetItemByTemplateID(nTemplateID)
    return self.m_ItemTbl[nTemplateID]
end

--[[
-- 函数类型: public
-- 函数功能: 清空包裹
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:ClearAllCell()
    self.m_ItemTbl = {}
    self.m_nUsedCnt = 0
end

--[[
-- 函数类型: public
-- 函数功能: 获取包裹可用空间大小
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:GetFreeSize()
    return self.m_nSize - self.m_nUsedCnt
end

--[[
-- 函数类型: public
-- 函数功能: 获取包裹空间大小
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:GetPackageSize()
    return self.m_nSize
end

--[[
-- 函数类型: public
-- 函数功能: 查询是否存在该物品
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 
--]]
function CPackage:IsHaveItem(nTemplateID)
    nTemplateID = tonumber(nTemplateID)
    if self.m_ItemTbl[nTemplateID] then
        return true
    else
         return false
    end
end

--[[
-- 函数类型: public
-- 函数功能: 改变物品数量
-- 参数[IN]: nTemplateID:物品模板ID nNum: 变化量
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:ChangeItemNum(nTemplateID, nNum)
    local _item = self.m_ItemTbl[nTemplateID]
    if _item then
        local _cell = _item:GetGrid() 
        local _num = _item:GetNum()
        _num = _num + nNum
        if _num < 0 then
            self.m_ItemTbl[nTemplateID] = nil
        else
           _item:SetNum(_num) 
        end
    else
        log_error(LOG_FILE_NAME, "不存在该物品")
    end
end

--[[
-- 函数类型: public
-- 函数功能: 获取对应ID的item数量 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPackage:GetItemNum(nTemplateID)
    local _item = self.m_ItemTbl[nTemplateID]
    if _item then
        return _item:GetNum()
    end
    return 0
end