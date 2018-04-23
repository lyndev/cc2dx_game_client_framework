-- =========================================================================
-- 文 件 名: LuaLogic.lua
-- 作    者: lyn
-- 创建日期: 2017-05-02
-- 功能描述: 游戏主控制类,主要负责游戏流程, 网络消息分发
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'CLuaLogic.log'

require "script.core.world.LoginWorld"
require "script.core.world.GameWorld"

CLuaLogic = {}
CLuaLogic.__index = CLuaLogic

CLuaLogic.m_pWorld      = nil                                   -- 世界指针
local m_curWorldState   = CWorld.EWorld.E_NONE_WORLD            -- 当前世界状态
local m_fUpdateSpeed    = 1.0                                   -- 加速倍数
local m_bIntervalEffect = false                                 -- 是否固定帧更新
local m_fIntervalTime   = 0.016667000000000                     -- 固定帧更新间隔
local m_fightFixTime    = 0.033333                              -- 战斗逻辑固定帧

-- =========================================================================
-- 销毁世界
-- =========================================================================
local function DestroyWorld()
    if CLuaLogic.m_pWorld then
        CLuaLogic.m_pWorld:Destroy()
        CLuaLogic.m_pWorld = nil
    end
end

-- =========================================================================
-- 创建游戏世界
-- =========================================================================
local function CreateWorld(eWorld)
    
    -- 创建世界
    if eWorld == CWorld.EWorld.E_LOGIN_WORLD then
        CLuaLogic.m_pWorld = CLoginWorld:New()
    elseif eWorld == CWorld.EWorld.E_GAME_WORLD then
        CLuaLogic.m_pWorld = CGameWorld:New()
    end

    -- 世界创建成功
    if CLuaLogic.m_pWorld then
        m_curWorldState = eWorld

        -- 初始化世界
        local _bInit = CLuaLogic.m_pWorld:Init()
        if _bInit then
            log_info(LOG_FILE_NAME, "[%s]游戏世界初始化成功", CLuaLogic.m_pWorld:GetName())
        end

    -- 世界创建失败
    else
        m_curWorldState = CWorld.EWorld.E_NONE_WORLD
        log_error(LOG_FILE_NAME, "游戏世界创建失败,创建参数:%s", tostring(eWorld))
    end
end

-- =========================================================================
-- 设置当前世界类型并创建世界
-- =========================================================================
local function SetCurWorld(eWorld)
    if m_curWorldState ~= CWorld.EWorld.E_NONE_WORLD then
        -- 改变世界和当前世界一样
        if eWorld == m_curWorldState then
            return
        end
        DestroyWorld()
    end

    -- 创建新的游戏世界
    CreateWorld(eWorld)
end

function CLuaLogic:ChangeWorld(word)
    SetCurWorld(word)
end

function CLuaLogic:SetDevRunMode( is_dev )
    if is_dev then
        self.ServerIp   = "211.149.151.119"
        --self.ServerIp   = "192.168.8.104"
        self.ServerPort = 7900
    else
        self.ServerIp   = "106.14.46.50"
        self.ServerPort = 7900
    end
    CLuaLogic.DevMode = is_dev
end

-- =========================================================================
-- 
-- =========================================================================
function CLuaLogic.Init()
    xpcall(function ()
        CLuaLogic:SetDevRunMode(true)

        if CLuaLogic.funcUpdateId then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(CLuaLogic.funcUpdateId)
        end
        
        -- 设置LuaLogic更新函数
        CLuaLogic.funcUpdateId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(CLuaLogic.Update, 0, false)

        -- 设置为登录世界
        SetCurWorld(CWorld.EWorld.E_LOGIN_WORLD)
    end, ErrHandler)
end

-- =========================================================================
-- 帧更新，供C层调用
-- =========================================================================
function CLuaLogic.Update(ft)
    if m_bIntervalEffect then
        ft = m_fIntervalTime
    end

    xpcall(function () 
        if CCommunicationAgent then
            CCommunicationAgent:GetInstance():GetMsg()
        end

        -- 消息发送
        CMsgRegister.SendToServer()
        
        -- 游戏世界更新
        if CLuaLogic.m_pWorld then
            CLuaLogic.m_pWorld:Update(ft)
        end
        
        -- 战斗世界
        if gFightMgr then
            gFightMgr:Update(ft)
        end

        -- 全局时间管理器
        CTimerManager:GetInstance():Update(ft)

        -- 特效管理器
        CAnimationCreateManager:GetInstance():Update(ft)
        
        -- 文件加载
        if not requireOver then
            ActRequire()
        end

    end, ErrHandler)
end

-- =========================================================================
-- 获取当前所处世界
-- =========================================================================
function CLuaLogic.GetWorld()
    return CLuaLogic.m_pWorld
end

-- =========================================================================
-- 消息处理，供C++层调用
-- =========================================================================
function CLuaLogic.MessageProc(nMsgId, pData, nLen)
    xpcall(function () 
        -- 接收到消息(C++接收成功回调)
        if MSGSOURCE.SC == MsgScource(nMsgId) then
            --log_info(LOG_FILE_NAME, "成功接收到消息:%d,消息类型:%s", nMsgId, MSGTYPE[nMsgId] or '')
        end

        -- 改变世界
        if nMsgId == MSGID.CC_CHANGE_WORLD then
            CMsgRegister.ServerMsgList = {}
            local parser = DeserializeFromStr(pData)
            SetCurWorld(parser.eWorldType)
        end
        
        if CLuaLogic.m_pWorld then
            ParseMsgAndCallMsgHandler(nMsgId, pData, nLen)
            CLuaLogic.m_pWorld:MessageProc(nMsgId, pData, nLen)
        end

    end, ErrHandler)
end

-- =========================================================================
-- 退出销毁
-- =========================================================================
function CLuaLogic.Destroy()
    xpcall(function ()
        DestroyWorld()
    end, ErrHandler)
end

function CLuaLogic.ConnectFailed()
    print("断开连接~")
end