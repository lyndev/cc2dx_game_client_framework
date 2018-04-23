--[[
-- Copyright (C), 2015, 
-- 文 件 名: SignInManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-01-08
-- 完成日期: 
-- 功能描述: 签到逻辑
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CSignInManager.lua.log'

CSignInManager = class("CSignInManager")
CSignInManager.m_spInstance = nil

function CSignInManager:GetInstance()
    if not CSignInManager.m_spInstance then
        local o = {}
        setmetatable(o, CSignInManager)

        o.m_nSignNum             = 0               -- 签到次数
        o.m_alreadySignDayNumber = {}
        o.m_lastSignDay          = 0               -- 上次签到是哪天
        o.m_bIsTodaySign         = false           -- 今日是否签到
        o.m_nCurrentMonth        = 1               -- 当前月
        o.m_nCurrentDay          = 1
        o.m_tbExtrolInfo         = {}
        o.m_tTaskData            = {}

        CSignInManager.m_spInstance = o
        CMsgRegister:RegMsgListenerHandler(MSGID.SC_PLAYER_SIGNINUPDATE, function ( msgData )
            dump(msgData, "更新签到数据")
           o:SetSignInfo(msgData)
        end, "CSignInManager_SC_PLAYER_SIGNINUPDATE")

        CMsgRegister:RegMsgListenerHandler(MSGID.SC_PLAYER_TASKUPDATE, function ( msgData )
            dump(msgData, "更新任务数据")
           o:ResUpdateTask(msgData)
        end, "CSignInManager_SC_PLAYER_SIGNINUPDATE")

    end
    return CSignInManager.m_spInstance
end

function CSignInManager:Init(msg)
    local _clientTime = CPlayer:GetInstance():GetServerTimeMs()
    self.m_nCurrentMonth = tonumber(GetMonth(_clientTime))
    self.m_nCurrentDay  = tonumber(GetDay(_clientTime))
end

function CSignInManager:SetSignAndTaskInfo(msgData)
    self:SetSignInfo(msgData.sign)
    self:SetTaskInfo(msgData.tasks)
end

function CSignInManager:SetTaskInfo(msgData)
    self.m_tTaskData = msgData or {}
end

function CSignInManager:SetSignInfo(msgData)
    self.m_alreadySignDayNumber = msgData.signs
    self.m_lastSignDay          = msgData.lastSign
    self.m_nSignNum             = msgData.contiDay
    self.m_nlastSignMonth       = msgData.month
    
    local event = {}
    event.name = CEvent.UpateSignData
    gPublicDispatcher:DispatchEvent(event)
end

-- 处理初始化签到信息
function CSignInManager:ReqSignIn(parser)

end

-- 处理初始化签到信息
function CSignInManager:ResSignInInfoHandler(parser)

end

-- 判断当前次数的是否可以签到
function CSignInManager:IsCanSignIn(nDay)

end

-- 红点
function CSignInManager:ReadFlag()
   
end

-- 处理vip变化时间
function CSignInManager:OnVipLevelUpdate()

end

-- 获连续次数
function CSignInManager:GetSignNum()
    return self.m_nSignNum
end

-- 今日是否已经签到
function CSignInManager:IsTodaySign()
    local _curentMoth = self:GetCurrentMonth()
    local _lastMoth = self:GetLastSignMonth()
    local _currentDay = self:GetCurrentDay()
    local _lastDay = self:GetLastSignDay()
    if _lastDay == _currentDay and _curentMoth == _lastMoth then
        log_info(LOG_FILE_NAME, "已经签到")
        return true
    else
        print("没有签到", _curentMoth,_lastMoth,_currentDay,_lastDay)
        return false
    end
end

-- 今日是否已经签到
function CSignInManager:IsSign(day)
    for i,v in ipairs(self.m_alreadySignDayNumber or {}) do
        if v == day then
            return true
        end
    end
    return false
end

-- 获取上次签到月份
function CSignInManager:GetLastSignMonth()
    return self.m_nlastSignMonth or 0
end

-- 获取上次签到的天
function CSignInManager:GetLastSignDay()
    return self.m_lastSignDay or 0
end

-- 获取当前月份
function CSignInManager:GetCurrentMonth()
    return self.m_nCurrentMonth or 0
end

-- 获取当前月份
function CSignInManager:GetCurrentDay()
    return self.m_nCurrentDay or 0
end

-- 更新任务数据
function CSignInManager:ResUpdateTask(msgData)
    self:SetTaskInfo(msgData)
end

-- 获取任务
function CSignInManager:GetTasks()
    return self.m_tTaskData
end

-- 是否已经领取奖励
function CSignInManager:IsGatAwardTask(taskId)
    local _taskdata = self:GetTasks()
    if _taskdata and _taskdata.getIds then
        for i,v in ipairs(_taskdata.getIds) do
            if v == taskId then
                return true
            end
        end
    end
    return false
end

-- 是否已经完成
function CSignInManager:IsFinished(taskId)
    local _taskdata = self:GetTasks()
    if _taskdata and _taskdata.doneIds then
        for i,v in ipairs(_taskdata.doneIds) do
            if v == taskId then
                return true
            end
        end
    end
    return false
end

-- 任务进度
function CSignInManager:GetTaskTimes(taskId)
    local _taksData = self:GetTasks()
    dump(_taksData, "任务数据")
    if _taksData then
        if taskId == 1 then
            return _taksData.share or 0 -- 分享N次朋友圈
        elseif taskId == 2 then
            return _taksData.shareFris or 0 -- 分享N次给好友
        elseif taskId == 3 then
            return _taksData.daerTms or 0 -- 玩大二N盘
        elseif taskId == 4 then
            return _taksData.mjTms or 0 -- 玩麻将N盘
        elseif taskId == 5 then
            return _taksData.pokerTms or 0 -- 玩扑克N盘
        elseif taskId == 6 then
            return _taksData.winDaerTms or 0 -- 赢大二N盘
        elseif taskId == 7 then
            return _taksData.winMjTms or 0 -- 赢麻将N盘
        elseif taskId == 8 then
            return _taksData.winPokerTms or 0 -- 赢扑克N盘
        end
    else
        log_error(LOG_FILE_NAME, "获取任务次数失败")
        return 0    
    end
end

-- 获取当前月的所有天
function CSignInManager:GetCurrentMothDays(year, moth)
    local _times = CPlayer:GetInstance():GetServerTimeMs()
    year = year or GetYear(_times)
    moth = moth or self:GetCurrentMonth()
    local weeks = {}
    weeks[1] = {}
    weeks[2] = {}
    weeks[3] = {}
    weeks[4] = {}
    weeks[5] = {}
    weeks[6] = {}
    weeks[7] = {}
    local _montDays = GetMonthDay(year, moth)
    for i = 1, _montDays do
        local _day = i
        local _dayMs =  GetDateMs(year, moth, _day)
        local _weekDay = tonumber(GetWeek(_dayMs))
        if _weekDay == 0 then
            _weekDay = 7
        end
        table.insert(weeks[_weekDay], tonumber(_day))
    end
    return weeks
end

function CSignInManager:OnDestroy()
    CMsgRegister:UnRegListenerHandler(MSGID.SC_PLAYER_TASKUPDATE, "CSignInManager_SC_PLAYER_SIGNINUPDATE")
    CMsgRegister:UnRegListenerHandler(MSGID.SC_PLAYER_SIGNINUPDATE, "CSignInManager_SC_PLAYER_SIGNINUPDATE")
end