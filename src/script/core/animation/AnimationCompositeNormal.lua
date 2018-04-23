--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationCompositeNormal.lua
-- 作    者: 
-- 版    本: V1.0.0
-- 创建日期: 2016-06-06
-- 完成日期: 
-- 功能描述: UI一个特效多个播放动作的动画处理
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationCompositeNormal.log'

require "script.core.animation.AnimationBase"

CAnimationCompositeNormal = class('CAnimationCompositeNormal',  CAnimationBase)

--[[
-- 函数类型: public
-- 函数功能: 创建一个复合动作动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeNormal:Create(strPath, params, configID)
	local o = CAnimationBase:Create()
	setmetatable(o, CAnimationCompositeNormal)
	o.type = 'CompositeActionNormal'
	o.m_animtionType = CAnimationBase.AnimationType.CompositeActionNormal
	o.m_configID = configID
	o.m_showObject = cc.CSLoader:createNode(strPath)
	o.m_timeLine = cc.CSLoader:createTimeline(strPath)

	if not o.m_timeLine then
		log_error(LOG_FILE_NAME, "timeline 创建为空:%d", configID)
		return nil
	end

	if  o.m_showObject  then

	    o.m_tFrameNum = {}
	    
	    -- 解析帧动画
	    local _,_tableSize =  string.gsub(params,"_","_")
	    if _tableSize >= 0 then
	     	for i=1, _tableSize do
	     		local _tFrame = StrSplit(params, "|")
	     		local _fameTab = StrSplit(_tFrame[i], "_")
	     		_fameTab = TableValueToNumber(_fameTab)
	     		local _animationInfo = ccs.AnimationInfo(tostring(_fameTab[1]), _fameTab[1], _fameTab[2])
	     		o.m_timeLine:addAnimationInfo(_animationInfo)
	     		if i >= _tableSize then

	     			-- 总帧数
	    			o.m_totalFrame = _fameTab[2] or 0
	     		end
	     	end
	    end
	    o.m_isRunAction = false
	else
		log_error(LOG_FILE_NAME, "创建特效失败, timeline or node为空:%d", configID)
		return nil
	end
	return o
end

--[[
-- 函数类型: public
-- 函数功能: 播放动画
-- 参数[IN]: 是否循环, 指定动画起始帧
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeNormal:Play(name, loop)
	if self.m_timeLine then
		if not self.m_isRunAction and self.m_showObject then
			self.m_showObject:runAction(self.m_timeLine)
			self.m_isRunAction = true
		end
		if not name then
			if loop then
				self.m_timeLine:gotoFrameAndPlay(0, true)
			else
				self.m_timeLine:gotoFrameAndPlay(0, false)
			end
		else
			self.m_timeLine:play(tostring(name), loop)
		end
	end
end

--[[
-- 函数类型: public
-- 函数功能: 获取帧数 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeNormal:GetFramesNum(name)
	if name and self.m_timeLine then
		local _animationInfo = self.m_timeLine:getAnimationInfo(tostring(name))
		if _animationInfo then
			return _animationInfo.endIndex - _animationInfo.startIndex
		end
	end
	return 0
end

--[[
-- 函数类型: public
-- 函数功能: 销毁
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCompositeNormal:Destroy()
	CAnimationCompositeNormal.super.Destroy(self)
end