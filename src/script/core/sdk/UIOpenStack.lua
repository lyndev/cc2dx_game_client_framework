CUIOpenStack = {}
CUIOpenStack.__index = CUIOpenStack
CUIOpenStack._instance = nil

local LOG_FILE_NAME = "CUIOpenStack.log"

-- 栈顶UI操作类型
local EOperatorType = 
{
    NONE         = 0,                                               -- 不做任何操作
    OPEN         = 1,                                               -- 打开
    CLOSE        = 2,                                               -- 关闭
    HIDE         = 3,                                               -- 隐藏
    SHOW         = 4,                                               -- 显示
}

CUIOpenStack.EOperatorType = EOperatorType

function CUIOpenStack:GetInstance()
    if nil == CUIOpenStack._instance then
        local o = {}
        setmetatable(o, CUIOpenStack)

        o.stack        = {}                                         -- UI栈
        o.stack.uiList = {}                                         -- UI打开相关参数
        o.stack.nTop   = 0                                          -- 栈顶
        o.m_tRecordUIState = {}
        CUIOpenStack._instance = o
    end

    return CUIOpenStack._instance
end

-- 函数功能: UI层级打开管理销毁
function CUIOpenStack:Destroy()
    if not CUIOpenStack._instance then
        return
    end

    CUIOpenStack._instance  = nil
end

-- 函数功能: 打开栈顶UI
function CUIOpenStack:OpenTopStackUI()
    -- 空栈
    if self.stack.nTop <= 0 then
        return
    end

    -- 打开栈顶UI
    local topUI = self.stack.uiList[self.stack.nTop]
    if topUI then

        -- 打开栈顶UI
        local msg = {}
        msg.name = topUI.name
        msg.bNotPush = true
        if topUI.param then
            for k, v in pairs(topUI.param) do
                msg[k] = v
            end
        end

        -- UI打开
        local buf = SerializeToStr(msg)
        SendLocalMsg(MSGID.CC_OPEN_UI, buf, string.len(buf))
    else
        log_error(LOG_FILE_NAME, "stack top ui is empty")
    end
end

-- 函数功能: 关闭栈顶UI
function CUIOpenStack:CloseTopStackUI()
    -- 空栈
    if self.stack.nTop <= 0 then
        return
    end

    -- 关闭栈顶UI
    local topUI = self.stack.uiList[self.stack.nTop]
    if topUI then
        SendLocalMsg(MSGID.CC_CLOSE_UI, topUI.name, string.len(topUI.name))
    else
        log_error(LOG_FILE_NAME, "stack top ui is empty")
    end
end

-- 函数功能: 影藏栈顶UI
function CUIOpenStack:SetTopStackUIHIDE()
    -- 空栈
    if self.stack.nTop <= 0 then
        return
    end

    -- 关闭栈顶UI
    local topUI = self.stack.uiList[self.stack.nTop]
    if topUI then
        local pTopUI = CUIManager:GetInstance():GetUIByName(topUI.name)
        if pTopUI then
            pTopUI:SetVisible(false)
        end
    else
        log_error(LOG_FILE_NAME, "stack top ui is empty")
    end
end

-- 函数功能: 影藏栈顶UI
function CUIOpenStack:SetTopStackUISHOW()
    -- 空栈
    if self.stack.nTop <= 0 then
        return
    end

    -- 关闭栈顶UI
    local topUI = self.stack.uiList[self.stack.nTop]
    if topUI then
        local pTopUI = CUIManager:GetInstance():GetUIByName(topUI.name)
        if pTopUI then
            pTopUI:SetVisible(true)
        else
            OpenUI(topUI.name)
        end
    else
        log_error(LOG_FILE_NAME, "stack top ui is empty")
    end
end


-- 函数功能: 打开UI压栈
-- 参    数: 
--  [IN] strUIName: UI名称
--  [IN] openParam: UI打开参数
function CUIOpenStack:PushUIStack(strUIName, openParam, eType)
    -- 参数
    if "string" ~= type(strUIName) or (openParam and "table" ~= type(openParam)) then
        log_error(LOG_FILE_NAME, "invalid param "..type(strUIName)..","..type(openParam))
        return
    end

    -- 是否已压栈
    local topUI = nil 
    if self.stack.nTop > 0 then
        topUI = self.stack.uiList[self.stack.nTop]
        if topUI then
            if strUIName == topUI.name then
                return
            end
        end
    end

    -- 关闭或隐藏栈顶UI
    if nil == eType or eType == CUIOpenStack.EOperatorType.CLOSE then
        self:CloseTopStackUI()
    elseif eType and eType == CUIOpenStack.EOperatorType.HIDE then
        self:SetTopStackUIHIDE()
    end

    -- 压栈
    local tmpUI = {}
    tmpUI.name = strUIName
    tmpUI.param = openParam
    self.stack.nTop = self.stack.nTop + 1
    self.stack.uiList[self.stack.nTop] = tmpUI
end

-- 函数功能: 更新栈顶UI打开参数
-- 参    数: 
--  [IN] strUIName: UI名称
--  [IN] openParam: UI打开参数
function CUIOpenStack:UpdateTopUIStack(strUIName, openParam)
    if "string" ~= type(strUIName) or (openParam and "table" ~= type(openParam)) then
        log_error(LOG_FILE_NAME, "invalid param "..type(strUIName)..","..type(openParam))
        return
    end

    -- 空栈
    if self.stack.nTop <= 0 then
        log_error(LOG_FILE_NAME, "stack is empty")
        return
    end

    -- 栈顶更新
    local topUI = self.stack.uiList[self.stack.nTop]
    if not topUI then
        log_error(LOG_FILE_NAME, "top stack is nil")
        return
    end

    if strUIName == topUI.name then
        topUI.param = openParam
    end
end

-- 函数功能: 关闭UI出栈
-- 参    数: 
--  [IN] strUIName: UI名称
function CUIOpenStack:PopUIStack(strUIName, eType)
    -- 空栈
    if self.stack.nTop <= 0 then
        log_error(LOG_FILE_NAME, "self.stack is empty")
        return
    end

    -- 栈顶
    local topUI = self.stack.uiList[self.stack.nTop]
    if not topUI then
        log_error(LOG_FILE_NAME, "top stack is empty")
        return
    end

    if strUIName == topUI.name then

        -- 出栈
        self.stack.uiList[self.stack.nTop] = nil
        self.stack.nTop = self.stack.nTop - 1
        if 0 > self.stack.nTop then
            uiOpenStack.nTop = 0
        end

        -- 打开或显示栈顶UI
        if nil == eType or eType == CUIOpenStack.EOperatorType.OPEN then
            self:OpenTopStackUI()
        elseif eType and eType == CUIOpenStack.EOperatorType.SHOW then
            self:SetTopStackUISHOW()
        end
    else
        log_error(LOG_FILE_NAME, strUIName.." not top stack ui")
    end
end

function CUIOpenStack:RecordUIState()
    for k, v in pairs(self.stack.uiList) do
        if v and v.name then
            local _pUI = CUIManager:GetInstance():GetUIByName(v.name)
            local _bShow = _pUI:IsVisible()
            self.m_tRecordUIState[v.name] = _bShow
        end
    end
end

function CUIOpenStack:RecoverRecordUIState()
    for k, v in pairs(self.m_tRecordUIState) do
        if k then
            local _pUI = CUIManager:GetInstance():GetUIByName(k)
            if _pUI then
                _pUI:SetVisible(v)                    
            end
        end
    end
    self.m_tRecordUIState = {}
end


-- 函数功能: 获取栈顶UI
function CUIOpenStack:GetTopStackUI()
    -- 空栈
    if self.stack.nTop <= 0 then
        return
    end

    -- 栈顶UI
    return self.stack.uiList[self.stack.nTop]
end

-- 函数功能: 获取对应打开栈类型 
-- 参    数: 无
-- 返 回 值: 无
-- 备    注:
function CUIOpenStack:GetMappingType( nCurType )
    if nCurType == EOperatorType.NONE then
        return EOperatorType.NONE
    elseif nCurType == EOperatorType.CLOSE then
        return EOperatorType.OPEN
    elseif nCurType == EOperatorType.HIDE then
        return EOperatorType.SHOW
    end
    return nil
end


function CUIOpenStack:OperatorAllUI(eType)
    for k, v in pairs(self.stack.uiList) do
        if v and v.name then
            local _pUI = CUIManager:GetInstance():GetUIByName(v.name)
            if _pUI then
                if eType == CUIOpenStack.EOperatorType.CLOSE then
                    CloseUI(v.name)
                elseif  eType == CUIOpenStack.EOperatorType.HIDE then
                    _pUI:SetVisible(false)
                elseif eType == CUIOpenStack.EOperatorType.OPEN then
                    OpenUI(v.name)
                elseif  eType == CUIOpenStack.EOperatorType.SHOW then
                    _pUI:SetVisible(true)
                end 
            end
        end
    end
end

--功能: 关闭到指定UI
--参数: strUIName, eType:操作类型
--返回: 无
--备注: 
function CUIOpenStack:CloseAppointUI( strUIName, eType)
    -- 空栈
    if self.stack.nTop <= 0 then
        log_error(LOG_FILE_NAME, "self.stack is empty")
        return
    end
    -- 栈顶
    local topUI = self.stack.uiList[self.stack.nTop]
    if not topUI then
        log_error(LOG_FILE_NAME, "top stack is empty")
        return
    end
    while topUI.name ~= strUIName do
        self:CloseTopStackUI()
        self.stack.uiList[self.stack.nTop] = nil
        self.stack.nTop = self.stack.nTop - 1
        topUI = self.stack.uiList[self.stack.nTop]
        if not topUI then
            break
        end
    end
    if eType and eType == CUIOpenStack.EOperatorType.CLOSE then
        self:CloseTopStackUI()
    elseif eType and eType == CUIOpenStack.EOperatorType.HIDE then
        self:SetTopStackUIHIDE()
    elseif eType == CUIOpenStack.EOperatorType.OPEN then
        self:OpenTopStackUI()
    elseif eType and eType == CUIOpenStack.EOperatorType.SHOW then
        self:SetTopStackUISHOW()
    end
end
