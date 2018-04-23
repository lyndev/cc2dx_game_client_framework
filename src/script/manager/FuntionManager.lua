--[[
-- Copyright (C), 2015, 
-- 文 件 名: FuntionManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-07-05
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名 
local LOG_FILE_NAME = 'CFuntionManager.lua.log'

CFunctionManager = class("CFunctionManager")
CFunctionManager._instance = nil

-- 功能状态
local EFunctionState = 
{
    FUNCTION_OPEN  = 1,      -- 开启
    FUNCTION_CLOSE = 2,      -- 未开启
    FUNCTION_NEW   = 3,      -- 新功能开放
}

CFunctionManager.EFunctionState = EFunctionState

function CFunctionManager:GetInstance()
    if not CFunctionManager._instance then
        local o = {}
        setmetatable(o, CFunctionManager)

        o.m_listFunction           = {}           -- 功能列表
        o.m_listNewFunction        = {}           -- 新功能列表
        o.m_listNewFunctionCopy    = {}           -- 新功能列表
        o.m_isFunctionNewUIOpen    = false        -- 新功能开启UI是否开启
        o:Init()
        CFunctionManager._instance = o
    end
    
    return CFunctionManager._instance
end

function CFunctionManager:MessageProc(nMsgId, pData, nLen)
end

--[[
-- 函数类型: public
-- 函数功能: 初始化
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:Init(param)
    for k,v in pairs(Q_FunctionOpen) do
        if type(v) == "table" then
            self.m_listFunction[k] = {featureState = Q_FunctionOpen.GetTempData(k, 'q_default_open')}
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 登陆初始功能列表消息处理
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:DealResFeatureInfo(msg)
    for _, v in pairs(msg.info) do
        v.featureId = string.upper(v.featureId)
        self.m_listFunction[v.featureId] = v
    end

    -- 新功能开放初始化完成事件
    --gPublicDispatcher:DispatchEvent(CEvent:New(CEvent.FunctionInitOver))
end

--[[
-- 函数类型: public
-- 函数功能: 功能开放信息更新
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:DealResUpdateFeature(msg)
    for k, v in pairs(msg.info) do
        print("ResUpdateFeature ^^^^^^^^^^^ ", k, v)
    end

    msg.info.featureId = string.upper(msg.info.featureId)
    if self.m_listFunction[msg.info.featureId] and self.m_listFunction[msg.info.featureId].featureState ~= CFunctionManager.EFunctionState.FUNCTION_OPEN  
        and msg.info.featureState == CFunctionManager.EFunctionState.FUNCTION_NEW then
        table.insert(self.m_listNewFunction, msg.info.featureId)
        local nLevel = q_control.GetTempData(msg.info.featureId, "q_act_level") or 0
        if nLevel >= 8 then
            table.insert(self.m_listNewFunctionCopy, 1, msg.info.featureId)
        end
        self.m_listFunction[msg.info.featureId] = msg.info
        self.m_listFunction[msg.info.featureId].featureState = CFunctionManager.EFunctionState.FUNCTION_OPEN

        -- 功能开放事件
        local newEve = CEvent:New(CEvent.FunctionNewOpen)
        newEve.featureId = msg.info.featureId
        gPublicDispatcher:DispatchEvent(newEve)
    else
        log_error(LOG_ERROR_FILE, "======== featureId "..msg.info.featureId)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 获取功能是否开放
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:IsFunctionOpen(featureId)
    local tabRet = {}
    local info = self.m_listFunction[featureId]
    if info then
        if info.featureState == CFunctionManager.EFunctionState.FUNCTION_OPEN or 
            info.featureState == CFunctionManager.EFunctionState.FUNCTION_NEW then
            tabRet.bOpen = true
        else 
            tabRet.bOpen = false
        end
    else
        tabRet.bOpen = true     
    end

    -- 未开放原因
    if not tabRet.bOpen then
        if info and info.reason then
            tabRet.strReason = info.reason
        else
            tabRet.strReason = "功能开发中。。。"
        end
    end

    return tabRet
end 

--[[
-- 函数类型: public
-- 函数功能: 获取功能模板信息
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:GetFuncTemplateInfo(featureId)
    if "string" ~= type(featureId) then
        log_error(LOG_ERROR_FILE, "invalid param %s", type(featureId))
        return
    end

    return q_control[featureId]
end

--[[
-- 函数类型: public
-- 函数功能: 获取新功能开放列表
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:GetNewFunctionList()
    return self.m_listNewFunctionCopy
end

--[[
-- 函数类型: public
-- 函数功能: 重置新功能开放列表
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:ResetNewFunctionList()
    self.m_listNewFunctionCopy = {}
end

--[[
-- 函数功能: 获取队列中第一个开放的功能
-- 参    数: 无
-- 返 回 值: 队列中第一个开放的功能ID
-- 备    注: 无
--]]
function CFunctionManager:GetTopOpenFunction()
    return self.m_listNewFunctionCopy[1]
end

--[[
-- 函数功能: 移除某一个开放的新功能
-- 参    数: 
--     [IN] strFeatureID: 开放的功能ID
-- 返 回 值: 无
-- 备    注: 无
--]]
function CFunctionManager:RemoveOneFeature(strFeatureID)
    if not strFeatureID then
        log_error("CFunctionManager.log", "RemoveOneFeature the feature id is nil")
        return
    end

    -- 移除某一项
    for nIndex, v in pairs(self.m_listNewFunctionCopy) do
        if v == strFeatureID then
            table.remove(self.m_listNewFunctionCopy, nIndex)
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 销毁
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CFunctionManager:Destroy()
    CFunctionManager._instance  = nil
end