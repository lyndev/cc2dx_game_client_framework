--[[
-- Copyright (C), 2015, 
-- 文 件 名: UIPlayerCreateRoom.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-14
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUIPlayerCreateRoom.lua.log'

CUIPlayerCreateRoom = CreateClass(UIBase)

-- UI资源路径
local UI_PANEL_NAME = 'res_main/csb/ui_custom_create_room.csb'

function CUIPlayerCreateRoom:Create(msg)
    local o = {}
    setmetatable(o, CUIPlayerCreateRoom)
    o.m_pRootForm   = nil
    o.m_roomNumbers = {}
    return o
end

function CUIPlayerCreateRoom:Init(msg)
    -- 加载plist
    --CPlistCache:GetInstance():RetainPlist(UI_PLIST_NAME)
    self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
        log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
        return
    end
    -- 遮罩
    self.m_maskLayer = AddMaskLayer()
    self.m_maskLayer:retain()
    CWidgetManager:GetInstance():AddChild(self.m_maskLayer, ENUM.LAYE_TYPE.UITips)

    CWidgetManager:GetInstance():AddChild(self.m_pRootForm, ENUM.LAYE_TYPE.UITips)
    self.m_pRootForm:retain()
    AdapterUIRoot(self.m_pRootForm)

    local _img = FindNodeByName(self.m_pRootForm, "img_bg")
    BackGroundImg(_img)

    self:InitButtonEvent(msg)
    return true
end

function CUIPlayerCreateRoom:InitButtonEvent(msg)
    local btnClose = FindNodeByName(self.m_pRootForm, "btn_close")
    if btnClose then
        btnClose:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                CloseUI("CUIPlayerCreateRoom")
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end  

    local btn_create_score_room = FindNodeByName(self.m_pRootForm, "btn_create_score_room")
    if btn_create_score_room then
        btn_create_score_room:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                OpenUI("CUIPlayerCreateRoomOptional", nil, {type = "score"})
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end

    local btn_create_gold_room = FindNodeByName(self.m_pRootForm, "btn_create_gold_room")
    if btn_create_gold_room then
        btn_create_gold_room:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                OpenUI("CUIPlayerCreateRoomOptional", nil, {type = "gold"})
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    end

    local btnKeyboard = FindNodeByName(self.m_pRootForm, "node_keyboard")
    if btnKeyboard then
        for i = 0, 9 do
            local btnNumer = FindNodeByName(btnKeyboard, i)
            if btnNumer then
                btnNumer:setTag(i)
                btnNumer:addTouchEventListener(function(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                        self:OnClickNumber(sender)
                        self:UpdateInputRoomNumber()
                        WhiteButton(sender)
                    elseif eventType == ccui.TouchEventType.began then
                        GrayButton(sender)
                    elseif eventType == ccui.TouchEventType.canceled then
                        WhiteButton(sender)
                    end
                end)
            end
        end 

        local btnNumer = FindNodeByName(btnKeyboard, "re_input")
        if btnNumer then
            btnNumer:addTouchEventListener(function(sender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    self:SetNotice("")
                    self:OnDelOneRoomNumer()
                    self:UpdateInputRoomNumber()
                    WhiteButton(sender)
                elseif eventType == ccui.TouchEventType.began then
                    GrayButton(sender)
                elseif eventType == ccui.TouchEventType.canceled then
                    WhiteButton(sender)
                end
            end)
        end

        local btnDelete = FindNodeByName(btnKeyboard, "delete")
        if btnDelete then
            btnDelete:addTouchEventListener(function(sender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    self:SetNotice("")
                    self:OnResetRoomNumer()
                    self:UpdateInputRoomNumber()
                    WhiteButton(sender)
                elseif eventType == ccui.TouchEventType.began then
                    GrayButton(sender)
                elseif eventType == ccui.TouchEventType.canceled then
                    WhiteButton(sender)
                end
            end)
        end
    end
end

function CUIPlayerCreateRoom:GetRoot()
    return self.m_pRootForm
end

function CUIPlayerCreateRoom:RedFindRoomAndEnter(msgData)
    if msgData.code == 0 then
        if msgData.room then
            local GameSingleType = 
            {
                [ENUM.GameType.DAER]    = "4",
                [ENUM.GameType.MAJIANG] = "5",
                [ENUM.GameType.POKER]   = "6",
            }
             -- 检查游戏是否已经下载,下载完成后自动回调进入对应的游戏
            local _gameType = CPlayer:GetInstance():GetGameMainTypeBySubType(GameSingleType[msgData.room.gameType])
            if _gameType then
                local _bDownDaer = CPlayer:GetInstance():IsAlreadyDownGame(_gameType)
                if _bDownDaer then
                    CLobbyManager:GetInstance():ReqEnterCustomRoom(msgData.room.id, GameSingleType[msgData.room.gameType])
                elseif GAME_HOT_UPDATE then
                    local event = {}
                    event.name = CEvent.DownLoadGame
                    event.bForce = true
                    event.downlaodFinishCallback = function()
                        CLobbyManager:GetInstance():ReqEnterCustomRoom(msgData.room.id, GameSingleType[msgData.room.gameType])
                    end
                    event.gameType = ENUM.GameDownloadFlagType[_gameType]
                    gPublicDispatcher:DispatchEvent(event)
                else
                    Notice("联系程序员,重连接房间错误,原因:热更标记没开启。")
                end
            end
        else
            log_error(LOG_FILE_NAME, "服务器返回的房间数据错误")
        end
    else
        local ErrorStr = {
            [1] = "产生roomInfo信息错误",
            [2] = "请求参数错误",
            [3] = "没有找到指定的房间",
        }
        self:SetNotice(ErrorStr[msgData.code])
    end
end

function CUIPlayerCreateRoom:OnClickNumber(sender)
    if #self.m_roomNumbers >= 4 then
        return
    end
    local _number = tonumber(sender:getTag())
    if _number then
        table.insert(self.m_roomNumbers, _number)
        self:SetRoomID(self.m_roomNumbers)
        if #self.m_roomNumbers == 4 then
            --TODO:检查游戏下载
            SendMsgToServer(MSGID.CS_ROOM_REQENTERROOM, {roomNumber = self:GetRoomID(), roomType = ENUM.RoomType.Custom })
        end
    end
end

function CUIPlayerCreateRoom:SetNotice(str)
    local _textNotice = FindNodeByName(self.m_pRootForm, 'txt_notice')
    if _textNotice then
        _textNotice:setString(str)
    end
end

function CUIPlayerCreateRoom:OnResetRoomNumer()
    self.m_roomNumbers = {}
end

function CUIPlayerCreateRoom:OnDelOneRoomNumer()
    if #self.m_roomNumbers > 0 then
        table.remove(self.m_roomNumbers, #self.m_roomNumbers)
    end
    self:SetRoomID(self.m_roomNumbers)
end

function CUIPlayerCreateRoom:SetRoomID(numbers)
    local _id = '0'
    for i,v in ipairs(numbers) do
        _id = _id..v
    end
    self.m_searchRoomID = tonumber(_id)
end

function CUIPlayerCreateRoom:GetRoomID()
    return self.m_searchRoomID
end


function CUIPlayerCreateRoom:UpdateInputRoomNumber()
    for i = 1, 4 do
        local nodeNumber = FindNodeByName(self.m_pRootForm, "node_num_"..i)
        if nodeNumber then
            local number = FindNodeByName(nodeNumber, "num")
            if number then
                number:setString(self.m_roomNumbers[i] or '')
            end
        end
    end
end


function CUIPlayerCreateRoom:OnDestroy() 
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
end
