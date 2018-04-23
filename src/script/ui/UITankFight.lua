local UI_PANEL_NAME = 'res/csb/ui_tank_fight.csb'

CUITankFight =  CreateClass(UIBase)

function CUITankFight:Create(msg)
    local o = {}
    setmetatable(o, CUITankFight)
    o.m_pRootForm = nil
    return o
end

function CUITankFight:Init(msg)
    self.m_pRootForm = cc.CSLoader:createNode(UI_PANEL_NAME)
    if not self.m_pRootForm then
        log_error(LOG_FILE_NAME, '['..UI_PANEL_NAME..']'.." Not Found!")
        return
    end

    local _txtNum = FindNodeByName(self.m_pRootForm, "txt_room_num")
    if _txtNum then _txtNum:setString(msg.roomInfo.roomNum) end

    self.m_pRootForm:retain()
    
    CWidgetManager:GetInstance():AddChild(self.m_pRootForm)
   return true
end


function CUITankFight:Destroy()
    if self.m_pRootForm then
        self.m_pRootForm:removeFromParent()
        self.m_pRootForm:release()
        self.m_pRootForm = nil
    end
end
