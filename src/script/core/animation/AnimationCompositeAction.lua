--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationCompositeAction.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-05-25
-- 完成日期: 
-- 功能描述: 一个特效多个播放动作的动画处理
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationCompositeAction.log'

require "script.core.animation.AnimationBase"

CAnimationCompositeAction = class('CAnimationCompositeAction',  CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个复合动作动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeAction:Create(strPath, params, configID)
	local o = CAnimationBase:Create()
	setmetatable(o, CAnimationCompositeAction)
	o.m_showObject = cc.CSLoader:createNode(strPath)
	o.m_timeLine = cc.CSLoader:createTimeline(strPath)
	if o.m_showObject then
	    o.m_animtionType = CAnimationBase.AnimationType.CompositeAction
	    o.m_configID = configID

	    -- 解析帧动画
	    local _tFrame = StrSplit(params, "|")
	    local _fadeIn = StrSplit(_tFrame[1], "_")
	    _fadeIn = TableValueToNumber(_fadeIn)
	    local _loop = StrSplit(_tFrame[2], "_")
	    _loop = TableValueToNumber(_loop)
	    local _fadeOut = StrSplit(_tFrame[3], "_")
	    _fadeOut = TableValueToNumber(_fadeOut)

	    -- 创建动作信息
	    local fadeInInfo = ccs.AnimationInfo("fadeIn", _fadeIn[1], _fadeIn[2])
	    local loopInfo = ccs.AnimationInfo("loop", _loop[1], _loop[2])
	    local fadeOutInfo = ccs.AnimationInfo("fadeOut", _fadeOut[1], _fadeOut[2])
	    o.m_timeLine:addAnimationInfo(fadeInInfo)
	    o.m_timeLine:addAnimationInfo(loopInfo)
	    o.m_timeLine:addAnimationInfo(fadeOutInfo)

	    -- 总帧数
	    o.m_totalFrame = _fadeOut[2] or 0
	    o.m_isRunAction = false
	else
		log_error(LOG_FILE_NAME, "创建动画的失败:%d", configID)
		return nil
	end

	if not o.m_timeLine then
		log_error(LOG_FILE_NAME, "创建动画的 timeline 失败:%d", configID)
		return nil
	end


    return o
end

--[[
-- 函数类型: public
-- 函数功能: 播放动画
-- 参数[IN]: 是否循环, 指定动画名字
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeAction:Play(loop, name)
	if not self.m_isRunAction and self.m_showObject and self.m_timeLine  then
		local function onFrameEvent(frame)
		    if nil == frame then
		        return
		    end
		    local str = frame:getEvent()
            local a = 100  		-- 此参数和编辑器【淡出播放完成事件】绑定
            local b = 101 		-- 和编辑器【淡出播放完成事件】绑定
            str = tonumber(str)
		    if str == a then
		       self.m_timeLine:play("loop", true)
		    elseif str == b then
		    	self.m_isFinish = true
		    	self.m_showObject:hide()
		    end
		end

		self.m_timeLine:setFrameEventCallFunc(onFrameEvent)
		self.m_showObject:runAction(self.m_timeLine)
		self.m_isRunAction = true
	end
	if not name then
		if loop then
			if  self.m_timeLine then
				self.m_timeLine:play("fadeIn", false)
			end
		else
			if self.m_timeLine then
				self.m_timeLine:gotoFrameAndPlay(0, false)
				local _duration =  self.m_totalFrame / 60 
				performWithDelay( self.m_showObject, function()
					self.m_isFinish = true
				end, _duration)
			end
		end
	else
		if self.m_timeLine then
			self.m_timeLine:play(name, false)
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
function CAnimationCompositeAction:Destroy()
	CAnimationCompositeAction.super.Destroy(self)
end