-- [[
-- Copyright (C), 2015, 
-- 文 件 名: TimerUtility.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-23
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'TimerUtil.log'

CTimerUtility = {}
CTimerUtility.__index = CTimerUtility

--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:New()
    local timerUtil = {}
    setmetatable(timerUtil, CTimerUtility)
    timerUtil.m_TimeList = {}
    return timerUtil
end

--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:AddEvent(event)
    if event.nDelay == 0 then
        event:Action()
        if event.nLoop >= 1 then
            table.insert(self.m_TimeList, event)
        end
    else
        table.insert(self.m_TimeList, event)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 移除事件
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:RemoveEvent(eveR)
    local removeList = {}
    for idx, eve in ipairs(self.m_TimeList) do
        if eve == eveR then
            table.remove(self.m_TimeList, idx)
            break
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 更新
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:Update(ft)
    local removeList = {}
    for idx, eve in ipairs(self.m_TimeList) do
        eve:Update(ft)
        if eve.nRemainTime <= 0 then
            eve:Action()
            if eve.nLoop <= 0 then
               table.insert(removeList, eve)
            end
        end
    end

    for _, eve in ipairs(removeList) do
        self:RemoveEvent(eve)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:Stop()
    self.m_TimeList = {}
end

--[[
-- 函数类型: public
-- 函数功能: 根据类型移除事件
-- 参数[IN]: 类型
-- 返 回 值: 无
-- 备    注:
--]]
function CTimerUtility:RemoveEventByType(strType)
    local removeList = {}
    for idx, eve in ipairs(self.m_TimeList) do
        if eve.type == strType then
            table.insert(removeList, eve)
        end
    end
    
    for _, eve in ipairs(removeList) do
        self:RemoveEvent(eve)
    end
end

gPublicTimer = CTimerUtility:New()