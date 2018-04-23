-- [[
-- Copyright (C), 2015, 
-- 文 件 名: Entity.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-08
-- 完成日期: 
-- 功能描述: 游戏实体
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CEntity.log'

require "script.core.entity.Template"

CEntity = class("CEntity", CTemplate)

function CEntity:New(o)
    local t = CTemplate:New(o)
    t.m_nEntityID           = IDMaker.GetID()              -- ID生成器生成ID
    t.m_nServerID           = 0
    t.m_posX                = 0
    t.m_posY                = 0
    print("pos", t.m_posX, t.m_posY)
    setmetatable( t, CEntity )
    return t
end

function CEntity:GetEntityID()
    return self.m_nEntityID
end

function CEntity:GetServerID()
    return self.m_nServerID
end

function CEntity:SetServerID( id )
    self.m_nServerID = id
end

function CEntity:GetPosition()
    return self.m_posX, self.m_posY
end

function CEntity:SetPosition( x, y )
   self.m_posX, self.m_posY = x, y
end

function CEntity:SetPositionX(x)
    self.m_posX = x
end

function CEntity:SetPositionY(y)
    self.m_posY = y
end

function CEntity:GetPositionX( )
    return self.m_posX
end

function CEntity:GetPositionY( )
    return self.m_posY
end

function CEntity:GetState()
    return self.m_nState
end

function CEntity:SetState( type )
    self.m_nState = type
end

function CEntity:Update( dt )

end

function CEntity:Destroy()

end  