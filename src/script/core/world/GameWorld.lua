--[[
-- Copyright (C), 2015, 
-- 文 件 名: GameWorld.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-05-23
-- 完成日期: 
-- 功能描述: 游戏世界
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CGameWorld.log'

require "script.core.world.World"

CGameWorld = class("CGameWorld", CWorld)

function CGameWorld:New()
    local o = {}
    setmetatable(o, CGameWorld)
    return o
end

function CGameWorld:Init()
    -- 音乐播放
    CLobbyManager:GetInstance():Init()
    OpenUI("CUIMain")

    return true
end

function CGameWorld:GetName()
    return "GameWorld"
end

function CGameWorld:EnterMainUI()
end

-- 函数功能: 处理登录回复
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CGameWorld:OnLoginAck( msgData )
    if msgData.result == "ok" then

    end
end

-- 函数功能: 设置玩家信息
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CGameWorld:SetPlayerInfo( msgData )
    if msgData.base.accountType == CLoginLogic.LoginType.WeChat and 
        CPlayer:GetInstance().m_nAccountType == CLoginLogic.LoginType.Tourist then
        CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.PLAYERUID, "", "string")
        CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.ROLEID, "", "string")
    end
    CPlayer:GetInstance():Init(msgData.base)
    CloseUI("CUICommonTips")
end

--[[
-- 函数类型: public
-- 函数功能: 帧更新
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGameWorld:Update(dt)

    -- UI管理器
    CUIManager:GetInstance():Update(dt)
    
    CPlayer:GetInstance():Update(dt)

    if gFightMgr then
        gFightMgr:Update(dt)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 消息处理
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGameWorld:MessageProc(nMsgID, pData, nLen)
    local funcId = MsgFunc(nMsgID)
    -- 连接服务器成功
    if nMsgID == MSGID.CC_CONNECT_SUCCESS then  
        log_info(LOG_FILE_NAME, "连接服务器成功")
        --CloseUI("CUITipsAutoConnect")
        CLuaLogic.ConnectState = 1
        -- 设置为连接状态:已连接
        self:StartRelogin()

    -- 连接服务器失败
    elseif nMsgID == MSGID.CC_CONNECT_FAILED then    
        log_info(LOG_FILE_NAME, "连接服务器失败")
        CLuaLogic.ConnectFailed()
        
        --OpenUI("CUITipsAutoConnect", nil, {uiType = ENUM.UI_TYPE.TWICE})
        Notice("连接服务器失败")
    -- 服务器连接断开        
    elseif nMsgID == MSGID.CC_CONNECT_BREAK then     
        log_info(LOG_FILE_NAME, "与服务器连接断开")
        CLuaLogic.ConnectFailed()
        --OpenUI("CUITipsAutoConnect", nil, {uiType = ENUM.UI_TYPE.TWICE})
    --微信获取access_token后返回
    elseif nMsgID == 1601 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        local json_data = json.decode(resp_data)
        if json_data.errcode then
            --TODO：弹出错误提示
            print("登录失败!")
        else
            --access_token是调用授权关系接口的调用凭证，由于access_token有效期（目前为2个小时）较短，所以登录后，立即刷新
            WX.WeChatSDKAPIDelegate:RefreshAccessToken(json_data.refresh_token)
        end
    --刷新access_token后返回
    elseif nMsgID == 1602 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        --print("--------refresh_data=" .. resp_data)
        local refresh_data = json.decode(resp_data)
        if refresh_data.errcode then
                --TODO：弹出错误提示
                print("登录失败!")
                WX.WeChatSDKAPIDelegate:SendAuthRequest("snsapi_userinfo", "luzhouqipai_wechat_login_req")
        else
            --refresh_token拥有较长的有效期（30天），当refresh_token失效的后，需要用户重新授权，
            --所以，请开发者在refresh_token即将过期时（如第29天时），进行定时的自动刷新并保存好它。
            --记录下app_id, access_token, refresh_token
            --CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.OPENID, LocalStringEncrypt(refresh_data.openid), "string")
            --CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.ACCESS_TOKEN, LocalStringEncrypt(refresh_data.access_token), "string")
            CSystemSetting:GetInstance():SetSetting(CSystemSetting.KEY_TYPE.REFRESH_TOKEN, LocalStringEncrypt(refresh_data.refresh_token), "string")
            WX.WeChatSDKAPIDelegate:GetUserInfo(refresh_data.access_token, refresh_data.openid)
        end
    --获取用户信息后返回
    elseif nMsgID == 1603 then
        local resp_data = WX.WeChatSDKAPIDelegate:GetHttpResponseData()
        resp_data = string.gsub(resp_data,"\\","")
        local user_info_data = json.decode(resp_data)

        local login_type = CPlayer:GetInstance().m_nAccountType --获取登录类型
        if login_type == CLoginLogic.LoginType.Tourist then
            local uid = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.PLAYERUID, "string")
            --绑定账号
            local login_data = {}
            login_data.openid = user_info_data.openid
            login_data.headerUrl = user_info_data.headimgurl
            login_data.nickName  = user_info_data.nickname
            login_data.sex       = user_info_data.sex - 1
            login_data.uid = LocalStringEncrypt(uid)
            SendMsgToServer(MSGID.CS_ACCOUNT_BIND_REQ, login_data, true)
        else
            --微信登录只需要向服务器发送openid即可，服务器会根据当前的情况来登录或者创建账号
            local login_data = {}
            login_data.openid = user_info_data.openid
            login_data.headerUrl = user_info_data.headimgurl
            login_data.nickName  = user_info_data.nickname
            login_data.sex       = user_info_data.sex - 1
            SendMsgToServer(MSGID.CS_LOGINREQ, login_data, true)
        end

        
    --获取通过url创建的头像
    elseif nMsgID == 1604 then
        local head_sprite = WX.WeChatSDKAPIDelegate:GetHeadImage()
        if head_sprite then

            local clip_head = GetCircleHeadImg(head_sprite)
            -- clip_head:setPosition(0,0)
            -- clip_head:setAnchorPoint(cc.p(0, 0))
            --TODO:发送一个事件出去，通知头像信息返回
            local event = {}
            event.name = CEvent.WeChatHeadImg
            event.tag = head_sprite:getName()
            event.sp_head = clip_head
            gPublicDispatcher:DispatchEvent(event)
        end
    end
end

-- 函数功能: 微信登录
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CGameWorld:WeChatLogin( )
    -- local openid = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.OPENID, "string")
    -- local access_token = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.ACCESS_TOKEN, "string")
    local refresh_token = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.REFRESH_TOKEN, "string")
    if refresh_token == "" then
        --微信认证
        --注：不要随意更改参数，会导致验证不通过
        WX.WeChatSDKAPIDelegate:SendAuthRequest("snsapi_userinfo", "luzhouqipai_wechat_login_req")
    else
        --刷新token
        WX.WeChatSDKAPIDelegate:RefreshAccessToken(LocalStringEncrypt(refresh_token))
    end
end

-- 函数功能: 游客登录
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CGameWorld:TouristLogin()
    local roleId = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.ROLEID, "string")
    local uid = CSystemSetting:GetInstance():GetSetting(CSystemSetting.KEY_TYPE.PLAYERUID, "string")
    local login_data = {}
    if roleId ~= "" and uid ~= "" then
        login_data.uid = LocalStringEncrypt(uid)
        login_data.roleId = LocalStringEncrypt(roleId)
        SendMsgToServer(MSGID.CS_LOGINREQ, login_data, true)
    end
end

-- 函数功能: 开始登录
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CGameWorld:StartRelogin(  )
    local login_type = CPlayer:GetInstance().m_nAccountType --获取登录类型
    if login_type == CLoginLogic.LoginType.Tourist then
        self:TouristLogin()
    elseif login_type == CLoginLogic.LoginType.WeChat then
        self:WeChatLogin()
    end
end

--[[
-- 函数类型: public
-- 函数功能: 销毁
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CGameWorld:Destroy()
    GameInitFinish = false

    -- 断开连接
    CLuaLogic.DisConnect()

    -- 移除事件
    gPublicDispatcher:RemoveEventListenerObj(self)

    -- UI堆栈
    CUIOpenStack:GetInstance():Destroy()

    -- UI
    CUIManager:GetInstance():Destroy()

    -- 音乐关闭
    CMusicPlayer:GetInstance():Destroy()

    -- 释放一次未使用的资源
    display.removeUnusedSpriteFrames()

    CMsgRegister:ClearRegListenerHandler(MSGID.SC_LOGINACK)
    CMsgRegister:ClearRegListenerHandler(MSGID.SC_PLAYER_INFO)
end