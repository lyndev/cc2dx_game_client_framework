--[[
-- Copyright (C), 2015, 
-- 文 件 名: JoystickSkinned.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-25
-- 完成日期: 
-- 功能描述: 摇杆皮肤设置类
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'JoystickSkinned.log'

local JoystickSkinned =  class("JoystickSkinned", function()
	return display.newLayer()
end)

function JoystickSkinned:ctor()
	self:Init()
	self.backgroundSprite = nil
	self.thumbSprite = nil
	self.joystick = nil
    self:onUpdate(function(dt) 
        self:updatePositions(dt) 
    end)
end

function JoystickSkinned:Init()
end

function JoystickSkinned:updatePositions()
	if self.joystick and self.thumbSprite then
		self.thumbSprite:setPosition(self.joystick:getStickPosition())
	end
end

function JoystickSkinned:SetContentSize(s)
	self:setContentSize(s)
	self.backgroundSprite:setContentSize(s)
end

function JoystickSkinned:setBackgroundSprite(aSprite)
	self.backgroundSprite = aSprite
	if aSprite then
		self:addChild(self.backgroundSprite, 0)		
		self:SetContentSize(self.backgroundSprite:getContentSize())
	end
end

function JoystickSkinned:setThumbSprite(aSprite)
	self.thumbSprite = aSprite
	if aSprite then
		self:addChild(self.thumbSprite, 1)
	end
end

function JoystickSkinned:setJoystick(aJoystick)
	if self.joystick then
		if self.joystick:getParent() then
		else
			self.joystick:getParent():removeChild(self.oystick, true)
		end
		self.joystick:release()
	end
	aJoystick:retain()
	self.joystick = aJoystick

	if aJoystick then
		self:addChild(aJoystick, 2)
		if self.thumbSprite then
			self.joystick:setThumbRadius(self.thumbSprite:getBoundingBox().width/2)
		else
			self.joystick:setThumbRadius(32)
		end

		if self.backgroundSprite then
			self.joystick:setJoystickRadius(self.backgroundSprite:boundingBox().width/2)
		end
	end
end

return JoystickSkinned