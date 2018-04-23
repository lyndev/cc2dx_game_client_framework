-- =========================================================================
-- 文 件 名: UILogin.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-05-14
-- 完成日期:  
-- 功能描述: ui主界面 
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'CUILogin.lua.log'

CUILogin = CreateClass(UIBase)

-- UI资源路径
local UI_PANEL_NAME = 'res_main/csb/ui_login.csb'
local UI_PLIST_NAME = 'ui/*'

function CUILogin:Create(msg)
    local o = {}
    setmetatable(o, CUILogin)
    o.m_pRootForm = nil
    return o
end

function CUILogin:Init(msg)    
    self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
        log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
        return
    end
    CWidgetManager:GetInstance():AddChild(self.m_pRootForm)
    self.m_pRootForm:retain()
    AdapterUIRoot(self.m_pRootForm)
    local _bg = FindNodeByName(self.m_pRootForm, "bg")
    BackGroundImg(_bg)
    self:InitButtonEvent()
    return true
end

function CUILogin:GetRoot()
    return self.m_pRootForm
end

function CUILogin:InitButtonEvent(msg)
    local btn_wechat = FindNodeByName(self:GetRoot(), "btn_wechat")
    if btn_wechat then
        AddButtonListener(btn_wechat, function(sender, eventType)
            local _accountInput = FindNodeByName(self:GetRoot(), "txt_input_account")
            local _account = _accountInput:getString()
            if _account then
                local msgReqLogin = 
                {
                    plaformId    = 1,-- 平台ID
                    serverId     = 1,-- 区服ID
                    loginType    = 2,-- 登录类型（1 = 测试；2 = 正式）
                    userName     = _account,-- refresh_data理返回的玩家用户名
                    sign         = _account,-- 登录验证串
                    fgi          = '1',-- fgi
                    time         = '1500279579',-- 登录时间
                    clientVer    = "1.0.0",-- 客户端版本号
                    device       = "pc",-- imei
                    platform_uid = _account,-- refresh_data家用户名(渠道返回).
                    zoneName     = "test",
                    client       = "pc",-- clientid(渠道返回)
                }

                SendMsgToServer(MSGID.CS_LOGIN_REQLOGIN, msgReqLogin, true)  
            else
                log_error(LOG_FILE_NAME, "帐号不能为空字符串")
            end
        end)
    end
end

function CUILogin:OnDestroy()
    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
end
    