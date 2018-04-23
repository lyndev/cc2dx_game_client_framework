--[[
-- Copyright (C), 2015, 
-- 文 件 名: UIManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-25
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUIManager.log'

require 'script.core.sdk.UIBase'

CUIManager = class('CUIManager')
CUIManager._instance = nil

--[[
-- 函数类型: public
-- 函数功能: 单例获取
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:GetInstance()
    if nil == CUIManager._instance then
        local o = {}
        setmetatable(o, CUIManager)
        o.m_UIList     = {}             -- 已开UI列表, 类名-实例映射, 一个UI类只允许一个实例
        o.m_UIQueue    = {}             -- 待打开UI队列
        o.m_bLockQueue = false          -- 锁住待打开UI队列
        CUIManager._instance = o
        CUIManager._instance:Init()
    end
    return CUIManager._instance
end

function CUIManager:Init()
    CMsgRegister:AddMsgListenerHandler(MSGID.CC_OPEN_UI, function(msgData)
        self:OpenUI(msgData)
    end, "CUIManager")

    CMsgRegister:AddMsgListenerHandler(MSGID.CC_CLOSE_UI, function(msgData)
        self:CloseUI(msgData.name)
    end, "CUIManager")
end

local function OpenUI(self, msg)
    local strUIName = msg.name
    assert('string' == type(strUIName) and #strUIName ~= 0)    
    log_info(LOG_FILE_NAME, "打开UI面板 %s!", strUIName)
    
    -- 强制重新加载脚本
    local bForceReload  = msg.ForceReload or false

    -- 更新数据
    local bUpdate       = msg.update or false

    -- 脚本所在目录
    local strFolderName = msg.FolderName or 'ui'

    -- 是否加入队列
    local bAddToQueue   = msg.AddToQueue or false

    -- 按需重新加载脚本
    local strScriptPath = 'script/'..strFolderName..'/'..string.sub(strUIName, 2)
    if nil == _G[strUIName] or true == bForceReload then
        package.loaded[strScriptPath] = nil
        require(strScriptPath)
    end

    -- 检查是否已开
    if self:IsUIOpen(strUIName) then
        if bUpdate == false then
            if self.m_UIList[strUIName] and  self.m_UIList[strUIName]['SetVisible']then
                self.m_UIList[strUIName]:SetVisible(true)
            else
                log_error(LOG_FILE_NAME, "%s 面板重复打开!", strUIName)
            end
            return false
        elseif bUpdate == true then
            -- 刷新
            local ui = self.m_UIList[strUIName]
            if ui.UpdateData ~= nil then
                ui:UpdateData(msg)
                log_info(LOG_FILE_NAME, "刷新面板 %s 的数据", strUIName)
            end

            return true
        end
    end

    -- 不急着打开的ui
    if bAddToQueue then
        local bNotEmpty = (#self.m_UIQueue > 0)

        -- 去重
        if bNotEmpty and msg.name == self.m_UIQueue[1].name then
            return false
        end
        msg.AddToQueue = false
        table.insert(self.m_UIQueue, msg)

        -- 等待队列为空, 则立即打开
        if bNotEmpty or self.m_bLockQueue then
            return true
        end
    end

    -- 打开并加入列表中 
    assert(_G[strUIName].Create ~= nil)

    local ui = _G[strUIName]:Create(msg)

    if nil == ui then
        print('CUIManager: create ui failed.', strUIName)
        return false
    end

    if not ui:Init(msg) then
        ui:OnDestroy()
        print('Init failed! 打开'..tostring(strUIName)..'失败')
        return false
    end
    
    self.m_UIList[strUIName] = ui
    
    return true
end

--[[
-- 函数类型: public
-- 函数功能: 打开UI
-- 参数[IN]: name: UI类名(字符串), FolderName: 所在文件夹名, ForceReload: 是否强制重载加载, update: 刷新, AddToQueue: 加入待打开队列, ...
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:OpenUI(msgBuf)
    OpenUI(self, msgBuf)
end

--[[
-- 函数类型: public
-- 函数功能: 通过UI名字获取知道UI(UI脚本的名字)
-- 参数[IN]: UI脚本的名字
-- 返 回 值: UI脚本对象
-- 备    注:
--]]
function CUIManager:GetUIByName(strUIName)
    if not strUIName or not self.m_UIList then
        return nil
    end

    return self.m_UIList[strUIName]
end

--[[
-- 函数类型: private
-- 函数功能: 关闭UI
-- 参数[IN]: strUIName UI类名(字符串)
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:CloseUI(strUIName)
    if not self:IsUIOpen(strUIName) then
        return
    end

    assert(self.m_UIList[strUIName].OnDestroy ~= nil)
    self.m_UIList[strUIName]:OnDestroy()
    self.m_UIList[strUIName] = nil
        
    log_info(LOG_FILE_NAME, "关闭UI面板 %s", strUIName)

    -- 处理待打开队列, 删除第一个, 打开第二个
    if #self.m_UIQueue > 0 and not self.m_bLockQueue then
        local QHead = self.m_UIQueue[1]
        if QHead.name == strUIName then
            table.remove(self.m_UIQueue, 1)
            if #self.m_UIQueue > 0 then
                OpenUI(self, self.m_UIQueue[1])
            end
        end
    end

    -- 关闭面板的时候，强制lua垃圾清理
    collectgarbage()

    -- 释放一次资源
    --display.removeUnusedSpriteFrames()
end

--[[
-- 函数类型: 锁住待打开队列
-- 函数功能: bLocked
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:LockQueue(bLocked)
    self.m_bLockQueue = bLocked

    -- 解锁后马上释放一个UI出来
    if not bLocked and self.m_UIQueue[1] ~= nil then
        OpenUI(self, self.m_UIQueue[1])
    end
end

--[[
-- 函数类型: public
-- 函数功能: 清空队列中待打开的UI
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:PurgeQueue()
    self.m_UIQueue = {}
end

--[[
-- 函数类型: public
-- 函数功能: 关闭除了strUIName 之外的所有ui
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:CloseAllUI()
    for k, ui in pairs(self.m_UIList) do
        SendLocalMsg(MSGID.CC_CLOSE_UI, k, string.len(k))
    end
end

--[[
-- 函数类型: public
-- 函数功能: 检查UI是否已经打开
-- 参数[IN]: strUIName UI类名(字符串)
-- 返 回 值: 是否打开
-- 备    注:
--]]
function CUIManager:IsUIOpen(strUIName)
    return self.m_UIList[strUIName] ~= nil
end

--[[
-- 函数类型: public
-- 函数功能: UI更新分流
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:Update(ft)
    for _, ui in pairs(self.m_UIList) do
        if ui.Update ~= nil then
            ui:Update(ft)
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 关闭所有UI，程序退出时使用
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIManager:Destroy()
    for _, ui in pairs(self.m_UIList) do
        if ui.OnDestroy ~= nil then
            ui:OnDestroy()
        end
    end
    self.m_UIList = {}
    self.m_UIQueue = {}
end