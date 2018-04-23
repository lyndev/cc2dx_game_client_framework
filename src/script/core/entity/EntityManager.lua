-- [[
-- Copyright (C), 2015, 
-- 文 件 名: EntityManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-28
-- 完成日期: 
-- 功能描述: 实体管理器
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CEntityManager.log'

require "script.core.entity.Entity"

CEntityManager = {}
CEntityManager.__index = CEntityManager
CEntityManager._instacne = nil

function CEntityManager:New()
    local o = {}
    o.m_tEntityMap          = {}    -- key = 实体id, value = 实体对象
    o.m_tEntityServerIDMap  = {}    -- key = 实体服务器id, value = 实体id
    o.m_fBeforeTime         = 0
    o.m_fCurTime            = 0
    o.m_fTotalTime          = 0
    setmetatable( o,  CEntityManager)
    return o
end

-- 获得实体管理器单例对象
function CEntityManager:GetInstance()
    if not CEntityManager._instacne then
        CEntityManager._instacne = CEntityManager:New()
    end
    return CEntityManager._instacne
end

-- 析构实体管理器单例对象
function CEntityManager:Destroy()
    CEntityManager:UnInitialize()
    CEntityManager = nil
end

-- 重置管理器
function CEntityManager:Reset()
    self:ClearAllEntity()
end

-- 帧更新函数
function CEntityManager:Update(dt)
    for idx, objEntity in pairs(self.m_tEntityMap) do
        objEntity:Update(dt)
    end
end

-- 添加实体
function CEntityManager:AddEntity(pEntity)
    if not pEntity then
        log_error(LOG_FILE_NAME, "pEntity is nil,can not insert")
        return false
    end
    self.m_tEntityMap[pEntity:GetEntityID()] = pEntity

    -- 增加对有服务器标识的实体进行管理
    local _strServerID = tostring(pEntity:GetServerID())
    if  not self.m_tEntityServerIDMap[_strServerID] then
        if pEntity:GetServerID() ~= 0 then
            self.m_tEntityServerIDMap[_strServerID] = pEntity:GetEntityID()
        end
    else
        log_error(LOG_FILE_NAME, '添加了一个已经存在的服务标识的实体')
    end

    return true
end

function CEntityManager:GetEntityIDByServerID( entityServerID )
    return  self.m_tEntityServerIDMap[tostring(entityServerID)] or 0
end

-- 从实体缓存管理器中删除实体
function CEntityManager:RemoveEntity(pEntity)
    if pEntity then
        for idx, objEntity in pairs(self.m_tEntityMap) do
            if pEntity:GetEntityID() == objEntity:GetEntityID() then
                pEntity:Destroy()
                self.m_tEntityMap[pEntity:GetEntityID()] = nil
            end
        end
    end
end

-- 移除一个实体根据ID
function CEntityManager:RemoveEntityByID( entityID )
    local _pEntity = self:GetEntity(entityID)
    if _pEntity then
        _pEntity:Destroy()
        self.m_tEntityMap[entityID] = nil
    end
end

-- 根据ID获取实体缓存中的对象
function CEntityManager:GetEntity(nEntityID)
    if nEntityID ~= nil and nEntityID > 0 then
        return self.m_tEntityMap[nEntityID]
    end
end

-- 清空所有临时实体
function CEntityManager:ClearAllEntity()
    for k,v in pairs(self.m_tEntityMap) do
        self:RemoveEntityByID(k)
    end
    self.m_tEntityMap = {}
    self.m_tEntityServerIDMap = {}
end

function CEntityManager:GetEntitys()
    return self.m_tEntityMap
end