--[[
-- Copyright (C), 2015, 
-- 文 件 名: EventDispatcher.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-22
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CEventDispatcher.log'

require "script.core.sdk.Event"

CEventDispatcher = {}
CEventDispatcher.__index = CEventDispatcher

local LOG_FILE_NAME = "CEventDispatcher.log"

--功能: 构造
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:New()
    local dispatcher = {m_callBackMap = {}}
    setmetatable(dispatcher, CEventDispatcher)
    return dispatcher
end

--功能: 注册回调事件
--参数: strType, pCallobj, callBackFun
--返回: 无
--备注: 无
function CEventDispatcher:AddEventListener(strType, pCallobj, callBackFun)
    if (type(strType)~= "string" or type(pCallobj) ~= "table" or type(callBackFun) ~= "function") then
        log_error(LOG_FILE_NAME, "AddEventListener param error:strType=%s,obj=%s,func=%s", strType, type(pCallobj), type(callBackFun))
        return false
    end
    self.m_callBackMap[strType] = self.m_callBackMap[strType] or {}

    local objcallBack = {}
    objcallBack.pCallobj = pCallobj
    objcallBack.callBackFun = callBackFun

    table.insert(self.m_callBackMap[strType], objcallBack)

    return true
end

--功能: 检查是否为特定事件类型注册了任何侦听器
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:HasEventListener(strType)
    if type(strType)~= "string" then
        log_error(LOG_FILE_NAME, "HasEventListener param error:%s", strType)
        return
    end

    local callList = self.m_callBackMap[strType]

    if type(callList) ~= "table" then
        return false
    end

    for key, val in pairs(callList) do
        return true
    end
    return false
end

--功能:  从EventDispatcher 对象中删除侦听器
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:RemoveEventListenerType(strType, pCallobj)
    if type(strType)~= "string" or type(pCallobj) ~= "table" then
        log_error(LOG_FILE_NAME, "RemoveEventListenerType param error:%s,%s", strType, type(pCallobj))
        return
    end

    local callList = self.m_callBackMap[strType]

    if callList == nil then
        return
    end

    local removeList = {}
    for key, val in pairs(callList) do
        if val.pCallobj == pCallobj then
            callList[key] = nil
        end
    end
end

--功能: 将对象pCallobj注册的所有监听事件从 EventDispatcher 对象中删除侦听器
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:RemoveEventListenerObj(pCallobj)
    if type(pCallobj) ~= "table" then
        log_error(LOG_FILE_NAME, "RemoveEventListenerObj param error:%s", type(pCallobj))
        return
    end

    for key, callList in pairs(self.m_callBackMap) do
        self:RemoveEventListenerType(key, pCallobj)
    end
end

--功能: 将其所有监听都干掉
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:RemoveAllEventListener()
    self.m_callBackMap = {}
end

--功能: 分派事件
--参数: 无
--返回: 无
--备注: 无
function CEventDispatcher:DispatchEvent(eve)
    local callList = self.m_callBackMap[eve.name]

    if callList == nil then
        return
    end

    for key, val in pairs(callList) do
        if val.callBackFun == nil then
            log_error(LOG_FILE_NAME, "val.callBackFun is nil")
        else
            if type(val.callBackFun) == "function" then
                val.callBackFun(val.pCallobj, eve)
            else
                log_error(LOG_FILE_NAME, "val.callBackFun error:%s", type(val.callBackFun))
            end
        end
    end
end

gPublicDispatcher = CEventDispatcher:New()