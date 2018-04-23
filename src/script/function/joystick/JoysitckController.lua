--[[
-- Copyright (C), 2015, 
-- 文 件 名: JoysitckController.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-31
-- 完成日期: 
-- 功能描述: 摇杆控制器
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CJoysitckController.log'

local Joystick        = require("script.function.joystick.Joystick")
local JoystickSkinned = require("script.function.joystick.JoystickSkinned")

require("script.function.joystick.KeyboardController")

CJoysitckController = class("CJoysitckController")
CJoysitckController._instance = nil

local MINI_LIMIT_VALUE = 0.1 

local JOYSTICK_BG    = "png/joystick/joystick_bg.png"
local JOYSTICK_THUMB = "png/joystick/joystick_thumb.png"


function CJoysitckController:New()
    local o = {}
    setmetatable( o, CJoysitckController )
    o.m_targetObj = nil
    return o
end

function CJoysitckController:GetInstance( msg )
    if not CJoysitckController._instance then
        CJoysitckController._instance = CJoysitckController:New()
    end
    return  CJoysitckController._instance
end


function CJoysitckController:Init(msg)
    local _mountNode = msg.mountNode
    
    if not _mountNode then
        log_error(LOG_FILE_NAME, "摇杆父节点失败")
    end 

    self.m_pJoystickObj  = Joystick:create()
    self.m_pJoystickBase = JoystickSkinned:create()

    _mountNode:addChild(self.m_pJoystickBase)
    self.m_pJoystickBase:setPosition(100, 100):setRotation(90):setScaleX(-1)
    local _joystickBg    = cc.Sprite:create(JOYSTICK_BG)
    _joystickBg:setScale(0.9)
    local _joystickThumb = cc.Sprite:create(JOYSTICK_THUMB)
    self.m_pJoystickBase:setBackgroundSprite(_joystickBg)
    self.m_pJoystickBase:setThumbSprite(_joystickThumb)
    self.m_pJoystickObj:initWithRect(cc.rect(0, 0, 160.0, 160.0))
    self.m_pJoystickBase:setJoystick(self.m_pJoystickObj)

    KeyboardController:EnableKeyboard()
end

function CJoysitckController:SetTarget(target)
    self.m_targetObj = target
end

function CJoysitckController:On()
    self.m_bOn_Off = true
end


function CJoysitckController:Off()
    self.m_bOn_Off = false
end

function CJoysitckController:Hide()
    if self.m_pJoystickBase2 then
        self.m_pJoystickBase2:hide()
    end
end

function CJoysitckController:Show()
    if self.m_pJoystickBase2 then
        self.m_pJoystickBase2:show()
    end
end

function CJoysitckController:SetRatateJoystickPosition(pos)
    if self.m_pJoystickBaseRight then
        self.m_pJoystickBaseRight:setPosition(pos)
    end
end

function CJoysitckController:SetControlEntityID( entityID )
	self.m_controlObjID = entityID
end

local _time = 1
function CJoysitckController:Update( dt ) 

    -- 移动摇杆
    if self.m_pJoystickBase then
        -- 速率
        local _velocity = self.m_pJoystickObj:getVelocity()
        local _degrees = self.m_pJoystickObj:getDegrees()
        if self.m_targetObj then
            local _velocityDis = math.sqrt(_velocity.x * _velocity.x  + _velocity.y * _velocity.y)
            if _velocityDis > MINI_LIMIT_VALUE then
                self.m_targetObj:GetView():SetBodyAngle(_degrees)

                local _posX, _posY =  self.m_targetObj:GetView():GetPosition()
                _normalizePos = cc.pNormalize(cc.p(_velocity.y, _velocity.x))
                _posX = _posX + _normalizePos.x
                _posY = _posY + _normalizePos.y
                
                self.m_targetObj:GetView():SetPosition(_posX, _posY)
            end
        end

        _time = _time - dt

        if _time > 0 then
            return
        end

        _time = 1
        --print("速率", _velocity.x, _velocity.y)
        --print("角度", _degrees)
    end
end


function CJoysitckController:GetLeftJoystick()
    return self.m_pJoystickBase
end

function CJoysitckController:GetRightJoystick()
    return self.m_pJoystickBaseRight
end

function CJoysitckController:Destroy()
    self.m_pJoystickBaseRight   = nil
    self.m_pJoystickObjRight    = nil
    self.m_pJoystickBase        = nil
    self.m_pJoystickObj         = nil
    
    self.m_bMove                = nil
    self.m_bRatateTouched       = nil
    self.m_controlObjID         = nil
    self.m_bOn_Off              = nil

    gPublicDispatcher:RemoveEventListenerObj(self)
    CJoysitckController._instance = nil
end