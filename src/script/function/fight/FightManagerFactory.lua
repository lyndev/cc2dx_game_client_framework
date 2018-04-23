-- =========================================================================
-- 文 件 名: FightManagerFactory.lua
-- 作    者: lyn
-- 创建日期: 2017-05-10
-- 功能描述: 大厅游戏管理器
-- 其它相关:  
-- 修改记录: 
-- =========================================================================  

-- 日志文件名
local LOG_FILE_NAME = 'FightManagerFactory.lua.log'

require "script.function.fight.FightZJHManager"
require "script.function.fight.FightManager"

FightManagerFactory = class('FightManagerFactory')
FightManagerFactory._instance = nil

function FightManagerFactory:New()
    local o = {}
    setmetatable(o, FightManagerFactory)
    return o
end

function FightManagerFactory:GetInstance()
    if not FightManagerFactory._instance then
        FightManagerFactory._instance = FightManagerFactory:New()
    end
    return  FightManagerFactory._instance
end

function FightManagerFactory:CreateFightManager(type, msg)
	local _mgr = false
	if type == ENUM.GameType.DAER then
	elseif type == ENUM.GameType.MAJIANG then

	elseif type == ENUM.GameType.POKER then

	elseif type == ENUM.GameType.ZJH then
		_mgr = FightZJHManager:New()
	elseif type == ENUM.GameType.TANK then
		_mgr = FightManager:New()
    else
        log_error(LOG_FILE_NAME, "无效的游戏类型:%d", type)
	end
	if _mgr then
		_mgr:Init(msg)
	end
    return _mgr
end
