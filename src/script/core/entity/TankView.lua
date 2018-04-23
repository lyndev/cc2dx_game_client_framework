require "script.core.entity.Entity"
TankView = class("TankView", CEntity)

function TankView:New( o )
	local self = CEntity:New(o)
	setmetatable(self, TankView)
	self.m_viewTemplateId = o.viewTemplateId
	self.m_bodyView       = nil
	self.m_gunView        = nil
	self.m_bodyAngle      = 0
	self.m_gunAngle       = 0
	self:CreateView()
	return o
end

function TankView:CreateView()
	self.m_bodyView = display.newSprite("body_0.png")
	self.m_bodyView:setAnchorPoint(cc.p(0.5, 0.5))

	self.m_gunView = display.newSprite("gun_0.png")
	self.m_gunView:setAnchorPoint(0.5, 0.2)
	local _size = self.m_gunView:getContentSize()
	self.m_gunView:addTo(self.m_bodyView)
				  :move(33, 30)

	-- 加入地图节点显示
	CMapManager:GetInstance():AddToMapTopLayer(self.m_bodyView)
	self.m_bodyView:setPosition(cc.p(0, 0))

	-- 相机可见
	self.m_bodyView:setCameraMask(cc.CameraFlag.USER2)
	self.m_gunView:setCameraMask(cc.CameraFlag.USER2)
end

function TankView:Update(dt)

end

function TankView:SetPosition(posX, posY)
	TankView.super.SetPosition(self, posX, posY)
	self.m_bodyView:setPosition(posX, posY)
end

function TankView:SetBodyAngle(angle)
	self.m_bodyAngle = angle
	self.m_bodyView:setRotation(angle)
end

function TankView:SetGunAngle(angle)
	self.m_gunAngle = angle
	self.m_gunView:setRotation(angle)
end

function TankView:GetBodyAngle()
	return self.m_bodyAngle
end

function TankView:GetGunAngle()
	return self.m_gunAngle 
end

function TankView:GetBody()
	return self.m_bodyView
end

function TankView:getGun()
	return self.m_gunView
end

function TankView:Hide()
	self.m_bodyView:hide()
	self.m_gunView:hide()
end

function TankView:Show()
	self.m_bodyView:show()
	self.m_gunView:show()
end

function TankView:Destroy()
	self.m_bodyView:removeFromParent()
	self.m_gunView:removeFromParent()
end