--[[
-- Copyright (C), 2015, 
-- 文 件 名: MarqueeManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-05
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CMarqueeManager.lua.log'

CMarqueeManager = class('CMarqueeManager')
CMarqueeManager._instance = nil
local NoticeType = 
{
    System = 1,     -- 系统公告
    Player = 2,     -- 玩家公告
}

function CMarqueeManager:New()
    local o = {}
    setmetatable( o, CMarqueeManager)
    o.m_noticeList = {}
    o.m_noticeShowList = {}

    return o
end

function CMarqueeManager:GetInstance( msg )
    if not CMarqueeManager._instance then
        CMarqueeManager._instance = CMarqueeManager:New()
    end
    return  CMarqueeManager._instance
end

function CMarqueeManager:Init(param)
    -- 系统公告
    CMsgRegister:RegMsgListenerHandler(MSGID.SC_PLAYER_SYS_NOTICE, function ( msgData )
        self:AddOneNotice(msgData)
    end, "CMarqueeManager_SC_PLAYER_SYS_NOTICE")
end

function CMarqueeManager:GetOneShowNotice()
    if #self.m_noticeShowList >= 1 then
        local showNotice = clone(self.m_noticeShowList[1])
        self:RemoveOneNotice(1)
        return showNotice
    end
end

function CMarqueeManager:AddOneNotice(broadcast)
    if broadcast then
        self.m_noticeList[broadcast.broadCastID] = broadcast
        table.insert(self.m_noticeShowList, clone(broadcast))
        local event = {}
        event.name = CEvent.AddSysNotice
        event.broadcast = broadcast
        gPublicDispatcher:DispatchEvent(event)
        log_info(LOG_FILE_NAME, "接收到跑马灯")
    end
end

function CMarqueeManager:GetAllNotice()
    return self.m_noticeList
end

function CMarqueeManager:RemoveOneNotice(index)
    table.remove(self.m_noticeShowList, index)
end

function CMarqueeManager:Destroy()
    CMsgRegister:UnRegListenerHandler(MSGID.SC_REENTER_FIGHT_NOTIFY, "CMarqueeManager_SC_PLAYER_SYS_NOTICE")
    CMarqueeManager._instance = nil
end  