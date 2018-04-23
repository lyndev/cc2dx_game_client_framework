-- =========================================================================
-- 文 件 名: FightBase.lua
-- 作    者: lyn
-- 创建日期: 2017-05-02
-- 功能描述: 战斗基类
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'FightBase.log'
  
require("script.Map.MapParser")

FightBase = class("FightBase")

function FightBase:New(o)
	self = o or {}
	setmetatable(self, FightBase)
	return self
end

function FightBase:Init()
end

function FightBase:CreateMap(config_id)
    self.m_mapObj = CMapManager:New()
    self.m_mapObj:Init(1)
    self.m_mapObj:DraMapElements()
    self.m_mapObj:DrawMapBackground()
    self.m_mapObj:GetMapRootLayer():setCameraMask(cc.CameraFlag.USER2)
end

function FightBase:CreateFollowCamera(pos)
	if self.m_mapObj then
		local mapSize = self.m_mapObj:GetMapSize()
		self.cameraBoundaryX, self.cameraBoundaryY = mapSize.width - VISIBLE_WIDTH() * 0.5, mapSize.height - VISIBLE_HEIGHT() * 0.5
	   	self.m_followCamera = cc.Camera:createOrthographic(VISIBLE_WIDTH(), VISIBLE_HEIGHT(), 0, 1)
	    self.m_followCamera:setCameraFlag(cc.CameraFlag.USER2)
	  	self.m_followCamera:addTo(self.m_mapObj:GetMapTopLayer())
	  	self:UpdateCameraPosition(0, 0)
	end
end

function FightBase:CreateTestTank()
	self.m_testTank = display.newSprite("res/png/tank.png"):move(0, 0):setScale(0.4):setCameraMask(cc.CameraFlag.USER2)
    self:GetMap():AddToMapTopLayer(self.m_testTank)
    self:SetCameraFollowTarget(_tank)
    self:RegisterKeyboardController()
end
function FightBase:GetFollowCamera()
	return self.m_followCamera
end

function FightBase:GetMap()
	return self.m_mapObj
end

local CAMERA_BOUNDARY = false
function FightBase:UpdateCameraPosition(posX, posY)
	if self.m_followCamera then
		local willPosX, willPosY = 0, 0
		if CAMERA_BOUNDARY then
			if posX > self.cameraBoundaryX then
				posX = self.cameraBoundaryX
			end

			if posY > self.cameraBoundaryY then
				posY = self.cameraBoundaryY
			end
			
			willPosX, willPosY = posX - VISIBLE_WIDTH() * 0.5, posY - VISIBLE_HEIGHT() * 0.5

			if willPosX < 0 then
				willPosX = 0
			end
			if willPosY < 0 then
				willPosY = 0
			end
		else
			willPosX, willPosY = posX - VISIBLE_WIDTH() * 0.5, posY - VISIBLE_HEIGHT() * 0.5
		end
		self.m_followCamera:setPosition3D(cc.vec3(willPosX, willPosY, 0))
	end
end

function FightBase:SetCameraFollowTarget(targetNode)
	self.m_followTarget = targetNode
end

function FightBase:TankMove(bMove, factor)
	self.m_bMove = bMove
	self.m_dirFacotr = factor
end

local speed = 120
function FightBase:Update(dt)
	if self.m_bMove and self.m_testTank then
		local _posX = self.m_testTank:getPositionX()
		local _posY = self.m_testTank:getPositionY()
		_posX = _posX + self.m_dirFacotr.x * speed * dt 
		_posY = _posY + self.m_dirFacotr.y * speed * dt
		self.m_testTank:move(_posX, _posY)
		self:UpdateCameraPosition(_posX, _posY)
	end
end

--[[
-- 函数类型: public
-- 函数功能: 键盘控制坦克
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function FightBase:RegisterKeyboardController()
    local _layerExit = display.newLayer()
    self.m_nMoveDirection = 0
    local _MoveKeyTab = {}

    -- 移动
    local _Move = function (dir, keyCode)
        CJoysitckController:GetInstance():ReqJoystickTouchState(dir, 1)
        self.m_nMoveDirection = ENUM.EDirection.Up 
        local _keyTab = {
                    _key = keyCode, 
                    _dir = dir,
                 }
         for k, v in pairs(_MoveKeyTab) do
            if v._key == keyCode then
                table.remove(_MoveKeyTab,k)
            end
        end
        table.insert(_MoveKeyTab, #_MoveKeyTab + 1, _keyTab )
    end
    local function onKeyReleased(keyCode, event)

        -- 抬起
        if  keyCode == 146 or keyCode == 124 or keyCode == 127 or keyCode == 142  then
        	self:TankMove(false)
        end
    end

    local function onKeyPressed(keyCode, event)

        -- 键盘控制坦克
        -- 移动方向
        local FACTOR = {
        	[1] = {x = 0, y = 1},
        	[2] = {x = -1, y = 0},
        	[3] = {x = 1, y = 0},
        	[4] = {x = 0, y = -1},

    	}
        if keyCode == 146 then     -- w 上
            self.m_testTank:setRotation(0)
            self:TankMove(true, FACTOR[1])
        elseif keyCode == 124 then -- A 左
            self.m_testTank:setRotation(-90) 
            self:TankMove(true, FACTOR[2])
        elseif keyCode == 127 then -- D 右
        	self.m_testTank:setRotation(90)
            self:TankMove(true, FACTOR[3])
        elseif keyCode == 142 then -- S 下
        	self.m_testTank:setRotation(180)
            self:TankMove(true, FACTOR[4])
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )

    local eventDispatcher = _layerExit:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, _layerExit)

    -- 加入当前场景
    _layerExit:addTo(display.getRunningScene())

end