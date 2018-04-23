KeyboardController = {}

function KeyboardController:EnableKeyboard()
	self.m_layerKeyboardLayer = display.newLayer()
    self.m_nMoveDirection = 0
    local _MoveKeyTab = {}

    -- 移动
    local _Move = function (dir, keyCode)
        CJoysitckController:GetInstance():ReqJoystickTouchState(dir, 1)
        self.m_nMoveDirection = ENUM.EDirection.Up 
        local _keyTab = {
                    _key = keyCode, 
                    _dir = dir,
                 }
         for k, v in pairs(_MoveKeyTab) do
            if v._key == keyCode then
                table.remove(_MoveKeyTab,k)
            end
        end
        table.insert(_MoveKeyTab, #_MoveKeyTab + 1, _keyTab )
    end
    local function onKeyReleased(keyCode, event)
        if self.m_client then
            self.m_client.key_right = false
            self.m_client.key_left  = false
            self.m_server.key_right = false
            self.m_server.key_left  = false
            self.m_server.key_up = false
            self.m_server.key_down = false
        end

        -- 抬起
        if gFightMgr and ISKEYCONTROLTANK then
            if  keyCode == 146 or keyCode == 124 or keyCode == 127 or keyCode == 142  then
                CJoysitckController:GetInstance():ReqJoystickTouchState(self.m_nMoveDirection, 0)
                self.m_nMoveDirection = 0
                
                --把该键移除
                for k, v in pairs(_MoveKeyTab) do
                    if v._key == keyCode then
                        table.remove(_MoveKeyTab,k)
                    end
                end

                --获取上一个按钮
                if _MoveKeyTab[#_MoveKeyTab] ~= nil then
                    _Move(_MoveKeyTab[#_MoveKeyTab]._dir, _MoveKeyTab[#_MoveKeyTab]._key )
                end
            end
        end
    end

    local function onKeyPressed(keyCode, event)

        if self.m_client then
            if  keyCode == 26 then
                self.m_client.key_left  = true
                self.m_server.key_left  = true
            elseif keyCode == 27 then
                self.m_client.key_right = true
                self.m_server.key_right = true
            elseif keyCode == 28 then
                self.m_server.key_up = true
            elseif keyCode == 29 then
                self.m_server.key_down = true
            end
        end


        -- 键盘控制坦克
        if gFightMgr and ISKEYCONTROLTANK then
            -- 移动方向
            if keyCode == 146 then     -- w 上
                local _dir =  ENUM.EDirection.Up  
                _Move(_dir, keyCode)
            elseif keyCode == 124 then -- A 左
                local _dir =  ENUM.EDirection.Left  
                _Move(_dir, keyCode)
            elseif keyCode == 127 then -- D 右
                local _dir =  ENUM.EDirection.Right 
                _Move(_dir, keyCode)
            elseif keyCode == 142 then -- S 下
                local _dir =  ENUM.EDirection.Down 
                _Move(_dir, keyCode)
            end

            -- 炮塔方向
            if keyCode == 28 then     --  上
                local sendData = 
                {
                    turretDirection = ENUM.EDirection.Up,
                    zoneId = gFightMgr:GetMapServerID(),
                }
                gFightMgr:ReqTankTowerDirection(sendData)
            elseif keyCode == 26 then --  左
                local sendData = 
                {
                    turretDirection = ENUM.EDirection.Left,
                    zoneId = gFightMgr:GetMapServerID(),
                }
                gFightMgr:ReqTankTowerDirection(sendData)
            elseif keyCode == 27 then --  右
                local sendData = 
                {
                    turretDirection = ENUM.EDirection.Right,
                    zoneId = gFightMgr:GetMapServerID(),
                }
                gFightMgr:ReqTankTowerDirection(sendData)
            elseif keyCode == 29 then --  下
                local sendData = 
                {
                    turretDirection = ENUM.EDirection.Down,
                    zoneId = gFightMgr:GetMapServerID(),
                }
                gFightMgr:ReqTankTowerDirection(sendData)
            end

            -- 技能
            if keyCode == 133 then     --  j 1号技能
                local _event = {name = CEvent.Fight.OnClickSkillOne}
                gPublicDispatcher:DispatchEvent(_event)

            elseif keyCode == 134 then --  k 2号技能
                local _event = {name = CEvent.Fight.OnClickSkillTwo}
                gPublicDispatcher:DispatchEvent(_event)

            elseif keyCode == 59 then -- 空格  开火
                local _eventOpenFire = {name = CEvent.Joystick.TouchClickFire}
                gPublicDispatcher:DispatchEvent(_eventOpenFire)
            end
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )

    local eventDispatcher = self.m_layerKeyboardLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.m_layerKeyboardLayer)

    self.m_layerKeyboardLayer:addTo(display.getRunningScene())
end

function KeyboardController:DisableKeyboard()
	self.m_layerKeyboardLayer:removeFromParent()
end