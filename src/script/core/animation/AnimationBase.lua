--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-15
-- 完成日期: 
-- 功能描述: 动画效果基类
-- 其它相关: 
-- 修改记录:  
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationBase.log'

CAnimationBase = class('CAnimationBase')
CAnimationBase.AnimationType = 
{
	None                  = 0,
	Frame                 = 1, 		-- 帧
	Particle              = 2,  	-- 粒子
	CompositeParticle     = 3, 		-- 复合粒子(讲多个粒子特效组合在一个node下面的粒子组合)
	Image                 = 4, 		-- 图片(单张图片)
	CompositeAction       = 5, 		-- 复合动作动画
	CompositeActionNormal = 6,     -- UI复合动作
	Spine                 = 7, 		--spine动画
}

function CAnimationBase:Create(o)
	local o = o or {}
	o.m_nInstanceID 	= IDMaker.GetID()
	o.m_showObject 		= nil
	o.m_isFinish 		= false
	o.m_animtionType  	= CAnimationBase.AnimationType.None
	o.m_configID 		= 0
	setmetatable(o, CAnimationBase)
	return o
end

function CAnimationBase:Play(loop)
	
end

function CAnimationBase:Pause()
	
end

function CAnimationBase:AddTo(node)
	if node and self.m_showObject then
		node:addChild(self.m_showObject)
	end
end

function CAnimationBase:Update()

end

function CAnimationBase:GetInstanceID()
	return self.m_nInstanceID
end

function CAnimationBase:GetShow()
	return self.m_showObject
end

function CAnimationBase:IsFinished()
	return self.m_isFinish
end

function CAnimationBase:ParsePath(strPath)
	local _tPath = StrSplit(strPath, '/')
	local _strName = _tPath[#_tPath]
	if _strName and _strName ~= "" then
		return _strName
	else
		log_error(LOG_FILE_NAME, '解析动画路径错误！')
	end
	return ''
end

function CAnimationBase:GetAnimationType()
	return self.m_animtionType
end

function CAnimationBase:Destroy()

	if self.m_showObject then
		log_info(LOG_FILE_NAME, '销毁特效, 特效ID%d', self.m_configID)
		self.m_showObject:removeFromParent()
		self.m_showObject = nil
	end
end

