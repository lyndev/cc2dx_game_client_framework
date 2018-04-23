CLocalNotice = {}
CLocalNotice.__index = CLocalNotice

local instance = nil

function CLocalNotice:New()
    local o = {}
    setmetatable(o, CLocalNotice)
    return o
end

function CLocalNotice:GetInstance()
    if not instance then
        instance = CLocalNotice:New()
        instance:InitLocalNotice()
    end
    return instance
end

function CLocalNotice:InitLocalNotice()
--初始化本地推送
    local targetPlatform = CCApplication:sharedApplication():getTargetPlatform()
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
        for k, v in pairs(q_notice) do
            if type(v) ~= "function" then
                local bRepeat = false
                if v[q_notice_index["q_repeat"]] ~= 0 then
                    bRepeat = true
                end
                local sKey1 = string.format("notice%d", k)
                local sContent  = Language(v[q_notice_index["q_content"]])
                local nNow = CPlayer:GetInstance():GetClientTime()
                local sTime = v[q_notice_index["q_time"]]
                local tbParam = StrSplit(sTime, ":")
                local hour = tonumber(tbParam[1]) or 0
                local min  = tonumber(tbParam[2]) or 0
                local sec  = tonumber(tbParam[3]) or 0
                local time = CPlayer:GetInstance():GetTimePoint(hour, min, sec)
                local nTime = time - nNow
                if nTime <= 0 then
                    nTime = nTime + 24 * 3600
                end
                CGlobalInstanceMsg:GetInstance():DelLocalNotice(tostring(sKey1))
                CGlobalInstanceMsg:GetInstance():AddALocalNotice(sKey1, bRepeat, nTime, sContent)
            end
        end
    elseif (kTargetAndroid == targetPlatform) then
    end
    return true
end

--增加一个本地推送
--参数：sKey-推送的key nTime-间隔多少秒之后推送，sContent-推送内容 bRepeat-是否重复推送
--说明：第一次推送的时间为nTime之后
function CLocalNotice:AddLocalNotice(sKey, nTime, sContent, bRepeat)
    local targetPlatform = CCApplication:sharedApplication():getTargetPlatform()
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
        if not bRepeat then
            bRepeat = false
        else
            bRepeat = true
        end
        CGlobalInstanceMsg:GetInstance():DelLocalNotice(tostring(sKey))
        CGlobalInstanceMsg:GetInstance():AddALocalNotice(tostring(sKey), bRepeat, nTime, sContent)
    end
end

function CLocalNotice:Destroy()
    instance = nil
end

function CLocalNotice:ReleaseLocalNotice()
end

function CLocalNotice:CancelAllLocalNotifications()
    local targetPlatform = CCApplication:sharedApplication():getTargetPlatform()
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
        CGlobalInstanceMsg:GetInstance():CancelAllLocalNotifications()
    end
end