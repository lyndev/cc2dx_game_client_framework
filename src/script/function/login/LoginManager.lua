-- =========================================================================
-- 文 件 名: LoginManager.lua
-- 作    者: lyn
-- 创建日期: 2017-05-03
-- 功能描述: 登录管理器
-- 其它相关:  
-- 修改记录: 
-- =========================================================================  

-- 日志文件名
local LOG_FILE_NAME = 'LoginManager.log'

LoginManager = {} 
LoginManager.__index = LoginManager
 
--登录失败原因枚举
local ELoginFailedReason = 
{
    EACCOUNTCHECKFAILED = 1,   -- 账号验证未通过
    EDONTHAVEROLE       = 2,   -- 没有角色
    NEED_ACTIVE_CODE    = 3,   -- 需要激活码
    APP_VERSION_ERROR   = 4,   -- 客户端版本错误
}

LoginManager.LoginType = 
{
    Tourist     = 0,    --游客登录
    WeChat      = 1,    --微信登录
}

ConnectProxy = false

--[[
-- 函数功能: 创建登录逻辑
-- 参    数: 需要增加的变量以及函数table
-- 返 回 值: 登录逻辑对象
-- 备    注: 无
--]]
function LoginManager:New(o)
    o = o or {}
    setmetatable(o, LoginManager)
    o.m_LoginUI         = nil                  -- 登录UI
    o.m_bIsRegister     = false                -- 是否是注册界面进入
    o.m_loginInfo        = {}                   -- 储存一些数据的表
    o.m_bIsCreateUser   = false                -- 是否是创建玩家
    o.m_reconnectToken = nil
    return o
end

function LoginManager:GetInstance()
    if not LoginManager._instance then
        LoginManager._instance = self:New()
    end
    return  LoginManager._instance
end

-- 函数功能: 登录逻辑初始化
function LoginManager:Init()

    -- 连接服务器成功
    CMsgRegister:AddMsgListenerHandler(MSGID.CC_CONNECT_SUCCESS, function(msgData)
        self:OnConnectSuccessHandler(msgData)
    end, "LoginManager")

    -- 代理回复登录消息
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_AGENT_RESLOGINTOCLIENT, function(msgData)
        self:OnProxyLoginSuccessHandler(msgData)
    end, "LoginManager")

    -- 连接服务器失败
    CMsgRegister:AddMsgListenerHandler(MSGID.CC_CONNECT_FAILED, function(msgData)
        self:OnConnectFailHandler(msgData)
    end, "LoginManager")

    -- 服务器连接断开
    CMsgRegister:AddMsgListenerHandler(MSGID.CC_CONNECT_BREAK, function(msgData)
        self:OnConnectBreakHandler(msgData)
    end, "LoginManager")

    -- 服务器主动关闭连接消息
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_LOGIN_RESCLOSESOCKET, function(msgData)
        self:OnServerConnectBreakHandler(msgData)
    end, "LoginManager")

    -- 角色登录成功
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_LOGIN_RESLOGINSUCCESS, function(msgData)
        self:OnPlayerLoginSuccess(msgData)
    end, "LoginManager")

    OpenUI("CUILogin")

end

function LoginManager:Update(dt)
    if self.m_fight then
        self.m_fight:Update(dt)
    end
end

function LoginManager:OnConnectSuccessHandler(msgData)
    NetManager:GetInstance():ConnectSuccess()
    if ConnectProxy then        
        print("=====================================================")     
        print("\t\t连接代理服务器成功")     
        print("=====================================================") 
        CCommunicationAgent:GetInstance():SetAnalyticPacket(1)
    else
        print("=====================================================")     
        print("\t\t连接游戏服务器成功                ")     
        print("=====================================================")  

        -- 设置分分包分包对象类型：1 = 代理服务器 2 = 游戏服务器
        CCommunicationAgent:GetInstance():SetAnalyticPacket(2)

    end
end

-- 代理服务器登录成功回复处理
function LoginManager:OnProxyLoginSuccessHandler(msgData)
    ConnectProxy = false
    self.m_proxyMsg = msgData
    NetManager:GetInstance():DisConnect()
    NetManager:GetInstance():Connect(GAME_SERVER_IP, GAME_SERVER_PORT)
end

-- 连接失败
function LoginManager:OnConnectFailHandler(msgData)
    local _ip = NetManager:GetInstance():GetCurIP()
    local _port = NetManager:GetInstance():GetCurPort()
    log_error(LOG_FILE_NAME, "========== 连接服务器失败:%s, %d ==========", _ip or '', _port or 0)
end

function LoginManager:OnPlayerLoginSuccess(msgData)

    CPlayer:GetInstance():SetPlayerBaseInfo(msgData.role)
    self.m_reconnectToken = msgData.token
    -- 切换到游戏世
    local tbParam = {eWorldType = CWorld.EWorld.E_GAME_WORLD}
    SendLocalMsg(MSGID.CC_CHANGE_WORLD, tbParam) 
end

-- 连接断开
function LoginManager:OnConnectBreakHandler(msgData)
    NetManager:GetInstance():ConnectFail()
end

-- 服务主动连接断开
function LoginManager:OnServerConnectBreakHandler(msgData)
    NetManager:GetInstance():ConnectFail()
end

-- 函数功能: 登录逻辑消息处理函数
function LoginManager:MessageProc(nMsgId, pData, nLen)    
    local funcId = MsgFunc(nMsgId)
       
    -- 微信获取access_token后返回
    if nMsgId == 1601 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        local json_data = json.decode(resp_data)
        if json_data.errcode then
            -- TODO：弹出错误提示
            print("登录失败!")
        else
            -- access_token是调用授权关系接口的调用凭证，由于access_token有效期（目前为2个小时）较短，所以登录后，立即刷新
            WX.WeChatSDKAPIDelegate:RefreshAccessToken(json_data.refresh_token)
        end

    -- 刷新access_token后返回
    elseif nMsgId == 1602 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        local refresh_data = json.decode(resp_data)
        if refresh_data.errcode then
                --刷新超时后，则重新授权
                WX.WeChatSDKAPIDelegate:SendAuthRequest("snsapi_userinfo", "luzhouqipai_wechat_login_req")
        else
            -- refresh_token拥有较长的有效期（30天），当refresh_token失效的后，需要用户重新授权，
            -- 所以，请开发者在refresh_token即将过期时（如第29天时），进行定时的自动刷新并保存好它。
            -- 记录下app_id, access_token, refresh_token
            -- CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.OPENID, LocalStringEncrypt(refresh_data.openid), "string")
            -- CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.ACCESS_TOKEN, LocalStringEncrypt(refresh_data.access_token), "string")
            CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.REFRESH_TOKEN, LocalStringEncrypt(refresh_data.refresh_token), "string")
            WX.WeChatSDKAPIDelegate:GetUserInfo(refresh_data.access_token, refresh_data.openid)
        end
    -- 获取用户信息后返回
    elseif nMsgId == 1603 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        resp_data = string.gsub(resp_data,"\\","")
        local user_info_data = json.decode(resp_data)
        -- 微信登录只需要向服务器发送openid即可，服务器会根据当前的情况来登录或者创建账号
        local login_data = {}
        login_data.openid = user_info_data.openid
        login_data.headerUrl = user_info_data.headimgurl
        login_data.nickName  = user_info_data.nickname
        login_data.sex       = user_info_data.sex - 1
        SendMsgToServer(MSGID.CS_LOGINREQ, login_data, true)
        -- WX.WeChatSDKAPIDelegate:ReqestHeadImg(user_info_data.headimgurl,"user_head")
    -- 获取通过url创建的头像
    elseif nMsgId == 1604 then
        local head_sprite = WX.WeChatSDKAPIDelegate:GetHeadImage()
        if head_sprite then
            local login_ui = CUIManager:GetInstance():GetUIByName("CUILogin")
            
            local clip_head = GetCircleHeadImg(head_sprite)
            clip_head:setPosition(640, 360)
            login_ui.m_pRootForm:addChild(clip_head)

        end

    elseif nMsgId == 1701 then
        print("---分享聊天成功--")
        
    elseif nMsgId == 1702 then
        print("---分享朋友圈成功--")
    end
end

-- 微信登录
function LoginManager:WeChatLogin( )
    local is_installed = WX.WeChatSDKAPIDelegate:CheckWXInstalled()
    if not is_installed then
        Notice("请安装微信客户端后登录！")
        return
    end
    local refresh_token = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.REFRESH_TOKEN, "string")
    if refresh_token == "" then
        -- 微信认证
        -- 注：不要随意更改参数，会导致验证不通过
        WX.WeChatSDKAPIDelegate:SendAuthRequest("snsapi_userinfo", "luzhouqipai_wechat_login_req")
    else
        -- 刷新token
        WX.WeChatSDKAPIDelegate:RefreshAccessToken(LocalStringEncrypt(refresh_token))
    end
end

-- 游客登录
function LoginManager:TouristLogin(  )
    local roleId = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.ROLEID, "string")
    local uid = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.PLAYERUID, "string")
    self.m_bIsCreateUser = true
    local login_data = {}
    if roleId ~= "" and uid ~= "" then
        login_data.uid = LocalStringEncrypt(uid)
        login_data.roleId = LocalStringEncrypt(roleId)
        self.m_bIsCreateUser = false
    end
    SendMsgToServer(MSGID.CS_LOGINREQ, login_data, true)
end

function LoginManager:StartLogin(login_type)
    if login_type == LoginManager.LoginType.Tourist then
        self:TouristLogin()
    elseif login_type == LoginManager.LoginType.WeChat then
        self:WeChatLogin()
    end
end

function LoginManager:Destroy()
end