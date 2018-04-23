-- [[
-- Copyright (C), 2015, 
-- 文 件 名: CameraFollow.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-07
-- 完成日期: 
-- 功能描述: 相机跟随
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CCameraFollow.log'

CCameraFollow = {}
CCameraFollow.__index = CCameraFollow

function CCameraFollow:Create()
	local o = {}
	setmetatable(o, CCameraFollow)
	o.m_pOriginalTarget = nil      -- 跟随者
	o.m_pFollowTarget   = nil      -- 被跟随者
	o.m_pRect 	        = nil 	   -- 跟随范围
	o.m_pFollowAction   = nil      -- 跟随动作
	return o
end

-- 设置本体对象
function CCameraFollow:SetOriginalTarget( obj )
	assert(obj)
	self.m_pOriginalTarget = obj
end

-- 设置被跟随的对象
function CCameraFollow:SetFollowTarget( obj )
	assert(obj)
	self.m_pFollowTarget = obj
end

-- 跟随范围(cc.rect)
function CCameraFollow:SetRect( rect )
	self.m_pRect = rect
end

-- 跟随
function CCameraFollow:Follow()
	if self.m_pOriginalTarget and  self.m_pFollowTarget then
		self.m_pFollowAction = CCFollow:create(self.m_pFollowTarget, self.m_pRect or cc.rect(0,0))
		if self.m_pFollowAction then
			self.m_pOriginalTarget:runAction(self.m_pFollowAction)
		else
			log_error(LOG_FILE_NAME, "创建跟随动作失败！")
		end
	else
		log_error(LOG_FILE_NAME, "跟随者或者被跟随者未设置")
	end
end

-- 取消跟随
function CCameraFollow:StopFollow()
	if self.m_pOriginalTarget and self.m_pFollowAction then
		self.m_pOriginalTarget:stopAction(self.m_pFollowAction)
	else
		log_error(LOG_FILE_NAME, "取消跟随动作失败!")
	end
end


function CCameraFollow:StartFollow()
	if self.m_pOriginalTarget and self.m_pFollowAction then
		self.m_pOriginalTarget:runAction(self.m_pFollowAction)
	else
		log_error(LOG_FILE_NAME, "取消跟随动作失败!")
	end
end


function CCameraFollow:CalcBorder()
	if self.m_pFollowTarget then
		local _mapSize     = CMapManager:GetInstance():GetMapSize()
		local _mapTileSize = CMapManager:GetInstance():GetMapTileSize()
		local _width = _mapSize.width * _mapTileSize.width
		local _height = _mapSize.height * _mapTileSize.height
		local _originalPosX = self.m_pFollowTarget:getPositionX()
		local _originalPosY = self.m_pFollowTarget:getPositionY()
		local _winSize = cc.Director:getInstance():getVisibleSize()
		if _originalPosX <= _winSize.width * 0.5 then
			print("水平超出边界")
			self:StopFollow()
		else
			self:StartFollow()
		end

		if _originalPosY <= _winSize.height * 0.5 then
			print("垂直超出边界")
			self:StopFollow()
		else
			self:StartFollow()
		end
	end
end

-- 销毁
function CCameraFollow:Destroy()
	self.m_pOriginalTarget  = nil      -- 跟随者
	self.m_pFollowTarget    = nil      -- 被跟随者
	self.m_pRect 	        = nil 	   -- 跟随范围
	self.m_pFollowAction    = nil      -- 跟随动作
end