-- [[
-- Copyright (C), 2015, 
-- 文 件 名: TemplateFactory.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-07
-- 完成日期: 
-- 功能描述: 模板工厂对象，创建一个实体对象并初始化数据然后返回
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CTemplateFactory.log'

require "script.core.entity.Template"
require "script.core.entity.Entity"
require "script.core.entity.Item"

CTemplateFactory = {}
CTemplateFactory.__index = CTemplateFactory
CTemplateFactory.m_pTempData = {}

local function NewTempObject(classType)
    local pTemp = nil
    if classType < ENUM.CLASS_TYPE.CLASS_ITEM or classType > ENUM.CLASS_TYPE.CLASS_MAXNUM then
        log_error("CTemplateFactory.log", "NewTempObject eType is error eType = " .. eType)
        return nil
    end

    -- 实体
    if classType == ENUM.CLASS_TYPE.CLASS_ENTITY then 
        pTemp = CEntity:New()
    elseif classType == ENUM.CLASS_TYPE.CLASS_ITEM then
        pTemp = CItem:New()
    else
        return nil
    end

    return pTemp
end

-- 函数功能: 初始表引用 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CTemplateFactory.Init()
    --TODO: 设置实体类型的模版数据
end

--[[
-- 函数功能: 创建一个模板对象
-- 参    数: 
--     [IN] eType: 模板类型
--     [IN] nTemplateID: 模板对象ID
--     [IN] pInst: 实例数据
--     [IN] tParam:特殊实体类需要此参数
-- 返 回 值: 创建的模板对象, 如果创建失败则返回nil
--]]
function CTemplateFactory.CreateObject(eType, nTemplateID, pInst)

    -- 根据类型创建一个新的实体对象
    local pTempObj = NewTempObject(eType)
    if not pTempObj then
        log_info(LOG_FILE_NAME, "create Template object failed eType = " .. eType)
        return nil
    end

    -- 设置模版ID
    pTempObj:SetTemplateID ( nTemplateID )
    
    -- 拷贝模版数据
    pTempObj:Copy(nTemplateID)

    -- 如果有实例数据,则填写实例数据
    if pInst then
        if not pTempObj:InitInstance(pInst) then
            log_info(LOG_FILE_NAME, "init instance data failed!")
            pTempObj = nil
        end
    end
    
    return pTempObj
end

--[[
-- 函数功能: 获取对应类型的模板对象数据
-- 参    数: 
--     [IN] eType: 模板类型
--     [IN] nTemplateID: 模板对象ID
-- 返 回 值: 模板对象的指针, 若无模板对象则返回NULL
--]]
function CTemplateFactory.GetTemplateObj(eType, nTemplateID)
    local pData = nil
    if eType >= CTemplate.CLASS_TYPE.CLASS_ITEM and eType < CTemplate.CLASS_TYPE.CLASS_MAXNUM then
        pData = CTemplateFactory.m_pTempData[eType][nTemplateID]
        if not pData then
            if eType == CTemplate.CLASS_TYPE.CLASS_ITEM then
                pData = CTemplateFactory.m_pTempData[CTemplate.CLASS_TYPE.CLASS_EQUIPMENT][nTemplateID]
                eType = CTemplate.CLASS_TYPE.CLASS_EQUIPMENT
            end
        end
        return pData, eType
    end

    log_error(LOG_FILE_NAME, "the etype is out of range eType = " .. eType)
    return nil, eType
end

CTemplateFactory.Init()

return CTemplateFactory