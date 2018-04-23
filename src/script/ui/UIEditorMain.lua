--*******************************************************************************
-- Copyright (C), 2016, 
-- 文 件 名: UIEditorMain.lua
-- 作    者: lyn
-- 创建日期: 2017-01-16
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--******************************************************************************

-- 日志文件名
local LOG_FILE_NAME = 'UIEditorMain.lua.log'

require "res.config.EditorConfig"
require "script.MapEditorUtils.ExportMap"

CUIEditorMain = CreateClass(UIBase)

TableTest = {a = 100, b = 200, c = 300}
MapData = {}

local UI_PANEL_NAME         = "csb/ui_main.csb"
local UI_PLIST_NAME         = "plist/ui_editor_main.plist"
local PNG_BG_PATH           = "map/map_bg"
local PNG_EL_PATH           = "map/map_el"
local RED_POINT             = "red_point.png"
local GRAY_POINT            = "gray_point.png"
local UI_TEMPALTE_NAME      = "csb/ui_template_name.csb"
local UI_TEMPLATE_EL_SUB    = "csb/ui_template_el_sub_type.csb"
local MAP_REGION_X          = 1200
local MAP_REGION_Y          = 855
local MAP_NAME_PREFIX       = "newMap-"
local DEFAULT_WIDTH         = 20
local DEFAULT_HEIGHT        = 20
local DEFAULT_TILE_WIDTH    = 40
local DEFAULT_TILE_HEIGHT   = 40
local DEFAULT_MAP_ID        = 0
local MAP_CONFIG_DATA       = EditorConfig.ConfigData
local MAP_CONFIG_DATA_INDEX =  EditorConfig.ConfigDataIndex
local SaveCountDown         = EditorConfig.SaveTimeInterval * 60
local MathCeil              = math.ceil
local AutoSaveFlag          = true


function CUIEditorMain:Create(msg)
	local o = {}
	setmetatable(o, CUIEditorMain)
	o.m_pRootForm = nil
    o.m_tMapBackGround = {}
    o.m_tMapTile = {}
	return o
end

function CUIEditorMain:Init(msg)

    CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)
    
    -- 创建UI
	self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
    	log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
    	return
    end
    
    -- 加入控件管理器
    CWidgetManager:GetInstance():AddChild(self.m_pRootForm)
    self.m_pRootForm:retain()
    AdapterUIRoot(self.m_pRootForm)

    -- 加入背景和元素资源
    self:LoadConfigImage()

    -- 初始化ui控件
    self:InitButtonEvent(msg)
    self:InitElSubTypeBtn()
    self:InitCreateNewMapWidget()
    self:InitShowTileLabel()

    -- 初始化地图结构
    self:InitMapDataStructure()
    self:InitMapNode()

    -- 初始化UI上的背景和元素列表
    self:ShowBGImage(EditorConfig.MapBG)
    self:ShowElementIamge(EditorConfig.MapEL)
    self:ShowBgScorllView(true)
    self:ShowElScorllView(false)

    -- 渲染网格和背景
    self:DrawGrid()
    self:DrawMapBackground("map_01.png")

    -- 注册鼠标事件
    self:OnRegisterMouseEvent()

    Notice("初始化地图编辑器完成")
	return true
end

function CUIEditorMain:Update(dt)
    if SaveCountDown and AutoSaveFlag then
        SaveCountDown = SaveCountDown - dt
        if SaveCountDown <= 0 then
            SaveCountDown = EditorConfig.SaveTimeInterval * 60
            self:AutoSaveFile("自动备份文件成功...")
        end
    end
end

function CUIEditorMain:InitMapDataStructure(mapData)
    mapData = mapData or {}

    -- 清理原先绘制的背景和元素
    self:RemoveAllElement()
    self:RemoveAllDrawBackground()

    -- 设置地图数据
    self.m_mapData = {}
    self.m_mapData.mapName    = mapData.mapName or (MAP_NAME_PREFIX..os.time())
    self.m_mapData.mapID      = mapData.mapID or os.time()
    self.m_mapData.width      = mapData.tileX or DEFAULT_WIDTH
    self.m_mapData.height     = mapData.tileY or DEFAULT_HEIGHT
    self.m_mapData.tileWidth  = mapData.tileSizeW or DEFAULT_TILE_WIDTH
    self.m_mapData.tileHeight = mapData.tileSizeH or DEFAULT_TILE_HEIGHT
    self.m_mapData.bgID       = mapData.bgID or self:GetBackroundID() or 0
    self.m_mapData.tiles      = {}
    
    -- 初始化地图、地块尺寸
    self:SetTileSize(cc.size(self.m_mapData.tileWidth, self.m_mapData.tileHeight))
    self:SetMapTotalTile(cc.size(self.m_mapData.width, self.m_mapData.height))

    local externalTiles = mapData.mapTiles

    -- 初始化格子
    local ids = ""
    for i=1, self.m_mapData.width do
        self.m_mapData.tiles[i] = {}
        for j = 1, self.m_mapData.height do
             self.m_mapData.tiles[i][j] = {id = 0, name = '', sprite = false}
            if externalTiles and externalTiles[i] and externalTiles[i][j] then
                local _id = externalTiles[i][j]
                if _id and _id > 0 then
                    local _createTileInfo = self:CreateElementByID(_id)
                    if _createTileInfo then
                        local _pos = self:CalcTileOnMapPos(cc.size(i,j))
                        self:AddElementOnMapByTile(_pos, cc.size(i,j), _createTileInfo)
                    end
                    --ids = ids..i.."_"..j.."|"
                end
            end
        end
    end
    --print("元素的地址2", ids)
    -- 初始化背景
    local _bgName = MAP_CONFIG_DATA.GetTempData(self.m_mapData.bgID, "q_picture_id")
    self:DrawMapBackground(_bgName or "")
end

function CUIEditorMain:InitMapNode()
    if not self.m_mapBaseLayer then
        self.m_mapBaseLayer = cc.LayerColor:create(cc.c4b(40, 40, 40,  128))
        local _scorllView = FindNodeByName(self.m_pRootForm, "scroll_view_map")
        if _scorllView then
            _scorllView:addChild(self.m_mapBaseLayer)   
        end
    end
    self.m_mapBaseLayer:setPosition(100, 100)
    self.m_mapBaseLayer:setAnchorPoint(cc.p(0, 0))
    self.m_mapBaseLayer:setLocalZOrder(0)

    self:SetMapNodeSize(self:GetMapSize())
end

function CUIEditorMain:SetMapNodeSize(size)
    self.m_mapBaseLayer:setContentSize(size)
    local _scorllView = FindNodeByName(self.m_pRootForm, "scroll_view_map")
    if _scorllView then
        _scorllView:setInnerContainerSize(cc.size(size.width + 200, size.height + 200))     
    end
end

function CUIEditorMain:GetMapData()
    return self.m_mapData
end

function CUIEditorMain:LoadConfigImage()
    for i,v in ipairs(EditorConfig.MapBG) do
        --print("加载图片",v[MAP_CONFIG_DATA_INDEX.q_picture_id])
        display.loadImage(v[MAP_CONFIG_DATA_INDEX.q_picture_id])
    end
    
    for i, v in ipairs(EditorConfig.MapEL) do
        for k, data in pairs(v) do
            --print("加载图片",data[MAP_CONFIG_DATA_INDEX.q_picture_id])
            display.loadImage(data[MAP_CONFIG_DATA_INDEX.q_picture_id])
        end
    end

    display.loadImage(RED_POINT)
    display.loadImage(GRAY_POINT)
end

function CUIEditorMain:InitButtonEvent(msg)
    
    local btn_save_binary = FindNodeByName(self.m_pRootForm, "btn_save_binary")
    if btn_save_binary then
        AddButtonEvent(btn_save_binary, handler(self, self.OnBtnSaveBinaryClick), args)
    end

    local btn_new = FindNodeByName(self.m_pRootForm, "btn_new")
    if btn_new then
        AddButtonEvent(btn_new, handler(self, self.OnBtnNewClick), args)
    end

    local btn_open = FindNodeByName(self.m_pRootForm, "btn_open")
    if btn_open then
        AddButtonEvent(btn_open, handler(self, self.OnBtnOpenClick), args)
    end

    local btn_save = FindNodeByName(self.m_pRootForm, "btn_save")
    if btn_save then
        AddButtonEvent(btn_save, handler(self, self.OnBtnSaveClick), args)
    end

    local btn_export_server = FindNodeByName(self.m_pRootForm, "btn_export_server")
    if btn_export_server then
        AddButtonEvent(btn_export_server, handler(self, self.OnBtnExportServerClick), args)
    end

    local btn_export_client = FindNodeByName(self.m_pRootForm, "btn_export_client")
    if btn_export_client then
        AddButtonEvent(btn_export_client, handler(self, self.OnBtnExportClientClick), args)
    end

    local btn_tool_help = FindNodeByName(self.m_pRootForm, "btn_tool_help")
    if btn_tool_help then
        AddButtonEvent(btn_tool_help, handler(self, self.OnBtnToolHelpClick), args)
    end

    local btn_show_bg = FindNodeByName(self.m_pRootForm, "btn_show_bg")
    if btn_show_bg then
        AddButtonEvent(btn_show_bg, handler(self, self.OnBtnShowbgClick), args)
    end

    local btn_show_el = FindNodeByName(self.m_pRootForm, "btn_show_el")
    if btn_show_el then
        AddButtonEvent(btn_show_el, handler(self, self.OnBtnShowElClick), args)
    end

    local btn_create_ok = FindNodeByName(self.m_pRootForm, "btn_create_ok")
    if btn_create_ok then
        AddButtonEvent(btn_create_ok, handler(self, self.OnBtnCreateOkClick), args)
    end

    local btn_create_cancel = FindNodeByName(self.m_pRootForm, "btn_create_cancel")
    if btn_create_cancel then
        AddButtonEvent(btn_create_cancel, handler(self, self.OnBtnCreateCancelClick), args)
    end
    
    local btn_reset_scale = FindNodeByName(self.m_pRootForm, "btn_reset_scale")
    if btn_reset_scale then
        AddButtonEvent(btn_reset_scale, handler(self, self.OnBtnResetMapScaelClick), args)
    end
    
    local btn_resetting = FindNodeByName(self.m_pRootForm, "btn_resetting")
    if btn_resetting then
        AddButtonEvent(btn_resetting, handler(self, self.OnBtnSettingShowClick), args)
    end

    local function selectedStateEvent(sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self:ShowGrid(true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            self:ShowGrid(false)
        end
    end

    local checkbox = FindNodeByName(self.m_pRootForm, "chc_show_grid")
    if checkbox then
        checkbox:addEventListener(selectedStateEvent)
    end
end

function CUIEditorMain:OnBtnSaveBinaryClick(sender, args)
    MapData = self:GetMapData()
    MapData.element_ids = {}
    for x, v in pairs(MapData.tiles) do
        for y, tileInfo in pairs(v) do
            table.insert(MapData.element_ids, tileInfo.id)
        end
    end
    CPlatformInterface:GetInstance():SaveMapBinaryData("MapData")
end

function CUIEditorMain:OnBtnNewClick(sender, args)
    self:ResetMouseFocuse()
    self:ShowCreateTips(true)
end

function CUIEditorMain:OnBtnOpenClick(sender, args)
    self:ResetMouseFocuse()
    local _choicePath = CPlatformInterface:GetInstance():OpenWindow()
    if _choicePath == "" then
        return
    end
    local _fileName = StrSplit(_choicePath, "\\")
    if not _fileName then
        return
    end
    local _script = _fileName[#_fileName]
    package.loaded[_fileName] = nil
    local _mapData = require("res/export_map_config/save/".._script)

    local _cacheMapData = {}
    if _mapData then
        _cacheMapData.mapName       = _mapData.map_name
        _cacheMapData.mapID         = _mapData.map_id
        _cacheMapData.tileX         = _mapData.width
        _cacheMapData.tileY         = _mapData.height
        _cacheMapData.tileSizeW     = _mapData.tile_width
        _cacheMapData.tileSizeH     = _mapData.tile_height
        _cacheMapData.bgID          = _mapData.background_id
        _cacheMapData.mapTiles      = {}

        local _xTile = 1
        local _yTile = 1
        for i,v in ipairs(_mapData.element_ids) do
            if not _cacheMapData.mapTiles[_xTile] then
                _cacheMapData.mapTiles[_xTile] = {}
            end
            _cacheMapData.mapTiles[_xTile][_yTile] = v
            if _yTile < _mapData.height then
                _yTile = _yTile + 1
            else
                _yTile = 1
                _xTile = _xTile + 1
            end
        end

        -- 加载数据
        self:InitMapDataStructure(_cacheMapData)   
        
        self:SetMapNodeSize(self:GetMapSize())

        -- 重新绘制网格
        self:ClearDrawGrid()
        self:DrawGrid()

        Notice("加载地图数据成功")
    else
        Notice("加载地图数据失败")
    end
end

function CUIEditorMain:OnBtnSaveClick(sender, args)
    self:ResetMouseFocuse()
    self:SaveMapFile()
end

function CUIEditorMain:SaveMapFile(desc)
    local _mapData = self:GetMapData()
    ExportMap:Export(ExportMap.ExportType.Lua, _mapData, 'res/export_map_config/save', desc) 
end

function CUIEditorMain:AutoSaveFile(desc)
    local _mapData = self:GetMapData()
    ExportMap:Export(ExportMap.ExportType.Lua, _mapData, 'res/export_map_config/backup', desc) 
end

function CUIEditorMain:OnBtnExportServerClick(sender, args)
    self:ResetMouseFocuse()
    local _mapData = self:GetMapData()
    ExportMap:Export(ExportMap.ExportType.Json, _mapData)
end

function CUIEditorMain:OnBtnExportClientClick(sender, args)
    self:ResetMouseFocuse()
    local _mapData = self:GetMapData()
    ExportMap:Export(ExportMap.ExportType.Lua, _mapData)
end

function CUIEditorMain:OnBtnToolHelpClick(sender, args)
    self:ResetMouseFocuse()
    dump(args, "TODO:工具帮助")
end

function CUIEditorMain:OnBtnShowbgClick(sender, args)
    self:ResetMouseFocuse()
    self:ShowBgScorllView(true)
    self:ShowElScorllView(false)
end

function CUIEditorMain:OnBtnShowElClick(sender, args)
    self:ResetMouseFocuse()
    self:ShowElScorllView(true)
    self:ShowBgScorllView(false)
end

function CUIEditorMain:OnBtnCreateOkClick(sender, args)
    self:ResetMouseFocuse()
    self:ShowCreateTips(false)
    self:InitMapDataStructure(self.m_tempCreate)
    self:SetMapNodeSize(self:GetMapSize())
    self:ClearDrawGrid()
    self:DrawGrid()
end

function CUIEditorMain:OnBtnCreateCancelClick(sender, args)
    self:ResetMouseFocuse()
    self:ShowCreateTips(false)
end

function CUIEditorMain:OnBtnResetMapScaelClick(sender, args)
    self:ResetMouseFocuse()
    self:SetMapShowScale(1)
end

function CUIEditorMain:OnBtnSettingShowClick(sender, args)
    self:ResetMouseFocuse()
    self:InitResettingMapWidget()
    self:ShowResettingTips(true)
end

function CUIEditorMain:ShowCreateTips(bShow)
    self:ResetMouseFocuse()
    local _tips_create = FindNodeByName(self.m_pRootForm, "tips_create")
    if _tips_create then
        if bShow then
            _tips_create:show()
        else
            _tips_create:hide()
        end
    end
end

function CUIEditorMain:ResetMouseFocuse()
    self:SetCurrentMouseFocusImage(nil)
    self:SetCurrentChoiceEl(nil)
end

function CUIEditorMain:ShowResettingTips(bShow)
    self:ResetMouseFocuse()
    local tips_resetting = FindNodeByName(self.m_pRootForm, "tips_resetting")
    if tips_resetting then
        if bShow then
            tips_resetting:show()
        else
            tips_resetting:hide()
        end
    end
end

function CUIEditorMain:InitResettingMapWidget()
    self.m_tempCacheSetting = {}
    local function setInputData(sender, value)
        local _name = sender:getName()
        if _name == "input_file_name" then
            self.m_tempCacheSetting.mapName = value
        else
            local _tonumber = tonumber(value)
            if not _tonumber then
                Notice("必须是数字")
                return
            end
            if _name == "input_tile_x" then
                self.m_tempCacheSetting.tileX = value
            elseif _name == "input_tile_y" then
                self.m_tempCacheSetting.tileY = value
            elseif _name == "input_tile_size_w" then
                self.m_tempCacheSetting.tileSizeW = value
            elseif _name == "input_tile_size_h" then
                self.m_tempCacheSetting.tileSizeH = value
            elseif _name == "input_map_id" then
                self.m_tempCacheSetting.mapID = value
            end
        end
    end

    local function textFieldEvent(sender, eventType)
        local _vlaue = sender:getString()
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            setInputData(sender, _vlaue)
        end
    end

    local tips_resetting    = FindNodeByName(self.m_pRootForm, "tips_resetting")
    local input_file_name   = FindNodeByName(tips_resetting, "input_file_name")
    local input_tile_x      = FindNodeByName(tips_resetting, "input_tile_x")
    local input_tile_y      = FindNodeByName(tips_resetting, "input_tile_y")
    local input_map_id      = FindNodeByName(tips_resetting, "input_map_id")

    self.m_tempCacheSetting.mapName   = self.m_mapData.mapName
    self.m_tempCacheSetting.tileX     = self.m_mapData.width
    self.m_tempCacheSetting.tileY     = self.m_mapData.height
    self.m_tempCacheSetting.mapID     = self.m_mapData.mapID       
    self.m_tempCacheSetting.tileSizeW = self.m_mapData.tileWidth
    self.m_tempCacheSetting.tileSizeH = self.m_mapData.tileHeight
    self.m_tempCacheSetting.bgID      = self.m_mapData.bgID

    if input_file_name then
        input_file_name:setString( self.m_mapData.mapName or (MAP_NAME_PREFIX..os.time()))
        input_file_name:addEventListener(textFieldEvent)
    end
    
    if input_tile_x then
        input_tile_x:setString(self.m_mapData.width or DEFAULT_WIDTH)
        input_tile_x:addEventListener(textFieldEvent)
    end

    if input_tile_y then
        input_tile_y:setString(self.m_mapData.height or DEFAULT_HEIGHT)
        input_tile_y:addEventListener(textFieldEvent)
    end

    if input_map_id then
        input_map_id:setString(self.m_mapData.mapID  or os.time())
        input_map_id:addEventListener(textFieldEvent)
    end

    local btn_resetting_ok = FindNodeByName(self.m_pRootForm, "btn_resetting_ok")
    if btn_resetting_ok then
        AddButtonEvent(btn_resetting_ok, handler(self, self.OnClickResettingOkMapBtn), args)
    end   

    local btn_resetting_cancel = FindNodeByName(self.m_pRootForm, "btn_resetting_cancel")
    if btn_resetting_cancel then
        AddButtonEvent(btn_resetting_cancel, handler(self, self.OnClickCancelResettingMapBtn), args)
    end
end


--TODO:扩大，缩小处理不一样
function CUIEditorMain:OnClickResettingOkMapBtn(sender, args)
    self:ResettingMapInfo()
    self:ShowResettingTips(false)
end

function CUIEditorMain:ResettingMapInfo()
    local _cacheLastMapData = clone(self:GetMapData())
    _cacheLastMapData.mapName = self.m_tempCacheSetting.mapName
    _cacheLastMapData.mapID   = self.m_tempCacheSetting.mapID
    if self.m_tempCacheSetting.tileX ~=  _cacheLastMapData.width or _cacheLastMapData.height  ~= self.m_tempCacheSetting.tileY then
        _cacheLastMapData.tileX     = self.m_tempCacheSetting.tileX
        _cacheLastMapData.tileY     = self.m_tempCacheSetting.tileY
        _cacheLastMapData.tileSizeW = self.m_tempCacheSetting.tileSizeW
        _cacheLastMapData.tileSizeH = self.m_tempCacheSetting.tileSizeH
        local externalTiles = {}

        -- 将原来的地图元素数据拷贝出来
        local ids = ""
        for x = 1, _cacheLastMapData.tileX do
            if not externalTiles[x] then
                externalTiles[x] = {}
            end
            for y = 1, _cacheLastMapData.tileY do
                if _cacheLastMapData.tiles[x] and _cacheLastMapData.tiles[x][y] then
                    local _tileInfo = _cacheLastMapData.tiles[x][y]
                    if _tileInfo.sprite and _tileInfo.id > 0 then
                        --ids = ids..x.."_"..y.."|"
                        externalTiles[x][y] = _tileInfo.id
                    end
                end
            end
        end
        --print("元素的地址", ids)
        _cacheLastMapData.mapTiles = externalTiles
        self:InitMapDataStructure(_cacheLastMapData)
        self:SetMapNodeSize(self:GetMapSize())
        self:ClearDrawGrid()
        self:DrawGrid()

        local _bgName = MAP_CONFIG_DATA.GetTempData(self.m_mapData.bgID, "q_picture_id")
        self:DrawMapBackground(_bgName)
    else
        self.m_mapData.mapName = self.m_tempCacheSetting.mapName
        self.m_mapData.mapID = self.m_tempCacheSetting.mapID
    end
end

function CUIEditorMain:OnClickCancelResettingMapBtn(sender, args)
    self:ShowResettingTips(false)
end

function CUIEditorMain:InitShowTileLabel()
    self.m_showTileLabel = cc.Label:create()
    self.m_showTileLabel:setColor(cc.c3b(250, 0, 0))
    self.m_showTileLabel:setSystemFontSize(20)
    self.m_showTileLabel:setString("x:0, y:0")
    self.m_showTileLabel:addTo(self.m_pRootForm)
    self.m_showTileLabel:setLocalZOrder(1000)
    self.m_showTileLabel:setAnchorPoint(cc.p(1, 0.5))
end

function CUIEditorMain:ShowTileLabel(bShow, tile, pos)
    if self.m_showTileLabel then
        if bShow then
            self.m_showTileLabel:show()
            self.m_showTileLabel:setString("x:"..tile.x..",y:"..tile.y)
            pos = cc.p(pos.x, pos.y)
            self.m_showTileLabel:setPosition(pos or cc.p(0, 0))
        else
            self.m_showTileLabel:hide()
        end
    end
end

function CUIEditorMain:InitCreateNewMapWidget()
    self.m_tempCreate = {}
    local function setInputData(sender, value)
        local _name = sender:getName()
        if _name == "input_file_name" then
            self.m_tempCreate.mapName = value
        else
            local _tonumber = tonumber(value)
            if not _tonumber then
                Notice("必须是数字")
                return
            end
            if _name == "input_tile_x" then
                self.m_tempCreate.tileX = value
            elseif _name == "input_tile_y" then
                self.m_tempCreate.tileY = value
            elseif _name == "input_tile_size_w" then
                self.m_tempCreate.tileSizeW = value
            elseif _name == "input_tile_size_h" then
                self.m_tempCreate.tileSizeH = value
            elseif _name == "input_map_id" then
                self.m_tempCreate.mapID = value
            end
        end
    end

    local function textFieldEvent(sender, eventType)
        local _vlaue = sender:getString()
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            setInputData(sender, _vlaue)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            setInputData(sender, _vlaue)
        end
    end

    local input_file_name   = FindNodeByName(self.m_pRootForm, "input_file_name")
    local input_tile_x      = FindNodeByName(self.m_pRootForm, "input_tile_x")
    local input_tile_y      = FindNodeByName(self.m_pRootForm, "input_tile_y")
    local input_tile_size_w = FindNodeByName(self.m_pRootForm, "input_tile_size_w")
    local input_tile_size_h = FindNodeByName(self.m_pRootForm, "input_tile_size_h")
    local input_map_id      = FindNodeByName(self.m_pRootForm, "input_map_id")

    if input_file_name then
        input_file_name:setString(MAP_NAME_PREFIX..os.time())
        input_file_name:addEventListener(textFieldEvent)
    end
    
    if input_tile_x then
        input_tile_x:setString(DEFAULT_WIDTH)
        input_tile_x:addEventListener(textFieldEvent)
    end

    if input_tile_y then
        input_tile_y:setString(DEFAULT_HEIGHT)
        input_tile_y:addEventListener(textFieldEvent)
    end
    
    if input_tile_size_w then
        input_tile_size_w:setString(DEFAULT_TILE_WIDTH)
        input_tile_size_w:addEventListener(textFieldEvent)
    end
    
    if input_tile_size_h then
        input_tile_size_h:setString(DEFAULT_TILE_HEIGHT)
        input_tile_size_h:addEventListener(textFieldEvent)
    end  

    if input_map_id then
        input_map_id:setString(os.time())
        input_map_id:addEventListener(textFieldEvent)
    end
end

function CUIEditorMain:OnClickCreateNewMapBtn(sender, args)
    self:ShowCreateTips(false)
end

function CUIEditorMain:OnClickCreateNewMapCancelBtn(sender, args)
    self:ShowCreateTips(false)
end

function CUIEditorMain:SetTileSize(tileSize)
    self.m_tileSize = tileSize
    self.m_mapData.tileWidth  = tileSize.width
    self.m_mapData.tileHeight = tileSize.height
end

function CUIEditorMain:GetTileSize()
   return self.m_tileSize
end

function CUIEditorMain:SetMapTotalTile(size)
    self.m_mapSize = size
    self.m_mapData.width  = size.width
    self.m_mapData.height = size.height
end

function CUIEditorMain:SetBackroundID(id)
    self.m_mapData.bgID = id or 0 
end

function CUIEditorMain:GetBackroundID()
   return self.m_mapData.bgID 
end

function CUIEditorMain:GetMapTotalTile()
    return self.m_mapSize
end

function CUIEditorMain:GetMapSize()
    local _tileWidth = self:GetTileSize().width
    local _tileHeight = self:GetTileSize().height
    local _xCount = self:GetMapTotalTile().width
    local _yCount = self:GetMapTotalTile().height
    local _mapSizeW = _tileHeight * _xCount
    local _mapSizeH = _tileHeight * _yCount
    return cc.size(_mapSizeW, _mapSizeH)
end

function CUIEditorMain:ShowBGImage(pathList)
    local _listViewBG = FindNodeByName(self.m_pRootForm, "listview_bg")
    if _listViewBG then
        table.sort(pathList, function(a, b)
            return a[MAP_CONFIG_DATA_INDEX.q_id] < b[MAP_CONFIG_DATA_INDEX.q_id]
        end)
        for i, v in ipairs(pathList) do
            local _name = v[MAP_CONFIG_DATA_INDEX.q_monster_name]
            local _id = v[MAP_CONFIG_DATA_INDEX.q_id]
            local _path = v[MAP_CONFIG_DATA_INDEX.q_picture_id]
            local _widget = self:CreateImageItem(_id, _name, _path, "bg")
            if _widget then
                _listViewBG:pushBackCustomItem(_widget)
                _listViewBG:jumpToTop()
            else
                log_error(LOG_FILE_NAME, "元素物件列表，添加物件失败")
            end
        end
    end
end

function CUIEditorMain:ShowElementIamge(pathList)
    local _rt = FindNodeByName(self.m_pRootForm, "ahr_rt")
    self.m_tabSubElListVew = {}
    for type, datas in pairs(pathList) do
        local listView = ccui.ListView:create()
        self.m_tabSubElListVew[type] = listView
        listView:addTo(_rt)
        listView:setDirection(ccui.ScrollViewDir.vertical)
        listView:setBounceEnabled(true)
        listView:setAnchorPoint(cc.p(0, 1))
        listView:hide()
        table.sort(datas, function(a, b)
            return a[MAP_CONFIG_DATA_INDEX.q_id] < b[MAP_CONFIG_DATA_INDEX.q_id]
        end)
        for k, v in ipairs(datas) do
            local _name = v[MAP_CONFIG_DATA_INDEX.q_monster_name]
            local _id = v[MAP_CONFIG_DATA_INDEX.q_id]
            local _path = v[MAP_CONFIG_DATA_INDEX.q_picture_id]
            local _widget = self:CreateImageItem(_id, _name, _path, "el")
            listView:pushBackCustomItem(_widget)
            listView:jumpToTop()
        end
        listView:setContentSize(cc.size(320, 550))
        listView:setInnerContainerSize(cc.size(320, 550))
        listView:setPosition(cc.p(-398, -45))
    end
end

function CUIEditorMain:AddElementOnMap(pos, args)
    if args then
        -- 修正位置
        local _tile, _pos = self:FixElementTile(pos)
        self:AddElementOnMapByTile(_pos, _tile, args)
    end
end

function CUIEditorMain:AddElementOnMapByTile(pos, tile, args)
    if args then
        if self.m_mapData.tiles[tile.width] and self.m_mapData.tiles[tile.width][tile.height] then 
            if self.m_mapData.tiles[tile.width][tile.height].sprite then
                self.m_mapData.tiles[tile.width][tile.height].sprite:removeFromParent()
            end

            if self.m_mapData.tiles[tile.width][tile.height].shadow then
                self.m_mapData.tiles[tile.width][tile.height].shadow:removeFromParent()
            end

            local _sprite, shadowSprite = self:AddElementSpriteOnMap(pos, tile, args.id)
            self.m_mapData.tiles[tile.width][tile.height].sprite = _sprite
            self.m_mapData.tiles[tile.width][tile.height].shadow = shadowSprite
            self.m_mapData.tiles[tile.width][tile.height].id     = args.id or 1
            self.m_mapData.tiles[tile.width][tile.height].name   = args.name or "unknown"
            self.m_mapData.tiles[tile.width][tile.height].tileX  = tile.width
            self.m_mapData.tiles[tile.width][tile.height].tileY  = tile.height
        else
            print("没有此地块")
        end
    end
end

function CUIEditorMain:AddElementSpriteOnMap(pos, tile, id)
    if pos and id and tile then
        local _name = MAP_CONFIG_DATA.GetTempData(id, "q_picture_id")
        local _sprite = self:CreateImage(_name)
        if _sprite then
            local _maxTileH = self:GetMapTotalTile().height
            local _zOrder = _maxTileH - tile.height + 3
            _sprite:setLocalZOrder(_zOrder)
            _sprite:addTo(self.m_mapBaseLayer)
            _sprite:setPosition(pos)
            _sprite:setAnchorPoint(cc.p(0, 0))
        end

        local _shadow = self:AddElementShadow(pos, id)
        return _sprite, _shadow
    end
end

function CUIEditorMain:AddElementShadow(pos, id)
    local _shadowPath = MAP_CONFIG_DATA.GetTempData(id, "q_shadow_id")
    print("影子路径", _shadowPath)
    local _shadowTexture = display.getImage(_shadowPath)
    if not _shadowTexture then
        _shadowTexture = display.loadImage(_shadowPath)
    end
    if _shadowTexture then
        local _shadowSprite = display.newSprite(_shadowTexture)
         -- 影子锚点和偏移值
         local _strOffset = MAP_CONFIG_DATA.GetTempData(id, "q_shadow_offset")
         _strOffset = StrSplit(_strOffset, "|")
         local _anchor = StrSplit(_strOffset[1] or "0_0", "_")
         _anchor = TableValueToNumber(_anchor)
         local _offest = StrSplit(_strOffset[2] or "10_-10", "_")
         _offest = TableValueToNumber(_offest)
        _shadowSprite:setAnchorPoint(cc.p(_anchor[1], _anchor[2]))
        _shadowSprite:setLocalZOrder(2)
        local _posX = pos.x + _offest[1]
        local _posY = pos.y + _offest[2]
        _shadowSprite:setPosition(_posX, _posY)
        self.m_mapBaseLayer:addChild(_shadowSprite)
        return _shadowSprite
    else
        log_error(LOG_FILE_NAME, "影子没找到")
    end
end

function CUIEditorMain:CalcTileOnMapPos(tile)
    local _tileSizeW = self:GetTileSize().width
    local _tileSizeH = self:GetTileSize().height
    local _posX = (tile.width - 1) * _tileSizeW
    local _posY = (tile.height - 1) * _tileSizeW
    return cc.p(_posX, _posY)
end

function CUIEditorMain:CalcTile(pos)
    local _tileSizeW = self:GetTileSize().width
    local _tileSizeH = self:GetTileSize().height
    local _tileX = MathCeil(pos.x / _tileSizeW)
    local _tileY = MathCeil(pos.y / _tileSizeH)
    return cc.p(_tileX, _tileY)
end

function CUIEditorMain:RemoveAllElement()
    if self.m_mapData then
        for w,v in pairs(self.m_mapData.tiles or {}) do
            for h, data in pairs(v) do
                if data.sprite then
                    data.sprite:removeFromParent()
                    data.sprite = false
                end
                if data.shadow then
                    data.shadow:removeFromParent()
                end
            end
        end
    end
end

function CUIEditorMain:RemoveElmentOnMap(pos)
    local _tile, _pos = self:FixElementTile(pos)
    if self.m_mapData.tiles[_tile.width] and self.m_mapData.tiles[_tile.width][_tile.height] then
        if self.m_mapData.tiles[_tile.width][_tile.height].sprite then
            self.m_mapData.tiles[_tile.width][_tile.height].sprite:removeFromParent()
            self.m_mapData.tiles[_tile.width][_tile.height].sprite = false
        end

        if self.m_mapData.tiles[_tile.width][_tile.height].shadow then
            self.m_mapData.tiles[_tile.width][_tile.height].shadow:removeFromParent()
            self.m_mapData.tiles[_tile.width][_tile.height].shadow = false
        end
        self.m_mapData.tiles[_tile.width][_tile.height].id    = -1
        self.m_mapData.tiles[_tile.width][_tile.height].name  = ''
        self.m_mapData.tiles[_tile.width][_tile.height].tileX = 0 
        self.m_mapData.tiles[_tile.width][_tile.height].tileY = 0
    end
end

function CUIEditorMain:FixElementTile(pos)
    local _tileSizeW = self:GetTileSize().width
    local _tileSizeH = self:GetTileSize().height
    local _tileX = math.ceil(pos.x / _tileSizeW)
    local _tileY = math.ceil(pos.y / _tileSizeH)
    local _posX = (_tileX - 1) * _tileSizeW
    local _posY = (_tileY - 1) * _tileSizeW
    if _posX < 0  then
        _posX = 0
    end
    if _posY < 0  then
        _posY = 0
    end
    return cc.size(_tileX, _tileY), cc.p(_posX, _posY)
end

function CUIEditorMain:CreateImageItem(id, name, path, type)
    local _widget = ccui.Widget:create()
    _widget:setContentSize(cc.size(400, 50))
    _widget:setTouchEnabled(true)
    _widget:setName(name)
    _widget:setTag(id or 1)
    local args = {imageName = path, id = id}
    if type == "bg" then
        AddButtonEvent(_widget, handler(self, self.OnClickChoiceBackground), args)
    elseif type == 'el' then
        AddButtonEvent(_widget, handler(self, self.OnClickChoiceElement), args)
    end
        
    local _item = cc.CSLoader:createNode(UI_TEMPALTE_NAME)
    _item:addTo(_widget)

    local _title_name = cc.Label:createWithTTF(""..(name or ""), ResConfig.Font, 20)
    _title_name:addTo(_widget)
    _title_name:setAnchorPoint(cc.p(0, 0))
    _title_name:setPosition(cc.p(2, 24))

    local _full_name = cc.Label:createWithTTF(""..(path or ""), ResConfig.Font, 20) 
    _full_name:addTo(_widget)
    _full_name:setAnchorPoint(cc.p(0, 0))
    _full_name:setPosition(cc.p(2, 4))
    return _widget
end

function CUIEditorMain:OnClickChoiceBackground(sender, args)
    self:DrawMapBackground(args.imageName)
    self:ShowPreviewImage(args.imageName, args.id)
    self:SetBackroundID(args.id)
end

function CUIEditorMain:OnClickChoiceElement(sender, args)
    local _name = args.imageName
    local _tag = sender:getTag()
    self:SetCurrentMouseFocusImage(_name)
    self:SetCurrentChoiceEl(_name, _tag)
    self:ShowPreviewImage(_name, args.id)
end

function CUIEditorMain:OnClickMapLayer(sender, location)
    local _location = location
    local _choiceElInfo = self:GetCurrentChoiceEl()
    if _choiceElInfo then
        self:AddElementOnMap(_location, _choiceElInfo)
    else
        log_error(LOG_FILE_NAME, "请选择一个地块元素进行操作")
    end
end

function CUIEditorMain:CreateElementByID(id)
    local imagePath = MAP_CONFIG_DATA.GetTempData(id, "q_picture_id")
    local _args = {}
    _args.id     = id
    _args.name   = imagePath
    return _args
end


function CUIEditorMain:ShowMouseFocusImage(bShow, args)
    if self.m_currentMousFocusImage then
        if bShow then
            self.m_currentMousFocusImage:show()
            self.m_currentMousFocusImage:setPosition(args.x, args.y)
        else
            self.m_currentMousFocusImage:hide()
        end
    end
end

function CUIEditorMain:SetCurrentMouseFocusImage(name)
    if self.m_currentMousFocusImage then
        self.m_currentMousFocusImage:removeFromParent()
        self.m_currentMousFocusImage = nil
    end

    if name then
        local _tex = display.getImage(name)
        if _tex then
            self.m_currentMousFocusImage = display.newSprite(_tex)
            self.m_currentMousFocusImage:setAnchorPoint(cc.p(0, 0))
            self.m_currentMousFocusImage:addTo(self.m_pRootForm)
            self.m_currentMousFocusImage:setLocalZOrder(10)
        end
    end

    if self.m_currentMousFocusImage then
        local _texRed  = display.getImage(RED_POINT)
        local _width = self.m_currentMousFocusImage:getContentSize().width
        local _height = self.m_currentMousFocusImage:getContentSize().height
        if _texRed then
            for i = 1, 4 do
                print("red frame")
                local _frameNode = display.newNode()
                local _sprite = display.newSprite(RED_POINT, nil, nil, {scale9 = true})
                _frameNode:addTo(self.m_currentMousFocusImage)
                _sprite:setOpacity(180)
                if i == 1 or i == 2 then
                    local _yPos = (i - 1) * _height
                    _sprite:setContentSize(cc.size(_width, 3))
                    _sprite:setAnchorPoint(cc.p(0, 0))
                    _sprite:setPosition(0, _yPos)
                    _sprite:addTo(_frameNode)
                else
                    local _xPos = (math.floor(i/2) - 1) * _width
                    _sprite:setContentSize(cc.size(3, _height))
                    _sprite:setAnchorPoint(cc.p(0, 0))
                    if i == 4 then
                        _xPos = _xPos - 3
                    end
                    _sprite:setPosition(_xPos, 0)

                    _sprite:addTo(_frameNode)
                end

            end
        end
    end
end

function CUIEditorMain:SetCurrentChoiceEl(name, id)
    if not name or not id then
        self.m_curChoiceEl = nil
    else
        self.m_curChoiceEl = { name = name, id = id }
    end
    
end

function CUIEditorMain:GetCurrentChoiceEl()
    return self.m_curChoiceEl
end

function CUIEditorMain:OnClickElSubBtn(sender, args)
    local _tag = sender:getTag()
    print("click tag", _tag)
    self:ShowElSubTypeConfigs(_tag)
end

function CUIEditorMain:ShowElSubTypeConfigs(type)
    --TODO:过滤配置表里面的元素子类型
    local _listView = self.m_tabSubElListVew[type]
    if self.m_lastType then
        local _lastView = self.m_tabSubElListVew[self.m_lastType]
        if _lastView then
             print("hide type", self.m_lastType)
            _lastView:hide()
        end
    end
    if _listView then
        print("show type", type)
        _listView:show()
    end
    self.m_lastType = type
end

function CUIEditorMain:ShowPreviewImage(name, id)
    local _previewImage = FindNodeByName(self.m_pRootForm, 'image_preview')
    if _previewImage then
        _previewImage:setTexture(name)
        local _imageSize = FindNodeByName(self.m_pRootForm, 'txt_png_size')
        if _imageSize then
            local _width  = _previewImage:getContentSize().width
            local _height = _previewImage:getContentSize().height
            _imageSize:setString(_width.."x".._height)
        end
    end
    
    local _txtId = FindNodeByName(self.m_pRootForm, 'txt_id')
    if _txtId then
        _txtId:setString(id or "0")
    end
end

function CUIEditorMain:ShowBgScorllView(bShow)
    local _listViewBG = FindNodeByName(self.m_pRootForm, "listview_bg")
    if _listViewBG then
        if bShow then
            _listViewBG:show()
        else
            _listViewBG:hide()
        end
    end
end

function CUIEditorMain:ShowElScorllView(bShow)
    local _listViewEL = FindNodeByName(self.m_pRootForm, "listview_el")
    self:ShowElSub(bShow)
    self:ShowElSubTypeConfigs(nil)
end

function CUIEditorMain:RemoveAllDrawBackground()
    if self.m_tMapBackGround then
        for i,v in ipairs(self.m_tMapBackGround) do
            v:removeFromParent()
        end
    end
    self.m_tMapBackGround = {}
end

function CUIEditorMain:DrawMapBackground(name)
    local _tex = display.getImage(name)
    if _tex then
        if #self.m_tMapBackGround <= 0 then
            local _tileWidth = self:GetTileSize().width
            local _tileHeight = self:GetTileSize().height
            local _xCount = self:GetMapTotalTile().width
            local _yCount = self:GetMapTotalTile().height
            local _mapSizeW = _tileHeight * _xCount
            local _mapSizeH = _tileHeight * _yCount
            local _sprite = display.newSprite(_tex)
            local _backImageSizeW = _sprite:getContentSize().width
            local _backImageSizeH = _sprite:getContentSize().height
            local _backImageXCount = math.ceil(_mapSizeW / _backImageSizeW)
            local _backImageYCount = math.ceil(_mapSizeH /_backImageSizeW)

            for i = 1, _backImageXCount do                
                for j = 1, _backImageYCount do
                    local _sprite = display.newSprite(_tex)
                    _sprite:setAnchorPoint(cc.p(0, 0))
                    self.m_mapBaseLayer:addChild(_sprite)
                    _sprite:setPosition((i - 1) * _backImageSizeW,  (j - 1) * _backImageSizeH)
                    _sprite:setLocalZOrder(0)
                    table.insert(self.m_tMapBackGround, _sprite)
                end
            end
        else
            for i,v in ipairs(self.m_tMapBackGround) do
                v:setTexture(name)
            end
        end
    end
end

function CUIEditorMain:CreateImage(name)
    local _tex = display.getImage(name)
    local _sprite = display.newSprite(_tex)
    return _sprite
end

function CUIEditorMain:ShowGrid(bShow)
    if self.m_drawNode then
        if bShow then
            self.m_drawNode:show()
        else
            self.m_drawNode:hide()
        end
    end
end

function CUIEditorMain:ClearDrawGrid()
    if self.m_drawNode then
        self.m_drawNode:removeAllChildren()
    end
end

function CUIEditorMain:DrawGrid()
    local _mapWidth = self:GetMapTotalTile().width
    local _mapHeight = self:GetMapTotalTile().height
    print("地图格子大小", _mapWidth, _mapHeight)
    local _tileSizeX = self:GetTileSize().width
    local _tileSizeY = self:GetTileSize().height
    local _mapRegionSizeW = _mapWidth * _tileSizeX
    local _mapRegionSizeH = _mapHeight * _tileSizeY
    local _wLineCount = _mapWidth + 1
    local _hLineCount = _mapHeight + 1
    if self.m_mapBaseLayer then
        if not self.m_drawNode then
            self.m_drawNode = display.newNode()
            self.m_drawNode:addTo(self.m_mapBaseLayer)
            self.m_drawNode:setLocalZOrder(1000)
        else
            self.m_drawNode:removeAllChildren()
        end

        -- 画竖线
        local _texRed  = display.getImage(RED_POINT)
        local _texGray = display.getImage(GRAY_POINT)
        for i = 1, _wLineCount do
            local _sprite = nil
            if i == 1 or i == _wLineCount then
                _sprite = display.newSprite(RED_POINT, nil, nil, {scale9 = true})
            else
                _sprite = display.newSprite(GRAY_POINT, nil, nil, {scale9 = true})
            end
            if _sprite then
                local xPos = (i - 1) * _tileSizeX
                _sprite:setContentSize(cc.size(2, _mapRegionSizeH))
                _sprite:setAnchorPoint(cc.p(0, 0))
                _sprite:setPosition(xPos, 0)
                _sprite:addTo(self.m_drawNode)
            end
        end

        -- 画横线
        for i=1, _hLineCount do
            local _sprite = nil
            if i == 1 or i == _hLineCount then
                _sprite = display.newSprite(RED_POINT, nil, nil, {scale9 = true})
            else
                _sprite = display.newSprite(GRAY_POINT, nil, nil, {scale9 = true})
            end
            if _sprite then
                local yPos = (i - 1) * _tileSizeY
                _sprite:setContentSize(cc.size(_mapRegionSizeW, 2))
                _sprite:setAnchorPoint(cc.p(0, 0))
                _sprite:setPosition(0, yPos)
                _sprite:addTo(self.m_drawNode)
            end
        end
    end
end

function CUIEditorMain:ShowElSub(bShow)
    local _listviewSubType = FindNodeByName(self.m_pRootForm, "listview_el_classify")
    if _listviewSubType then
        if bShow then
            _listviewSubType:show()
        else
            _listviewSubType:hide()
        end
    end
end

function CUIEditorMain:InitElSubTypeBtn()
    if EditorConfig.ElSubType then
        local _listviewSubType = FindNodeByName(self.m_pRootForm, "listview_el_classify")
        if _listviewSubType then
            for k, v in pairs(EditorConfig.ElSubType) do
                local _item = cc.CSLoader:createNode(UI_TEMPLATE_EL_SUB)
                if _item then
                    local _widget = ccui.Widget:create()
                    local txt_name = FindNodeByName(_item, 'txt_name')
                    if txt_name then
                        txt_name:setString(v)
                    end
                    _widget:setTouchEnabled(true)
                    _widget:setTag(k)
                    AddButtonEvent(_widget, handler(self, self.OnClickElSubBtn), args)
                    _widget:setContentSize(cc.size(_item:getContentSize().width, _item:getContentSize().height))
                    _widget:addChild(_item)
                    _listviewSubType:pushBackCustomItem(_widget)
                end
            end
            _listviewSubType:jumpToTop()
        end
    end
end

function CUIEditorMain:OnRegisterMouseEvent()
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    local mouseListenter = cc.EventListenerMouse:create()
    mouseListenter:registerScriptHandler(handler(self, self.onMouseUp), cc.Handler.EVENT_MOUSE_DOWN )
    mouseListenter:registerScriptHandler(handler(self, self.onMouseMove), cc.Handler.EVENT_MOUSE_MOVE )
    mouseListenter:registerScriptHandler(handler(self, self.onMouseDown), cc.Handler.EVENT_MOUSE_UP )
    mouseListenter:registerScriptHandler(handler(self, self.onMouseScroll), cc.Handler.EVENT_MOUSE_SCROLL )
    dispatcher:addEventListenerWithSceneGraphPriority(mouseListenter,display.getRunningScene()); 
end

function CUIEditorMain:onMouseDown(event)
    
    local _posX, _posY = event:getCursorX(), event:getCursorY()
    local _location = cc.p(_posX, _posY)
    local _moudeDownFlag = event:getMouseButton()

    -- 是否在地图区域点击
    local _rect = cc.rect(0, 0, MAP_REGION_X, MAP_REGION_Y)
    if cc.rectContainsPoint(_rect, _location) then
        local location = self.m_mapBaseLayer:convertToNodeSpace(_location)
        if _moudeDownFlag == 0 then
            local _bMove = self:GetMouseMoveFlag()    
            if not _bMove then
                self:OnClickMapLayer(sender, location)
            end
        elseif _moudeDownFlag == 1 then
            self:RemoveElmentOnMap(location)
        end
    end
end

function CUIEditorMain:onMouseUp(event)
    self:SetMouseMoveFlag(false)
end

function CUIEditorMain:onMouseMove(event)
    self:SetMouseMoveFlag(true)
    local _posX, _posY = event:getCursorX(), event:getCursorY()
    local _location = cc.p(_posX, _posY)

    -- 是否在地图区域移动
    local _rect = cc.rect(0, 0, MAP_REGION_X, MAP_REGION_Y)
    if cc.rectContainsPoint(_rect, _location) then
        local _onMapNodePos = self.m_mapBaseLayer:convertToNodeSpace(_location)
        local _tile = self:CalcTile(_onMapNodePos)
        local _convertLocatioin = self.m_pRootForm:convertToNodeSpace(_location)
        local _pos = cc.p(_convertLocatioin.x,  _convertLocatioin.y)
        self:ShowTileLabel(true, _tile, _pos)
        self:ShowMouseFocusImage(true, _pos)
    else
        self:ShowTileLabel(false)
        self:ShowMouseFocusImage(false)
    end   
end

function CUIEditorMain:onMouseScroll(event)
    local _posX, _posY = event:getCursorX(), event:getCursorY()
    local _location = cc.p(_posX, _posY)

    -- 是否在地图区域滑动鼠标滚轮
    local _rect = cc.rect(0, 0, MAP_REGION_X, MAP_REGION_Y)
    if cc.rectContainsPoint(_rect, _location) then
        if self.m_mapBaseLayer then
            local _s = self.m_mapBaseLayer:getScale()
            _s = _s +  event:getScrollY() * 0.05
            self:SetMapShowScale(_s)
        end
    end
end

function CUIEditorMain:SetMouseMoveFlag(bMove)
    self.m_bMove = bMove
end

function CUIEditorMain:GetMouseMoveFlag(bMove)
    return self.m_bMove
end

function CUIEditorMain:SetMapShowScale(sacel)
    if sacel < 0.3 then
        sacel = 0.3
    elseif sacel > 2 then
        sacel = 2
    end

    local _scorllView = FindNodeByName(self.m_pRootForm, "scroll_view_map")
    _width = self.m_mapBaseLayer:getContentSize().width * sacel
    _height = self.m_mapBaseLayer:getContentSize().height *sacel
    _scorllView:setInnerContainerSize(cc.size(_width + 200, _height + 200))
    self.m_mapBaseLayer:setScale(sacel)
    local _txt_map_scale = FindNodeByName(self.m_pRootForm, 'txt_map_scale')
    if _txt_map_scale then
        _txt_map_scale:setString("缩放比:"..math.ceil((sacel * 100)).."%")
    end
end

function CUIEditorMain:OnDestroy()
    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
    CPlistCache:GetInstance():ReleasePlist(UI_PLIST_NAME)
end