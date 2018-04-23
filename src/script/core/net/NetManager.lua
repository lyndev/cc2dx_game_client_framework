-- =========================================================================
-- 文 件 名: NetManager.lua
-- 作    者: lyn
-- 创建日期: 2017-05-03
-- 功能描述: 消息相关处理函数及定义 
-- 其它相关:  
-- 修改记录: 
-- =========================================================================  

-- 日志文件名
local LOG_FILE_NAME = 'NetManager.log'

NetManager = class("NetManager")

function NetManager:New(o)
    o = o or {}
    o.m_bConnect = false
    o.m_lastConnectTime = 0
    setmetatable(o, NetManager)
    return o
end

function NetManager:Init(msg)
	self:Connect(GAME_PROXY_SERVER_IP, GAME_PROXY_SERVER_PORT)
    self:ConnectUDP(GAME_PROXY_SERVER_IP, GAME_CLIENT_UDP_PORT)
end

function NetManager:GetInstance()
    if not NetManager._instance then
        NetManager._instance = NetManager:New()
    end
    return  NetManager._instance
end

function NetManager:IsConnect()
	return self.m_bConnect
end

function NetManager:ConnectSuccess()
	self.m_bConnect = true
end

function NetManager:ConnectFail()
	self.m_bConnect = false
    log_error(LOG_FILE_NAME, "========== 与服务器断开连接, IP:%s, PORT:%d ==========", self:GetCurIP(), self:GetCurPort())
end

function NetManager:GetCurIP()
	return self.m_connectIP or 0
end

function NetManager:GetCurPort()
	return self.m_connectPort or ''
end

function NetManager:OnBreak()
	self:ConnectFail()
	log_error(LOG_FILE_NAME, "========== 与服务器断开连接, IP:%s, PORT:%d ==========", self:GetCurIP(), self:GetCurPort())
end

function NetManager:Connect(ip, port)
	assert(ip)
	assert(port)
	self.m_connectIP = ip
	self.m_connectPort = port
    -- local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    -- if not NetManager.DevMode then
    --     if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
    --         local ip_addr = WX.WeChatSDKAPIDelegate:GetIpAddressByDomain("www.0830qp.cn")
    --         if ip_addr then
    --             log_info(LOG_FILE_NAME, "域名解析成功！IP=%s", ip_addr)
    --             IP = ip_addr
    --         else
    --             return
    --         end
    --     end
    -- end
    log_info(LOG_FILE_NAME, "==========准备连接服务器, IP:%s, PORT:%d:==========", ip, port)
    CCommunicationAgent:GetInstance():Connect(ip, port)
end

function NetManager:ConnectUDP(ip, port)
    assert(ip)
    assert(port)
    self.m_connectIP = ip
    self.m_connectPort = port

    log_info(LOG_FILE_NAME, "==========准备连接UDP服务器, IP:%s, PORT:%d:==========", ip, port)
    CCommunicationAgent:GetInstance():ConnectUDP(ip, port)
end

function NetManager.DisConnect()
    CCommunicationAgent:GetInstance():DisConnect()
end