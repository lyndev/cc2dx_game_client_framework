-- Copyright (C), 2015, 
-- 文 件 名: UpdateDownloader.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-02-06
-- 完成日期: 
-- 功能描述: 迭代热更新,下载逻辑
-- 其它相关: 使用需要把C++中的AssetsManagerEx中宏设置为：#define IS_ITERATION ITERATION_OPEN
--              以及MainScene.lua 中require这个文件。
-- 修改记录: 
--]]

UpdateDownloader = {}
UpdateDownloader.__index = UpdateDownloader
UpdateDownloader.__insstance = nil

-- 游戏的标记要和player.lua下的标记统一 1 = 已经下载，0 = 没有下载
local Game_Daer_Down_Flag    = "game_daer"
local Game_Majiang_Down_Flag = "game_Majiang"
local Game_Dezhou_Down_Flag  = "game_Dezhou"
local Game_Main_Down_Flag    = "game_main"

-- 更新类型
local GAME_MAIN  = "game_main"
local GAME_DAER  = "game_daer"
local GAME_MJ    = "game_mj"
local GAME_POKER = "game_poker"

local GAME_MAIN_MAINFEST  =  "res_main/project.manifest" --"version_main/project.manifest"
local GAME_DAER_MAINFEST  =  "res_daer/project.manifest" --"version_daer/project.manifest"
local GAME_MJ_MAINFEST    =  "res_mj/project.manifest" --"version_mj/project.manifest"
local GAME_POKER_MAINFEST =  "res_poker/project.manifest" --"version_poker/project.manifest"

-- json文件中的对象，如果增加新游戏，需要在json和这里增加类型和标记
local SERVER_JSON_TYPE = {
    ["game_main"]  = "Versions_GameMain",
    ["game_daer"]  = "Versions_GameDaer",
    ["game_mj"]    = "Versions_GameMJ",
    ["game_poker"] = "Versions_GamePoker",
}

-- 迭代版本的url读取json 106.14.36.155:1573
local VERSIONS_URL = "http:/192.168.1.155/res/newgamecardfixhot/LuzhouqipaiVersions.json"

-- 如果是zip模式更新则百分比用percent 如果是false则是散文件更新百分比用percentfile
local IS_ZIP_MODE = true

local Game_Word = 
{
	["game_main"]  = "主版本",
	["game_daer"]  = "泸州大贰",
	["game_mj"]    = "泸州鬼麻将",
	["game_poker"] = "德州扑克",
}

local Game_Local_key = 
{
	["game_main"]  = Game_Main_Down_Flag,
	["game_daer"]  = Game_Daer_Down_Flag,
	["game_mj"]    = Game_Majiang_Down_Flag,
	["game_poker"] = Game_Dezhou_Down_Flag,
}

local Game_Res_Path = {
    ["game_main"]  = "",
    ["game_daer"]  = "res_daer",
    ["game_mj"]    = "res_mj",
    ["game_poker"] = "res_poker",
}

local OperatorType = 
{
	Update = 1,
	Download = 2,
}

function AdapterUIRoot( root )
    if root then
        local winSize = cc.Director:getInstance():getVisibleSize()
        root:setContentSize(cc.size(winSize.width, winSize.height))
        ccui.Helper:doLayout(root)
    end
end

function UpdateDownloader:New(o)
    o = o or {}
    setmetatable(o, UpdateDownloader)
    o.m_assetManager            = nil
    o.m_listenerAssetsManagerEx = nil
    o.m_failCount               = 0
    o.m_needUpdateGameFlags     = {}
    o.m_curOperatorType         = OperatorType.Update
    o.m_curOperatorFlagType     = GAME_MAIN
    o.m_curUpdateTime           = 0
    o.m_updateTimes             = 0
    return o
end

function UpdateDownloader:GetInstance()
    if not UpdateDownloader.__insstance then
        UpdateDownloader.__insstance = UpdateDownloader:New()
    end
    return UpdateDownloader.__insstance
end

function UpdateDownloader:Init()
    if GAME_HOT_UPDATE then
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        self:OpenUpdateUI_()
        self:DownloadHttpServerJsonConfig(VERSIONS_URL)
    else
        self:UpdaterSuccess_()
    end
end
  
function UpdateDownloader:SerializeToStr(_t)
    local szRet = "{"  
    function doT2S(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. SerializeToStr(_v) .. ","
            elseif "boolean" == type(_v) then
                szRet = szRet ..tostring(_v)..','
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. SerializeToStr(_v) .. ","  
            elseif "boolean" == type(_v) then
                szRet = szRet ..tostring(_v)..','
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end
 
function UpdateDownloader:DeserializeFromStr(_szText)
    _szText = "return " .. _szText
    local fun = loadstring(_szText)
    if not fun then
        return nil
    end
    return fun();
end

function UpdateDownloader:SetOperatorType(type)
	self.m_curOperatorType = type or OperatorType.Update
end

function UpdateDownloader:GetOperatorType()
	return self.m_curOperatorType
end

function UpdateDownloader:SetOperatorFlagType(type)
	self.m_curOperatorFlagType = type or GAME_MAIN
end

function UpdateDownloader:GetOperatorFlagType()
	return self.m_curOperatorFlagType
end

function UpdateDownloader:DestroyAssetManager()
    if self.m_assetManager then       
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_listenerAssetsManagerEx)
        self.m_assetManager:release()
        self.m_listenerAssetsManagerEx = nil
        self.m_assetManager = nil
        self.m_failCount = 0
    end
end

function UpdateDownloader:SetAlreadyDownloadVersion(versionType, version)
    local _key = versionType.."_down_version_lua"
    local _oldV = self:GetAlreadyDownloadVersion(versionType)
    table.insert(_oldV, version)
    _oldV = self:SerializeToStr(_oldV)
    cc.UserDefault:getInstance():setStringForKey(_key, _oldV)
    cc.UserDefault:getInstance():flush() 
end

function UpdateDownloader:GetAlreadyDownloadVersion(versionType)
    local _key = versionType.."_down_version_lua"
    local _v = cc.UserDefault:getInstance():getStringForKey(_key)
    if _v and type(_v) == "string" then
        return self:DeserializeFromStr(_v) or {}
    else
        return {}
    end
end

function UpdateDownloader:IsDownloadVersion(versionType, version)
    print("IsDownloadVersion",version)
    local _allDownloadVersion = self:GetAlreadyDownloadVersion(versionType)
    for i,v in ipairs(_allDownloadVersion) do
        if version == v then
            print(version .. " IsDownloadVersion ! ")
            return true
        end
    end
    return false
end

function UpdateDownloader:IsDownloadAllServerVersion(versionType, alreadyDownloadTimes)
    local _jsonVersionType = SERVER_JSON_TYPE[versionType]
    local _serverConfigTables = self:GetHttpServerAllVersiosList()
    if not _serverConfigTables then
        print("[IsDownloadAllServerVersion error]  _serverConfigTables is nil")
        return
    end
    local _totalTimes = #(_serverConfigTables[_jsonVersionType] or {})
    if alreadyDownloadTimes >= _totalTimes then
        return true
    else
        return false
    end
end

function UpdateDownloader:GetHttpServerNotDownloadVersionsByVersionType(versionType)
    local _jsonVersionType = SERVER_JSON_TYPE[versionType]
    local _serverConfigTables = self:GetHttpServerAllVersiosList()
    if not _serverConfigTables then
        print("[IsDownloadAllServerVersion error]  _serverConfigTables is nil")
        return {}
    end
    local _someTypeAllVersions = (_serverConfigTables[_jsonVersionType] or {})
    local _tempSomeTypeAllVersions = {}
    for i,v in ipairs(_someTypeAllVersions) do
        local _isDownload = self:IsDownloadVersion(versionType, v.version)
        if not _isDownload then
            table.insert(_tempSomeTypeAllVersions, v)
        end
    end
    dump(_tempSomeTypeAllVersions,"versionType versions")
    return _tempSomeTypeAllVersions
end

function UpdateDownloader:DownloadHttpServerJsonConfig(url)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    print("url:", url)
    xhr:open("POST", url)
    local function onReadyStateChange()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response   = xhr.response
            local versionTable = json.decode(response, 1)
            self:OnHttpServerJsonConfigDownload(versionTable)
        else
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        end
    end

    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()
end

function UpdateDownloader:OnHttpServerJsonConfigDownload(versionTable)
    self.m_versionsList = versionTable
    -- 开始更新
    self:StartIterationCheckUpdate()
end

function UpdateDownloader:GetHttpServerAllVersiosList()
    return self.m_versionsList
end

function UpdateDownloader:StartIterationCheckUpdate()
	-- 主版本更新
    local _versionsGameMain = self:GetHttpServerNotDownloadVersionsByVersionType(GAME_MAIN)
    if #_versionsGameMain > 0 then
	   table.insert(self.m_needUpdateGameFlags, {type = GAME_MAIN, versions = _versionsGameMain})
    end

	-- 次级游戏检查更新
	local _game_daer_flag = cc.UserDefault:getInstance():getIntegerForKey(Game_Daer_Down_Flag)
	local _game_mj_flag = cc.UserDefault:getInstance():getIntegerForKey(Game_Majiang_Down_Flag)
	local _game_poker_flag = cc.UserDefault:getInstance():getIntegerForKey(Game_Dezhou_Down_Flag)

	if _game_daer_flag == 1 then
        local _versionsGameDaer = self:GetHttpServerNotDownloadVersionsByVersionType(GAME_DAER)
        if #_versionsGameDaer > 0 then
		    table.insert(self.m_needUpdateGameFlags, {type = GAME_DAER, versions = _versionsGameDaer})
        end
	end
	if _game_mj_flag == 1 then
        local _versionsGameMJ = self:GetHttpServerNotDownloadVersionsByVersionType(GAME_MJ)
        if #_versionsGameMJ > 0 then
		    table.insert(self.m_needUpdateGameFlags, {type = GAME_MJ, versions = _versionsGameMJ})
        end
	end
	if _game_poker_flag == 1  then
        local _versionsGamePoker = self:GetHttpServerNotDownloadVersionsByVersionType(GAME_POKER)
        if #_versionsGamePoker > 0 then
		    table.insert(self.m_needUpdateGameFlags, {type = GAME_POKER, versions = _versionsGamePoker})
        end
	end
	
    if #self.m_needUpdateGameFlags == 0 then
        self:GameStart()
        return
    else
        self.m_updateTimes = #self.m_needUpdateGameFlags
        self.m_curUpdateTime = 1
        self:StartIterationUpdate()
    end
end

function UpdateDownloader:StartIterationUpdate()
    local _startUpdateInfo = self.m_needUpdateGameFlags[self.m_curUpdateTime]
    if _startUpdateInfo then
        print("StartIterationUpdate type: url:",_startUpdateInfo.type, _startUpdateInfo.versions[1].url)
        -- 这里每次取1的下标的原因是每次更新了一个版本后会移除，所以每次都从1开始取
        self:Updater(_startUpdateInfo.type, _startUpdateInfo.versions[1].url)
    else
        print("[ StartIterationCheckUpdate error] _startUpdateInfo is nil")
    end
end

-- 更新器
function UpdateDownloader:Updater(versionType, remoteURL)
    if GAME_HOT_UPDATE then
    	self:SetOperatorFlagType(versionType)
    	self:SetOperatorType(OperatorType.Update)
    	local _main_fests_file = self:GetMainfestByVerionType(versionType)
    	self:Start(_main_fests_file, versionType, remoteURL)
    else
        print("UpdateDownloader warning: not set GAME_HOT_UPDATE is true, current can't download something")
    end
end

-- 下载器(增加了循环下载多版本)
function UpdateDownloader:Downloader(versionType, callback)
    if GAME_HOT_UPDATE then
        self.m_downloadFinishCallback = callback
    	self:OpenDownloadUI_()
    	self:SetOperatorFlagType(versionType)
    	self:SetOperatorType(OperatorType.Download)
        local _jsonTagString = SERVER_JSON_TYPE[versionType]
        self.m_needDownloadGameVersions = self.m_versionsList[_jsonTagString]
        self:StartIterationDownload()
    else
        print("UpdateDownloader warning: not set GAME_HOT_UPDATE is true, current can't update something")
    end
end

function UpdateDownloader:StartIterationDownload()
    local versionType = self:GetOperatorFlagType()
    local _main_fests_file = self:GetMainfestByVerionType(versionType)
    local remoteURL = self.m_needDownloadGameVersions[1].url
    print("[UpdateDownloader:Downloader ]download begin", versionType, _main_fests_file, remoteURL)
    self:Start(_main_fests_file, versionType, remoteURL)
end

function UpdateDownloader:GetMainfestByVerionType(versionType)
	local _main_fests_file = GAME_MAIN_MAINFEST
	if versionType == "game_main" then
		_main_fests_file = GAME_MAIN_MAINFEST
	elseif versionType == "game_mj" then
		_main_fests_file = GAME_MJ_MAINFEST
	elseif versionType == "game_daer" then
		_main_fests_file = GAME_DAER_MAINFEST
	elseif versionType == "game_poker" then
		_main_fests_file = GAME_POKER_MAINFEST
	end
	return _main_fests_file
end

function UpdateDownloader:Start(main_fests_file, versionType, remoteURL)
	assert(main_fests_file)
    assert(versionType)
    assert(remoteURL)
    self:DestroyAssetManager()

    local MAIN_FESTS_FILE = main_fests_file
    MAIN_FESTS_FILE = main_fests_file.."+"..remoteURL
    local DOWN_LOAD_PATH = cc.FileUtils:getInstance():getWritablePath()
    if versionType == GAME_MAIN then 
        DOWN_LOAD_PATH = DOWN_LOAD_PATH .. Game_Res_Path[versionType]
    else
        DOWN_LOAD_PATH = DOWN_LOAD_PATH ..'res/'--..Game_Res_Path[versionType]
    end

    self.m_assetManager = cc.AssetsManagerEx:create(MAIN_FESTS_FILE, DOWN_LOAD_PATH)
    self.m_assetManager:retain()

    print("begin res update path : game type: MAIN_FESTS_FILE:", DOWN_LOAD_PATH, versionType, MAIN_FESTS_FILE)

    if not self.m_assetManager:getLocalManifest():isLoaded() then
        print("AssetsManager:getLocalManifest Error, path:", main_fests_file)
    else
        self.m_listenerAssetsManagerEx = cc.EventListenerAssetsManagerEx:create(self.m_assetManager,  function(event)
            if event then
                self:OnUpdateEvent_(event)
            else
                print("event is nil")
            end
        end)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.m_listenerAssetsManagerEx, 1)
        self.m_assetManager:update()
    end
end

-- 背景缩放
function BackGroundImg(img)
    if img then
        local size = img:getParent():getContentSize()
        local point = img:getAnchorPoint()
        img:setAnchorPoint(cc.p(0, 0))
        img:setContentSize(cc.size(display.width+1,display.height))
        if point.x == 0 and point.y == 0 then
            img:setPosition(0, 0)
        end
    end
end

function UpdateDownloader:OpenUpdateUI_()

    -- 打开更新资源UI
    if not self.m_pUpdateUI then   
        self.m_pUpdateUI = cc.CSLoader:createNode("res_main/update/ui_update_loading.csb")
        local _updateUI = self.m_pUpdateUI
        if _updateUI then
            _updateUI:addTo(GameScene)
            AdapterUIRoot(_updateUI)
            -- 背景适配
            local _bgImg = _updateUI:getChildByName("login_bg_1")
            BackGroundImg(_bgImg)

            local _cbNode = _updateUI:getChildByName("c_b")

            -- 显示更新百分比
            self.m_textPercent = _cbNode:getChildByName("text_loading_progress")
            -- 更新进度条
            self.m_barPercent = _cbNode:getChildByName("loading_bar")
            -- 更新提示
            self.m_textNotice = _cbNode:getChildByName("text_notice")
            -- APK更新提示
            self.m_nodeNotice = _cbNode:getChildByName("node_apk_notice")
            -- 资源版本号
            self.m_curTestEngineVersion = _cbNode:getChildByName("text_engine_version")
            self.m_curTextResVersion = _cbNode:getChildByName("text_res_version")
            self.m_curTextTargetVersion = _cbNode:getChildByName("text_target_res_version")
            self.m_textNotice:setString("正在努力【"..(Game_Word[self:GetOperatorFlagType()] or '').."】更新补丁...")   
            self.m_retryNode = _updateUI:getChildByName("node_retry_notice")
        end
    end
end

function UpdateDownloader:OpenDownloadUI_()
	if not self.m_pDownloadUI then   
        self.m_pDownloadUI = cc.CSLoader:createNode("res_main/update/ui_download.csb")
        if self.m_pDownloadUI then
            self.m_mask = AddBlackMaskLayer()
            if CWidgetManager then
                CWidgetManager:GetInstance():AddChild(self.m_mask, ENUM.LAYE_TYPE.UITips)
                CWidgetManager:GetInstance():AddChild(self.m_pDownloadUI, ENUM.LAYE_TYPE.UITips)
                AdapterUIRoot(self.m_pDownloadUI)
            else
                self.m_mask:addTo(GameScene)
                self.m_pDownloadUI:addTo(GameScene)    
                AdapterUIRoot(self.m_pDownloadUI)
            end
            
            local _cbNode = self.m_pDownloadUI:getChildByName("anchor_c_c") 
            -- 显示更新百分比
            self.m_textPercent = _cbNode:getChildByName("text_loading_progress")
            -- 更新进度条
            self.m_barPercent = _cbNode:getChildByName("loading_bar")
            self.m_textNotice = _cbNode:getChildByName("text_notice")
            self.m_retryNode = self.m_pDownloadUI:getChildByName("node_retry_notice")
            if not self.m_retryNode then
                print("error OpenDownloadUI_ not find the self.m_retryNode")
            end
        end
    end
end

function UpdateDownloader:ShowRetryButton(bShow)
    if self.m_retryNode then
        if bShow then
            print("show", bShow)
            self.m_retryNode:show()
            local _retryBtn = self.m_retryNode:getChildByName("btn_retry")
            if _retryBtn then
                _retryBtn:addTouchEventListener(function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        local _curUpdateType = self:GetOperatorType()
                        if _curUpdateType == OperatorType.Update then
                            self:StartIterationCheckUpdate()
                        elseif _curUpdateType == OperatorType.Download then
                            local _callback = self.m_downloadFinishCallback
                            local _versionType = self:GetOperatorFlagType()
                            self:Downloader(_versionType, _versionType)    
                        end
                    end
                end)
            end
        else
            print("hide", bShow)
            self.m_retryNode:hide()
        end
    else
        print("error ShowRetryButton not find the self.m_retryNode on download ui ")
    end
end

function UpdateDownloader:CloseUpdateUI()
    if self.m_pUpdateUI and not tolua.isnull(self.m_pUpdateUI) then
        self.m_pUpdateUI:removeFromParent()
        print("destroy update ui")
    end
    self.m_textPercent = nil
    self.m_barPercent = nil
    self.m_textNotice = nil
    self.m_nodeNotice = nil
    self.m_curTestEngineVersion = nil
    self.m_curTextResVersion = nil
    self.m_curTextTargetVersion = nil
end

function UpdateDownloader:CloseDownloadUI()
    if self.m_mask and not tolua.isnull(self.m_mask) then
        self.m_mask:removeFromParent()
    end
    self.m_mask = nil

    if self.m_pDownloadUI and not tolua.isnull(self.m_pDownloadUI)  then
        self.m_pDownloadUI:removeFromParent()
        print("destroy download ui")
    end
    self.m_pDownloadUI = nil
    self.m_textPercent = nil
    self.m_barPercent = nil
end

function UpdateDownloader:SetCurResVersion(curVersion)
    if self.m_curTextResVersion then
        self.m_curTextResVersion:setString('当前资源版本号:'..curVersion)
    end
    print("curVersion:", curVersion)
end

function UpdateDownloader:SetTargetResVersion(tarVersion)
    if self.m_curTextTargetVersion then
        self.m_curTextTargetVersion:setString('最新资源版本号:'..tarVersion)
    end
    print("tarVersion:", tarVersion)    
end

function UpdateDownloader:SetUpdatePercent(percent)
    if self.m_textPercent then
        self.m_textPercent:setString(math.ceil(percent).."%")
    end

    if self.m_barPercent then
        self.m_barPercent:setPercent(math.ceil(percent))
    end
end

function UpdateDownloader:OnUpdateEvent_(event)
    local eventCode = event:getEventCode()

    if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
        print("[AssetsManager Error]: No local manifest file found")
        self:SetNoticeShow("配置文件错误，请清空缓存数据重新下载。")
        self:ShowRetryButton(true)
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST then
        print("[AssetsManager Error]: download manifest file fail")
        self:SetNoticeShow("配置文件更新失败!")
        self:ShowRetryButton(true)
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
        print("[AssetsManager Error]: parse manifest file fail")
       	self:SetNoticeShow("配置文件更新失败!")
        self:ShowRetryButton(true)
       
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_MUST_UPDATE_APP then
        print("[AssetsManager Error]: must update app")

        if self.m_nodeNotice then
            self.m_nodeNotice:show()
            local _btnEndGame = self.m_nodeNotice:getChildByName("btn_end_game")
            if _btnEndGame then
                _btnEndGame:addTouchEventListener(function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        cc.Director:getInstance():endToLua()
                        --TODO:前往下载地址
                        self:SetNoticeShow("App需要重新下载,请前往官网下载最新的版本。")
                    end
                end)
            end
        end
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND then
        self:ShowRetryButton(false)
        -- 获取远程更新配置
        local _remoteManifet = self.m_assetManager:getRemoteManifest()
        
        -- 获取本地更新配置
        local _localManifet = self.m_assetManager:getLocalManifest()

        -- 设置引擎版本号信息
            --TODO:

        -- 设置当前资源版本号信息
        self:SetCurResVersion(_localManifet:getVersion() or '0')

        -- 设置目标资源版本号信息
        self:SetTargetResVersion(_remoteManifet:getVersion())

        self:SetNoticeShow("正在努力更新【"..(Game_Word[self:GetOperatorFlagType()] or '').."】补丁,请稍等。")

        print("[AssetsManager Info]: found new version")
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
        self:ShowRetryButton(false)
        local assetId = event:getAssetId()
        local percent = event:getPercent()
        local percentByFile = event:getPercentByFile()     

        if assetId == cc.AssetsManagerExStatic.VERSION_ID then
            print( string.format("update progression: Version file, percent = %d%%, percentByFile = %d%%", percent, percentByFile) )
        elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
            print( string.format("update progression: Manifest file, percent = %d%%, percentByFile = %d%%", percent, percentByFile) )
        else
            local _percent = percent
            if not IS_ZIP_MODE then
                _percent = percentByFile            
            end
            self:SetUpdatePercent(_percent)
            print( string.format("update progression: AssetId = %s, percent = %d%%, percentByFile = %d%%", assetId, percent, percentByFile) )
        end
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ASSET_UPDATED then
        print("[AssetsManager Info]: Asset updated")
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
        print("[AssetsManager Error]: error updating, AssetId = " .. event:getAssetId() .. ", Message = " .. event:getMessage())
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED then
        self.m_failCount = self.m_failCount + 1
        if (self.m_failCount < 5) then
            self.m_assetManager:downloadFailedAssets()
            self:ShowRetryButton(true)
         else
            print("[AssetsManager Error]: UPDATE_FAILED !!! some file is not find or res server mainfest error")
            self:ShowRetryButton(true)
             self.m_failCount = 0
         end
    
    elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DECOMPRESS then
        print("[AssetsManager Error]: error decompress, Message = " .. event:getMessage())
    
    elseif (eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE) or
            (eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED) then
        print("[AssetsManager Info]: updated finished")

        -- 获取本地更新配置
        local _localManifet = self.m_assetManager:getLocalManifest()

        -- 设置当前资源版本号信息
        self:SetTargetResVersion(_localManifet:getVersion() or '0')

 		self:DestroyAssetManager()

 		local _operatorType = self:GetOperatorType()
 		if _operatorType == OperatorType.Update then
            performWithDelay(GameScene, function()
                self:UpdaterSuccess_()
            end, 1)
        elseif _operatorType == OperatorType.Download then
        	self:DownloaderSuccess_()
        end
    end
end

function UpdateDownloader:SetNoticeShow(str)
    if self.m_textNotice then
        self.m_textNotice:setString(str or '')
    end
end

function UpdateDownloader:UpdaterSuccess_()
   
	local _info = self.m_needUpdateGameFlags[self.m_curUpdateTime]
	if _info then
        self:SetAlreadyDownloadVersion(_info.type, _info.versions[1].version)
        table.remove(_info.versions, 1)
        local _versionsCount = #(_info.versions or {})
        if _versionsCount == 0 then
            self.m_curUpdateTime = self.m_curUpdateTime + 1
        end
	end
	
    if self.m_curUpdateTime > self.m_updateTimes then
        print("UpdateDownloader info: all game version update finish.")
        self:GameStart()
    else
        self:StartIterationUpdate()
    end
end

function UpdateDownloader:DownloaderSuccess_()
    
    self:SetAlreadyDownloadVersion(self:GetOperatorFlagType(), self.m_needDownloadGameVersions[1].version)
    table.remove(self.m_needDownloadGameVersions, 1)    
    if #self.m_needDownloadGameVersions == 0 then
        print("UpdateDownloader info: all game version donwload finish.")
        self:CloseDownloadUI()

        -- 写入已下载标记
        local _key = self:GetOperatorFlagType()
        cc.UserDefault:getInstance():setIntegerForKey(Game_Local_key[_key], 1)

        -- TODO:发射一个下载完成事件，参数带游戏类型
        print("download one game success!")

        -- 回调
        if self.m_downloadFinishCallback and type(self.m_downloadFinishCallback) == "function" then
            self.m_downloadFinishCallback()
        else
            print("self.m_downloadFinishCallback is error", self.m_downloadFinishCallback)
        end
        self.m_needDownloadGameFlags = {}
    else
        self:StartIterationDownload()
    end
end

function performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local callfunc = cc.CallFunc:create(callback)
    local sequence = cc.Sequence:create(delay, callfunc)
    node:runAction(sequence)
    return sequence
end

function UpdateDownloader:GameStart()
	if GameScene then
    	print("UpdateDownloader: all game version update finish.")
        performWithDelay(GameScene, function()
            self:CloseUpdateUI()
            GameScene:SetAppState(GAME_STATE_TYPE.GAME_STATE)
        end, 0.2)
    end
end