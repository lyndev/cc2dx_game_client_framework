--[[
-- Copyright (C), 2016, 
-- 文 件 名: ResLoadManager.lua
-- 作    者: 
-- 版    本: V1.0.0
-- 创建日期: 2016-03-3
-- 完成日期: 
-- 功能描述:异步预加载
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CResLoadManager.log'
CResLoadManager = {}
CResLoadManager.__index = CResLoadManager 
CResLoadManager._instance = nil

local RES_ENUM = {
    IMAGE        = 1,    -- 纹理
    SPRITEFRAMES = 2,    -- 帧缓存

}

function CResLoadManager:New()
    local o = {}
    o.m_pFinishCallback             = nil
    o._node                         = display.newNode()
    o.m_resPngTotalCount            = 0
    o.m_resPvrTotalCount            = 0
    o.m_resPngCount                 = 0
    o.m_resPvrCount                 = 0
    setmetatable( o, CResLoadManager )
    CWidgetManager:GetInstance():AddChild(o._node)
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 得到单例
-- 参    数: 
-- 返 回 值: 返回单例
-- 备    注:
-- ]]
function CResLoadManager:GetInstance()
    if not CResLoadManager._instance then
        CResLoadManager._instance = self:New()
    end
    CUILoadingManager:GetInstance()
    return  CResLoadManager._instance
end

-- [[
-- 函数类型: public
-- 函数功能: 加载资源 png
-- 参    数: m_resTable 要在updata预加载资源的的tab m_ 
-- 返 回 值: 
-- 备    注:
-- ]]
function CResLoadManager:LoadStart(m_pFinishCallback,m_resTable,m_addSpriteFramesTable )

    -- 打开UI事件
    local _eventLoading = CEvent:New(CEvent.Loading.OpenLoadUI)
    gPublicDispatcher:DispatchEvent(_eventLoading)

    if m_pFinishCallback and type(m_pFinishCallback) then
        self:SetLoadingFinishCallback(m_pFinishCallback)
    end
    local _TresTable = m_resTable
    local _addSpriteFramesTable = m_addSpriteFramesTable
    if _TresTable and type(_TresTable) == "table"  then
        for k,v in pairs(_TresTable) do
            self.m_resPngTotalCount = self.m_resPngTotalCount + 1
        end
    end
    if _addSpriteFramesTable and type(_addSpriteFramesTable) == "table" then
        for kk,vv in pairs(_addSpriteFramesTable) do
            self.m_resPvrTotalCount = self.m_resPvrTotalCount + 1
        end
    end
    if  type(_TresTable) == "table" and self.m_resPngTotalCount > 0  or type(_addSpriteFramesTable) == "table" and self.m_resPngTotalCount > 0  then

         -- 一帧加载资源
        self._node:onUpdate(function(dt)
            if self.m_resPngCount < self.m_resPngTotalCount then
                self.m_resPngCount = self.m_resPngCount + 1
                if type(_TresTable[self.m_resPngCount]) == "string" then
                    local _resName = string.sub(_TresTable[self.m_resPngCount], 1, -5)
                    display.loadImage(_resName..".png")
                    self:LoadingCallback()
                end
            end
        end)

        -- 异步加载资源
        if _addSpriteFramesTable and type(_addSpriteFramesTable) == "table" then  
            for k,v in pairs(_addSpriteFramesTable) do
                display.addSpriteFrames(v..".plist", v..".png", function ()
                    self.m_resPvrCount = self.m_resPvrCount + 1
                    self:LoadingCallback()
                end)
            end
        end
    else
        self:LoadFinished()
    end
end

-- [[
-- 函数类型: private
-- 函数功能: 加载一个资源成功的回调
-- 参    数: 无
-- 返 回 值: 
-- 备    注:
-- ]]
function CResLoadManager:LoadingCallback()
    local _percent = 0
    if self.m_resPngTotalCount + self.m_resPvrTotalCount > 0 then
        _percent = (self.m_resPngCount + self.m_resPvrCount) /  (self.m_resPngTotalCount + self.m_resPvrTotalCount) * 100
    end
    if self.m_resPngCount + self.m_resPvrCount  >= self.m_resPngTotalCount + self.m_resPvrTotalCount  then
        self:LoadFinished()
    end
    
    -- 加载资源进度事件
    local _eventLoadCallBack= CEvent:New(CEvent.Loading.LoadCallBack)
    _eventLoadCallBack.percent = _percent
    gPublicDispatcher:DispatchEvent(_eventLoadCallBack)
end

-- [[
-- 函数类型: private
-- 函数功能: 加载完成的回调
-- 参    数: 无
-- 返 回 值: 
-- 备    注:
-- ]]
function CResLoadManager:LoadFinished()
    if self.m_pFinishCallback ~= nil and type(self.m_pFinishCallback) == "function" then
        local _cb_finish = self.m_pFinishCallback
        self._node:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function()
            _cb_finish()
            -- self:OnLoadingFinish()
            
        end)))
    else
        log_error(LOG_FILE_NAME,"self.m_finishEvent回调函数为空或不是函数")
    end
end

--[[
-- 函数类型: public
-- 函数功能: 加载完后的处理
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CResLoadManager:OnLoadingFinish()

    -- UI关闭事件
    local _eventLoadFinishCallBack= CEvent:New(CEvent.Loading.CloseLoadUI )
    gPublicDispatcher:DispatchEvent(_eventLoadFinishCallBack)

    self.m_pFinishCallback             = nil
    self.m_resPngTotalCount            = 0
    self.m_resPvrTotalCount            = 0
    self.m_resPngCount                 = 0
    self.m_resPvrCount                 = 0
end
--[[
-- 函数类型: public
-- 函数功能: 设置加载完后的函数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CResLoadManager:SetLoadingFinishCallback( func)
    if func and type(func) == "function" then
        self.m_pFinishCallback = func
    end
end

-- [[
-- 函数类型: public
-- 函数功能: 销毁单例
-- 参    数: 无
-- 返 回 值: 
-- 备    注:
-- ]]
function CResLoadManager:Destroy()
    gPublicDispatcher:RemoveEventListenerObj(self)
    CResLoadManager._instance = nil
end
