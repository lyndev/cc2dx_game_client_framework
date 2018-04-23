-- =========================================================================
-- 文 件 名: UIFightZJH.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-06-04
-- 完成日期:  
-- 功能描述: 炸金花战斗界面
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'CUIFightZJH.lua.log'

CUIFightZJH = CreateClass(UIBase)

-- UI资源路径
local UI_PANEL_NAME = 'res/res_zjh/csb/ui_fight_zjh.csb'
local UI_PLIST_NAME = 'ui/*'
local FULL_PEOPLE_COUNT = 7

local ACTION_TYPE = {
    NONE           = 0,         
    A_READY        = 1,      
    A_UNREADY      = 2,    
    A_ROBOT        = 3,      
    A_UNROBOT      = 4,    
    A_WAIT         = 5,       
    A_UNWAIT       = 6,     
    A_GIVE_UP      = 7,    
    A_LOOK_CARD    = 8,  
    A_OPEN_CARD    = 9,  
    A_COMPARE_CARD = 10,
    A_ADD_SCORE    = 11,   
    A_WAIT_COMPARE = 12,
    A_THINKING     = 13,    
}


function CUIFightZJH:Create(msg)
    local o = {}
    setmetatable(o, CUIFightZJH)
    o.m_pRootForm = nil
    return o
end

function CUIFightZJH:Init(msg)
    -- 加载plist
    --CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)
    
    self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
        log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
        return
    end

    gPublicDispatcher:AddEventListener(CEvent.PlayerEnterLeaveRoom, self, self.EventPlayerEnterLeaveRoom)

    -- 动作执行结果
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESACTION, function(msgData)
        self:OnActionMsgHandler(msgData)
    end, "CUIFightZJH")

    -- 即将执行的动作
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESWILLEXCUTEACTION, function(msgData)
        self:OnWillActionMsgHandler(msgData)
    end, "CUIFightZJH")

    -- 战斗结算
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESFIGHTRESULT, function(msgData)
        self:OnFightResultHandler(msgData)
    end, "CUIFightZJH")

    -- 战斗开始数据
    CMsgRegister:AddMsgListenerHandler(MSGID.SC_ROOM_RESGAMESTARTFIGHTDATA, function(msgData)
        self:OnGameStartFightDataHandler(msgData)
    end, "CUIFightZJH")

    -- 遮罩
    self.m_maskLayer = AddMaskLayer()
    self.m_maskLayer:retain()
    CWidgetManager:GetInstance():AddChild(self.m_maskLayer)
    
    local _bg = FindNodeByName(self.m_pRootForm, "bg")
    BackGroundImg(_bg)

    CWidgetManager:GetInstance():AddChild(self.m_pRootForm)
    self.m_pRootForm:retain()
    AdapterUIRoot(self.m_pRootForm)
    self:InitButtonEvent()
    self:InitNode()
    return true
end

function CUIFightZJH:GetRoot()
    return self.m_pRootForm
end


function CUIFightZJH:InitButtonEvent(msg)

    -- 准备
    self.m_readyBtn = FindNodeByName(self.m_pRootForm, "btn_ready")
    if self.m_readyBtn then
        AddButtonListener(self.m_readyBtn, function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                gFightMgr:ReqAction({action = ACTION_TYPE.A_READY})
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end

    -- 取消准备
    self.m_unReadyBtn = FindNodeByName(self.m_pRootForm, "btn_unready")
    if self.m_unReadyBtn then
        self.m_unReadyBtn:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
            local _fightState = gFightMgr:GetFightState()
            if _fightState ~= ENUM.GameFightState.Begin then
                sender:hide()
            end
                gFightMgr:ReqAction({action = ACTION_TYPE.A_UNREADY})
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end

    -- 换桌
    self.m_swapBtn = FindNodeByName(self.m_pRootForm, "btn_swap")
    if self.m_swapBtn then
        self.m_swapBtn :addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                --TODO:重置ui
                self:ClearDeskAndReadyNextFight()
                gFightMgr:ReqLeaveRoom(true)
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end
end

function CUIFightZJH:InitNode()
    self.m_headNode = {}
    for i = 1, FULL_PEOPLE_COUNT do
        self.m_headNode[i] = FindNodeByName(self.m_pRootForm, "node_head_"..i)
    end
end

function CUIFightZJH:GetHeadNode(uiIndex)
    return self.m_headNode[uiIndex]
end

function CUIFightZJH:OnActionMsgHandler(msgData)
    local _action = msgData.actions
    if _action then
        local _actionType = _action.actionType
        local _roleId = _action.roleId
        local _location = _action.locationIndex
        local _uiIndex = self:GetUIRelativeIndex(_location)
        function IsMineAction()
            if _roleId == _mineroleId then
                return true
            end
            return false
        end
        if _actionType == ACTION_TYPE.A_READY then
            if IsMineAction() then
                self:ClearDeskAndReadyNextFight()
                self:ShowFightBeignButtonState(false, true)
                self:ShowUnreadyCountDown()
            end
            self:ShowPlayerReadyFlag(_uiIndex, true) 
        elseif _actionType == ACTION_TYPE.A_UNREADY then
            self:ShowPlayerReadyFlag(_uiIndex, false)
            if IsMineAction() then
                self:ShowFightBeignButtonState(false, false)
            end
        elseif _actionType == ACTION_TYPE.A_ROBOT then

        elseif _actionType == ACTION_TYPE.A_UNROBOT then

        elseif _actionType == ACTION_TYPE.A_WAIT then

        elseif _actionType == ACTION_TYPE.A_UNWAIT then

        elseif _actionType == ACTION_TYPE.A_GIVE_UP then

        elseif _actionType == ACTION_TYPE.A_LOOK_CARD then

        elseif _actionType == ACTION_TYPE.A_OPEN_CARD then

        elseif _actionType == ACTION_TYPE.A_COMPARE_CARD then

        elseif _actionType == ACTION_TYPE.A_ADD_SCORE then

        elseif _actionType == ACTION_TYPE.A_WAIT_COMPARE then

        elseif _actionType == ACTION_TYPE.A_THINKING then

        end
    end
end


function CUIFightZJH:OnWillActionMsgHandler(msgData)
end

function CUIFightZJH:OnFightResultHandler(msgData)
end

function CUIFightZJH:OnGameStartFightDataHandler(msgData)
end

-- 清除桌面并恢复开局状态准备下一局
function CUIFightZJH:ClearDeskAndReadyNextFight()

end

function CUIFightZJH:EventPlayerEnterLeaveRoom(event)
    local _playerInfo = event.playerInfo
    local _uiIndex = self:GetUIRelativeIndex(_playerInfo.locationIndex)
    self:SetPlayerHeadInfo(self:GetHeadNode(_uiIndex), _playerInfo)
end

-- 根据头像节点和玩家信息设置
function CUIFightZJH:SetPlayerHeadInfo(headNode, playerInfo, bLeave)
    if not headNode then
        log_error(LOG_FILE_NAME, "SetPlayerHeadInfo headNode 为空")
        return
    end

    if bLeave then
        headNode:hide()
    else
        headNode:show()
        if playerInfo then
            local _roomType = gFightMgr:GetRoomType()
            local _coinSpNode = FindNodeByName(headNode, "sp_coin")

            -- 金币图标
            _coinSpNode:show()

            -- 金币/积分数量

            -- 名字
            local _txtName = FindNodeByName(headNode, "name")
            if _txtName then
                _txtName:setString(playerInfo.roleName)
            end

            -- 头像
            local _sp = UIWXHeadHelper:GetCircleHeadImg(playerInfo.uid, playerInfo.headerUrl, playerInfo.sex)
            self:SetHead(playerInfo.uid, _sp)

            -- 头像点击
            local btn_head = FindNodeByName(headNode, "btn_head")
            if btn_head then
                btn_head:addTouchEventListener(function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        OpenUI("CUIOtherPlayerInfo", nil, {roleId = playerInfo.uid})
                    end
                end)
            end
            
            -- 是否是vip
            local _vip = FindNodeByName(headNode, "vip")
            if playerInfo.vipLeftDay and playerInfo.vipLeftDay > 0 then
                _vip:show()
            else
                _vip:hide()
            end

            -- 战斗状态
            local _myRoleId = CPlayer:GetInstance():GetRoleID()
            local _fightState = gFightMgr:GetFightState()
            if _fightState == ENUM.GameFightState.Fighting then
                -- 准备状态
                self:ShowFightBeignButtonState(true, playerInfo.bReady)
                self:ShowPlayerReadyFlag(playerInfo.directionType, false)
            else
                -- 准备状态
                if _myRoleId == playerInfo.uid then
                    self:ShowFightBeignButtonState(false, playerInfo.bReady)
                end
                self:ShowPlayerReadyFlag(playerInfo.directionType,  playerInfo.bReady)
            end

        else
            if not playerInfo then
                log_error(LOG_FILE_NAME, "SetPlayerHeadInfo 玩家信息为空")
            end
        end
    end
end

function CUIFightZJH:GetUIRelativeIndex(index)
    local _mineroleId = CPlayer:GetInstance():GetRoleID()
    local _minePlayerInfo = gFightMgr:GetPlayer(_mineroleId)
    if _mineroleId == _minePlayerInfo.roleId then
        return 1
    else
        local _myIndex = _minePlayerInfo.locationIndex
        local _thatRelativeIndex = 1
        local _offsetIndex = FULL_PEOPLE_COUNT - _myIndex
        if index > _myIndex then
            _thatRelativeIndex = index - _myIndex
        else
            _thatRelativeIndex = index + _offsetIndex
        end
        return _thatRelativeIndex    
    end
end

-- 微信头像事件回调处理
function CUIFightZJH:EventSetPlayerHead(event)
    local _playerInfo = gFightMgr:GetPlayer(event.tag)
    if _playerInfo then
        local _sp = UIWXHeadHelper:GetCircleHeadImg(event.tag, -1)
        self:SetHead(_playerInfo.uid, _sp)
    end
end

function CUIFightZJH:SetZhuangFlag(index, bShow)
    local _head = self:GetHeadNode(index)
    if _head then
        local _zhuang = FindNodeByName(_head, "zhuang")
        if _zhuang then
            if bShow then
                _zhuang:show()
            else
                _zhuang:hide()
            end
        end
    else
        log_error(LOG_FILE_NAME, "SetZhuangFlag 获取玩家头像节点失败")
    end
end

-- 设置玩家头像
function CUIFightZJH:SetHead(roleId, sp)
    local _player = gFightMgr:GetPlayer(roleId)
    if _player then
        local _dirType = _player:GetDirection()
        local _headNode = self:GetHeadNode(_dirType)
        if _headNode then
            local _head = FindNodeByName(_headNode, "icon_node")
            if sp and _head then
                sp:addTo(_head)
            end
        end
    end
end

function CUIFightZJH:StartDealCard()
    for i = 1, 3 do
        for i = 0, (FULL_PEOPLE_COUNT - 1) do
           --TODO:发牌，从庄位置开发发
        end
    end
end

-- 设置对应位置玩家的牌
function CUIFightZJH:SetPlayerHandCard(index, cards, bMing)

end

-- 比牌显示
function CUIFightZJH:ShowPlayCompareCard(sourcePlayer, targetPlayer, sourceCards, targetCards)

end

-- 弃牌
function CUIFightZJH:ShowPlayGiveUpCard(index)
    
end

-- 显示玩家倒计时
function CUIFightZJH:ShowPlayerCountdown(index, remainTime)
end

-- 下注
function CUIFightZJH:ShowPlayAddCoin(index, coin)
end

-- 开局显示玩家准备状态或换桌
function CUIFightZJH:ShowFightBeignButtonState(bHideAll, bReady)
    local _roomType = gFightMgr:GetRoomType()
    local _readyBtn   = FindNodeByName(self.m_pRootForm, "btn_ready")
    local _unReadyBtn = FindNodeByName(self.m_pRootForm, "btn_unready")
    local _switchBtn  = FindNodeByName(self.m_pRootForm, "btn_swap")

    if _readyBtn then
        _readyBtn:hide()
    end
    if _unReadyBtn then
        _unReadyBtn:hide()
    end
    if _switchBtn then
        _switchBtn:hide()
    end
    if not bHideAll then
        -- 匹配
        if _roomType == ENUM.RoomType.Normal then
            if bReady then
                if _unReadyBtn then
                    _unReadyBtn:show()
                    _unReadyBtn:setPosition(cc.p(0, 0))
                end
            else
                if _readyBtn then
                    _readyBtn:show()
                end
                if _switchBtn then
                    _switchBtn:show()
                end

            end
        -- 其他类型的比赛没有换桌
        else
            if bReady then
                if _unReadyBtn then
                    _unReadyBtn:setPosition(cc.p(0, 0))
                    _unReadyBtn:show()
                end
            else
                if _readyBtn then
                    _readyBtn:setPosition(cc.p(0, 0))
                    _readyBtn:show()
                end
            end
        end
    end
end

-- 显示玩家准备标记
function CUIFightZJH:ShowPlayerReadyFlag(location, bReady)
    if dirType then
        local node_name = 
        {
            [1]     = "ready_flag_1",
            [2]     = "ready_flag_2",
            [3]     = "ready_flag_3",
            [4]     = "ready_flag_4",
            [5]     = "ready_flag_5",
            [6]     = "ready_flag_6",
            [7]     = "ready_flag_7",
        }

        local ready_flag = FindNodeByName(self.m_pRootForm, node_name[dirType])
        if ready_flag then
            if bReady then
                ready_flag:show()
            else
                ready_flag:hide()
            end
        else
            log_error(LOG_FILE_NAME, "没有找到 准备手的标记：%d", dirType)
        end
    else
        log_error(LOG_FILE_NAME, "显示隐藏准备状态失败,方位错误")
    end
end

function CUIFightZJH:ShowUnreadyCountDown()
    if self.m_unReadyBtn then
        self.m_unReadyBtn:setColor(cc.c3b(125, 125, 125))
        local _countDown = self.m_unReadyBtn:getChildByName("text_count_down")
        local ONE_SECOND = 1
        local curCountDonw = TIME_COUNT_DOWN
        _countDown:setString("("..curCountDonw.."s)")
        self.m_unReadyBtn:setTouchEnabled(false)
        if _countDown then
            self.m_unReadyBtn:onUpdate(function(dt)
                ONE_SECOND = ONE_SECOND - dt
                if ONE_SECOND <= 0 then
                    ONE_SECOND = 1
                    curCountDonw = curCountDonw - 1
                    _countDown:setString("("..curCountDonw.."s)")
                    if curCountDonw <= 0 then
                        curCountDonw = 0
                        _countDown:setString("")
                        self.m_unReadyBtn:setColor(cc.c3b(255, 255, 255))
                        self.m_unReadyBtn:setTouchEnabled(true)
                        self.m_unReadyBtn:unscheduleUpdate()
                    end                
                end
            end)
        end
    end
end

function CUIFightZJH:OnDestroy()
    if self.m_maskLayer then
        self.m_maskLayer:removeFromParent()
        self.m_maskLayer:release()
        self.m_maskLayer = nil
    end

    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
    --CPlistCache:GetInstance():ReleasePlist(UI_PLIST_NAME)
end