-- [[
-- Copyright (C), 2015, 
-- 文 件 名: TimerBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-23
-- 完成日期: 
-- 功能描述: 计时器基础类
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CTimerBase.log'

CTimerBase = {}
CTimerBase.__index = CTimerBase

function CTimerBase:New(nDelay, nTimes)
	assert(nDelay)
	assert(nTimes)

	local o = {}
	setmetatable( o, CTimerBase )
	o.m_tCallBackList 	= {}
	o.m_nHandlerCount 	= 0
	o.m_nDelay			= nDelay or 0
	o.m_nTimes			= nTimes or 0 			-- -1表示无限次数
	o.m_nCurDuration 	= 0
	o.m_bIsOver 		= false
	return o
end

function CTimerBase:AddHandler( handler, params )
	assert(handler)
	self.m_tParams = params or {}
    local _tCall = {}
    _tCall.callback = handler
    _tCall.params = params or {}
	self.m_tCallBackList[IDMaker.GetID()] = _tCall
	self.m_nHandlerCount = self.m_nHandlerCount + 1
end

function CTimerBase:RemoveHandler( handler )
	if self.m_nHandlerCount then
		for k,v in pairs(self.m_nHandlerCount) do
			if v == handler then
				self.m_tCallBackList[k] = nil
				self.m_nHandlerCount = self.m_nHandlerCount - 1
				break
			end
		end
		if self.m_nHandlerCount <= 0 then
			self.m_bIsOver = true
		end
	end
end

function CTimerBase:Update(dt)
	self.m_nCurDuration = self.m_nCurDuration + dt
	if not self.m_bIsOver then
		if self.m_nCurDuration > self.m_nDelay then
			self.m_nCurDuration = 0
			if self.m_tCallBackList then
				for i,v in pairs(self.m_tCallBackList) do
					if v.callback then 
                        v:callback(v.params)
                    end
				end
				if self.m_nTimes > 0 then
					self.m_nTimes = self.m_nTimes - 1
					if self.m_nTimes <=0 then
						self.m_bIsOver = true
					end
				end
			end
		end
	end
end

function CTimerBase:IsOver()
	return self.m_bIsOver
end

function CTimerBase:RemoveAllHandler()
	self.m_tCallBackList = nil
	self.m_nHandlerCount = 0
	self.m_bIsOver = true
end