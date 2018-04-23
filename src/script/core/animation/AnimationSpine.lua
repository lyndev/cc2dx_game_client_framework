

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationSpine.log'

require "script.core.animation.AnimationBase"

CAnimationSpine = class('AnimationSpine',  CAnimationBase)

local EventType = 
{
	Start_Event 	= 0,
	End_Event 		= 1,
	Complete_Event 	= 2,
	Animation_Event = 3,
}

--[[
-- 函数类型: public
-- 函数功能: 创建一个序列帧动画对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationSpine:Create( strPath, scale )
	scale = scale or 1
	local o = CAnimationBase:Create()
	o.m_animtionType = CAnimationBase.AnimationType.Spine
	setmetatable(o, CAnimationSpine)
	o.m_resPath = strPath
	o.m_animationName = self:ParsePath(strPath)
	o.m_showObject = sp.SkeletonAnimation:create(strPath .. "/skeleton.json", strPath .. "/skeleton.atlas", scale)
	if o.m_showObject then
		o.m_showObject:retain()
	end
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 播放动画
-- 参数[IN]: 是否循环
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationSpine:Play( action, loop )
	if self.m_showObject then
		self.m_showObject:registerSpineEventHandler(
			function ( event )
				self:StartEventHandler(event)
			end, EventType.Start_Event)

		
		self.m_showObject:registerSpineEventHandler(
			function ( event )
				self:EndEventHandler(event)
			end, EventType.End_Event)

		self.m_showObject:registerSpineEventHandler(
			function ( event )
				self:CompleteEventHandler(event)
			end, EventType.Complete_Event)

		self.m_showObject:registerSpineEventHandler(
			function ( event )
				self:AnimationEventHandler(event)
			end, EventType.Animation_Event)

		self.m_showObject:setAnimation(1, action, loop)
		

	end
end

-- 函数功能: 开始播放事件回调
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CAnimationSpine:StartEventHandler( event )
	
end
-- 函数功能: 播放结束事件回调
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CAnimationSpine:EndEventHandler( event )
	self.m_isFinish = true
end
-- 函数功能: 播放完成一次事件回调
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CAnimationSpine:CompleteEventHandler( event )
	
end

-- 函数功能: 动画中的自定义事件
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CAnimationSpine:AnimationEventHandler( event )
	if event.eventData.name == "xunhuan1" then
		
	end
end

--[[
-- 函数类型: public
-- 函数功能: 获取动画名字
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationSpine:GetAnimationName()
	return self.m_animationName
end

--[[
-- 函数类型: public
-- 函数功能: 销毁
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationSpine:Destroy()

	if self.m_showObject then
		self.m_showObject:release()
	end

	-- 基类析构
	CAnimationSpine.super.Destroy(self)
end