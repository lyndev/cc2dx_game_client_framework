-- =========================================================================
-- 文 件 名: UIMain.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-05-14
-- 完成日期:  
-- 功能描述: ui主界面 
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'CUIMain.lua.log'

CUIMain = CreateClass(UIBase)

-- UI资源路径
local UI_PANEL_NAME = 'res_main/csb/ui_main.csb'
local UI_PLIST_NAME = 'ui/*'

function CUIMain:Create(msg)
    local o = {}
    setmetatable(o, CUIMain)
    o.m_pRootForm = nil
    return o
end

function CUIMain:Init(msg)
    -- 加载plist
    --CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)
    
    self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
        log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
        return
    end
    
    -- 遮罩
    --self.m_maskLayer = AddMaskLayer()
    --self.m_maskLayer:retain()
    --CWidgetManager:GetInstance():AddChild(self.m_maskLayer)

    CWidgetManager:GetInstance():AddChild(self.m_pRootForm)
    self.m_pRootForm:retain()
    AdapterUIRoot(self.m_pRootForm)
    local _bg = FindNodeByName(self.m_pRootForm, "bg")
    BackGroundImg(_bg)

    --CMusicPlayer:GetInstance():PlayBGM("res/res_main/audio/music/main_bg.mp3", true)
    self:InitButtonEvent()
    return true
end

function CUIMain:GetRoot()
    return self.m_pRootForm
end

function CUIMain:InitButtonEvent(msg)
    local btn_create = FindNodeByName(self:GetRoot(), "btn_create")
    local btn_jion = FindNodeByName(self:GetRoot(), "btn_jion")
    if btn_create then
        AddButtonListener(btn_create, function(sender, eventType)
            self:CreateRoom()
        end)
    end
    if btn_jion then
        AddButtonListener(btn_jion, function(sender, eventType)
            OpenUI("CUIPlayerCreateRoom")
        end)
    end
end

function CUIMain:CreateRoom()
    -- 创建房间
    SendMsgToServer(150201, {roomType = 1, gameType = ENUM.GameType.TANK})
    --SendUDPMsgToServer(150201, {roomType = 1, gameType = ENUM.GameType.ZJH})
end

function CUIMain:OnDestroy()
    if self.m_maskLayer then
        self.m_maskLayer:removeFromParent()
        self.m_maskLayer:release()
        self.m_maskLayer = nil
    end

    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
    --CPlistCache:GetInstance():ReleasePlist(UI_PLIST_NAME)
end