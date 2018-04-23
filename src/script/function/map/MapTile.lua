-- *******************************************************************************
-- Copyright (C), 2016, 
-- 文 件 名: MapTile.lua
-- 作    者: lyn
-- 创建日期: 2017-01-20
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- *******************************************************************************/

-- 日志文件名
local LOG_FILE_NAME = 'MapTile.lua.log'

CMapTile = class("MapTile")

local MASK_TYPE = {
	NOT_MASK = 0,
	MASK = 1,

}

function CMapTile:New(o)
	o = o or {}
	o.m_sprite           = nil
	o.m_spriteShadowPath = ""
	o.m_id               = 0
	o.m_name             = ""
	o.m_tilePos          = cc.p(0, 0)
	o.m_shadow           = nil
	o.m_breakPngPath     = ""
	o.m_breakShadowPath  = ""
	o.m_spritPath        = ""
	o.m_collsionSize     = cc.size(0, 0)
	o.m_pos 			 = cc.p(0, 0)
	setmetatable(o, CMapTile)
	return o
end

function CMapTile:Init(id)
	self.m_sprite           = nil
	self.m_id               = id or 0
	self.m_name             = Q_MapElement.GetTempData(id, "q_monster_name") or ""
	self.m_shadow           = nil
	local _sizeX            = Q_MapElement.GetTempData(id, "q_obj_width") or 0
	local _sizeY            = Q_MapElement.GetTempData(id, "q_obj_height") or 0
	self.m_collsionSize     = cc.size(_sizeX, _sizeY)
	self.m_breakPngPath     = Q_MapElement.GetTempData(id, "q_replace_id") or ""
	self.m_spritePath       = Q_MapElement.GetTempData(id, "q_picture_id") or ""
	self.m_spriteShadowPath = Q_MapElement.GetTempData(id, "q_shadow_id") or ""
	self.m_breakShadowPath  = Q_MapElement.GetTempData(id, "q_replace_shadow_id") or ""
	self.m_bMask			= Q_MapElement.GetTempData(id, "q_shade") or ""

	self.m_breakPngPath     = ParsePngPath(self.m_breakPngPath)    
	self.m_spritePath       = ParsePngPath(self.m_spritePath)      
	self.m_spriteShadowPath = ParsePngPath(self.m_spriteShadowPath)
	self.m_breakShadowPath  = ParsePngPath(self.m_breakShadowPath) 

	self.m_camp 		    = Q_MapElement.GetTempData(id, "q_camp")
	self.m_collisionBullet  = Q_MapElement.GetTempData(id, "q_ispenetration")
	self.m_baseType 		= Q_MapElement.GetTempData(id, "q_type")
end

function CMapTile:AddTo(target)
	if target then
		local _sprite = self:GetShow(true)
		local _shadow = self:GetShadow(true)
		if _sprite then
			_sprite:addTo(target)
		end
		if _shadow then
			_shadow:addTo(target)
		end
		self.m_targetNode = target
	end
end

function CMapTile:SetPosition(pos)
	self.m_pos = pos
	local _sprite = self:GetShow()
	local _shadow = self:GetShadow()
	if _sprite then
		_sprite:setPosition(pos)
	end
	if _shadow then
		local _anchor, _pos = self:GetShadowOffset()
		_shadow:setAnchorPoint(_anchor)
		_shadow:setPosition(pos.x + _pos.x, pos.y + _pos.y)
	end
end

function CMapTile:SetZorder(zoder)
	if self.m_sprite and self.m_bMask == MASK_TYPE.MASK then
		self.m_sprite:setLocalZOrder(zoder or 0)
	else
		self.m_sprite:setLocalZOrder(2)
	end
end

function CMapTile:SetTilePos(tile)
	self.m_tilePos = tile or cc.size(0, 0)
end

function CMapTile:ShowBreak()
	self:SetShow(self.m_breakPngPath)
	self:SetShadow(self.m_breakShadowPath)
end

function CMapTile:ShowNorml()
	self:SetShow(self.m_spritPath)
	self:SetShadow(self.m_spriteShadowPath)
end

function CMapTile:GetShadowOffset()
	local _strOffset = Q_MapElement.GetTempData(self.m_id, "q_shadow_offset")
	_strOffset = StrSplit(_strOffset, "|")
	local _anchor = StrSplit(_strOffset[1] or "0_0", "_")
	 _anchor = TableValueToNumber(_anchor)
	local _offest = StrSplit(_strOffset[2] or "10_-10", "_")
	_offest = TableValueToNumber(_offest)
	return cc.p(_anchor[1], _anchor[2]), cc.p(_offest[1], _offest[2])
end

function CMapTile:SetShow(pngPath)
	if pngPath and pngPath ~= "" and pngPath ~= "0.0" and self.m_targetNode then
		if self.m_sprite then
			self.m_sprite:removeFromParent()
		end

		self.m_sprite = cc.Sprite:createWithSpriteFrameName(pngPath)
		if self.m_sprite then
			self.m_sprite:setAnchorPoint(cc.p(0, 0))
			self.m_sprite:addTo(self.m_targetNode):move(self.m_pos)
			self.m_sprite:setCameraMask(cc.CameraFlag.USER2)
		end
	end
end

function CMapTile:GetCamp()
	return self.m_camp
end

function CMapTile:IsBasePlace()
	if self.m_baseType == 3 then
		return true
	end
	return false
end

function CMapTile:IsBulletCollision()
	if self.m_collisionBullet == 1 then
		return true
	end
	return false
end

function CMapTile:GetShow(bCacheFrame)
	if not self.m_sprite and self.m_spritePath ~= "" and self.m_spritePath ~= "0.0"  then
		if bCacheFrame then
			self.m_sprite = cc.Sprite:createWithSpriteFrameName(self.m_spritePath)
		else
			local _tex = display.loadImage(self.m_spritePath)
			if _tex then
				self.m_sprite = display.newSprite(_tex)
			end
		end
		if self.m_sprite then
			self.m_sprite:setAnchorPoint(cc.p(0, 0))
		else
			log_error(LOG_FILE_NAME, "地块图片创建失败:%s", self.m_spritePath)
		end
	end
	return self.m_sprite
end

function CMapTile:SetShadow(pngPath)
	if pngPath and pngPath ~= "" and pngPath ~= "0.0" and self.m_shadow then
		self.m_shadow:setTexture(pngPath)
	end
end

function CMapTile:GetShadow(bCacheFrame)

	if not self.m_shadow and self.m_spriteShadowPath ~= "" and self.m_spriteShadowPath ~= "0.0" then
		if bCacheFrame then
			self.m_shadow = cc.Sprite:createWithSpriteFrameName(self.m_spriteShadowPath)
		else
			_shadowTexture = display.loadImage(self.m_spriteShadowPath)
			if _shadowTexture then
				self.m_shadow = display.newSprite(_shadowTexture)
			end
		end
		if self.m_shadow then
			self.m_shadow:setAnchorPoint(cc.p(0, 0))
		end
	end
	return self.m_shadow
end

function CMapTile:GetCollisionSize()
	return self.m_collsionSize
end

function CMapTile:Destroy()
	if self.m_sprite then
	    self.m_sprite:removeFromParent()
	    self.m_sprite = false
	end
	if self.m_shadow then
	    self.shadow:removeFromParent()
	end
end