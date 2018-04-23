CMemoryUtil = {}
CMemoryUtil.__index = CMemoryUtil
local instance = nil

--调试刷新间隔
local DEBUG_INTERVAL = 0.5
--正常刷新间隔
local DEFAULT_INTERVAL = 5.0
--是否处于调试
local InMemoryDebug = false

--内存吃紧标准
local C_AVAILABLE_MEMORY = 60.0
local E_AVAILABLE_MEMORY = 40.0
local C_USED_MEMORY = 90.0
local E_USED_MEMORY = 110.0
local targetPlatform = -1

if not IsGameServer then
    targetPlatform = CCApplication:sharedApplication():getTargetPlatform()
end

if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
    C_AVAILABLE_MEMORY = 50.0
    E_AVAILABLE_MEMORY = 30.0
    C_USED_MEMORY = 90.0
    E_USED_MEMORY = 110.0
end



--功能: 内存工具类
--参数: 无
--返回: CMemoryUtil
--备注: 无
function CMemoryUtil:New()
    local timerUtil = {}
    setmetatable(timerUtil, CMemoryUtil)
    timerUtil.m_Interval = 999
    timerUtil.m_pShowSprite = nil
    timerUtil.m_nUsed    = 0
    timerUtil.m_nAviable = 0
    return timerUtil
end

--功能: 获取内存工具类单键
--参数: 无
--返回: CMemoryUtil
--备注: 无
function CMemoryUtil:GetInstance()
    if not instance then
        instance = CMemoryUtil:New()
    end
    return instance
end

--功能: 获取内存工具类单键
--参数: 无
--返回: CMemoryUtil
--备注: 无
function CMemoryUtil:Destroy()
    if self.m_pShowSprite then
        self.m_pShowSprite:removeFromParent()
        self.m_pShowSprite = nil
    end
    instance = nil
end

--功能: 帧更新
--参数: 无
--返回: 无
--备注: 无
function CMemoryUtil:Update(dt)
    self.m_Interval = self.m_Interval + dt
    if (InMemoryDebug and self.m_Interval >= DEBUG_INTERVAL) or
        (not InMemoryDebug and self.m_Interval >= DEFAULT_INTERVAL)
    then
        self:GetMemroyInfo()
        self.m_Interval = 0.0
    end
end

--功能: 获取获取内存信息
--参数: 无
--返回: 无
--备注: 无
function CMemoryUtil:GetMemroyInfo()
    if IsGameServer then
        return
    end
    self.m_nUsed = CMemoryMonitor:GetInstance():GameUsedMemory()
    self.m_nAviable = CMemoryMonitor:GetInstance():AvailableMemory()

    if not InMemoryDebug then
        if self.m_pShowSprite then
            self.m_pShowSprite:removeFromParent()
            self.m_pShowSprite = nil
        end
        return self.m_nAviable, self.m_nUsed
    end

    local strInfo = string.format("use:%dM\nhas:%dM", self.m_nUsed, self.m_nAviable)
    if not self.m_pShowSprite then
        self.m_pShowSprite = CCLabelTTF:create(strInfo, "Airal", 32)
        if self.m_pShowSprite then
            self.m_pShowSprite:setAnchorPoint(cc.p(0, 0))
            self.m_pShowSprite:setPosition(cc.p(200, 100))
            self.m_pShowSprite:setHorizontalAlignment(kCCTextAlignmentLeft);  
            CSceneMgr:GetInstance():GetUINode():addChild(self.m_pShowSprite, 99)
        end
    end

    if self.m_pShowSprite then
        self.m_pShowSprite:setString(strInfo)
    end
    return self.m_nAviable, self.m_nUsed
end

--功能: 设置是否调试
--参数: 无
--返回: 无
--备注: 无
function CMemoryUtil:SetIsDebug(bDebug)
    InMemoryDebug = bDebug
end

--功能: 内存吃紧级别
--参数: 0、不吃紧，1、一般吃紧，2、非常吃紧
--返回: 无
--备注: 无
function CMemoryUtil:MemoryEmergency()
    if self.m_nAviable < E_AVAILABLE_MEMORY and self.m_nUsed > E_USED_MEMORY then
        return 2
    end

    if self.m_nAviable < C_AVAILABLE_MEMORY and self.m_nUsed > C_USED_MEMORY then
        return 1
    end
    return 0
end

--功能: 打印内存信息
--参数: 无
--返回: 无
--备注: 无
function release_printMemory(msg)
    if not InMemoryDebug then
        return
    end 
    msg = msg or ""
    local strInfo = string.format("memory:%s, all = %fM, used = %fM", msg, CMemoryUtil:GetInstance():GetMemroyInfo())
    log_info("MemoryUtil.log", strInfo)
end