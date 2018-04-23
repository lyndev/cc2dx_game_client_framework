--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationImage.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-15
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationImage.log'

require "script.core.animation.AnimationBase"

CAnimationImage = class("CAnimationImage", CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个图片动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationImage:Create(strPath, configID)
	local o = CAnimationBase:Create()
	o.m_animtionType = CAnimationBase.AnimationType.Image
	setmetatable(o, CAnimationImage)
	o.m_configID = configID
 	o.m_showObject = display.newSprite(strPath)
 	return o
end