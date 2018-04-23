-- =========================================================================
-- 文 件 名: Base.lua
-- 作    者: lyn
-- 创建日期: 
-- 功能描述: 
-- 其它相关:  
-- 修改记录: 
-- ========================================================================= 
local LOG_FILE_NAME = 'CBase.lua.log'
Controller = class("Controller", IController)

Controller.instance = nil
function Controller:Create(o)
    local self = o or {}
    setmetatable(self, Controller)
    self.m_commandMap     = {} -- IDictionary<string, Type>
    self.m_viewCmdMap     = {} -- IDictionary<IView, List<string>>
    self.m_instance       = {}
    self.m_syncRoot       = {}
    self.m_staticSyncRoot = {}
end

function Controller:GetInstance()
    if not Controller.instance then
        Controller.instance = Controller:Create()
    end
    return Controller.instance
end

function Controller:Init()
end

function Controller:ExecuteCommand(msgNote)
    local commandType = false
    local views = {}
    if self.m_commandMap[msgNote.Name] then
        commandType = self.m_commandMap[msgNote.Name]
    else 
        for k, v in pairs(self.m_viewCmdMap) do
            if v[msgNote.Name] then
                views.Add(v.Key)
            end
        end
   end

    -- if (commandType != null)   //Controller
    --     object commandInstance = Activator.CreateInstance(commandType)
    --     if (commandInstance is ICommand) 
    --         ((ICommand)commandInstance).Execute(msgNote)
    --     }
    -- }
    if views and #views > 0 then
        for i, v in ipairs(views) do
            v.OnMessage(msgNote)
        end
        views = {}
    end
end

function Controller:RegisterCommand(commandName, commandType) 
    self.m_commandMap[commandName] = commandType
end

function Controller:RegisterViewCommand(view, commandNames) 
    if self.m_viewCmdMap[view] then
        local list = self.m_viewCmdMap[view]
        for i, v in ipairs(commandNames) do
            if not list[v] then
                table.insert(list, v)
            end
        end
    else 
        self.m_viewCmdMap[view] = commandNames
    end        
end

function Controller:HasCommand(string commandName) 
    return self.m_commandMap[commandName]
end

function Controller:RemoveCommand(string commandName) 
    self.m_commandMap[commandName] = nil
end

function Controller:RemoveViewCommand(view, commandNames) 
    if self.m_viewCmdMap[view] then
       self.m_viewCmdMap[view] = {}
    end
end