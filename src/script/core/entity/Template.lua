-- [[
-- Copyright (C), 2015, 
-- 文 件 名: CTemplate.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-07
-- 完成日期: 
-- 功能描述: 模板接口，封装实体管理器中模板对象所应该具备的接口
--是通过实体管理器创建出来的对象的基类，目前包括:实体及其子类、道具对象及其子类
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CCameraFollow.log'

require 'script.ENUM'

CTemplate = class("CTemplate", GameObject)

function CTemplate:New( o )
    o = o or {}
    setmetatable(o, CTemplate)
    o.m_nTemplateID = 0            -- 模板ID
    return o
end

-- 模板方式初始化，用于模板对象的初始化(用模板数据初始化)
function CTemplate:InitTemplate(data)
end

-- 实例方式初始化，在复制完模板对象的数据后调用该接口进行初始
function CTemplate:InitInstance(data)
    return true
end

-- 对象复制，用于复制模板对象的数据到当前对象中
function CTemplate:Copy(obj)
    
end

-- 判断是否是某个类型
function CTemplate:Isa(eType)
    return eType == ENUM.CLASS_TYPE.CLASS_NULL
end

-- 得到类型
function CTemplate:ClassType()
    return ENUM.CLASS_TYPE.CLASS_NULL
end

-- 获取模板ID
function CTemplate:GetTemplateID()
    return self.m_nTemplateID
end

-- 设置模板ID
function CTemplate:SetTemplateID(templateID)
    -- 参数合法性检测
    if not tonumber(templateID) then
        log_error(LOG_FILE_NAME, "模版ID必须为一个number类型:" .. templateID)
        return
    end
    self.m_nTemplateID = templateID
end

return CTemplate