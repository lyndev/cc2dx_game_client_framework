-- [[
-- Copyright (C), 2015, 
-- 文 件 名: TimerEvent.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-23
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'TimerEvent.log'

CTimerEvent = {}
CTimerEvent.__index = CTimerEvent

function CTimerEvent:New(o)
    o = o or {}
    setmetatable(o, CTimerEvent)

    o.nRemainTime   = 0 -- 定时剩余时间
    o.nLoop         = 0 -- 执行次数
    o.nDelay        = 0 -- 间隔时间

    return o
end

--[[
-- 函数功能: 通过间隔时间和执行次数计时
-- 参    数: nLoop: 执行次数
--           nDelay: 间隔时间
-- 返 回 值: 无
--]]
function CTimerEvent:TimerEventByDelay(nLoop, nDelay)
    self.nLoop = nLoop
    self.nDelay = nDelay
    self.nRemainTime = nDelay
end

--[[
-- 函数功能: 获取剩余时间
-- 参    数: 无
-- 返 回 值: 无
--]]
function CTimerEvent:Remain()
    return self.nRemainTime
end

function CTimerEvent:Action()
    if self.nLoop > 0 then
        self.nLoop = self.nLoop - 1
    end
    
    if self.nLoop > 0 then
        self.nRemainTime = self.nDelay
    end
end

function CTimerEvent:Update(dt)
    if self.nRemainTime > 0 then
        self.nRemainTime = self.nRemainTime - dt
    end
end