--[[
-- Copyright (C), 2015, 
-- 文 件 名: Facade.lua
-- 作    者: lyn
-- 创建日期: 2017-01-10
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CFacade.lua.log'

Facade = class("Facade")

function Facade:ctor()
    self.m_controller = nil
    self.m_GameManager = nil
    self.m_Managers = }
    InitFramework()
end

function Facade:InitFramework()
    if (m_controller != nil) return
    m_controller = Controller.Instance
end

function Facade:RegisterCommand(commandName, commandType)
    m_controller.RegisterCommand(commandName, commandType)
end

function Facade:RemoveCommand(commandName) 
    m_controller.RemoveCommand(commandName)
end

function Facade:HasCommand(commandName) 
    return m_controller.HasCommand(commandName)
end

function Facade:RegisterMultiCommand(commandType, commandsName) 
    for i, v in ipairs(commandsName) do
        self:RegisterCommand(v, commandType)
    end
end

function Facade:RemoveMultiCommand(commandsName)
    for i, v in ipairs(commandsName) do
        self:RemoveCommand(v)
    end
end

function Facade:SendMessageCommand(message, body) 
    self.m_controller:ExecuteCommand(message, body)
end

function Facade:AddManager(typeName, obj) 
    self.m_Managers[typeName] = obj
end

function Facade:GetManager(typeName)
    return self.m_Managers[typeName]
end

function Facade:RemoveManager(typeName) 
    self.m_Managers[typeName] = nil
end