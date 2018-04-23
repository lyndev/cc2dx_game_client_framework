--[[
-- Copyright (C), 2015, 
-- 文 件 名: AppFacade.lua
-- 作    者: lyn
-- 创建日期: 2017-01-10
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CAppFacade.lua.log'

AppFacade = class(AppFacade, Facade)
AppFacade._instance = nil

-- 单例
function AppFacade:GetInstance()
    if AppFacade._instance == nil then
        AppFacade._instance = AppFacade:new()
    end
    return AppFacade._instance
end

-- 初始化框架
function AppFacade:InitFramework()
    AppFacade.super.InitFramework(self)
    self:RegisterCommand(cmd.START_UP , typeof(StartUpCommand))
end


-- 启动框架
function AppFacade:StartUp()
    SendMessageCommand(NotiConst.START_UP)
    RemoveMultiCommand(NotiConst.START_UP)
end