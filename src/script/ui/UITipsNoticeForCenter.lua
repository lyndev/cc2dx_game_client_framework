--[[
-- Copyright (C), 2015, 
-- 文 件 名: UITipsNoticeForCenter.lua
-- 作    者: 
-- 版    本: V1.0.0
-- 创建日期: 2016-04-29
-- 完成日期: 
-- 功能描述: 通用提示框
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUITipsNoticeForCenter.log'

CUITipsNoticeForCenter = CreateClass(UIBase)

-- //////////////////// UI名字宏 ////////////////////
local UI_PANEL_NAME = 'csb/ui_tips_notice_center.csb'

-- ////////////////// UI用到的资源宏/////////////////
local UI_PLIST_NAME = 'plist/ui_editor_main.plist'

local ONE_LINE_WIDTH  = 600



-- 返 回 值: 无
-- 备    注:
function CUITipsNoticeForCenter:Create(msg)
	local o = {}
	setmetatable( o, CUITipsNoticeForCenter)
	o.m_pRootForm = nil
	return o
end

function CUITipsNoticeForCenter:Init(msg)
    CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)
	self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
    	log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
    	return
    end
    self.m_pRootForm:move(VISIBLE_WIDTH() * 0.5, VISIBLE_HEIGHT() * 0.5 )
    self:setNoticeData(msg)

  	return true
end

--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUITipsNoticeForCenter:setNoticeData( msg )
    local _noticeData = msg.messageData or ""
    CWidgetManager:GetInstance():AddChild(self.m_pRootForm, ENUM.LAYE_TYPE.UITips)

    -- 显示内容
    local _data = _noticeData
    local _textContent = FindNodeByName( self.m_pRootForm, "text_content")
    if _textContent then

        -- 背景图缩放
        local _ImgBg = FindNodeByName(self.m_pRootForm, "img_bg")
        local FONT_SIZE = 20
        local _tWords, _wordsWidth = GetLayoutWords(_data, ONE_LINE_WIDTH, FONT_SIZE)
        local _width = 0
        local _height = 0
        if _textContent then  
            -- 重新组装文字
            local _newContent = ""
            local _line = #_tWords
            for i, v in ipairs(_tWords) do
                _newContent = _newContent .. v 
                if #_tWords > 1 then
                    _newContent = _newContent .. "\n"
                end
            end 
            _textContent:setString(_newContent)
            if _ImgBg then
        
                _height = _ImgBg:getContentSize().height
                if _line > 1 then
                    _width = ONE_LINE_WIDTH + 30
                    _height = 60 + _line * 20
                else
                    _width = _wordsWidth + 30
                    if _width < 70 then
                        _width = 70
                    end
                end
                _ImgBg:setContentSize(cc.size(_width * 0.8, _height))
            end
        end  
    end

    -- 运行动画
    local _toPosX, _toPosY = VISIBLE_WIDTH() * 0.5, VISIBLE_HEIGHT() * 0.5 + 200
    if self.m_pRootForm then
      local _destoryLayerCb = function()
          CloseUI("CUITipsNoticeForCenter")
      end
      self.m_pRootForm:runAction(cc.Sequence:create(
            cc.FadeIn:create(0.2),
            cc.DelayTime:create(1.5),
            cc.CallFunc:create(_destoryLayerCb)
        ))
    end
end

function CUITipsNoticeForCenter:OnDestroy()
    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm = nil
    end
    CPlistCache:GetInstance():ReleasePlist(UI_PLIST_NAME)
end
	