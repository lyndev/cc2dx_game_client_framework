--[[
-- Copyright (C), 2015, 
-- 文 件 名: AnimationCreateManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-04-05
-- 完成日期: 
-- 功能描述: 动画创建器, 现在支持创建：1.帧动画 2.粒子动画 3.复合节点粒子 4.单张图片
-- 其它相关: 本来想用对象池的方法来优化特效的创建,经过仔细的斟酌后发现会存在以下2点问题:
-- 	1.缓存使用过的特效,是已经挂载了节点上,即使隐藏不显示,也会对帧率有较大影响(理论上可以retain并从节点移除,保存对象指针)。
-- 	2.使用的图片本身已经加到缓存了,创建一个特效对象,不会卡,但是频繁的释放还是会产生内存碎片问题。
-- 	3.帧动画的动画缓存问题,不缓存特效对此会频繁的创建和释放缓存帧动画。
--	综上还是决定暂时不使用对象池来处理。
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAnimationCreateManager.log'

require "script.core.animation.AnimationBase"
require "script.core.animation.AnimationCompositeParticle"
require "script.core.animation.AnimationParticle"
require "script.core.animation.AnimationImage"
require "script.core.animation.AnimationFrame"
require "script.core.animation.AnimationCompositeAction"
require "script.core.animation.AnimationCompositeNormal"

CAnimationCreateManager = class('CAnimationCreateManager')

CAnimationCreateManager._instance = nil

local FRAME_MAX_VALUE = 50 	-- 帧资源最多缓存50个

--[[
-- 函数类型: public
-- 函数功能: 构造一个CAnimationCreateManager管理器对象
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:New()
    local o = {}
    o.m_tAnimationMap 				= {} 					-- key = 动画特效实例ID， value = 动画对象
    o.m_ClearTime 	  				= 0.2
    o.m_tAnimationFrameResCache 	= {}
    o.m_tAnimationFrameCount 		= {}
    o.m_tFrameResChechTime 			= 5
    setmetatable(o, CAnimationCreateManager)
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 单例获取
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:GetInstance(msg)
    if not CAnimationCreateManager._instance then
        CAnimationCreateManager._instance = self:New()
    end
    return  CAnimationCreateManager._instance
end

--[[
-- 函数类型: public
-- 函数功能: 初始化
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:Init(param)
end

--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:CreateEffectByID(id)
	if id then
		local _strPath 		 	= q_animationeffect.GetTempData(id, "EffectPath")
		local _animationType 	= q_animationeffect.GetTempData(id, "AnimationType")
		local _frameCount		= q_animationeffect.GetTempData(id, "FrameCount")
		local _actionArgs 		= {}
		local _frameName        = q_animationeffect.GetTempData(id, "FrameName")
		local _particleDuration = q_animationeffect.GetTempData(id, "DurationTime")
		if _particleDuration and _particleDuration ~='' and _particleDuration ~= '0' then
			_particleDuration = tonumber(_particleDuration)
		else
			_particleDuration = 0
		end
		return self:CreateEffect(_strPath, {frameName = _frameName, animationType = _animationType, frameCount = _frameCount, actionArgs = _actionArgs, configID = id, duration = _particleDuration or -1 })
	else
		log_error(LOG_FILE_NAME, "创建特效失败, 特效ID为空!")
		return nil
	end
end

--[[
-- 函数类型: public
-- 函数功能: 创建动画
-- 参数[IN]: 动画逻辑, 参数
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:CreateEffect(strPath, args)
	local _animation = nil
	if strPath and strPath ~= '' then

		-- 创建一个帧动画
		if args.animationType == CAnimationBase.AnimationType.Frame then

			-- 帧资源缓存
			if not self.m_tAnimationFrameResCache[args.configID] then			
				-- 图集资源引用
				print("帧动画的路径", strPath)
				CPlistCache:GetInstance():RetainPlist(strPath)
 				self.m_tAnimationFrameResCache[args.configID] = {path = strPath, animation = false }
			end

			_animation = CAnimationFrame:Create(strPath,  args.frameCount, args.configID, args.frameName)
			local _animationName = _animation:GetAnimationName()

			-- 保存帧动画的名字
			if _animationName and not self.m_tAnimationFrameResCache[args.configID] then
				-- 保存动画名字
				self.m_tAnimationFrameResCache[args.configID].animationName = _animationName
			end

		-- 创建一个粒子动画
		elseif  args.animationType == CAnimationBase.AnimationType.Particle then
			_animation =	CAnimationParticle:Create(strPath, args.configID)

		-- 创建一个复合粒子动画
		elseif  args.animationType == CAnimationBase.AnimationType.CompositeParticle then
			_animation =	CAnimationCompositeParticle:Create(strPath, args.duration, args.configID)

		-- 创建一个图片动画
		elseif  args.animationType == CAnimationBase.AnimationType.Image then
			_animation =	CAnimationImage:Create(strPath, args.configID)

		-- 创建一个复合动作动画
		elseif  args.animationType == CAnimationBase.AnimationType.CompositeAction then
			_animation = CAnimationCompositeAction:Create(strPath, args.actionArgs, args.configID)

		-- 创建一个复合动画
		elseif  args.animationType == CAnimationBase.AnimationType.CompositeActionNormal then
			_animation = CAnimationCompositeNormal:Create(strPath, args.actionArgs, args.configID)
		end

		-- 加入列表存储
		if _animation then
			self.m_tAnimationMap[_animation:GetInstanceID()] = _animation
		end
		return _animation
	else
		log_error(LOG_FILE_NAME, '创建动画失败，路径为空, 动画ID:%d', args.configID)
	end
end

--[[
-- 函数类型: public
-- 函数功能: 更新
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:Update(dt)
	
	self.m_ClearTime = self.m_ClearTime - dt
	self.m_tFrameResChechTime = self.m_tFrameResChechTime - dt
	
	-- 有频率的进行检测清理
	if self.m_ClearTime <= 0 then
		if self.m_tAnimationMap then
			for k, v in pairs(self.m_tAnimationMap) do
				if v and v:IsFinished() then
					self:RemoveEffect(k)
				end
			end
		end
	end
	
end

--[[
-- 函数类型: public
-- 函数功能: 获取一个动画特效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:GetEffect(nInstanceID)
	return self.m_tAnimationMap[nInstanceID]
end

--[[
-- 函数类型: public
-- 函数功能: 移除一个动画特效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:RemoveEffect(nInstanceID)
	if self.m_tAnimationMap[nInstanceID] then
		self.m_tAnimationMap[nInstanceID]:Destroy()
		self.m_tAnimationMap[nInstanceID] = nil
	end
end

--[[
-- 函数类型: private
-- 函数功能: 检查帧资源是否需要清理
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:CheckFrameCacheResAndRelease_()
				
	-- 是否超过缓存个数限制,注:需要判断该资源是否在使用中,再进行移除缓存
	if #self.m_tAnimationFrameCount > FRAME_MAX_VALUE then

		local _willReleaseIndex = 0
		for i= #self.m_tAnimationFrameCount, 1, -1 do
			local _animationID = self.m_tAnimationFrameCount[i]
			local _cacheInfo = self.m_tAnimationFrameResCache[_animationID]
			if _cacheInfo then
				local _curRefCount = CPlistCache:GetInstance():GetPlistRefCount(_cacheInfo.path)
				if _curRefCount == 1 then
					_willReleaseIndex = i
					self.m_tAnimationFrameResCache[_animationID] = nil

					-- 移除缓存的动画
					display.removeAnimationCache(_cacheInfo.animationName)

					-- 移除资源的引用
					CPlistCache:GetInstance():ReleasePlist(_cacheInfo.path)
					log_info(LOG_FILE_NAME, "移除一个缓存特效,路径:%s", _cacheInfo.path)
					break
				end
			end
		end

		if _willReleaseIndex ~= 0 then
			table.remove(self.m_tAnimationFrameCount, _willReleaseIndex)
		end
	end
end

--[[
-- 函数类型: public
-- 函数功能: 清理接口
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:ClearAll()
	self:Destroy()
end

--[[
-- 函数类型: public
-- 函数功能: 销毁(析构)
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CAnimationCreateManager:Destroy()

	-- 清理帧动画缓存的资源
	for k, v in pairs(self.m_tAnimationFrameResCache) do

		-- 移除缓存的动画
		display.removeAnimationCache(v.animationName)
		
		-- 移除资源的引用
		CPlistCache:GetInstance():ReleasePlist(v.path)
	end
	self.m_tAnimationFrameResCache = {}
	
	-- 清理管理器的所有动画
	for k, v in pairs(self.m_tAnimationMap) do
		if v then
			v:Destroy()
		end
	end
	self.m_tAnimationMap = {}

    CAnimationCreateManager._instance = nil
end