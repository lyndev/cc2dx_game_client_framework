CSDKCallback = {}
CSDKCallback.__index = CSDKCallback

-- /*******************************************************************************
--  * 函数原型：void CPlatformInterface::payCallback(const char *billNo, const char *accessToken)
--  * 函数功能：充值回调
--  * 参数[IN]: const char * billNo　订单号
--  *           const char * accessToken    accessToken
--  * 返回值：无
--  ********************************************************************************/
function CSDKCallback.payCallback(billNo, accessToken)
    print(">>>payCallback", billNo, accessToken, "<<<")
    if billNo ~= "" and accessToken ~= "" then
        CRechargeLogic:GetInstance():DealPayCallBack(billNo, accessToken)
    else
        print("the billNo or accessToken is nil")
    end
end

-- /*******************************************************************************
--  * 函数原型：void CPlatformInterface::getPayListCallback(const char *payListResult)
--  * 函数功能：由于获取充值列表改为异步模式，所以添加此回调，当获取到列表后调用此回调
--  * 参数[IN]: const char * payListResult　获取的充值列表
--  * 返回值：无
--  ********************************************************************************/
function CSDKCallback.getPayListCallback(payListResult)
    print(">>>payListResult", "<<<", payListResult)
    if payListResult == "[]" then
        print("the pay list result is nil")    
    end

    CRechargeLogic:GetInstance():DealPayList(payListResult)
end

-- /*******************************************************************************
--  * 函数原型：bool CPlatformInterface::LoginSuccess( const char * username, int64 userID, int64 sessionID, const char * token )
--  * 函数功能：平台登录成功的回调函数
--  *
--  * 参数[IN]:const char * username　账号名字，　（这里一定要记住使用的是平台的用户的userID值）
--  *          const char * userID            此参数暂时可以不用，　定义值为０
--  *          const char * sessionID         会话ＩＤ值，　此值有可能是字符串的，　主要是保存平台传递过来的登录时间
--  *          const char * token     token验证值，　请注意这个const char * token并不是字符串，他有可能是一个二进制数据
--  *
--  * 返回值：返回处理是否成功
--  * 说明: 游戏必须要实现的接口逻辑
--  ********************************************************************************/
function CSDKCallback.LoginSuccess(username, userID, sessionID, token)
    local loginInstance = CLoginLogic:GetInstance()
    if not loginInstance then
        log_error("CSDKCallback.log", "LoginSuccess,CLoginLogic:GetInstance() is nil")
        local tbParam = SerializeToStr({eWorldType = CWorld.EWorld.E_LOGIN_WORLD})
        SendLocalMsg(MSGID.CC_CHANGE_WORLD, tbParam, #tbParam) -- 切换到登录世界
        return
    end
    loginInstance:SDKLoginSuccess(username, userID, sessionID, token)
end

-- /*******************************************************************************
--  * 函数原型：bool CPlatformInterface::LoginCancel()
--  * 函数功能：游戏中会有小退出游戏的情况，　要退出就需要注销掉当前登录用户的登录记录操作
--  *
--  * 参数[IN]: 无
--  *
--  * 返回值：返回处理是否成功
--  * 说明: 游戏必须要实现的接口逻辑
--  ********************************************************************************/
function CSDKCallback.LoginCancel(code)
    local loginInstance = CLoginLogic:GetInstance()
    if not loginInstance then
        log_error("CSDKCallback.log", "LoginCancel,CLoginLogic:GetInstance() is nil")
        local tbParam = SerializeToStr({eWorldType = CWorld.EWorld.E_LOGIN_WORLD})
        SendLocalMsg(MSGID.CC_CHANGE_WORLD, tbParam, #tbParam) -- 切换到登录世界
        return
    end
    loginInstance:ShowLoginBtn()
end

-- /*******************************************************************************
--  * 函数原型：bool CPlatformInterface::PlatformToGameLogout()
--  * 函数功能：当在ＳＤＫ中使用了注销账号功能时，ＳＤＫ会调用此接口
--  *
--  * 参数[IN]:  无
--  *
--  * 返回值：无
--  * 说明: 游戏必须要实现的接口逻辑
--  ********************************************************************************/
function CSDKCallback.PlatformToGameLogout()
    local tbParam = SerializeToStr({eWorldType = CWorld.EWorld.E_LOGIN_WORLD})
    SendLocalMsg(MSGID.CC_CHANGE_WORLD, tbParam, #tbParam) -- 切换到登录世界
end