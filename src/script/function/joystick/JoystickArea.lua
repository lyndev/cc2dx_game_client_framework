--[[
-- Copyright (C), 2015, 
-- 文 件 名: JoystickArea.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-26
-- 完成日期: 
-- 功能描述: 区域摇杆,滑动到哪个区域就停留在那个区域的正方向上
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'JoystickArea.log'

local Joystick = require("script.Joystick.Joystick")

local JoystickArea = class("JoystickArea", Joystick) 

function JoystickArea:ctor()
	JoystickArea.super:ctor(self)
end

function JoystickArea:onTouchBegan(touch, event)
	local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
	location = self:convertToNodeSpace(location)

	if location.x < -self:getJoystickRadius() or 
		location.x > self:getJoystickRadius() or 
		location.y < -self:getJoystickRadius() or
		location.y > self:getJoystickRadius()
	then
		return false
    else
		local dSq = location.x * location.x + location.y * location.y
		if self:getJoystickRadiusSq() > dSq then
			self:updateVelocity(location)
			if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN] then
				self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN]()
			end
			return true
		end
	end
	return false
end

function JoystickArea:onTouchMoved(touch, event)
	local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
	location = self:convertToNodeSpace(location)
	self:updateVelocity(location)
end

function JoystickArea:onTouchEnded(touch, event)

	local location = cc.p(0,0)
	local _v = self:getVelocity()
	local _velocity1 = math.sqrt(_v.x * _v.x  + _v.y * _v.y);

	-- 小于内圈就重置
	if _velocity1 < 0.4 then

		self:updateVelocity(location)

		if not self:getAutoCenter() then
			local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
			location = self:convertToNodeSpace(location)
		end

	-- 否则就停留在当前方向的正方向位置
	else
		local _degrees = self:getDegrees()

		-- 右
        if (_degrees <= 360 and  _degrees > 315) or  (_degrees >= 0 and _degrees <= 45) then
        	self:updateVelocity(cc.p(self:getJoystickRadius() - tonumber(Q_Global.GetTempData(19, 'q_string_value') or 0.4), 0))

        -- 上
        elseif  _degrees > 45 and  _degrees <= 135 then
        	self:updateVelocity(cc.p(0, self:getJoystickRadius() - tonumber(Q_Global.GetTempData(19, 'q_string_value') or 0.4) ))

        -- 左
        elseif  _degrees > 135 and  _degrees <= 225 then
			self:updateVelocity(cc.p(-self:getJoystickRadius() + tonumber(Q_Global.GetTempData(19, 'q_string_value') or 0.4), 0))

        -- 下
        elseif  _degrees > 225 and  _degrees <= 315 then
        	self:updateVelocity(cc.p(0,  -self:getJoystickRadius() + tonumber(Q_Global.GetTempData(19, 'q_string_value') or 0.4) ))
        end
	end
	if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED] then
		self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED]()
	end
end

return JoystickArea