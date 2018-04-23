-- [[
-- Copyright (C), 2015, 
-- 文 件 名: JoystickAxis.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-25
-- 完成日期: 
-- 功能描述: 轴型摇杆, 只能在水平和垂直轴上滑动
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'JoystickAxis.log'

local Joystick = require("script.Joystick.Joystick")

local JoystickAxis = class("JoystickAxis", Joystick)

function JoystickAxis:ctor( pos )
	JoystickAxis.super:ctor(self)
	self.m_bMoveed = false
end

function JoystickAxis:CheckPosition( pos )
	local  _degrees = self:getDegrees()
	local y = pos.y;
	local x = pos.x;
	local _v = self:getVelocity();
	local _velocity1 = math.sqrt(_v.x * _v.x  + _v.y * _v.y);

	if _velocity1 <= 0.1 then
		return pos
	end
	-- 方向左 右
	if (_degrees <= 360 and _degrees > 315) or (_degrees >= 0 and _degrees <= 45) or  (_degrees > 135 and _degrees <= 225) then
		y = 0
	end

	-- 方向上 下
	if  (_degrees > 45 and  _degrees <= 135) or  ( _degrees > 225 and  _degrees <= 315) then
		x = 0
	end

	if x > self.joystickRadius then
		x = self.joystickRadius - self:getThumbRadius()
	end

	if x < -self.joystickRadius then
		x = -self.joystickRadius + self:getThumbRadius()
	end
	if y > self.joystickRadius then
	
		y = self.joystickRadius - self:getThumbRadius()
	end

	if y < -self.joystickRadius then
		y = -self.joystickRadius + self:getThumbRadius()
	end
	
	return cc.p(x, y);
end


function JoystickAxis:onTouchBegan(touch, event)
	local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
	location = self:convertToNodeSpace(location)

	if location.x < -self:getJoystickRadius() or 
		location.x > self:getJoystickRadius() or 
		location.y < -self:getJoystickRadius() or
		location.y > self:getJoystickRadius()
	then
		return false
    else
		return true
	end
	return false
end

function JoystickAxis:onTouchMoved(touch, event)
	self.m_bMoveed = true
	local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
	location = self:convertToNodeSpace(location)

	-- 调整位置
	location = self:CheckPosition(location)
	self:updateVelocity(location)
end

function JoystickAxis:onTouchEnded(touch, event)
	local location = cc.p(0,0)
	local _v = self:getVelocity()
	local _velocity1 = math.sqrt(_v.x * _v.x  + _v.y * _v.y);
	if _velocity1 <= 0.6 then
		if not self:getAutoCenter() then
			local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
			location = self:convertToNodeSpace(location)
		end
		self:updateVelocity(location)
		if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED] then
			self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED]()
		end
	else
		if self.m_bMoveed then
			self.m_bMoveed = false
			local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
			location = self:convertToNodeSpace(location)
			location = self:CheckPosition(location)
			self:updateVelocity(location)
			if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN] then
				self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN]()
			end
		end
	end
end

function JoystickAxis:onTouchCancelled(touch, event)
	self:onTouchEnded(touch, event)
end

return JoystickAxis