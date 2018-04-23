-- *******************************************************************************
-- Copyright (C), 2016, 
-- 文 件 名: MapParser.lua
-- 作    者: lyn
-- 创建日期: 2017-01-20
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- *******************************************************************************/

-- 日志文件名
local LOG_FILE_NAME = 'MapParser.lua.log'

require("script.function.map.MapBase")
require("script.function.map.MapTile")

CMapManager = class('CMapManager', CMapBase)
local DRAW = false
CMapManager.__instance = nil

function CMapManager:New(o)
    local o = CMapBase:New(o)
    o.m_mapTiles = {}
    o.m_mapCollisionFlag = {}
    setmetatable(o, CMapManager)
    return o
end

function CMapManager:GetInstance()
	if not CMapManager.__instance then
		CMapManager.__instance = CMapManager:New()
	end
	return CMapManager.__instance
end

function CMapManager:Init(id)
	CMapManager.super.Init(self)
    -- 加载受损显示的元素图集
    self.m_plists = Q_Map.GetTempData(id, 'q_use_plist')
    self.m_plists = StrSplit(self.m_plists, "|")
    for i,v in ipairs(self.m_plists) do
    	CPlistCache:GetInstance():RetainPlist(v)
    end
	self:LoadMapConfig(id)
end

function CMapManager:LoadMapConfig(id)
	local _mapPath = Q_Map.GetTempData(id, 'q_lua') -- "res/mapconfig/map_1485054044.lua"--
    if _mapPath == '' then
        return
    end
    package.loaded[_mapPath] = nil
    local _mapData = require(_mapPath)

    local _cacheMapData = {}
    local _cacheMapImageId = {}
    if _mapData then
		local _mapTiles = {}
        local _xTile = 1
        local _yTile = 1
        for i,v in ipairs(_mapData.element_ids) do
            if not _mapTiles[_xTile] then
                _mapTiles[_xTile] = {}
            end
            _mapTiles[_xTile][_yTile] = v
            if _yTile < _mapData.height then
                _yTile = _yTile + 1
            else
                _yTile = 1
                _xTile = _xTile + 1
            end
            _cacheMapImageId[v] = v
        end

        self:SetTiles(_mapTiles)
       	self:SetMapName(_mapData.map_name)
		self:SetMapID(_mapData.map_id)
		self:SetMapSize(cc.size(_mapData.width, _mapData.height))
		self:SetMapTileSize(cc.size(_mapData.tile_width, _mapData.tile_height))
		self:SetMapBgID(_mapData.background_id)
		self:LoadMapWillUseImagePath(_cacheMapImageId)
    end
end

-- 读取即将使用的地图图片
function CMapManager:LoadMapWillUseImagePath(ids)
    for k, v in pairs(ids) do
		local _image       = Q_MapElement.GetTempData(v, 'q_picture_id')
		local _replace     = Q_MapElement.GetTempData(v, 'q_replace_id')
		local _shadow      = Q_MapElement.GetTempData(v, 'q_shadow_id')
		local _breakShadow = Q_MapElement.GetTempData(v, 'q_replace_shadow_id')

    	if _image ~= "" then
    		table.insert(self.m_mapUseImages, _image)
    	end

    	if _replace ~= "" then
    		table.insert(self.m_mapUseImages, _replace)
    	end

    	if _shadow ~= "" then
    		table.insert(self.m_mapUseImages, _shadow)
    	end

    	if _breakShadow ~= "" then
    		table.insert(self.m_mapUseImages, _breakShadow)
    	end 	
    end
end

function CMapManager:DraMapElements()
	local _topNode = self:GetMapTopLayer()
	local _tiles = self:GetTiles()
	for _tileX, _hTiles  in pairs(_tiles) do
		for _tlieY, _id in pairs(_hTiles) do
			local _tile = cc.p(_tileX, _tlieY)
			self:AddElement(_topNode, _tile, _id)
		end
	end
end

function CMapManager:DrawMapBackground()
	local _bgID = self:GetMapBgID()
	local _name = Q_MapElement.GetTempData(_bgID, "q_picture_id")
	display.loadImage(_name)
	local _bottomNode = self:GetMapBottomLayer()
    local _tex = display.getImage(_name)
    if _tex then
		local _tileWidth  = self:GetMapTileWidth()
		local _tileHeight = self:GetMapTileHeight()
		local _xCount     = self:GetMapWidth()
		local _yCount     = self:GetMapHeight()

        -- 地图总的像素大小
        local _mapSizeW = _tileHeight * _xCount
        local _mapSizeH = _tileHeight * _yCount

        -- 根据背景图片的大小进行平铺
        local _sprite = display.newSprite(_tex)
        local _backImageSizeW = _sprite:getContentSize().width
        local _backImageSizeH = _sprite:getContentSize().height
        local _backImageXCount = math.ceil(_mapSizeW / _backImageSizeW)
        local _backImageYCount = math.ceil(_mapSizeH /_backImageSizeW)
        for i = 1, _backImageXCount do                
            for j = 1, _backImageYCount do
                local _sprite = display.newSprite(_tex)
                _sprite:setAnchorPoint(cc.p(0, 0))
                _bottomNode:addChild(_sprite)
                _sprite:setPosition((i - 1) * _backImageSizeW,  (j - 1) * _backImageSizeH)
                _sprite:setLocalZOrder(1)
            end
        end
    else
    	log_error(LOG_FILE_NAME, "背景元素不存在:%s", _name)
    end
end

function CMapManager:AddElement(root, tile, id)
	if root and tile and id and id > 0 then
		local _tileObj = CMapTile:New()
		_tileObj:Init(id)
		if not self.m_mapTiles[tile.x] then
			self.m_mapTiles[tile.x] = {}
		end
		_tileObj:AddTo(root)
		local _pos = self:CalcTileOnMapPos(tile)
		_tileObj:SetPosition(_pos)
		_tileObj:SetZorder(self:CalcZOrder(tile))
		_tileObj:SetTilePos(tile)
		self:AddElementCollision(tile, _tileObj)
		self.m_mapTiles[tile.x][tile.y] = _tileObj
	end
end

function CMapManager:RemoveElment(tile)
	local _tileObj= self:GetTileObj(tile)
	if _tileObj then
		self:RemoveElementCollision(tile, _tileObj)
		_tileObj:Destroy()
		self.m_mapTiles[tile.x][tile.y] = nil

	end
end

function CMapManager:BreakElement(tile)
	local _tileObj= self:GetTileObj(tile)
	if _tileObj then
		_tileObj:ShowBreak()
	end
end

function CMapManager:GetTileObj(tile)
	if self.m_mapTiles[tile.x] and self.m_mapTiles[tile.x][tile.y] then
		return self.m_mapTiles[tile.x][tile.y]
    end
end

-- 碰撞区域存在重叠碰撞问题需要用碰撞计数的方法处理
function CMapManager:AddElementCollision(tile, tileObj)
	local _size = tileObj:GetCollisionSize()
	local _isBulletBlock = tileObj:IsBulletCollision()
	local _camp = tileObj:GetCamp()
	if DRAW then
		local _colorLayer = cc.LayerColor:create(cc.c4b(120, 120, 0, 200)) 
		local _pos = self:CalcTileOnMapPos(tile)
    	_colorLayer:setPosition(_pos)
    	_colorLayer:setContentSize(cc.size(_size.width * self:GetMapTileSize().width, _size.height * self:GetMapTileSize().height))
		_colorLayer:setCameraMask(cc.CameraFlag.USER2)
		_colorLayer:setAnchorPoint(cc.p(0, 0))
		_colorLayer:setLocalZOrder(5000)
		_colorLayer:addTo(gFightMgr:GetMap():GetMapTopLayer())
	end

	for x = tile.x, _size.width do
		for y = tile.y, _size.height do
			if not self.m_mapCollisionFlag[tile.x] then
				self.m_mapCollisionFlag[tile.x] = {}
			end

			local _collisionInfo = self.m_mapCollisionFlag[tile.x][tile.y]
			if not _collisionInfo then
				self.m_mapCollisionFlag[tile.x][tile.y] = {}
				_collisionInfo = self.m_mapCollisionFlag[tile.x][tile.y]
				_collisionInfo.moveBlockRefCount = 1
				if _isBulletBlock then
					_collisionInfo.bulletBlockRefCount = 1
				end
				if _camp == ENUM.ENTITY_CAMP.RED then
					_collisionInfo.readCamp = 1
				elseif _camp == ENUM.ENTITY_CAMP.BLUE then
				 	_collisionInfo.blueCamp = 1
				end
			else
				_collisionInfo.moveBlockRefCount = _collisionInfo.moveBlockRefCount + 1
				if _isBulletBlock then
					_collisionInfo.bulletBlockRefCount = _collisionInfo.bulletBlockRefCount + 1
				end
				if _camp == ENUM.ENTITY_CAMP.RED then
					_collisionInfo.redCamp = _collisionInfo.redCamp + 1
				elseif _camp == ENUM.ENTITY_CAMP.BLUE then
				 	_collisionInfo.blueCamp = _collisionInfo.blueCamp + 1
				end
			end
			self.m_mapCollisionFlag[tile.x][tile.y] = _collisionInfo
		end
	end
end

function CMapManager:RemoveElementCollision(tile, tileObj)
	if tileObj then
		local _size = tileObj:GetCollisionSize()
		local _isBulletBlock = tileObj:IsBulletCollision()
		local _camp = tileObj:GetCamp()
		for x = tile.x, _size.width do
			for y = tile.y, _size.height do
				if self.m_mapCollisionFlag[tile.x] and self.m_mapCollisionFlag[tile.x][tile.y] then
					self.m_mapCollisionFlag[tile.x][tile.y] = self.m_mapCollisionFlag[tile.x][tile.y] -1
					if _isBulletBlock then
						self.m_mapCollisionFlag[tile.x][tile.y].bulletBlockRefCount = self.m_mapCollisionFlag[tile.x][tile.y].bulletBlockRefCount - 1
					end
					if _camp == ENUM.ENTITY_CAMP.RED then
						self.m_mapCollisionFlag[tile.x][tile.y].redCamp = self.m_mapCollisionFlag[tile.x][tile.y].redCamp - 1
					elseif _camp == ENUM.ENTITY_CAMP.BLUE then
					 	self.m_mapCollisionFlag[tile.x][tile.y].blueCamp = self.m_mapCollisionFlag[tile.x][tile.y].blueCamp - 1
					end
				end
			end
		end
	end
end

function CMapManager:GetCollisionByTile(tile)
	if tile and self.m_mapCollisionFlag[tile.x] and self.m_mapCollisionFlag[tile.x][tile.y] then
		return self.m_mapCollisionFlag[tile.x][tile.y]
	else
		return false
	end
end

function CMapManager:RemoveAllElement()
    if self.m_mapTiles then
        for w, v in pairs(self.m_mapTiles) do
            for h, tileObj in pairs(v) do
            	if tileObj and tileObj ~= 0 then
            		tileObj:Destroy()
            	end
            end
        end
    end
    self.m_mapTiles = {}
end

function CMapManager:Destroy()
	for i,v in ipairs(self.m_plists) do
    	CPlistCache:GetInstance():ReleasePlist(v)
    end
	self:RemoveAllElement()
	CMapManager.super.Destroy(self)
    CMapManager._instance = nil
end