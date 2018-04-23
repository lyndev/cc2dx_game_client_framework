--[[
-- Copyright (C), 2015, 
-- 文 件 名: WidgetManager.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-02-25
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CWidgetManager.log'

CWidgetManager = {}
CWidgetManager.__index = CWidgetManager
CWidgetManager._instance = nil

function CWidgetManager:New()
    local o = {}
    o.m_pWidgetRoot = cc.Node:create()
    setmetatable( o, CWidgetManager )
    return o
end

function CWidgetManager:GetInstance( msg )
    if not CWidgetManager._instance then
        CWidgetManager._instance = self:New()
        CWidgetManager._instance:Init()
    end
    return  CWidgetManager._instance
end

function CWidgetManager:Init(param)
	local _scn = GameScene:GetUILayer()
	if _scn then
		_scn:addChild(self.m_pWidgetRoot, 9999)
	else
		log_error("添加UI主节点失败, 场景没找到")
	end
end

function CWidgetManager:AddChild(node, layerType)
	if node then
		if layerType == ENUM.LAYE_TYPE.UISCENE then
			local _uiNode = GameScene:GetSceneLayer()
			_uiNode:addChild(node)
		elseif layerType == ENUM.LAYE_TYPE.SPRITE then
			local _uiNode = GameScene:GetElementLayer()
			_uiNode:addChild(node)
        elseif layerType == ENUM.LAYE_TYPE.UINotice then
            local _uiNode = GameScene:GetNoticeUILayer()
            _uiNode:addChild(node)
        elseif layerType == ENUM.LAYE_TYPE.UITips then
            local _uiNode = GameScene:GetTipsUILayer()
            _uiNode:addChild(node)
        elseif layerType == ENUM.LAYE_TYPE.Guide then
            local _uiNode = GameScene:GetGuideUILayer()
            _uiNode:addChild(node)
		else
            local _uiNode = GameScene:GetUILayer()
            _uiNode:addChild(node)
		end
	end
end

function CWidgetManager:GetUIRoot()
	return self.m_pWidgetRoot
end

function CWidgetManager:RemoveChildByObj( obj )

end

function CWidgetManager:Destroy()
    CWidgetManager._instance = nil
end
