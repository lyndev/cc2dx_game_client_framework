--[[
-- Copyright (C), 2015, 
-- 文 件 名: PlistCache.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-22
-- 完成日期: 
-- 功能描述: plist 资源的引用计数加载和卸载
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CPlistCache.log'
CPlistCache = {}
CPlistCache.__index = CPlistCache
CPlistCache.m_plistMap = {}

--[[
-- 函数功能: 获取共享实例
-- 参    数: 无
-- 返 回 值: 无
-- 备    注: 无
--]]
function CPlistCache:GetInstance()
    return CPlistCache
end

--[[
-- 函数功能: 销毁数据
-- 参    数: 无
-- 返 回 值: 无
-- 备    注: 无
--]]
function CPlistCache:DestroyAll()
    for k,v in pairs(self.m_plistMap) do
        if v then
            self:ReleasePlist(k)
        end
    end
end

--[[
-- 函数功能: 加载纹理资源
-- 参    数: 
--     [IN] strPlistName: plist文件名称
-- 返 回 值: 无
-- 备    注: 加载对应的资源，如果资源已经加载则引用计数加1
--]]
function CPlistCache:RetainPlist(strPlistName)
    -- 判断资源是否已经加载
    if self.m_plistMap[strPlistName] then
        self.m_plistMap[strPlistName] = self.m_plistMap[strPlistName] + 1
    else
        release_print("加载资源:"..strPlistName)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(strPlistName)
        self.m_plistMap[strPlistName] = 1
    end
end

--[[
-- 函数功能: 释放纹理资源
-- 参    数: 
--     [IN] strPlistName: plist文件名称
--     [IN] strPvrName: pvr文件名称或者png
-- 返 回 值: 无
-- 备    注: 释放对应的资源，如果引用计数为0则释放资源
--]]
function CPlistCache:ReleasePlist(strPlistName, strPvrName)
    if not self.m_plistMap[strPlistName] then
        log_error(LOG_FILE_NAME, "release the don't load plist" .. strPlistName)
        return
    end

    -- 如果pvr名称不为空
    if strPvrName then
        local iPlistPos = string.find(strPlistName, ".plist")
        local iPvrPos = string.find(strPvrName, ".pvr")
        if not iPlistPos or not iPvrPos then
            return
        end
        if string.sub(strPlistName, 1, iPlistPos) ~= string.sub(strPvrName, 1, iPvrPos) then
            log_error(LOG_FILE_NAME, "the plist and pvr name is not same")
            return 
        end
    else
        local iPlistPos = string.find(strPlistName, ".plist")
        if iPlistPos then
            strPvrName = string.sub(strPlistName, 1, iPlistPos) .. "pvr.ccz"
        end 
    end

    self.m_plistMap[strPlistName] = tonumber(self.m_plistMap[strPlistName]) - 1 -- 引用计数减1

    -- 没有引用计数的时候释放资源
    if tonumber(self.m_plistMap[strPlistName]) == 0 then
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(strPlistName)
        cc.Director:getInstance():getTextureCache():removeTextureForKey(strPvrName)
        self.m_plistMap[strPlistName] = nil
    end
end

--[[
-- 函数类型: public
-- 函数功能: 获取plist资源被引用的次数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPlistCache:GetPlistRefCount(strPlistName)
    return self.m_plistMap[strPlistName] or 0
end

--[[
-- 函数类型: public
-- 函数功能: 打印资源使用情况
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CPlistCache:PrintPlist()
    for list, num in pairs(self.m_plistMap) do
        local strInfo = string.format("%s:%d", list, num)
        release_print(strInfo)
    end
end

return CPlistCache