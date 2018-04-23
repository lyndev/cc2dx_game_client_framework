require "script.core.entity.Entity"
require "script.core.entity.TankView"

EntityTank = class("EntityTank", CEntity)

function EntityTank:New(o)
	local t = CEntity:New(o)
	t.m_viewObj = TankView:New({viewTemplateId = 0})
	t.m_logicBodyAngle = 0
	t.m_logicGunAngle = 0
	setmetatable(t, EntityTank)
	return t
end

function EntityTank:Update(dt)
end

function EntityTank:SetBodyAngle(angle)
	self.m_logicBodyAngle = angle
end

function EntityTank:SetGunAngle(angle)
	self.m_logicGunAngle = angle
end

function EntityTank:GetBodyAngle()
	return self.m_logicBodyAngle
end

function EntityTank:GetGunAngle()
	return self.m_logicGunAngle
end

function EntityTank:GetView()
	return self.m_viewObj
end

function EntityTank:Hide()
	self.m_viewObj:Hide()
end

function EntityTank:Show()
	self.m_viewObj:Show()
end

function EntityTank:Destroy()
	self.m_viewObj:Destroy()
end