--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationParticle.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-15
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationParticle.log'

require "script.core.animation.AnimationBase"

CAnimationParticle = class("CAnimationParticle", CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个粒子动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationParticle:Create(strPath, configID)
	local o = CAnimationBase:Create()
	setmetatable(o, CAnimationParticle)
	o.m_animtionType = CAnimationBase.AnimationType.Particle
	o.m_configID = configID
 	o.m_showObject = cc.ParticleSystemQuad:create(strPath)
 	if not o.m_showObject then
 		log_error(LOG_FILE_NAME, "创建粒子动画对象失败:%d", configID)
 		return nil
 	end
 	return o
end