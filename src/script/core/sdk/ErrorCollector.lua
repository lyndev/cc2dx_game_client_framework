--local Url    = "http://wwmxdol.bugupload.companyaddress.com/bug.php"          --错误post的地址
local Url = "http://192.168.1.200:8888/GameDataGather/crash?"
local base64 = require("base64")                                   --base64
local MAX_ERRORS = 20                                              --每次运行程序收集的最大错误数

local errorCollector =
{
    errors = {},
    errorCount = 0
}


-- 按照模式分割字符串
function errorCollector:getSplitStr(str, patterns)
    local ret
    for v in string.gmatch(str, patterns)
    do
        ret = v
        break
    end
    --release_print(ret)
    return ret
end

-- 返回标识错误的key（由文件名和行号组成）
function errorCollector:getKey(message)
    --release_print(message)
    return self:getSplitStr(message, "%a+%.%a+") .. "_" .. self:getSplitStr(message, "%d+")
end

-- 压入一条错误消息
function errorCollector:put(message)
    --release_print(#self.errors)
    if (self.errors ~= nil and self.errorCount >= MAX_ERRORS)
    then
        return
    else
        local key = self:getKey(message)
        if (self.errors[key] ~= nil)
        then
            return
        end
        
        self:insert(key, message)
    end
end

-- 将错误消息的key保存，以备去重
function errorCollector:insert(key, message)
    --release_print("[AAA]in insert")
    self.errors[key] = {}
    self.errors[key].error = message
    self.errors[key].state = 0
    self.errorCount = self.errorCount + 1
    self:send(key, message)
end

-- 将消息发送到服务器
function errorCollector:send(key, message)
    local co = coroutine.create(
        function()
            local str = base64.encode(message)
            local request = CCLuaHttpRequest:Create()
            request:setUrl(Url)
            request:setRequestType(CCHttpRequest.kHttpPost)  
            request:SetResponseScriptCallback(function (bSuccess, strbody, iStatus, errorInfo) 
                self:Callback(bSuccess, strbody, iStatus, errorInfo) 
               end)
            local strPostData = "key=" .. key .. "&message=" .. string.gsub(str, "[+]", "%%2b")
            request:setRequestData(strPostData, string.len(strPostData))
            CCHttpClient:getInstance():setTimeoutForConnect(10)
            CCHttpClient:getInstance():send(request)
            request:release()
        end
        )
    coroutine.resume(co)
end

-- 发送回调
function errorCollector:Callback(bSuccess, strbody, iStatus, errorInfo)
    release_print("error report post result: " .. strbody .. " code: " .. iStatus)    
end


return errorCollector

