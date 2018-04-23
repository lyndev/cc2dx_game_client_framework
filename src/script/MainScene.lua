require("app.tools.init")

local MainScene = class("MainScene", cc.Node)

-- 游戏主状态
GAME_STATE_TYPE = 
{
    UPDATE_STATE    = 1,    -- 热更新状态
    GAME_STATE      = 2,    -- 游戏状态
}

--[[
-- 函数类型: public
-- 函数功能: 游戏启动入口
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GameLaunch()
    
    -- 运行主场景
    self:RunGameScene() 

    -- 创建游戏中的核心层
    self:CreateLayers_()

    -- 开屏画面
    self:GameBeginStartShowImg()

    -- 游戏正式启动
    local function GameStart()

        local fadeOut = cc.FadeOut:create(0.5)
        local sequence = cc.Sequence:create( fadeOut, cc.CallFunc:create(function()
            if self.m_gameBeginUIRoot then
                self.m_gameBeginUIRoot:removeFromParent()
            end
        end))
        if self.m_gameBeginUIRoot then
            self.m_gameBeginUIRoot:runAction(sequence)
        end

        -- 设置游戏全局状体为:热更新状体
        self:SetAppState(GAME_STATE_TYPE.GAME_STATE)

        -- 注册android的返回弹出退出
        self:RegisterAndroidGameExit_()

        -- 初始化手机按键
        self:InitMobilePhoneKeyBack()

        -- 初始化搜索路径
        self:InitAppSearchPath()

        cc.Director:getInstance():setDisplayStats(true)
    end

    local delay = cc.DelayTime:create(1)
    local callfunc = cc.CallFunc:create(function()
        GameStart()
    end)
    local sequence = cc.Sequence:create(delay, callfunc)
    self:runAction(sequence)
end

--[[
-- 函数类型: public
-- 函数功能: 运行游戏场景
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:RunGameScene()
    local scene = display.newScene("MainScene", {physics = false})
    scene:addChild(self)
    display.runScene(scene)
end

--[[
-- 函数类型: public
-- 函数功能: 初始化搜素路径
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:InitAppSearchPath()
    cc.FileUtils:getInstance():LuaCorrectSearchPaths()
           
    local _writablePath = cc.FileUtils:getInstance():getWritablePath()
    cc.FileUtils:getInstance():LuaAddSearchPath(_writablePath .. "res/", true)
    cc.FileUtils:getInstance():LuaAddSearchPath(_writablePath .. "src/", true)

    -- apk不可修改的目录
    cc.FileUtils:getInstance():LuaAddSearchPathBothSD("res/")
    cc.FileUtils:getInstance():LuaAddSearchPathBothSD("src/")
end

--[[
-- 函数类型: public
-- 函数功能: 设置游戏的主状态
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:SetAppState(state)
    if state == GAME_STATE_TYPE.UPDATE_STATE then

        require("script.UpdateLogic")

        -- 初始化热更新逻辑
        CUpdateLogic.Init()

    elseif state == GAME_STATE_TYPE.GAME_STATE  then
        
        -- 添加资源搜索路径(pc android 通用, 详见FileUtilsEx.lua)
        require("script.config.FileSearchPath")
        for i, v in ipairs(FileSearchPath) do
            cc.FileUtils:getInstance():LuaAddSearchPathBothSD(v)
        end

        require "script.RequireFile"

        -- 初始化主逻辑
        CLuaLogic.Init()
    end
    self.m_gameState = state
end

--[[
-- 函数类型: private
-- 函数功能: 创建游戏中的图层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:CreateLayers_()

    -- 场景层
    self.m_sceneLayer = display.newNode()
    self.m_sceneLayer:addTo(self)

    -- 元素层(精灵层)
    self.m_elementLayer = display.newNode()
    self.m_elementLayer:addTo(self)

    -- UI层
    self.m_uiLayer = display.newNode()
    self.m_uiLayer:addTo(self)

    -- 公告层
    self.m_uiNoticeLayer = display.newNode()
    self.m_uiNoticeLayer:addTo(self)    

    self.m_uiTipsLayer = display.newNode()
    self.m_uiTipsLayer:addTo(self)    

    -- 新手引导层
    self.m_uiGuideLayer = display.newNode()
    self.m_uiGuideLayer:addTo(self)
end

function MainScene:GameBeginStartShowImg()

    -- self.m_gameBeginUIRoot = cc.CSLoader:createNode("ui_csb/ui_game_begin.csb")
    -- if self.m_gameBeginUIRoot then
    --     local winSize = cc.Director:getInstance():getVisibleSize()
    --     self.m_gameBeginUIRoot:addTo(self)
    --     self.m_gameBeginUIRoot:setContentSize(cc.size(winSize.width, winSize.height))
    --     ccui.Helper:doLayout(self.m_gameBeginUIRoot)

    --     local img = self.m_gameBeginUIRoot:getChildByName("img_bg")
    --     if img then
    --         local size = img:getParent():getContentSize()
    --         local point = img:getAnchorPoint();
    --         img:setContentSize(cc.size(display.width+1,display.height))
    --     end
    -- end
end

--[[
-- 函数类型: public
-- 函数功能: 获取场景层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetSceneLayer()
    return self.m_sceneLayer
end

--[[
-- 函数类型: public
-- 函数功能: 获取元素层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetElementLayer()
    return self.m_elementLayer
end

--[[
-- 函数类型: public
-- 函数功能: 获取普通UI层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetUILayer()
    return self.m_uiLayer
end

--[[
-- 函数类型: public
-- 函数功能: 获取新手引导UI层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetGuideUILayer()
    return self.m_uiGuideLayer
end

--[[
-- 函数类型: public
-- 函数功能: 获取公告UI层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetNoticeUILayer()
    return self.m_uiNoticeLayer
end

--[[
-- 函数类型: public
-- 函数功能: TipsUI层
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:GetTipsUILayer()
    return self.m_uiTipsLayer
end

--[[
-- 函数类型: private
-- 函数功能: 注册android手机的程序退出层级
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:RegisterAndroidGameExit_()
    local _layerExit = display.newLayer()

    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            if self.m_pKeyBackCallBack then
                self.m_pKeyBackCallBack()
            else
            end
        elseif keyCode == cc.KeyCode.KEY_MENU  then
            if self.m_pKeyMenuCallBack then
                if type(self.m_pKeyMenuCallBack) == "function" then
                    self.m_pKeyMenuCallBack()
                else
                    log_error(LOG_FILE_NAME, "设置手机主菜单不是一个函数！")
                end
            else
                --TODO:手机主菜单的操作处理
            end
        end
    end

    local function onKeyPressed(keyCode, event)

    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )

    local eventDispatcher = _layerExit:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, _layerExit)

    -- 加入当前场景
    _layerExit:addTo(self)

end

--[[
-- 函数类型: public
-- 函数功能: 初始化手机返回退出tips
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:InitMobilePhoneKeyBack()
    -- 热更新中退出
    self:SetAndroidKeyBackCallBack(function()
        if CLuaLogic then
            local _world = CLuaLogic.GetWorld()
            if _world then
                local _wordName = _world:GetName()
                if _wordName == "LoginWorld" then
                    self:OpenExitUI()
                else
                    OpenUI("CUIGameExitTips")
                end
            else
                self:OpenExitUI()
            end

        else
            self:OpenExitUI()
        end
    end)
end

--[[
-- 函数类型: public
-- 函数功能: 设置手机返回的回调
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:SetAndroidKeyBackCallBack(callback)
    if type(callback) == 'function' then
        self.m_pKeyBackCallBack = callback 
    else
        log_error(LOG_FILE_NAME, "设置手机返回不是一个函数！")
    end
end

--[[
-- 函数类型: public
-- 函数功能: 设置手机主菜单回调
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function MainScene:SetAndroidKeyMenuCallBack(callback)
    if type(callback) == 'function' then
        self.m_pKeyMenuCallBack = callback 
    else
        log_error(LOG_FILE_NAME, "设置手机主菜单不是一个函数！")
    end
end

local UI_FIGHT_EXIT_PROGRAM  =  'ui_csb/ui_app_exit.csb'

--[[
-- 函数类型: public
-- 函数功能: 退出TIPS
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 这里的退出UI，在热更新界面需要用到，热更新阶段大部分脚本是不可用的所以这里都是原始的cocos2d lua来写的
--]]
function MainScene:OpenExitUI()

    if ENUM and CPlayer then
        if ENUM.GameFightState.None ~= CPlayer:GetInstance():GetGameFightState() then
            print('退出无效')
            return 
        end
    end

    local winSize = cc.Director:getInstance():getVisibleSize()
    if self.m_colorLayer then
        self.m_colorLayer:removeFromParent()
    end
    self.m_colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 120)) 
    self.m_colorLayer:setContentSize(cc.size(winSize.width, winSize.height))
    local listener = cc.EventListenerTouchOneByOne:create()  
    local function onTouchBegan( touch, event)
        return true
    end
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )  
    -- 时间派发器
    local eventDispatcher = self.m_colorLayer:getEventDispatcher() 
    -- 吞没事件 
    listener:setSwallowTouches(true)
    -- 绑定触摸事件到层当中  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.m_colorLayer) 
    self.m_colorLayer:getEventDispatcher():setPriority(listener, 1)
    self.m_colorLayer:addTo(self)

    if self.m_exitUIRoot then
        self.m_exitUIRoot:removeFromParent()
    end
    self.m_exitUIRoot = cc.CSLoader:createNode(UI_FIGHT_EXIT_PROGRAM)
    self.m_exitUIRoot:addTo(self)

    -- 适配
    self.m_exitUIRoot:setContentSize(cc.size(winSize.width, winSize.height))
    ccui.Helper:doLayout(self.m_exitUIRoot)

    local _nodeRoot = self.m_exitUIRoot:getChildByName('node_root')

    local _bBtn_yes = _nodeRoot:getChildByName('btn_yes')
    
    -- 确认退出按钮
    if _bBtn_yes then
            _bBtn_yes:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                cc.Director:getInstance():endToLua()  
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    else
        print("not find btn yes")
    end

    -- 不退出
    local _bBtn_no = _nodeRoot:getChildByName('btn_no')
    if _bBtn_no then
        _bBtn_no:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                self.m_colorLayer:removeFromParent()
                self.m_exitUIRoot:removeFromParent()
                self.m_colorLayer = nil
                self.m_exitUIRoot = nil
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    else
        print("not find btn no")
    end
end

return MainScene