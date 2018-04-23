-- =========================================================================
-- 文 件 名: MsgRegister.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-05-02
-- 完成日期:  
-- 功能描述: 消息相关处理函数及定义 
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'CMsgRegister.log'

protobuf = require "script.core.sdk.protobuf"
require "script.core.net.MsgLogFilter"

CMsgRegister = {}
CMsgRegister.__index = CMsgRegister  

-- 前三位为功能编号（100~999）(注：客户端独立功能1-99)
-- 第四位为来源（1:SC   2:CS  3:SS  4:CC） 
-- 后两位为具体功能来源的消息编号
-- 1-99 客户端占用,所以通信协议ID从100起
MSG_SED_RSSULT_TYPE = 
{
    [0]  = '发送成功',
    [-1] = '参数传入失败',
    [-2] = '连接已经断开，不能发送数据',
    [-4] = '发送队列已满',
    [-5] = '分配内存失败',
}

-- 消息来源分类
MSGSOURCE =
{
    SC = 1,         -- 服务器->客户端
    CS = 2,         -- 客户端->服务器
    SS = 3,         -- 服务器->服务器
    CC = 4,         -- 客户端->客户端
}
 
-- =========================================================================
-- 发送本地消息
-- =========================================================================
function SendLocalMsg(msgId, content, high)
    local _msgLocalData = SerializeToStr(content or {})
    length = #_msgLocalData
    
    -- 特殊的UI的操作不走通信底层直接在lua层派发(避免ui都是在下一帧才打开)
    local _funcId = MsgFunc(msgId)
    if _funcId == MSGFUNC.UI then
        local _msgLocalData = SerializeToStr(content or {})
        ParseMsgAndCallMsgHandler(msgId, _msgLocalData, length)
    else
        if not msgId or not content or not length  then
            log_error(LOG_FILE_NAME, "error params msgID:%s, content:%s, len:%d", msgId, content, length)
            dump(content, "错误消息")
            return
        end
        high = high or false
        if CCommunicationAgent then
            if type(CCommunicationAgent:GetInstance().SendMsgPriority) == "function" then
                CCommunicationAgent:GetInstance():SendMsgPriority(msgId, _msgLocalData, length, high)
            else
                CCommunicationAgent:GetInstance():SendLocalMsg(msgId, _msgLocalData, length)
            end
        end
    end
end


-- =========================================================================
-- 大功能编号 
-- =========================================================================
function MsgFunc(msgId)
    return math.floor(msgId / 1000)
end

-- =========================================================================
-- 消息来源
-- =========================================================================
function MsgScource(msgId)
    return math.floor(msgId / 100) % 10
end

-- =========================================================================
-- 具体处理逻辑
-- =========================================================================
function MsgDetail(msgId)
    return msgId % 100
end

-- =========================================================================
-- 根据消息Id解析消息
-- =========================================================================
function ParseMsgId(msgId, data, len)
    assert(msgId)
    assert(data)
    assert(len)
    if not MSGTYPE[msgId] then
        log_info(LOG_FILE_NAME, "msgId not find: "..tostring(msgId))
        return nil
    end
    return ParseMsgType(MSGTYPE[msgId], data, len)
end

-- =========================================================================
-- 根据消息类型解析消息解析
-- =========================================================================
function ParseMsgType(msgType, data, len)
    assert(msgType)
    assert(data)
    if not protobuf.check(msgType) then
        log_error(LOG_FILE_NAME, "protobuf.check(msgType) 无效类型:%s", msgType)
    end
    -- if not msgType or 
    --    not data or
    --    type(msgType) ~= "string" or
    --    type(data) ~= "string" or
    --    not protobuf.check(msgType)
    -- then
    --     log_error(LOG_FILE_NAME, "MsgParser() param error:%s, data: %s, len: %d", msgType, data, len)
    --     return nil
    -- end

    local decode, _= protobuf.decode(msgType, data, len)
    local ret = {}

    if not decode then
        log_error(LOG_FILE_NAME, "%s decode failed!", msgType)
        return ret
    end
    
    for k, v in pairs(decode) do
        -- 嵌套
        if type(v) == "table" and 
            #v == 2 and 
            type(v[1]) == "string" and 
            protobuf.check(v[1]) 
        then
            ret[k] = ParseMsgType(v[1], v[2])
        -- repeated
        elseif type(v) == "table" then
            local ret2 = {}
            for k1, v1 in pairs(v) do
                --嵌套
                if type(v1) == "table" and 
                    #v1 == 2 and 
                    type(v1[1]) == "string" and 
                    protobuf.check(v1[1]) 
                then
                    ret2[k1] = ParseMsgType(v1[1], v1[2])
                else
                    ret2[k1] = v1
                end
            end
            ret[k] = ret2
        else
            ret[k] = v
        end
    end
    return ret
end

-- 发往服务器的消息容器
local serverMsgList         = {}            -- 消息队列
CMsgRegister.ServerMsgList  = serverMsgList -- 消息队列

function PrintMsgSendResult(nMsgId, result)
    if DEBUG ~= 0 then
        if FilterMsgID.ShowLog(nMsgId) then
            local _str = string.format("发送消息:%d,消息类型:%s,发送结果:%s", nMsgId, MSGTYPE[nMsgId] or "本地", MSG_SED_RSSULT_TYPE[result])
            print(_str)
        end
    end
end

-- =========================================================================
-- 发送服务器消息
-- bHigh:高优先级消息标识（登录消息使用）,否则ActSend()时才真正发送
-- =========================================================================
function SendMsgToServer(msgId, sendData, bHigh)
    local msg_proto_name = MSGTYPE[msgId] or ""
    if FilterMsgID.ShowLog(msgId) then
        dump(sendData, "===========【发送】消息数据:"..", 消息ID:"..msgId.."===========\nproto:"..msg_proto_name.."", 10)
    end
    local pData = protobuf.encode(MSGTYPE[msgId], sendData)
    local length = #pData
    if bHigh then
        local _result = CCommunicationAgent:GetInstance():SendMsgToServer(msgId, pData, length)
        if DEBUG ~= 0 then
            if _result == 0 then
                PrintMsgSendResult(msgId, _result)
            else
                log_error(LOG_FILE_NAME, "发送消息:%d,消息类型:%s,发送结果:%s",msgId,  MSGTYPE[msgId], MSG_SED_RSSULT_TYPE[_result])
            end
        end
    else
        table.insert(serverMsgList, {id = msgId, data = pData, len = length, hasSend = false})
    end
end

-- =========================================================================
-- 发送udp消息到服务器
-- =========================================================================
function SendUDPMsgToServer(msgId, sendData)
    local msg_proto_name = MSGTYPE[msgId] or ""
    dump(sendData, "===========【发送UDP】消息数据:"..", 消息ID:"..msgId.."===========\nproto:"..msg_proto_name.."", 10)
    local pData = protobuf.encode(MSGTYPE[msgId], sendData)
    local length = #pData
    local _result = CCommunicationAgent:GetInstance():SendUDPMsgToServer(msgId, pData, length)
    if DEBUG ~= 0 then
        if _result == 0 then
            PrintMsgSendResult(msgId, _result)
        else
            log_error(LOG_FILE_NAME, "发送UDP消息:%d,消息类型:%s,发送结果:%s",msgId,  MSGTYPE[msgId], MSG_SED_RSSULT_TYPE[_result])
        end
    end
end

-- =========================================================================
-- LuaLogic中每帧调用
-- =========================================================================
function CMsgRegister.SendToServer()
    if #serverMsgList <= 0 then
        return
    end

    if not NetManager:GetInstance():IsConnect() then
        return
    end
    
    -- 每帧发n个包
    for i, msgSend in ipairs(serverMsgList) do
        if msgSend then
            local _result = CCommunicationAgent:GetInstance():SendMsgToServer(msgSend.id, msgSend.data, msgSend.len)
            if _result == 0 then
                PrintMsgSendResult(msgSend.id, _result)
            else
                log_error(LOG_FILE_NAME, "发送消息:%d,消息类型:%s,发送结果:%s", msgSend.id,  MSGTYPE[msgSend.id],  MSG_SED_RSSULT_TYPE[_result])
            end
        end
    end
    serverMsgList = {}
end

-- 消息处理函数列表
CMsgRegister.MsgHandlerList = {}

-- =========================================================================
-- 注册消息监听函数
-- =========================================================================
function CMsgRegister:AddMsgListenerHandler(msg_id, handler, class_name)
    assert(msg_id, "msg_id 参数错误")
    assert(handler, "handler 参数错误")
    assert(class_name, "class_name 参数错误")
    local key = msg_id.."_"..class_name or "default"
    local msg_name = MSGTYPE[msg_id]
    local msg_source = MsgScource(msg_id)

    if msg_name == nil and msg_source == MSGSOURCE.SC then
        print("CMsgRegister:AddMsgListenerHandler 找不到对应的消息号的proto: ", msg_id)
        return
    end
    if self.MsgHandlerList[msg_id] == nil then
        self.MsgHandlerList[msg_id] = {}
    end
    local handler_list = self.MsgHandlerList[msg_id]
    handler_list[key] = handler
end

-- =========================================================================
-- 注销消息监听函数
-- =========================================================================
function CMsgRegister:RemoveMsgListenerHandler(msg_id, class_name)
    assert(msg_id, "msg_id 参数错误")
    assert(class_name, "class_name 参数错误")
    local msg_name = MSGTYPE[msg_id]
    local msg_source = MsgScource(msg_id)

    if msg_name == nil and msg_source == MSGSOURCE.SC then
        print("CMsgRegister:ClearMsgListenerHandler 找不到对应的消息号为: ", msg_id)
    end
    if self.MsgHandlerList[msg_id] == nil then
        return
    end
    local key = msg_id.."_"..class_name or "default"
    local handler_list = self.MsgHandlerList[msg_id]
    handler_list[key] = nil
end

-- =========================================================================
-- 清空消息注册的所有监听函数
-- =========================================================================
function CMsgRegister:ClearAllMsgListenerHandler()
    self.MsgHandlerList[msg_name] = nil
end

-- =========================================================================
-- 解析消息并调用注册的监听函数
-- =========================================================================
function ParseMsgAndCallMsgHandler(nMsgId, data, len)
    local msg_source     = MsgScource(nMsgId)
    local msg_content    = {}
    local msg_proto_name = MSGTYPE[nMsgId] or "本地"
    
    if msg_source == MSGSOURCE.SC then
        msg_content = ParseMsgId(nMsgId, data, len)
        if FilterMsgID.ShowLog(nMsgId) then
            if DEBUG ~= 0 then
                dump(msg_content, "===========【接收】服务器消息数据:"..", 消息ID:"..nMsgId.."===========\nproto:"..msg_proto_name.."", 10)
            end
        end
    elseif msg_source == MSGSOURCE.CC then
        msg_content = DeserializeFromStr(data)
        if FilterMsgID.ShowLog(nMsgId) then
            if DEBUG ~= 0 then
                dump(msg_content or {}, "===========【接收】本地消息数据:"..", 消息ID:"..nMsgId..":"..msg_proto_name.."===========", 10)
            end
        end
    end
    local handler_list = CMsgRegister.MsgHandlerList[nMsgId]
    if handler_list ~= nil then
        for k, call_back in pairs(handler_list) do
            call_back(msg_content)
        end
    end
    
    return msg_content
end

-- =========================================================================
-- 清楚所有没有发送出去的消息
-- =========================================================================
function CMsgRegister.ClearMsgList()
    serverMsgList = {}
end

-- 消息功能分类
MSGFUNC = 
{
    CONNECT        = 1,       --连接服务器相关
    UI             = 2,       --UI
    FIGHTMGR       = 3,       --战斗功能
    LOGIN          = 100,     --登录功能
    PROXY          = 925      --代理消息
}


-- 消息类型[ 对应proto ]
MSGTYPE = 
{
    -- 所有的消息类型已经用工具自动生成并合并到此table    
}               

--[[
    客户端与客户端消息通信 手动注册枚举
    客户端与服务器消息通信 都采用工具生产 自动合并到 MSGID table中
    服务器与客户端消息通信 都采用工具生产 自动合并到 MSGID table中
--]]
-- 消息ID
MSGID = 
{
    --连接服务器相关:MSGFUNC.CONNECT
    CC_CONNECT_SUCCESS                           = 001401,    --连接成功
    CC_CONNECT_FAILED                            = 001402,    --连接失败
    CC_CONNECT_BREAK                             = 001403,    --连接断开
    CC_SEND_SUCCESS                              = 001404,    --服务器消息发送成功
    
    CC_SDK_PAYCALLBACK                           = 001405,    --充值回调
    CC_SDK_GETPAYLISTCALLBACK                    = 001406,    --获取的充值列表
    CC_SDK_LOGINSUCCESS                          = 001407,    --登录成功
    CC_SDK_LOGINCANCEL                           = 001408,    --小退出游戏
    CC_SDK_PLATFORMTOGAMELOGOUT                  = 001409,    --注销账号功能
    
    --UI功能:MSGFUNC.UI
    CC_OPEN_UI                                   = 002401,    --打开UI
    CC_CLOSE_UI                                  = 002402,    --关闭UI
    CC_SHOW_TIPS                                 = 002403,    --显示tips
    
    CC_LOGIN_OPEN_CREATEROLEUI                   = 100401,    --打开创建角色界面消息
    CC_LOGIN_CLOSE_CREATEROLEUI                  = 100402,    --关闭创建角色界面消息
    CC_CHANGE_WORLD                              = 100403,    --改变世界

   
 }

-- 注册pb(已经通过工具生成)