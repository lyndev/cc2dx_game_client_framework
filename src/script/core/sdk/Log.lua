--[[
-- Copyright (C), 2015, 
-- 文 件 名: Log.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

local log_path = "."
if DEBUG ~= 0 then
    log_path = "log//"--cc.FileUtils:getInstance():getWritablePath()
end

--[[
-- 函数类型: public
-- 函数功能: 普通信息
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function log_info(sFilename, sMsg, ...)
    if DEBUG == 0 then
        return
    end

    local arg = {...}
    if arg ~= nil and sMsg ~= nil then
        sMsg = string.format(sMsg, unpack(arg))
    end

    --设置控制台颜色
    CConsole:GetInstance():SetColor(CConsole.GREEN)

    local dInfo = debug.getinfo(2)
    release_print(os.date("[%c] ")..'[脚本:'..string.sub(sFilename, 1, #sFilename - 4)..'] [info]'..'\n  '..sMsg..'\n')
    sMsg = os.date("[%c] ") .. ": [File:" .. dInfo.source .. " Line:"..dInfo.currentline.."] [info]" .. sMsg .. "\n"
    local objFile = io.open(log_path .. sFilename, "a+")
    if objFile then
        objFile:write(sMsg)
        objFile:close()
    end
    
    --恢复控制台颜色
    CConsole:GetInstance():SetColor(CConsole.YELLOW)
end

-- debug信息
function trace_msg()
    local sMsg = debug.traceback()
    io.stdout:write(sMsg)
    return sMsg
end

--[[
-- 函数类型: public
-- 函数功能: 警告信息
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function log_warning( sFilename, sMsg, ... )
    
    if DEBUG == 0 then
        return
    end

    local arg = {...}
    if arg ~= nil and sMsg ~= nil then
        sMsg = string.format(sMsg, unpack(arg))
    end
    --设置控制台颜色
    CConsole:GetInstance():SetColor(CConsole.RED)
    local dInfo = debug.getinfo(2)
    release_print(os.date("[%c] ")..'[脚本:'..string.sub(sFilename, 1, #sFilename - 4)..'] [warning]'..'\n  '..sMsg..'\n')
    sMsg = os.date("[%c] ") .. ":[File:" .. dInfo.source .. " Line:"..dInfo.currentline.."] [info]" .. sMsg .. "\n"
    local objFile = io.open(log_path .. sFilename, "a+")
    if objFile then
        objFile:write(sMsg)
        objFile:close()
    end
    --恢复控制台颜色
    CConsole:GetInstance():SetColor(CConsole.YELLOW)
end

--[[
-- 函数类型: public
-- 函数功能: 错误信息日志
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function log_error(sFilename, sMsg, ...)
    if DEBUG == 0 then
        return
    end

    local arg = {...}
    if arg ~= nil and 0 ~= #arg and sMsg ~= nil then
        sMsg = string.format(sMsg, unpack(arg))
    end

    --设置控制台颜色
    CConsole:GetInstance():SetColor(CConsole.RED)
    local dInfo = debug.getinfo(2)
    release_print(os.date("[%c] ")..'[脚本:'..string.sub(sFilename, 1, #sFilename - 4)..'] [error]'..'\n  '..sMsg..'\n')
    sMsg = os.date("[%c] ") .. ": [File:" .. dInfo.source .. " Line:"..dInfo.currentline.."] [error]" .. sMsg .. "\n" .. debug.traceback()
    local objFile = io.open(log_path .. sFilename, "a+")
    if objFile then
        objFile:write(sMsg)
        objFile:close()
    end

    --恢复控制台颜色
    CConsole:GetInstance():SetColor(CConsole.YELLOW)
end

--[[
-- 函数类型: public
-- 函数功能: 致命错误信息
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function log_fatal(sFilename, sMsg, ...)

    if DEBUG == 0 then
        return
    end

    local arg = {...}
    if arg ~= nil then
        sMsg = string.format(sMsg, unpack(arg))
    end

    local dInfo = debug.getinfo(2)
    release_print(os.date("[%c]")..'[脚本:'..string.sub(sFilename, 1, #sFilename - 4)..'] [fatal]'..'\n  '..sMsg..'\n')
    sMsg = os.date("[%c]") .. ": [File:" .. dInfo.source .. " Line:"..dInfo.currentline.."] [fatal]" .. sMsg .. "\n" .. debug.traceback()
    local objFile = io.open(log_path .. sFilename, "a+")
    if objFile then
        objFile:write(sMsg)
        objFile:close()
    end
end