--[[
-- Copyright (C), 2015, 
-- 文 件 名: Joystick.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-25
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'Joystick.log'

local Joystick =  class("Joystick", function()
	return display.newNode()
end)

local SJ_PI  		= 3.14159265359
local SJ_PI_X_2 	= 6.28318530718
local SJ_RAD2DEG 	= 180.0 / SJ_PI
local SJ_DEG2RAD 	= SJ_PI/ 180.0

function Joystick:initWithRect(rect)

    self.stickPosition = cc.p(0,0)
    self.degrees = 0.0
    self.velocity = cc.p(0,0)
    self.autoCenter = true
    self.isDPad = false
    self.hasDeadzone = false
    self.numberOfDirections = 4
    self.joystickRadius = 32
	self.joystickRadiusSq = 0

    self:setJoystickRadius(rect.width/2)
    self:setThumbRadius(32)
    self:setDeadRadius(0)
    self.m_tTouchCallBackList = {}
    
    self:setPosition(cc.p(0,0))

    local listener = cc.EventListenerTouchOneByOne:create()  

    local function onTouchBegan( touch, event)
       	return self:onTouchBegan(touch, event)
    end

    local function onTouchMoved( touch, event )
    	self:onTouchMoved(touch, event)
    end
    local function onTouchEnded( touch, event )
		self:onTouchEnded(touch, event)
   	end

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )  
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED )  
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED )  
    
    -- 时间派发器 
    local eventDispatcher = self:getEventDispatcher() 

    -- 吞没事件	
    listener:setSwallowTouches(true)

    -- 绑定触摸事件到层当中  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) 

	return true
end

function Joystick:getStickPosition()
	return self.stickPosition
end

function Joystick:getDegrees()
	return self.degrees
end

function Joystick:getVelocity()
	return self.velocity
end

function Joystick:getAutoCenter()
	return self.autoCenter
end

function Joystick:getHasDeadzone()
	return self.hasDeadzone
end

function Joystick:getNumberOfDirections()
	return self.numberOfDirections
end

function Joystick:getJoystickRadiusSq()
	return self.joystickRadiusSq
end

function Joystick:getJoystickRadius()
	return self.joystickRadius
end

function Joystick:getThumbRadius()
	return self.thumbRadius
end

function Joystick:getDeadRadius()
	return self.deadRadius
end

function Joystick:Reset()
	self:updateVelocity(cc.p(0,0))
end

function round(r)	
	if r > 0 then
		return math.floor(r + 0.5)
	else
		return math.ceil(r - 0.5)
	end
end

function Joystick:updateVelocity(point)
	local dx = point.x
	local dy = point.y
	local dSq = dx * dx + dy * dy
	
	if dSq <= self.deadRadiusSq then
		self.velocity = cc.p(0, 0)
		self.degrees = 0.0
		self.stickPosition = point
		return
	end

	local angle = math.atan2(dy, dx)
	if angle < 0 then
		angle = angle + SJ_PI_X_2
	end

	local cosAngle = 0
	local sinAngle = 0
	
	cosAngle = math.cos(angle)
	sinAngle = math.sin(angle)
	
	-- 速度 -1.0 to 1.0.
	if dSq > self.joystickRadiusSq then
		dx = cosAngle * self.joystickRadius
		dy = sinAngle * self.joystickRadius
	end
	
	self.velocity = cc.p(dx/self.joystickRadius, dy/self.joystickRadius)
	self.degrees = angle * SJ_RAD2DEG
	
	-- 更新拇指点的位置
	self.stickPosition = cc.p(dx, dy)
end

function Joystick:setJoystickRadius(r)
	self.joystickRadius = r
	self.joystickRadiusSq = r*r
end

function Joystick:setThumbRadius(r)
	self.thumbRadius = r
	self.thumbRadiusSq = r*r
end

function Joystick:setDeadRadius(r)
	self.deadRadius = r
	self.deadRadiusSq = r * r
end

function Joystick:onTouchBegan(touch, event)
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
			if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN] then
				self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_BEGAN]()
			end
			self:updateVelocity(location)
			return true
		end
	end
	return false
end

function Joystick:onTouchMoved(touch, event)
	local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
	location = self:convertToNodeSpace(location)
	self:updateVelocity(location)
end

function Joystick:onTouchEnded(touch, event)
	if self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED] then
		self.m_tTouchCallBackList[cc.Handler.EVENT_TOUCH_ENDED]()
	end
	local location = cc.p(0,0)
	if not self:getAutoCenter() then
		local location = cc.Director:getInstance():convertToGL(touch:getLocationInView())
		location = self:convertToNodeSpace(location)
	end
	self:updateVelocity(location)
end

function Joystick:onTouchCancelled(touch, event)
	self:onTouchEnded(touch, event)
end

function Joystick:touchDelegateRelease()

	self:release()
end

function Joystick:touchDelegateRetain()
	self:retain()
end

function Joystick:SetScriptEventHandler(eventType, callback )
	self.m_tTouchCallBackList[eventType] = callback
end

return Joystick