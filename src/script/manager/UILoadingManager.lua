--[[
-- Copyright (C), 2016, 
-- 文 件 名: UILoadingManager.lua
-- 作    者: 
-- 版    本: V1.0.0
-- 创建日期: 2016-03-3
-- 完成日期: 
-- 功能描述:异步预加载
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUILoadingManager.log'

-- //////////////////// UI名字宏 ////////////////////
local UI_PANEL_NAME = 'ui/ui_login_loading.csb'

-- ////////////////// UI用到的资源宏/////////////////
local UI_PLIST_NAME = 'ui/.plist'

CUILoadingManager = {}
CUILoadingManager.__index = CUILoadingManager 
CUILoadingManager._instance = nil
 
 
function CUILoadingManager:New()
    local o = {}
    o.m_pRootForm = nil
    o.m_tData     = {}        -- 要加载资源数据的表
    o.m_nNumber   = 0         -- 要加载资源数据的个数
    o.m_pLoaingAnimation = nil
    setmetatable( o, CUILoadingManager )
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 得到单例
-- 参    数: m_callBack 加载一个资源的回调  m_finishEvent 加载资源完成后的回调
-- 返 回 值: 返回单例
-- 备    注:
-- ]]
function CUILoadingManager:GetInstance()
    if not CUILoadingManager._instance then
        CUILoadingManager._instance = self:New()
    end

    -- 打开UI事件
    gPublicDispatcher:AddEventListener( CEvent.Loading.OpenLoadUI, self, self.OpenUI )

    -- 设置加载进度条事件
    gPublicDispatcher:AddEventListener( CEvent.Loading.LoadCallBack, self, self.SetLoadingBarPercent )

    -- 关闭UI事件
    gPublicDispatcher:AddEventListener( CEvent.Loading.CloseLoadUI, self, self.OnLoadingFinish )

    return  CUILoadingManager._instance
end

function CUILoadingManager:OpenUI( event )
    --CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)

    if self.m_pRootForm == nil then
    	self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
        if not self.m_pRootForm then
        	log_error(LOG_FILE_NAME, '['..CUILoadingManager..']'.." Not Found!")
        	return
        end
        CWidgetManager:GetInstance():AddChild(self.m_pRootForm)

        -- 背景适配
        local _imgBg = FindNodeByName(self.m_pRootForm, "img_bg")
        if _imgBg then
            BackGroundImg(_imgBg)
        end 
        AdapterUIRoot(self.m_pRootForm)
        self.m_pLoadingBar = FindNodeByName(self.m_pRootForm, "loadingBar")
        self.m_fPercent = 0
        if self.m_pLoadingBar then
            self.m_pLoadingBar:setPercent(0)
            self:UpdateLoadingBarPos()
        else
            log_error(LOG_FILE_NAME,"进度条获取失败")
        end

        -- 小提示刷新显示
        local _TextTip = FindNodeByName(self.m_pRootForm, "text_tip")
        if _TextTip then
            local _loadingTextLanguage = Q_Global.GetTempData(23, 'q_string_value')
            local _LoadingLanguageTab = StrSplit(_loadingTextLanguage, "|")
            if _LoadingLanguageTab then
                local updataTipText_ = function ()
                    local _randNum = math.random(1, #_LoadingLanguageTab)
                    local _tipContent = Language(_LoadingLanguageTab[_randNum])
                    if _tipContent then
                        _TextTip:setString(tostring(Language(305).._tipContent))
                    end
                end
                local _action = cc.Sequence:create(cc.CallFunc:create(updataTipText_), cc.DelayTime:create(1.0))
                _TextTip:runAction(cc.RepeatForever:create(_action))
            end
        end

        -- 加载的显示
        local _TextLoadingState = FindNodeByName(self.m_pRootForm, "text_loading_state")
        if _TextLoadingState then
            local _LoadingStateStr = Language(301) or nil
            if _LoadingStateStr then
                _TextLoadingState:setString(_LoadingStateStr)
            end
        end
    else
        self.m_pRootForm:show()
    end
	return true
end

--[[
-- 函数类型: public
-- 函数功能: 加载完成后 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUILoadingManager:UpdateLoadingState()
    local _TextLoadingState = FindNodeByName(self.m_pRootForm, "text_loading_state")
    if _TextLoadingState then
        local _LoadingStateStr = Language(302) or nil
        if _LoadingStateStr then
            _TextLoadingState:setString(_LoadingStateStr)
        end
    end
end

--[[
-- 函数类型: private
-- 函数功能: 加载一个资源成功后的回调
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUILoadingManager:SetLoadingBarPercent( event )
    local _percent = 0
    if event.percent then
        _percent = event.percent
    end
    if _percent < 100 then
        self.m_pLoadingBar:setPercent(_percent)
    else
        self.m_pLoadingBar:setPercent(100)
        self:UpdateLoadingState()
    end
    self:UpdateLoadingBarPos()
end

--[[
-- 函数类型: public
-- 函数功能: 更新进度条动画位置 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUILoadingManager:UpdateLoadingBarPos()

    -- 设置进度条动画
    if self.m_pLoaingAnimation == nil then
        self.m_pLoaingAnimation =  CAnimationCreateManager:GetInstance():CreateEffectByID(12106)
        if self.m_pLoaingAnimation then
            self.m_pLoaingAnimation:AddTo(self.m_pLoadingBar)
            self.m_pLoaingAnimation:Play(true)
        end
    end
    if self.m_pLoaingAnimation and self.m_pLoaingAnimation:GetShow() then
        self.m_pLoaingAnimation:GetShow():setPosition(cc.p(self.m_pLoadingBar:getPercent() / 100 * self.m_pLoadingBar:getContentSize().width, self.m_pLoadingBar:getContentSize().height * 0.5))
    end
end

--[[
-- 函数类型: public
-- 函数功能: 加载完后UI的处理
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUILoadingManager:OnLoadingFinish(event)
    if self.m_pRootForm then
        self.m_pRootForm:hide()
    end
    if self.m_pLoadingBar then
        self.m_pLoadingBar:setPercent(0)
    end
    if self.m_pLoaingAnimation then
        CAnimationCreateManager:GetInstance():RemoveEffect(self.m_pLoaingAnimation:GetInstanceID())
        self.m_pLoaingAnimation = nil
    end
end

-- [[
-- 函数类型: public
-- 函数功能: 销毁单例
-- 参    数: 无
-- 返 回 值: 
-- 备    注:
-- ]]
function CUILoadingManager:Destroy()

    -- 移除特效
    if self.m_pLoaingAnimation then
        CAnimationCreateManager:GetInstance():RemoveEffect(self.m_pLoaingAnimation:GetInstanceID())
        self.m_pLoaingAnimation = nil
    end
    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
    gPublicDispatcher:RemoveEventListenerObj(self)
    
    CUILoadingManager._instance = nil
end
