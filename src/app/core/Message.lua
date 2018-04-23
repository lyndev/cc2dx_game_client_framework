-- =========================================================================
-- 文 件 名: Message.lua
-- 作    者: lyn
-- 创建日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- =======================================================================

-- 日志文件名
local LOG_FILE_NAME = 'Message.log'

require("IMessage")
Message = class("Message", IMessage)

function Message:create(name, body, type)
	local self = {}
	setmetatable(self, Message)
	self.m_name = name
	self.m_body = body
	self.m_type = type
end

function Message:toString()
	local msg = "Notification Name: "..Name
	msg = msg.. "\nBody:" ..self.m_body:toString())
	msg = msg.. "\nType:" ..self.m_type)
	return msg
end

function Message:getName()
	return self.m_name
end

function Message:getBody()
	return self.m_body
end

function Message:getType()
	return self.m_type
end

function Message:setName(name)
	self.m_name = name
end

function Message:setBody(body)
	self.m_body = body
end

function Message:setType(type)
	self.m_type = type
end