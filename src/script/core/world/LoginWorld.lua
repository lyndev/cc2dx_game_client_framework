-- =========================================================================
-- 文 件 名: UILogin.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-05-02
-- 完成日期:  
-- 功能描述: 登录世界
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

local LOG_FILE_NAME = "LoginWorld.lua"

require "script.function.login.LoginManager"

CLoginWorld = class("CLoginWorld", CWorld)

function CLoginWorld:New()
    local o = {}
    setmetatable(o, CLoginWorld)
    return o
end

function CLoginWorld:Init()
    CLuaLogic.m_ServerIp = nil
    CMsgRegister.ClearMsgList()
    CUIManager:GetInstance():Init()
    NetManager:GetInstance():Init()
    LoginManager:GetInstance():Init()
    return true
end

function CLoginWorld:GetName()
    return "LoginWorld"
end

function CLoginWorld:Update(dt)
    LoginManager:GetInstance():Update(dt)
    CUIManager:GetInstance():Update(dt)
    CPlayer:GetInstance():Update(dt)
end

function CLoginWorld:Destroy()
    LoginManager:GetInstance():Destroy()
    CUIManager:GetInstance():Destroy()
    -- 释放一次未使用的资源
    display.removeUnusedSpriteFrames()
end

function CLoginWorld:MessageProc(nMsgID, pData, nLen)
    LoginManager:GetInstance():MessageProc(nMsgID, pData, nLen)
end