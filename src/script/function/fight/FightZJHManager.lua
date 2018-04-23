-- =========================================================================
-- 文 件 名: FightZJHManager.lua
-- 作    者: lyn
-- 创建日期: 2017-05-10
-- 功能描述: 扎金花战斗管理器
-- 其它相关:  
-- 修改记录: 
-- =========================================================================  
-- 日志文件名
local LOG_FILE_NAME = 'FightZJHManager.log'

require "script.function.fight.FightQiPaiBase"

FightZJHManager = class('FightZJHManager', CFightQiPaiBase)

function FightZJHManager:New(o)
    log_info(LOG_FILE_NAME, "扎金花管理器初始化")
    local self = CFightQiPaiBase:New(o)
    setmetatable(self, FightZJHManager)
    return self
end

function FightZJHManager:Init(msg)
    FightZJHManager.super.Init(self, msg)
    self:SetGameType(ENUM.GameType.ZJH)
end