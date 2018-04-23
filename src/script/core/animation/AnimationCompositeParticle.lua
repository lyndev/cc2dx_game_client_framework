--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationCompositeParticle.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-15
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationCompositeParticle.log'

require "script.core.animation.AnimationBase"

CAnimationCompositeParticle = class("CAnimationCompositeParticle", CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个复合粒子动画对象 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeParticle:Create(strPath, duration, configID)
	local o = CAnimationBase:Create()
	o.m_animtionType = CAnimationBase.AnimationType.CompositeParticle
	setmetatable(o, CAnimationCompositeParticle)
 	o.m_showObject = cc.CSLoader:createNode(strPath)
 	o.m_timeLine = cc.CSLoader:createTimeline(strPath)
 	if o.m_showObject then
	 	o.m_configID = configID
	 	o.m_duration = duration
	else
		log_error(LOG_FILE_NAME, "创建动画节点失败:%d", configID)
		return nil
	end

	if not o.m_timeLine then
		log_error(LOG_FILE_NAME, "创建动画的timeline失败:%d", configID)
		return nil
	end
 	return o
end

--[[
-- 函数类型: public
-- 函数功能: 播放
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeParticle:Play(loop)
	if self.m_timeLine and self.m_showObject then
		self.m_timeLine:gotoFrameAndPlay(0, loop or false)
		self.m_showObject:runAction(self.m_timeLine)
		if not loop then
			performWithDelay(self.m_showObject, function()
				self.m_isFinish = true
			end, self.m_duration)
		end
	end
end