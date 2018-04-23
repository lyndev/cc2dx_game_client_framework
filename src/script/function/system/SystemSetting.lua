--[[
-- Copyright (C), 2015, 
-- 文 件 名: SystemSetting.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-08-04
-- 完成日期: 
-- 功能描述: 系统设置
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CSystemSetting.log'

CSystemSetting = class("CSystemSetting")

CSystemSetting.instance = nil   -- 单件

CSystemSetting.KEY_TYPE = 
{
    MUSIC = 'music',    -- 背景音乐
    SOUND = 'sound',    -- 音效
    VOICE = 'voice',    -- 语音
    PLAYERUID = "player_uid", --uid
    OPENID = "open_id",     --open_id
    ROLEID = "role_id",     --role_id
    ACCESS_TOKEN = "access_token", --access_token
    REFRESH_TOKEN = "refresh_token", --refresh_token
}
local KEY_TYPE = CSystemSetting.KEY_TYPE

function CSystemSetting:New(o)
    o = o or {}
    setmetatable(o, CSystemSetting)
    return o
end

function CSystemSetting:GetInstance()
    if not CSystemSetting.instance then
        CSystemSetting.instance = self:New()
    end
    return CSystemSetting.instance
end

function CSystemSetting:Init()
    self:LoadSystemSetting()
end

function CSystemSetting:SetSetting(key, value, type)
    local userDefault =  cc.UserDefault:getInstance()
    if type == 'float' then
         userDefault:setFloatForKey(key, value)
    elseif type == 'int' then
        userDefault:setIntegerForKey(key, value)
    elseif type == 'string' then
        userDefault:setStringForKey(key, value)
    end
    userDefault:flush() 
end

function CSystemSetting:GetSetting(key, type)
    local userDefault =  cc.UserDefault:getInstance()
    if type == 'float' then
        return userDefault:getFloatForKey(key)
    elseif type == 'int' then
        return userDefault:getIntegerForKey(key)
    elseif type == 'string' then
        return userDefault:getStringForKey(key)
    end
end

function CSystemSetting:LoadSystemSetting()
    local userdata = cc.UserDefault:getInstance()
    local _getMusicVolume = userdata:getFloatForKey(KEY_TYPE.MUSIC)
    if _getMusicVolume <= 0 then
        _getMusicVolume = 1
        self:SetSetting(KEY_TYPE.MUSIC, 1, "float")
    end
    CMusicPlayer:GetInstance():SetBGMVolume(_getMusicVolume or 1)
    local _getSoundVolume = userdata:getFloatForKey(KEY_TYPE.SOUND)
    if _getSoundVolume <= 0 then
        _getSoundVolume = 1
        self:SetSetting(KEY_TYPE.SOUND, 1, "float")
    end
    CMusicPlayer:GetInstance():SetEffectVolume( _getSoundVolume or 1)
end