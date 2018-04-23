-- [[
-- Copyright (C), 2015, 
-- 文 件 名: TimerManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-23
-- 完成日期: 
-- 功能描述: 计时器管理器
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CTimerManager.log'

CTimerManager = {}
CTimerManager.__index = CTimerManager

CTimerManager._instance = nil

function CTimerManager:New()
	local o = {}
	setmetatable( o, CTimerManager )
	o.m_tTimerList = {}
	return o
end

function CTimerManager:GetInstance()
	if nil == CTimerManager._instance then
		CTimerManager._instance = CTimerManager:New()
	end
	return CTimerManager._instance
end

function CTimerManager:Update( dt )
	if self.m_tTimerList then
		for k,v in pairs(self.m_tTimerList) do
			if v:IsOver() then
				self:RemoveTimer(v)
			else
				v:Update(dt)
			end
		end
	end
end

function CTimerManager:AddTimer( timer )
	assert(timer)
	if self.m_tTimerList then
		local _isExist = false
		for k,v in pairs(self.m_tTimerList) do
			if v == timer then
				_isExist = true
				break
			end
		end
		if _isExist then
			log_error(LOG_FILE_NAME, "timer器不存在")
		else
			self.m_tTimerList[IDMaker.GetID()] = timer
		end
	end
end

function CTimerManager:RemoveTimer( timer )
	assert(timer)
	if self.m_tTimerList then
		for k,v in pairs(self.m_tTimerList) do
			if v == timer then
				self.m_tTimerList[k] = nil
                log_info(LOG_FILE_NAME, '一个timer器移除成功')
				break
			end
		end
	end
end

function CTimerManager:OnDestroy()
	self.m_tTimerList = nil
	CTimerManager._instance = nil
end