-- [[
-- Copyright (C), 2015, 
-- 文 件 名: MapBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-07
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CMapBase.log'

CMapBase = class("CMapBase")

local MathCeil = math.ceil

function CMapBase:New(o)
    o = o or {}
    setmetatable(o, CMapBase)
    o.m_mapSize      = cc.size(0, 0)
    o.m_mapTileSize  = cc.size(0, 0)
    o.m_mapName      = ''
    o.m_mapID        = 0
    o.m_pMapData     = nil
    o.m_mapBgID      = 0
    o.m_mapTiles     = {}
    o.m_mapUseImages = {}
    return o
end

function CMapBase:Init()
    log_info(LOG_FILE_NAME, "初始化MapBase")
    self.m_pMapRootLayer    = cc.Layer:create()
    self.m_pMapBottomLayer  = cc.Layer:create()
    self.m_pMapTopLayer     = cc.Layer:create()
    self.m_pMapElementLayer = cc.Layer:create()
    self.m_pMoveLayer       = cc.Layer:create()
    
    self.m_pMapRootLayer:addChild(self.m_pMapBottomLayer)   -- 底层
    self.m_pMapRootLayer:addChild(self.m_pMapElementLayer)  -- 移动层
    self.m_pMapRootLayer:addChild(self.m_pMoveLayer)        -- 移动层
    self.m_pMapRootLayer:addChild(self.m_pMapTopLayer)      -- 顶层
    GameScene:GetSceneLayer():addChild(self.m_pMapRootLayer)
end

function CMapBase:SetCameraMask()
    return self.m_pMapRootLayer:setCameraMask(cc.CameraFlag.USER2)
end

function CMapBase:GetMapRootLayer()
    return self.m_pMapRootLayer
end

function CMapBase:GetMapBottomLayer()
    return self.m_pMapBottomLayer
end

function CMapBase:GetMapTopLayer()
    return self.m_pMapTopLayer
end

function CMapBase:GetMapElementLayer()
    return self.m_pMapElementLayer
end

function CMapBase:GetMoveLayer()
    return self.m_pMoveLayer
end

function CMapBase:AddToMapElementLayer(node)
    self.m_pMapElementLayer:addChild(node)
end

function CMapBase:AddToMapBottomLayer(node)
    self.m_pMapBottomLayer:addChild(node)
end

function CMapBase:AddToMoveLayer(node)
    self.m_pMoveLayer:addChild(node)
end

function CMapBase:AddToMapTopLayer(node)
    self.m_pMapTopLayer:addChild(node)
end

function CMapBase:GetMap()
	return self.m_pMapData
end

function CMapBase:SetMapBgID(id)
    self.m_mapBgID = id
end

function CMapBase:GetMapBgID(id)
    return self.m_mapBgID
end

function CMapBase:SetTiles(tiles)
    self.m_mapTiles = tiles
end

function CMapBase:GetTiles()
    return self.m_mapTiles
end

function CMapBase:SetMapName(name)
    self.m_mapName = name
end

function CMapBase:SetMapID(id)
    self.m_mapID = id
end

function CMapBase:SetMapSize(size)
    self.m_mapSize = size or cc.size(0, 0)
end

function CMapBase:SetMapTileSize(size)
    self.m_mapTileSize = size or cc.size(0, 0)
end

function CMapBase:GetMapSize()
	return  self.m_mapSize
end

function CMapBase:GetMapWidth()
    return self.m_mapSize.width
end

function CMapBase:GetMapHeight()
    return self.m_mapSize.height
end

function CMapBase:GetMapTileSize()
	return self.m_mapTileSize
end

function CMapBase:GetMapTileWidth()
    return self.m_mapTileSize.height
end

function CMapBase:GetMapTileHeight()
    return self.m_mapTileSize.width
end

function CMapBase:GetWillUseImagesPath()
    return self.m_mapUseImages
end

function CMapBase:LoadMapWillUseImagePath(ids)
end

function CMapBase:CalcTileOnMapPos(tile)
    local _tileSizeW = self:GetMapTileWidth()
    local _tileSizeH = self:GetMapTileHeight()
    local _posX = (tile.x - 1) * _tileSizeW
    local _posY = (tile.y - 1) * _tileSizeW
    return cc.p(_posX, _posY)
end

function CMapBase:CalcTileCenterPos(tile)
    local _tileSizeW = self:GetMapTileWidth()
    local _tileSizeH = self:GetMapTileHeight()
    local _pos = self:CalcTileOnMapPos(tile)
    return cc.p(_pos.x + _tileSizeW * 0.5 , _pos.y + _tileSizeH * 0.5)
end

function CMapBase:CalcZOrder(tile)
    local _maxTileH = self:GetMapHeight()
    local _zOrder = _maxTileH - tile.y + 3
    return _zOrder
end

function CMapBase:CalcTile(pos)
    local _tileSizeW = self:GetMapTileWidth()
    local _tileSizeH = self:GetMapTileHeight()
    local _tileX = MathCeil(pos.x / _tileSizeW)
    local _tileY = MathCeil(pos.y / _tileSizeH)
    return cc.p(_tileX, _tileY)
end

function CMapBase:FixElementTile(pos)
    local _tileSizeW = self:GetMapTileWidth()
    local _tileSizeH = self:GetMapTileHeight()
    local _tileX = MathCeil(pos.x / _tileSizeW)
    local _tileY = MathCeil(pos.y / _tileSizeH)
    local _posX = (_tileX - 1) * _tileSizeW
    local _posY = (_tileY - 1) * _tileSizeW
    if _posX < 0  then
        _posX = 0
    end
    if _posY < 0  then
        _posY = 0
    end
    return cc.p(_tileX, _tileY), cc.p(_posX, _posY)
end

function CMapBase:Destroy()
    self.m_pMapRootLayer:removeFromParent()
end	