--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationFrame.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-15
-- 完成日期: 
-- 功能描述: 帧动画
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationFrame.log'

require "script.core.animation.AnimationBase"

CAnimationFrame = class('AnimationFrame',  CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个序列帧动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationFrame:Create( strPath, frameCount, configID, frameName)
	local o = CAnimationBase:Create()
	o.m_animtionType = CAnimationBase.AnimationType.Frame
	setmetatable(o, CAnimationFrame)
	o.m_configID = configID
	o.m_resPath = strPath
	local name = ""
	local _pngName = ""
	if frameName then
		name = frameName
		_pngName = frameName
	else
		name = self:ParsePath(strPath)
		_pngName = string.sub(name, 1, #name - 6)
	end
	
	o.m_animation = display.getAnimationCache(name)
	o.m_animationName = name
	if not o.m_animation then
        local _frames = display.newFrames(_pngName.."_%02d.png", 1, frameCount)
        if _frames then
	        _animation = display.newAnimation(_frames, 0.1)
	        display.setAnimationCache(name, _animation)
	        o.m_animation = _animation
	    else
	    	log_error(LOG_FILE_NAME, "帧特效没找到！请检查配置表:%d", configID)
	    end
    end
    o.m_showObject = display.newSprite()
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 播放动画
-- 参数[IN]: 是否循环
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationFrame:Play(loop)
	if 	self.m_showObject then
		if self.m_animation then
			if loop then
 				self.m_showObject:playAnimationForever(self.m_animation)
 			else
 				local function PlayFinish()
 					self.m_isFinish = true
 				end
 				self.m_showObject:playAnimationOnce(self.m_animation, { onComplete = PlayFinish })
 			end
 		end
 	end
end

--[[
-- 函数类型: public
-- 函数功能: 获取动画名字
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationFrame:GetAnimationName()
	return self.m_animationName
end

--[[
-- 函数类型: public
-- 函数功能: 销毁
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationFrame:Destroy()

	-- 注: 帧动画的动画和纹理由管理器进行管理了。这里不进行释放特此说明

	-- 基类析构
	CAnimationFrame.super.Destroy(self)
end