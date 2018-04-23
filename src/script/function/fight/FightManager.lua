require "script.function.map.MapManager"
require "script.core.entity.EntityTank"
require("script.function.joystick.JoysitckController")
require "script.function.fight.FightQiPaiBase"

FightManager = class("FightManager", CFightQiPaiBase)
local LOG_FILE_NAME = 'FightManager.lua.log'
local FRAME_RATE = 0.05 --每秒20帧
local SHOW_FRAMW_RATE = 0.0167
function FightManager:New( o )
  local o = CFightQiPaiBase:New(o)
  log_info(LOG_FILE_NAME, "初始FightManager管理器子类")
  setmetatable(o, FightManager)
  return o
end

function FightManager:Init( msg )

    OpenUI("CUITankFight", msg)
    CMapManager:GetInstance():Init(msg.mapId or 3)
    CMapManager:GetInstance():DraMapElements()
    CMapManager:GetInstance():DrawMapBackground()

    self.m_msgData = msg

    -- 初始化cocos相机
    local _mapTopNode = CMapManager:GetInstance():GetMapTopLayer()
    self._camera = cc.Camera:createOrthographic(VISIBLE_WIDTH(), VISIBLE_HEIGHT(), 0, 1)
    self._camera:setCameraFlag(cc.CameraFlag.USER2)
    self._camera:addTo(_mapTopNode)
    self._camera:setPosition3D(cc.vec3(0, 0, 0))
    
    -- 摇杆
    CJoysitckController:GetInstance():Init({mountNode = GameScene:GetUILayer()})

    -- 更新所有图层的相机遮罩
    CMapManager:GetInstance():SetCameraMask()

    self:ReadyUdpMsg()

    -- 房间创建(进入)成功
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESMOVEKEYDATAS, function(msgData)
        self:SyncMoveHandler(msgData)
    end, "FightManager")
end

function FightManager:ReadyUdpMsg()
  SendMsgToServer(MSGID.CS_ROOM_REQUDPENTERROOM, {roomNumber = self.m_msgData.roomInfo.roomNum, userId = CPlayer:GetInstance():GetUserID()})
end

local SendTime = FRAME_RATE
local _curPoint = cc.p(0, 0)
local _targetPoint = cc.p(0, 0)
local _movePoint = cc.p(0, 0)
local DT = 0.0167
function FightManager:Update( dt )
    DT = dt
  CJoysitckController:GetInstance():Update( dt )
  if self._camera and self.m_entityTest then
   -- self:UpdateCameraPosition(self.m_entityTest:GetPosition())
  end

  SendTime = SendTime - dt
  if SendTime <= 0 then
    SendTime = FRAME_RATE
    local _posX, _posY = self.m_entityTest:GetView():GetPosition() 
    local _angle = self.m_entityTest:GetView():GetBodyAngle() 
    local sendData = {
      posX = _posX,
      posY = _posY,
      angle = _angle,
      roleId = CPlayer:GetInstance():GetRoleID(),
    }
    SendMsgToServer(MSGID.CS_ROOM_REQMOVEKEYDATA, {moveData = sendData, userId = CPlayer:GetInstance():GetUserID()})
  end

    if self.m_otherEntityTest then
        local _t = dt / SHOW_FRAMW_RATE
        if _t > 1 then
            _t = 1
        end
        local _posX, _posY = self.m_otherEntityTest:GetView():GetPosition()
        local _targetPosX, _targetPosY = self.m_otherEntityTest:GetPosition()
        _curPoint.x = _posX
        _curPoint.y = _posY
        
        _targetPoint.x = _targetPosX
        _targetPoint.y = _targetPosY
        _movePoint = cc.pLerp(_curPoint, _targetPoint, _t)
        self.m_otherEntityTest:GetView():SetPosition(_movePoint.x, _movePoint.y)
    end
end

function FightManager:UpdateCameraPosition(posX, posY)
  if self._camera then
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
    
    self._camera:setPosition(willPosX, willPosY)
  end
end

function FightManager:EnterRoom(msgData)
    log_info(LOG_FILE_NAME, "一个玩家进入房间，创建实体")
    FightManager.super.EnterRoom(self, msgData)
    local _createEntity = EntityTank:New()
    _createEntity:SetServerID(msgData.playerBaseInfo.roleId)
    if msgData.playerBaseInfo.roleId ~= CPlayer:GetInstance():GetRoleID() then
      self.m_otherEntityTest = _createEntity
    else
      self.m_entityTest = _createEntity
      CJoysitckController:GetInstance():SetTarget(self.m_entityTest)
    end
end

function FightManager:LeaveRoom(roleId, bRemoveInfo)
  FightManager.super.LeaveRoom(self, msgData)
end

function FightManager:SyncMoveHandler(msgData)
  
    local _moveData = msgData.moveData
    if _moveData then 
        if _moveData.roleId == CPlayer:GetInstance():GetRoleID() then
            self.m_entityTest:SetPosition(_moveData.posX,_moveData.posY)
            self.m_entityTest:SetBodyAngle(_moveData.angle)
        else
            if self.m_otherEntityTest then
                self.m_otherEntityTest:SetPosition(_moveData.posX, _moveData.posY)
                self.m_otherEntityTest:SetGunAngle(_moveData.angle)
                self.m_otherEntityTest:GetView():SetBodyAngle(_moveData.angle)
            end
        end
    end

end

function FightManager:Destroy()
  FightManager.super.Destroy()
  CMapManager:GetInstance():Destroy()
end