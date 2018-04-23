CRefreshManager = {}
local LOG_FILE_NAME = "CRefreshManager.log"
CRefreshManager.__index = CRefreshManager

local instance = nil   -- 单件

--new
function CRefreshManager:New()
    local o = {}
    o.m_Event = {}
    setmetatable(o, CRefreshManager)
    o.m_Sec   = math.floor(CPlayer:GetInstance():GetClientTime())
    o.m_CurSec = 0
    return o
end

--获取单件
function CRefreshManager:GetInstance()
    if not instance then
        instance = CRefreshManager:New()
    end
    return instance
end

--退出游戏销毁单件
function CRefreshManager:Destroy()
    instance = nil
end

--注册刷新
function CRefreshManager:RegisterEvent(sKey, hour, min, sec, callBack)
    if self.m_Event[sKey] then
        log_error(LOG_FILE_NAME, "register duplicate callBack for key: " .. sKey)
        return
    end
    local eve = {}
    eve.hour = hour
    eve.min = min
    eve.sec = sec
    eve.callBack = callBack
    self.m_Event[sKey] = eve
end

-- update
function CRefreshManager:Update(ft)
    self.m_CurSec = self.m_CurSec + ft
    if self.m_CurSec >= 1 then
        self.m_CurSec = self.m_CurSec - 1
        local nNow = CPlayer:GetInstance():GetClientTime()
        local tabTime = os.date("*t", math.floor(nNow))
        for k, eve in pairs(self.m_Event) do
            if tabTime.hour == eve.hour and tabTime.min == eve.min and tabTime.sec == eve.sec then
                eve.callBack()
            end
        end
    end
end