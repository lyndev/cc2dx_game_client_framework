-- [[
-- Copyright (C), 2015, 
-- 文 件 名: UILogin.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-22
-- 完成日期: 
-- 功能描述: 世界基类
-- 其它相关: 
-- 修改记录: 
-- ]]

local LOG_FILE_NAME = "CWord.log"

CWorld = {}
CWorld.__index = CWorld

CWorld.EWorld = 
{
    E_NONE_WORLD     = 0,  -- 空，初始状态
    E_LOGIN_WORLD    = 1,  -- 登陆
    E_GAME_WORLD     = 2,  -- 游戏中
}

-- 创建
function CWorld:New()
    local o = {}
    setmetatable(o, CWorld)
    return o
end

-- 纯虚函数
function CWorld:Init()
end

-- 纯虚函数
function CWorld:GetName()
    log_error(LOG_FILE_NAME, '子类世界没有必须重写此函数[GetName]')
    return "WorldBase"
end

-- 纯虚函数
function CWorld:Update(dt)

end

-- 纯虚函数
function CWorld:Destroy()

end

-- 纯虚函数
function CWorld:MessageProc(nMsgID, pData, nLen)
end

-- 纯虚函数
function CWorld:ccTouchBegan(touch, event)
    log_error(LOG_FILE_NAME, '子类世界没有必须重写此函数[ccTouchBegan]')
    return false
end

-- 纯虚函数
function CWorld:ccTouchEnded(touch, event)
    log_error(LOG_FILE_NAME, '子类世界没有必须重写此函数[ccTouchEnded]')
    return false
end

-- 纯虚函数
function CWorld:ccTouchMoved(touch, event)
    log_error(LOG_FILE_NAME, '子类世界没有必须重写此函数[ccTouchMoved]')
    return false
end

-- 纯虚函数
function CWorld:ccTouchCancelled(touch, event)
     log_error(LOG_FILE_NAME, '子类世界没有必须重写此函数[ccTouchCancelled]')
    return false
end
