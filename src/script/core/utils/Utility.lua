--[[
-- Copyright (C), 2015, 
-- 文 件 名: Utility.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-01-11
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUtility.log'

GameUtil = {}
GameUtil.Width = 0
GameUtil.Height = 0
 
CC_CONTENT_SCALE_FACTOR = function()
    return cc.Director:getInstance():getContentScaleFactor()
end

CC_POINT_PIXELS_TO_POINTS = function(pixels)
    return cc.p(pixels.x/CC_CONTENT_SCALE_FACTOR(), pixels.y/CC_CONTENT_SCALE_FACTOR())
end

CC_POINT_POINTS_TO_PIXELS = function(points)
    return cc.p(points.x*CC_CONTENT_SCALE_FACTOR(), points.y*CC_CONTENT_SCALE_FACTOR())
end

function VISIBLE_WIDTH()
    if GameUtil.Width == 0 then
       GameUtil.Width = cc.Director:getInstance():getVisibleSize().width
    end
    return GameUtil.Width
end

function VISIBLE_HEIGHT()
    if GameUtil.Height == 0 then
       GameUtil.Height = cc.Director:getInstance():getVisibleSize().height
    end
    return GameUtil.Height
end
require("socket")


function GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

--[[
-- 函数类型: public
-- 函数功能: 新增或重新加载脚本模块
-- 参数[IN]: strScriptName 脚本模块名
-- 返 回 值: 是否成功
-- 备    注:
--]] 
function ReloadScript(strScriptName)
    assert(strScriptName ~= nil)
    if nil == strScriptName then
        return false
    end

    strScriptName = 'script/'..tostring(strScriptName)
    package.loaded[strScriptName] = nil
    require(strScriptName)
    return true
end

--[[
-- 函数类型: public
-- 函数功能: 用于内部调用lua函数时捕获错误信息，打印lua调用堆栈
-- 参数[IN]: 错误消息
-- 返 回 值: 无
-- 备    注:
--]]
function ErrHandler(msg)
    if msg then
        --设置控制台颜色
        CConsole:GetInstance():SetColor(CConsole.RED)
        local message = string.format(msg)  
        local err = "ErrReport:\n" .. message .. "\n" .. debug.traceback() .. "\nEnd\n"  
        release_print(err)
        --恢复控制台颜色
        CConsole:GetInstance():SetColor(CConsole.YELLOW)
        return err
    end
end

--[[
-- 函数类型: public
-- 函数功能: 适配UI节点
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function AdapterUIRoot( root )
    if root then
        local winSize = cc.Director:getInstance():getVisibleSize()
        root:setContentSize(cc.size(winSize.width, winSize.height))
        ccui.Helper:doLayout(root)
    end
end

-- 切换UI场景
function SwitchUIScene( sceneID )

    -- 移除当前虽有UI和UI场景
    CUIManager:GetInstance():CloseAllUI()

    -- 配置数据
    local _path   = Q_Scene.GetTempData(sceneID, "q_path")
    local _script = Q_Scene.GetTempData(sceneID, "q_script")
    -- 打开制定UI场景
    local msg = {name = _script, path = _path }
    local buff = SerializeToStr(msg)
    SendLocalMsg(MSGID.CC_OPEN_UI, buff, #buff)
end

--[[
-- 函数类型: public
-- 函数功能: 通过ID获取配置表名字
-- 参数[IN]: 无
-- 返 回 值: 无 
-- 备    注:
--]]
function GetConfigTableByTemplateID( templateID )
    if not laodConfigStr then
        _G["laodConfigStr"] = true
        local _strConfigTable = Q_Global.GetTempData(8, 'q_string_value')
        local _tConfigTable = StrSplit(_strConfigTable, '|')
        _G["_tAllConfigTable"] = {}
        for k, v in pairs(_tConfigTable) do
            local _tUnitTable = StrSplit(v, '+')
            local _data = { from = tonumber(_tUnitTable[1]), to = tonumber(_tUnitTable[2]), name = _tUnitTable[3] }
            table.insert(_tAllConfigTable, _data)
        end
    end

    for k,v in pairs(_tAllConfigTable) do
        if templateID >= v.from and  templateID <= v.to then
            return _G[v.name]
        end 
    end
    log_error(LOG_FILE_NAME, '当前ID的配置表名字没找到:%d', templateID)
    return nil
end

--[[
-- 函数类型: public
-- 函数功能: 根据父节点,寻找指定名字的节点
-- 参数[IN]: 父节点, 名字
-- 返 回 值: 无
-- 备    注:
--]]
function FindNodeByName(root, name)
    name = tostring(name)
    if nil == root then
        return nil
    end

    if root:getName() == name then 
        return root
    end

    local _children = root:getChildren()

    for k, v in pairs(_children) do
        if nil ~= v then
            _findNode = FindNodeByName(v, name)
            if nil ~= _findNode then
                return _findNode
            end
        end
    end

    return nil
end

--[[
-- 函数类型: public
-- 函数功能: 根据父节点,寻找指定tag的节点
-- 参数[IN]: 父节点, 名字
-- 返 回 值: 无
-- 备    注:
--]]
function FindNodeByTag(root, tag)
    tag = tonumber(tag)
    if nil == root then
        return nil
    end

    if root:getTag() == tag then 
        return root
    end

    local _children = root:getChildren()

    for k, v in pairs(_children) do
        if nil ~= v then
            local _fingNode = FindNodeByTag(v, tag)
            if nil ~= _fingNode then
                return _fingNode
            end
        end
    end

    return nil
end

--[[
-- 函数类型: public
-- 函数功能: 绑定cocos studio里面的按钮事件名称绑定按钮事件
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function BindChildrenButtonEvent(root)
    local _children = root:getChildren()
    for k,v in pairs(_children) do
        if v["getCallbackName"] then
            local _callbackName = v:getCallbackName()
            if _callbackName ~= "" then
                if _callbackName == 'OpenOtherUI' then

                elseif _callbackName == "SwitchUIScene" then
                    v:addTouchEventListener(function(sender, eventType)
                        if eventType == ccui.TouchEventType.ended then
                            local _userData = sender:getCustomProperty()
                            local _configID = tonumber(_userData)
                            SwitchUIScene(_configID)
                        end
                    end)        
                end
            end
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 获取语言包对于的文字
-- 参数[IN]: 语言包id
-- 返 回 值: 对应语言的文字
-- 备    注:
--]]
function Language(nIndex)
    if type(nIndex) ~= "number" then
        nIndex = tonumber(nIndex)
    end
    if not nIndex or not Q_Language[nIndex] then
        return ""
    end
    return Q_Language.GetTempData(nIndex, "q_text")
end

--[[
-- 函数类型: public
-- 函数功能: 添加触摸遮挡层
-- 参数[IN]: 触摸遮挡层
-- 返 回 值: 无
-- 备    注:
--]]
function AddMaskLayer(color, args)
    local _winSize = cc.Director:getInstance():getVisibleSize()
    local _colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, color or 0)) 
    _colorLayer:setContentSize(_winSize.width, _winSize.height)
    _colorLayer:setPosition(0,0)
    local listener = cc.EventListenerTouchOneByOne:create()  

    -- 点击回调(点击在区域范围才行)
    local function onTouchBegan( touch, event)
        --print("遮罩层，父级名字：",event:getCurrentTarget():getParent():getName())
        if args and args.onBegan then
            args.onBegan(event:getCurrentTarget(), event)
        end
        return true
    end
    
    local function onTouchEnded( touch, event)
        if args and args.onEnded then
            args.onEnded(event:getCurrentTarget(), event)
        end
    end
    
    local function onTouchCancelled( touch, event)
        if args and args.onCancelled then
            args.onCancelled(event:getCurrentTarget(), event)
        end
    end

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)  

    -- 时间派发器
    local eventDispatcher = _colorLayer:getEventDispatcher() 

    -- 吞没事件 
    if args and args.swallow then
        listener:setSwallowTouches(args.swallow)
    else
        listener:setSwallowTouches(true)
    end

    -- 绑定触摸事件到层当中  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, _colorLayer) 
    _colorLayer:getEventDispatcher():setPriority(listener, 1)
    return _colorLayer
end

--[[
-- 函数类型: public
-- 函数功能: 添加灰色触摸遮挡层
-- 参数[IN]: 触摸遮挡层
-- 返 回 值: 无
-- 备    注:
--]]
function AddBlackMaskLayer(args)
    local _colorLayer = AddMaskLayer(120, args)
    return _colorLayer
end

function AddGuideMaskLayer(size, pos, opacity)
    local opacity = opacity or 120
    local _colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, opacity)) 
    _colorLayer:setPosition(pos)
    _colorLayer:setContentSize(size)
    _colorLayer:setPosition(pos)
    local listener = cc.EventListenerTouchOneByOne:create()  
    -- 点击回调(点击在区域范围才行)
    local function onTouchBegan( touch, event)
        local _location = touch:getLocation()
        local _sender = event:getCurrentTarget()
        local _rect = cc.rect(0, 0, _sender:getContentSize().width, _sender:getContentSize().height)
        local _location = _sender:convertToNodeSpace(_location)
        if cc.rectContainsPoint(_rect, _location) then
            return true
        end
        return false
    end
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )  
    -- 时间派发器
    local eventDispatcher = _colorLayer:getEventDispatcher() 
    -- 吞没事件 
    listener:setSwallowTouches(true)
    -- 绑定触摸事件到层当中  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, _colorLayer) 
    _colorLayer:getEventDispatcher():setPriority(listener, 1)
    return _colorLayer
end

--[[
-- 函数类型: public
-- 函数功能: 创建一个没有图片的按钮
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CreateEmptyButton(width, height, callback)
    local _width, _height = width or 70, height or 70
    local item = cc.MenuItemImage:create()
    item:registerScriptTapHandler(callback)
    item:setContentSize(_width or 70, _height or 70)
    item:setAnchorPoint(cc.p(0.5,0.5))
    item:setPosition(0, 0)
    local _btn = cc.Menu:create(item)
    _btn:setPosition(0, 0)
    return _btn, item
end

function AddEventListener( node, bSwallow, onBeganCallback, onMovedCallback, onEndedCallback)
   
    local listener = cc.EventListenerTouchOneByOne:create()  

    -- 点击回调(点击在区域范围才行)
    local function onTouchBegan(touch, event)

        local _location = touch:getLocation()
        local _sender = event:getCurrentTarget()
        local _rect = cc.rect(node:getPositionX(), node:getPositionY(), _sender:getContentSize().width, _sender:getContentSize().height)
        local _location = _sender:getParent():convertToNodeSpace(_location)

        -- 点击区域判断
        if cc.rectContainsPoint(_rect, _location) then
            if onBeganCallback and type(onBeganCallback) == 'function' then
                onBeganCallback(node, ccui.TouchEventType.began)
            end
            return true
        end

        return false
    end

    -- 移动回调
    local function onTouchMoved( touch, event )
        local _location = touch:getLocation()
        local _sender = event:getCurrentTarget()
        local _rect = cc.rect(node:getPositionX(), node:getPositionY(), _sender:getContentSize().width, _sender:getContentSize().height)
        local _location = _sender:getParent():convertToNodeSpace(_location)

        -- 移动区域判断
        if cc.rectContainsPoint(_rect, _location) then
            if onMovedCallback and type(onMovedCallback) == 'function' then
                onMovedCallback(node, ccui.TouchEventType.moved)
            end 
        end 
         
    end

    -- 结束回调
    local function onTouchEnded( touch, event )
        local _location = touch:getLocation()
        local _sender = event:getCurrentTarget()
        local _rect = cc.rect(node:getPositionX(), node:getPositionY(), _sender:getContentSize().width, _sender:getContentSize().height)
        local _location = _sender:getParent():convertToNodeSpace(_location)

        -- 结束区域判断
        if cc.rectContainsPoint(_rect, _location) then
            if onEndedCallback and type(onEndedCallback) == 'function' then
                onEndedCallback(node, ccui.TouchEventType.ended)
            end
        end        
    end

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN )  
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED )  
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED )  
    
    -- 时间派发器
    local eventDispatcher = node:getEventDispatcher() 

    -- 吞没事件 
    listener:setSwallowTouches(bSwallow or true)

    -- 绑定触摸事件到层当中  
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node) 
end

function OpenUIEvent(state, name)
    local event = CEvent:New(CEvent.GuideOpenUI )
    event.strUIName = name
    event.state     = state
    gPublicDispatcher:DispatchEvent(event)
end

--[[
-- 函数类型: public
-- 函数功能: 打开UI
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function OpenUI( name, data, folder)
    if folder == '' or nil then
        folder = 'ui'
    end
    high = high or false
    local msg = data or {}
    msg.name = name
    msg.FolderName = 'ui'
    SendLocalMsg( MSGID.CC_OPEN_UI, msg, true) 
end

function ShowMarquee(bShow)
    local _UIMarquee = CUIManager:GetInstance():GetUIByName("CUIMarquee")
    if not _UIMarquee then
        OpenUI("CUIMarquee")
    else
        _UIMarquee:SetVisible(bShow)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 关闭UI
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CloseUI(name)
    local msg = {}
    msg.name = name
    SendLocalMsg(MSGID.CC_CLOSE_UI, msg)
end

--[[ 
-- 函数类型: public
-- 函数功能: 打开通用弹出式提示框UI
-- 参数[IN]: msg.cancelCallback = 取消的回调函数, msg.confirmCallback = 确认回调函数 msg.noticeContent = 提示汉字内容
-- 返 回 值: 无
-- 备    注:
--]]
function OpenFightChatTipsUI(msg)
    local strUIName = "CUITipsFightChat"
    print("当前打开UI:", strUIName)
    assert('string' == type(strUIName) and #strUIName ~= 0)   

    local strFolderName = msg.FolderName or 'UILogic'

    -- 按需重新加载脚本
    local strScriptPath = 'script/'..strFolderName..'/'..string.sub(strUIName, 2)
    if nil == _G[strUIName] then
        package.loaded[strScriptPath] = nil
        require(strScriptPath)
    end

    local ui = _G[strUIName]:Create(msg)
    if nil == ui then
       log_error(LOG_FILE_NAME, "打开UI失败:%d", strUIName)
        return false
    end
    
    -- 播放音效
    ui:Init(msg)

    return ui
end

function OpenEnterRoomTipsUI(msg)
    local strUIName = "CUIEnterRoomTipsUI"
    assert('string' == type(strUIName) and #strUIName ~= 0)   
    local strFolderName = msg.FolderName or 'UILogic'
    -- 按需重新加载脚本
    local strScriptPath = 'script/'..strFolderName..'/'..string.sub(strUIName, 2)
    if nil == _G[strUIName] then
        package.loaded[strScriptPath] = nil
        require(strScriptPath)
    end
    local ui = _G[strUIName]:Create(msg)
    if nil == ui then
       log_error(LOG_FILE_NAME, "打开UI失败:%d", strUIName)
        return false
    end
    
    ui:Init(msg)

    return ui
end

--[[
-- 函数类型: public
-- 函数功能: 打开功能确认提示
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function OpenFunctionSure()
    -- 登录的时候,需要玩家确认的功能
    local _functionList = CPlayer:GetInstance():GetFunctionSureStack()
    if #_functionList > 0 then
        OpenUI("CUITipsFunctionSure", nil, {update = true})
    else
        CloseUI("CUITipsFunctionSure")
    end
end

-- 获取节点box区域内相对点的坐标
function GetRelativePostion(node, RelativePos)
    local box = node:boundingBox()
    return cc.pointMake(box:getMinX() + box.size.width * RelativePos.x,
                       box:getMinY() + box.size.height * RelativePos.y)
end

-- 移动锚点，图片左下角位置保持不变
function MoveAnchorPt(node, AnchorPt)
    node:setPosition(GetRelativePostion(node, AnchorPt))
    node:setAnchorPoint(AnchorPt)
end

-- 功能: 序列化table成字串,可以通过 loadstring 加载
-- 参数: t table
-- 返回: 序列后的字串
-- 备注: 支持table的递归结构，但数据类型不支持function属性(因为function只是记录地址，在不同机器上序列化和反序列化后的地址相同没什么意义) 
-- 备注:  
function SerializeToStr(_t)
    local szRet = "{"  
    function doT2S(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. SerializeToStr(_v) .. ","
            elseif "boolean" == type(_v) then
                szRet = szRet ..tostring(_v)..','
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. SerializeToStr(_v) .. ","  
            elseif "boolean" == type(_v) then
                szRet = szRet ..tostring(_v)..','
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end

-- 功能: 将SerializeToStr序列成的字串反序列化成table
-- 参数: str 字串
-- 返回: 反序列化的table
-- 备注: 
function DeserializeFromStr(_szText)
    _szText = "return " .. _szText
    local fun = loadstring(_szText)
    if not fun then
        log_error(LOG_FILE_NAME, '反序列化失败!', _szText)
        return nil
    end
    return fun();
end

--[[
-- 函数类型: public
-- 函数功能: bool转数字
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 0 = false, 1 = true
--]]
function BoolToNumber(bool)
    if bool then
        return 1
    end
    return 0
end

-- 功能: 打包效果工厂使用的动态参数, 格式如: 500.0,1,test.png
-- 参数: 变长基本数值类型参数
-- 返回值: 打包后的参数字符串
-- 示例:
-- local arg = PackEffectArg(math.random(1000), 400 + i * 5, i * 100, 50 + i * 5)
-- local effect = CEffectFactory:GetInstance():CreateEffect('effect/xxx.xml', arg)
function PackEffectArg(...)
    local arg = {...}
    if IsGameServer then
        return
    end
    return ''..table.concat(arg, ',')
end

--设置游戏的随机种子
math.randomseed(os.time())

--[[
-- 函数原型: ParseData(t) 
-- 函数功能: 解析protobuf数据
-- 参    数:
--     [IN]: 待解析的decode table
-- 返 回 值: 解析完成的table
-- 备    注: 该函数只能解析大多数的消息结构，如果消息结构中含有repeated字段的数据，请自行解析
--]]
function ParseData(t)
    local ret = {}
    for k,v in pairs(t) do
        if type(v) == "table" then
            if #v == 2 and type(v[1]) == "string" and protobuf.check(v[1]) then
                local buff = protobuf.decode(v[1], v[2])
                ret[k] = ParseData(buff)
            else
                for k1,v1 in pairs(v) do
                    ret[k][k1] = ParseData(v1)
                end
            end
        else
            ret[k] = v
        end
    end
    return ret
end

--[[
-- 函数功能: 字符串分解函数
-- 参    数: 
--    [IN] strSource: 待分解字符串
--    [IN] strTag: 分解标记
-- 返 回 值: 分解完后的table
-- 备    注: 无
--]]
function StrSplit(strSource, strTag)
    local tabSplit = {}
    if not strSource or not strTag then
        log_error("Utility.log", "StrSplit the param is nil~~~")
        return tabSplit
    end

    -- 开始分解字符串
    while (true) do
        local nPos,nEndPos = string.find(strSource, strTag)
        -- 没有找到分割标记
        if not nPos then
            if string.len(strSource) > 0 then
                tabSplit[#tabSplit + 1] = strSource
            end
            break
        end

        -- 分割出第一个字符串
        local strSub = string.sub(strSource, 1, nPos - 1)
        if string.len(strSub) > 0 then
            tabSplit[#tabSplit + 1] = strSub
        end
        strSource = string.sub(strSource, nEndPos + 1, #strSource)
    end

    return tabSplit
end

--[[
-- 函数类型: public
-- 函数功能: 迭代字符，分割为table
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 对中文字符进行了判断
--]]
function StrValueToTable(str)
    str1 = str
    local _strTable = {}
    local i = 1 
    while true do 
        c = string.sub(str1,i,i)
        b = string.byte(c)
        if b and b > 128 then
            table.insert(_strTable, string.sub(str1,i,i+2))
            i = i + 3
        else
            table.insert(_strTable, c)
            i = i + 1
        end
        if i > #str1 then
             break
        end
    end
    return  _strTable
end

--[[
-- 函数类型: public
-- 函数功能: 将table的所有值转换为数值类型
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function TableValueToNumber(tTable)
    local _table = {}
    if tTable then
        for k,v in pairs(tTable) do
            table.insert(_table, tonumber(v))
        end
    end
    return _table
end

--[[
-- 函数类型: private
-- 函数功能: 解决FIXED_WIDTH模式下，ipad 等分辨率的scorll区域的高度自适应问题
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function AdapterScrollViewSize(scrollView)
    if scrollView then
        local _h =  VISIBLE_HEIGHT() - 720 -- (720为设计分辨率的高度)
        local _height = scrollView:getContentSize().height
        local _width = scrollView:getContentSize().width
        _height = _height + _h
        scrollView:setContentSize(cc.size(_width, _height))
    end
end

--[[
-- 函数类型: public
-- 函数功能: 将一个大数字的每位分离到table
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function NumberSplit( numberSource )
    if type( numberSource ) ~= 'number' then
        log_error( LOG_FILE_NAME, 'split number is not number type')
        return {}
    end

    local _tSplit = {}
    repeat
        local _nNumber = numberSource % 10
        table.insert( _tSplit, _nNumber )
        numberSource = math.floor( numberSource * 0.1 ) 
    until  numberSource <= 0

    local _tSwitch = {}
    for i = #_tSplit, 1, -1 do
        table.insert( _tSwitch, _tSplit[i])
    end
    dump(_tSwitch, "数字分离")
    return _tSwitch
end

--[[
-- 函数类型: public
-- 函数功能: 在父类table中查找成员或者函数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
local function Search(k, plist)
    for i=1,#plist do
        if plist[i][k] then -- 尝试每一个父类，在某一个父类中查找到了就返回
            return plist[i][k]
        end
    end
end

-- 创建class函数,参数为父类Table
local nClassNum = 0  --类编号自增
function CreateClass( ... )
    local arg = {...}
    if arg ~= nil and #arg == 1 then
        nClassNum = nClassNum + 1
        return class(string.format("class_%d", nClassNum), arg[1])
    else
        local c = {}    -- 新类
        local parents = {...}

        -- 设置类的metatable
        setmetatable(c, {__index = function (t, k)
            return Search(k, parents)
        end})

        -- 将C作为其实例的元表
        c.__index = c

        -- 为新类定义一个构造函数，如果需要为类增加成员变量，
        -- 建议重写New方法或者通过显示的传Table o进来
        function c:New(o)
            o = o or {}
            setmetatable(o, c)
            return o
        end
        return c
    end
end


--[[
函数功能: 克隆对象
参    数：
    [IN]: object 对象
返 回 值: 新对象对象
]]--
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local _setmetatableindex
_setmetatableindex = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        _setmetatableindex(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            _setmetatableindex(mt, index)
        end
    end
end
setmetatableindex = _setmetatableindex

function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        _setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end

local _iskindof
_iskindof = function(cls, name)
    local __index = rawget(cls, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then return true end

    if rawget(cls, "__cname") == name then return true end
    local __supers = rawget(cls, "__supers")
    if not __supers then return false end
    for _, super in ipairs(__supers) do
        if _iskindof(super, name) then return true end
    end
    return false
end

function Schedule(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local callfunc = cc.CallFunc:create(callback)
    local sequence = cc.Sequence:createWithTwoActions(delay, callfunc)
    local action = cc.RepeatForever:create(tolua.cast(sequence, 'CCActionInterval'))
    node:runAction(action)
    return action
end

function performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local callfunc = cc.CallFunc:create(callback)
    local sequence = cc.Sequence:create(delay, callfunc)
    node:runAction(sequence)
    return sequence
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

-- 功能: 判断文件是否存在
-- 参数: strFilePath 文件路径
-- 返回值: 是否存在
function IsFileExisits(strFilePath)
    local file = io.open(strFilePath, 'r')
    if nil == file then
        return false
    end
    io.close(file)
    return true
end

-- 功能: 格式化时间
-- 参数: 分钟数
-- 返回值: 格式化后的字符串
function FormatTime(nMinutes)
    local strFormat = ""
    local nDays = math.floor(nMinutes / (60*24)) -- 天
    nMinutes = nMinutes % (60*24) -- 剩余的分钟数
    local nHours = math.floor(nMinutes / 60) -- 小时
    nMinutes = nMinutes % 60 -- 剩余的分钟数

    if nDays > 0 then
        if nHours > 0 then
            strFormat = string.format(Language(20036) or "%2d days %2d hour", nDays, nHours)
        else
            strFormat = string.format(Language(20037) or "%2d days", nDays)
        end
    else
        if nHours > 0 then
            if nMinutes > 0 then
                strFormat = string.format(Language(20038) or "%2d hours %2d minutes", nHours, nMinutes)
            else
                strFormat = string.format(Language(20039) or "%2d hours", nHours)
            end
        else
            if nMinutes > 0 then
                strFormat = string.format(Language(20040) or "%2d minutes", nMinutes)
            end
        end
    end

    return strFormat
end

-- 功能: 格式化时间
-- 参数: 秒数
-- 返回: 格式化后的字符串
function FormatTimeBySecond(nSeconds)
    local nHours = math.floor(nSeconds / (60*60)) -- 小时
    nSeconds = nSeconds % (60*60) 
    local nMinutes = math.floor(nSeconds / 60) -- 分钟数
    nSeconds = nSeconds % 60 -- 秒数

    return string.format("%02d:%02d:%02d", nHours, nMinutes, nSeconds)
end

--[[
-- 函数类型: public
-- 函数功能: 随机数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function GameRandom(arg1, arg2)
    if arg1 == arg2 and arg2 ~= nil then
        return arg1
    elseif arg1 == 1 and arg2 == nil then
        return 1
    end
    
    local num = nil
    if IsGameServer or IsFightCheck then
        num = gRandomTbl[1]
        if arg2 == nil and arg1 == nil and num then
            if num < 0 or num > 1 then
                num = nil
            end
        elseif arg2 == nil and arg1 ~= nil and num then
            if num < 1 or num > arg1 then
                num = nil
            end
        elseif arg2 ~= nil and arg1 ~= nil and num then
            if num < arg1 or num > arg2 then
                num = nil
            end
        end

        if num then
            if LogFight then
                table.insert(gUpdateTbl[gFightMgr.m_Process], {"random1", num, gFightMgr.m_fTime, "\n"})
            end
            table.remove(gRandomTbl, 1)
        else
            if LogFight then
                table.insert(gUpdateTbl[gFightMgr.m_Process], {"random2", num, gFightMgr.m_fTime, "\n"})
            end
            return arg1 or 0.5
        end  
    end

    if not num then
        if arg2 == nil and arg1 == nil then
            num = math.random()
        elseif arg2 == nil and arg1 ~= nil then
            num = math.random(arg1)
        elseif arg2 ~= nil and arg1 ~= nil then
            num = math.random(arg1, arg2)
        end

        if not gFightMgr or 
            (gFightMgr.m_eState ~= CFightMgr.EFightStatus.FIGHTSTATUS_RUN and 
            gFightMgr.m_eState ~= CFightMgr.EFightStatus.FIGHTSTATUS_BIGSKILL)
        then

        end

        if gFightMgr and gRandomTbl and not IsGameServer and not IsFightCheck then
            table.insert(gRandomTbl, num)
            if LogFight then
                table.insert(gUpdateTbl[gFightMgr.m_Process], {"random1", num, gFightMgr.m_fTime, "\n"})
            end
        end
    end
    return num
end

--[[
-- 函数类型: pulibic
-- 函数功能: 转换为有逗号的金币数量（逗号是用的"."）
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 1-0000 = 1万= 1000-0000， 1-00000000
--]]
function FormatMoney(num)
    local _bXiaoyu0 = false
    if num < 0 then
        _bXiaoyu0 = true
    end
    num = math.abs(tonumber(num))
    local nums = NumberSplit(num)
    if num >= 10000 and num < 100000000 then
          local _afterNum = num / 10000
        _afterNum = GetPreciseDecimal(_afterNum, 1)
        if _bXiaoyu0 then
            _afterNum = "-".._afterNum
        end
        return _afterNum.."万"
    elseif num >= 100000000 then
        local _afterNum = num / 100000000
        _afterNum = GetPreciseDecimal(_afterNum, 1)
        if _bXiaoyu0 then
            _afterNum = "-".._afterNum
        end
        return _afterNum.."亿"
    end
    return num
end

--[[
-- 函数类型: public
-- 函数功能: 获取某年的某一月的天数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function GetMonthDay(nYear, nMonth)
    nYear = tonumber(nYear)
    nMonth = tonumber(nMonth)
    local nDayCount = -1
    if (nMonth < 1 or nMonth > 12) or nYear < 1 then
        log_info("Utility.log", "the year = %d, month = %d is error", nYear, nMonth)
        return nDayCount
    end

    if nMonth == 1 or nMonth == 3 or
       nMonth == 5 or nMonth == 7 or
       nMonth == 8 or nMonth == 10 or 
       nMonth == 12 then -- 大月
       nDayCount = 31
    elseif nMonth == 4 or nMonth == 6 or
           nMonth == 9 or nMonth == 11 then -- 小月
        nDayCount = 30
    elseif nMonth == 2 then
        if ((0 == nYear%4) and (0 ~= nYear%100)) or 
            (0 == nYear%400) then -- 闰年
            nDayCount = 29
        else -- 非闰年
            nDayCount = 28
        end
    else
        log_info("Utility.log", "the year = %d, month = %d is error", nYear, nMonth)
    end
    return nDayCount
end

NoticeList = {}
NoticeUpdateIntervalTime = 0

--[[
-- 函数类型: public
-- 函数功能: 屏幕中心的系统提示
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function Notice(msg)
    table.insert(NoticeList, msg)
end

--[[
-- 函数类型: public
-- 函数功能: 屏幕系统中心提示队列
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function NoticeOrder(dt)
    NoticeUpdateIntervalTime = NoticeUpdateIntervalTime - dt
    if #NoticeList > 0 then
        if NoticeUpdateIntervalTime <= 0 then
            OpenUI("CUITipsNoticeForCenter",nil,{messageData = NoticeList[1], uiType = 1})
            table.remove(NoticeList, 1)
            NoticeUpdateIntervalTime = 2
        end
    end
end

--漂浮字体提示
function NoticeFonts( pForm, sContent, nPosX, nPosY )
    local _pFonts = CTipsFonts:New()
    _pFonts:Create( pForm, sContent, nPosX, nPosY )
end

-- 功能: 判断是否在同一天
-- 参数: 无
-- 返回值: 是否
function SameDayTest()
    local strFileDate = CCUserDefault:sharedUserDefault():getStringForKey('DateTest') or ''
    local strCurrentDate = os.date('%Y-%m-%d')
    local bInSameDay = (strFileDate == strCurrentDate)
    if not bInSameDay then
        CCUserDefault:sharedUserDefault():setStringForKey('DateTest', strCurrentDate)
    end
    return bInSameDay
end

-- 功能: 去除顺序表中的重复数据
-- 参数: tbl 会直接删除其中的数据
-- 返回值: 返回此表
function RemoveDuplicateElem(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        t[v] = true
        tbl[k] = nil
    end

    for k, _ in pairs(t) do
        table.insert(tbl, k)
    end
    return tbl
end

-- 功能: 获取模板数据的一条记录
-- 参数: 
-- 返回值: key-val格式的记录 OR nil
function GetTemplateItem(strTblName, idx)
    assert(type(strTblName) == 'string')
    local tbl = _G[strTblName] or {}
    local IdxTbl = _G[strTblName..'_index'] or {}
    local config = {}
    local bEmpty = true

    if nil == tbl[idx] then
        return nil
    end

    for key, i in pairs(IdxTbl) do
        bEmpty = false
        config[key] = tbl[idx][i]
    end

    if bEmpty then
        return nil
    end
    return config
end

--[[
-- 函数类型: public
-- 函数功能: 缩放缩放图片
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 背景图片必须是图片控件不能用Sprite
--]]
function BackGroundImg(img)
    if img then
        local size = img:getParent():getContentSize()
        local point = img:getAnchorPoint();
        img:setContentSize(cc.size(display.width+1,display.height))
    end
end

function SetGolbal(key, value)
    rawset(_G, key, value)
end

function TableMerge( table1, table2)
    for k, v in pairs(table1) do
        table2[k] = v
    end
    return table2
end

--[[
-- 函数功能: 判断两个时间戳是否是同一天
-- 参    数: 
--     [IN] nTimeStamp1: 时间戳1
--     [IN] nTimeStamp2: 时间戳2
-- 返 回 值: true 是同一天, false 不是同一天
-- 备    注: 无
--]]
function IsTimeStampSameDay(nTimeStamp1, nTimeStamp2)
    local tbTime1 = os.date("*t", (nTimeStamp1 or 0))
    local tbTime2 = os.date("*t", (nTimeStamp2 or 0))

    return (tbTime1.year  == tbTime2.year and
            tbTime1.month == tbTime2.month and
            tbTime1.day   == tbTime2.day)
end

local requireList = {}
local requireOver = false
function AddRequire(luaFile)
    if IsGameServer then
        require(luaFile)
    else
        table.insert(requireList, luaFile)
        requireOver = false
    end
end

function ActRequire()
    if requireOver then
        return
    end
    for v = 6, 0, -1 do
        local luaFile = requireList[1]
        if luaFile then
            require(luaFile)
            table.remove(requireList, 1)
        else
            requireOver = true
            break
        end
    end
end

function ActRequireAll()
    repeat
        local luaFile = requireList[1]
        if luaFile then
            require(luaFile)
            table.remove(requireList, 1)
        else
            requireOver = true
            break
        end
    until false
end

function RequireOver()
    return requireOver
end

--功能: 返回指定的tab的大小（针对以key-value的table）
--参数: tab:指定的tab
--返回: tab的大小
--备注:
function TableSize( tab )
    local nResult = 0
    if type(tab) == 'table' then
        for _, _ in pairs(tab) do
            nResult = nResult + 1
        end
    end
    return nResult
end


--功能: 拼接两个tab
--参数: 
--返回: 拼接后的tab
--备注:
function connectTable(tab1, tab2)
    local tResult = {}
    if type(tab1) == 'table' and type(tab2) == 'table' then
        for _key, _val in pairs(tab1) do
            table.insert(tResult, _val)
        end
        for _key, _val in pairs(tab2) do
            table.insert(tResult, _val)
        end
    end
    return tResult
end

function GrayNode(node)
    if node then
        local _allChidren = node:getChildren()
        for k, v in pairs(_allChidren) do
            v:setColor(cc.c3b(180, 180, 180))
        end
        node:setColor(cc.c3b(180, 180, 180))
    end
end

function ResetGrayNode(node)
    if node then
        local _allChidren = node:getChildren()
        for k, v in pairs(_allChidren) do
            v:setColor(cc.c3b(255, 255, 255))
        end
        node:setColor(cc.c3b(255, 255, 255))
    end
end

--[[
-- 函数类型: public
-- 函数功能: 毫秒转换为日期
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function ConvertToDate(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%Y.%m.%d %H:%M", sTime)
end

function ConvertToDateS(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%Y.%m.%d %H:%M:%S", sTime)
end

function GetDateMs(y, m, d)
    if y and m and d then
        local _ms =  os.time({day = d, month = m, year = y, hour=0, minute=0, second=0}) * 1000
        return _ms
    else
        log_error(LOG_FILE_NAME, "无效日期")
    end
end

function GetYear(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%Y", sTime)
end

function GetMonth(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%m", sTime)
end

function GetDay(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%d", sTime)
end

function GetWeek(sTime)
    sTime = tonumber(sTime) * 0.001
    return os.date("%w", sTime)
end

function GetAllDays(sTime)
    -- 秒
    local s = tonumber(sTime) * 0.001
    -- 分
    s = s / 60
    -- 时
    s = s / 60
    -- 天
    s = s / 24
    return s
end

function GetOn42GirdIndex(sTime)
    local _allDay = GetAllDays(sTime)
    local _pos = (_allDay - 23) % 42
    if _pos == 0 then
        _pos = 42
    end
    return math.ceil(_pos)
end

--功能: 开始渲染
--参数: pRt:渲染区, pSprite:要显示的精灵, pMask:遮罩精灵
--返回: 无
--备注: 
function StartRender( pRt, pSprite, pMask )
    if not pRt or not pSprite or not pMask then
        return
    end
    pRt:begin()
    pMask:visit()
    pSprite:visit()
    pRt:endToLua()
end

--功能: 获取椭圆的长半轴或短半轴
--参数: 无
--返回: 无
--备注: 
function GetLongSemiaxisAndShortSemiaxis(  )
    local strSemiaxis   = q_global.GetTempData(2017, 'q_string_value')
    local tSemiaxis     = StrSplit(strSemiaxis, "_")
    return tonumber(tSemiaxis[1]), tonumber(tSemiaxis[2])
end

--[[--

检查并尝试转换为数值，如果无法转换则返回 0

@param mixed value 要检查的值
@param [integer base] 进制，默认为十进制

@return number

]]
function checknumber(value, base)
    return tonumber(value, base) or 0
end

--[[--

检查并尝试转换为整数，如果无法转换则返回 0

@param mixed value 要检查的值

@return integer

]]
function checkint(value)
    return math.round(checknumber(value))
end

--[[--

检查并尝试转换为布尔值，除了 nil 和 false，其他任何值都会返回 true

@param mixed value 要检查的值

@return boolean

]]
function checkbool(value)
    return (value ~= nil and value ~= false)
end

--[[--

检查值是否是一个表格，如果不是则返回一个空表格

@param mixed value 要检查的值

@return table

]]
function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

function Distance(x1, y1, x2, y2)
    return math.sqrt((x1 -x2) * (x1 -x2) + (y1 -y2)*(y1 -y2))
end
--[[--

sprite变灰

@param node  变灰的节点

@return 

]]

function gray(node)
    local vertDefaultSource = "\n"..
    "attribute vec4 a_position; \n" ..
    "attribute vec2 a_texCoord; \n" ..
    "attribute vec4 a_color; \n"..                                                    
    "#ifdef GL_ES  \n"..
    "varying lowp vec4 v_fragmentColor;\n"..
    "varying mediump vec2 v_texCoord;\n"..
    "#else                      \n" ..
    "varying vec4 v_fragmentColor; \n" ..
    "varying vec2 v_texCoord;  \n"..
    "#endif    \n"..
    "void main() \n"..
    "{\n" ..
    "gl_Position = CC_PMatrix * a_position; \n"..
    "v_fragmentColor = a_color;\n"..
    "v_texCoord = a_texCoord;\n"..
    "}"
     
    local pszFragSource = "#ifdef GL_ES \n" ..
    "precision mediump float; \n" ..
    "#endif \n" ..
    "varying vec4 v_fragmentColor; \n" ..
    "varying vec2 v_texCoord; \n" ..
    "void main(void) \n" ..
    "{ \n" ..
    "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
    "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b); \n"..
    "gl_FragColor.w = c.w; \n"..
    "}"
    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)
end

--[[
-- 函数类型: public
-- 函数功能: 变灰后的恢复
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function resetGray(node)
    node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
end

--[[
-- 函数类型: public
-- 函数功能: 得到资源的列表
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function GetMapResoures( sul )
    local _mapTable = require(sul)
    local _imgTab = {}
    for k,v in pairs(_mapTable) do
        if k == "tilesets" then
            for kk,vv in pairs(v) do
                table.insert(_imgTab,#_imgTab + 1, 'map/'..vv.image)
            end
        end
    end
    return _imgTab
end

--[[
-- 函数类型: public
-- 函数功能: 检查敏感词汇
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function ChenckDirtyWord(word)
    return _ChenckDirtyWord(word)
end

--[[
-- 函数类型: public
-- 函数功能: 获取坐标点和平面构成的角的度数
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
local SJ_PI         = 3.14159265359
local SJ_PI_X_2     = 6.28318530718
local SJ_RAD2DEG    = 180.0 / SJ_PI
local SJ_DEG2RAD    = SJ_PI/ 180.0
function GetDegreesByPoint(point)
    local dx = point.x
    local dy = point.y
    local dSq = dx * dx + dy * dy
    
    local angle = math.atan2(dy, dx)
    if angle < 0 then
        angle = angle + SJ_PI_X_2
    end

    local cosAngle = 0
    local sinAngle = 0
    
    cosAngle = math.cos(angle)
    sinAngle = math.sin(angle)
            
    local degrees = angle * SJ_RAD2DEG      
    return degrees
end

--[[
-- 函数类型: public
-- 函数功能: 产生富文本 
-- 参数[IN]: string 消息串, width 文本的宽度
-- 返 回 值: 无
-- 备    注:
--]]
function CreateRichText(str, width, fontSize, color, pacity)
    local richText = ccui.RichText:create()
    local _width = width or 300
    local _color = color or  cc.c3b(255, 255, 255)
    local _pacity = pacity or 255
    local _fontSize = fontSize or 25
    local _richContentTab = {}
    richText:setContentSize(cc.size(_width, 100))
    richText:ignoreContentAdaptWithSize(false)
    richText:setAnchorPoint(0,1.0)
    _setContent = function(_str)
        if string.len(_str) > 0 then
            local _nIndexBegan = string.find(_str, "<")  -- 表情用[125] 表示  开始
            local _nIndexend = string.find(_str, ">")    -- 结束
            if _nIndexBegan and _nIndexend and _nIndexBegan < _nIndexend then
                if _nIndexBegan > 1 then

                    -- 1 到 _nIndexBegan 是字符
                    local _stringSplit = string.sub(_str,1,_nIndexBegan - 1)
                    local text = ccui.RichElementText:create( #_richContentTab + 1, _color, _pacity, _stringSplit, 'fonts/wryhct.ttf', _fontSize )
                    if text then
                        table.insert(_richContentTab, text)
                    end
                end

                -- 根据图片名字
                local _strPngId = string.sub(_str,_nIndexBegan + 1, _nIndexend - 1)
                local _strPngName = Q_Look.GetTempData(tonumber(_strPngId), 'q_look_img')
                if _strPngName then
                    local reimg = ccui.RichElementImage:create(#_richContentTab + 1, _color, _pacity, _strPngName)
                    if reimg then
                        table.insert(_richContentTab, reimg)
                    end
                end

                -- 继续遍历下面的额字符
                local _newStr = string.sub(_str, _nIndexend + 1)
                _setContent(_newStr)
            else
                local text = ccui.RichElementText:create( #_richContentTab + 1,_color, _pacity, _str, 'fonts/wryhct.ttf', _fontSize )
                if text then
                    table.insert(_richContentTab, text)
                end
            end
        end
    end
    _setContent(str)
    for k,v in pairs(_richContentTab) do
        richText:pushBackElement(v)
    end
    richText:setLocalZOrder(10)
    richText:formatText()
    return richText
end

function GrayButton(button)
    if button then
        button:setColor(cc.c3b(125, 125, 125))
    end
end

function WhiteButton(button)
    if button then
        button:setColor(cc.c3b(255, 255, 255))
    end
end

function GetStringByteCount(word)
    local curByte = string.byte(word)
    if curByte then
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        return byteCount
    end
end

function GetLayoutWords(content, oneLineWidht, fontSize)
    if not content or not oneLineWidht or not fontSize then
        log_error(LOG_FILE_NAME, "排版文字错误")
        return
    end
    local FONT_SIZE = fontSize
    local ONE_LINE_WIDTH = oneLineWidht
    local _wordsWidth = 0
    local _tWords = {}
    local _tempWords = ""
    local _wordCount = #(content or "")
    local _index = 1
    while true do
        local _word = string.sub(content, _index, _index)
        if _word then
            local _wordByteCount = GetStringByteCount(_word)
            local _wordWidth = FONT_SIZE
            if _wordByteCount >= 3 then
                _wordWidth = FONT_SIZE
            elseif _wordByteCount == 2 then
                _wordWidth = FONT_SIZE * (2 / 3)
            elseif _wordByteCount == 1 then
                _wordWidth = FONT_SIZE * 0.5
            end
            
            _wordsWidth = _wordsWidth + _wordWidth
            _tempWords = _tempWords .. string.sub(content, _index, _index + (_wordByteCount - 1))
            if _wordsWidth >= ONE_LINE_WIDTH then
                table.insert(_tWords, _tempWords)
                _tempWords = ""
                _wordsWidth = 0
            end
            _index = _index + _wordByteCount
            if _index > _wordCount then
                if _wordsWidth > 0 then
                    table.insert(_tWords, _tempWords)
                end
                break
            end
        else
            break
        end
    end
    return _tWords, _wordsWidth
end

--[[
-- 函数类型: public
-- 函数功能: 给按钮添加音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function AddButtonSound(sender)
    local _soundId = sender:getCustomProperty()
    CMusicPlayer:GetInstance():PlayEffectById(tonumber(_soundId), 0)
end

--[[
-- 函数类型: public
-- 函数功能: 判断一个点是否在实体点的屏幕范围内
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CheckPostionInEntityRegion(entityPos, targetPos)
    if entityPos and targetPos then
        local _startX, _startY = entityPos.x - VISIBLE_WIDTH() * 0.5, entityPos.y - VISIBLE_HEIGHT() * 0.5
        local _endX, _endY = _startX + VISIBLE_WIDTH(), _startY + VISIBLE_HEIGHT()
        local _rect = cc.rect(_startX, _startY, _endX, _endY)
        if cc.rectContainsPoint(_rect, targetPos) then
            return true
        end
    end
    return false
end

function SetOneNoticeText(_lineTxtItem, noticeInfo, type, bUser)
    local lineTxtWidth = 0

    --- 系统
    if noticeInfo.sysBroad then
        local txtSys = FindNodeByName(_lineTxtItem, "txt_sys")
        local offsetX = 0
        if txtSys then
            txtSys:show()
            lineTxtWidth = lineTxtWidth + txtSys:getContentSize().width
            offsetX = txtSys:getContentSize().width
        end
        local txtContent = FindNodeByName(_lineTxtItem, "txt_content")
        local _user = FindNodeByName(_lineTxtItem, "txt_user")
        if _user then
            _user:hide()
        end
        local _vip = FindNodeByName(_lineTxtItem, "vip")
        if _vip then
            _vip:hide()
        end
        local txtPlayer = FindNodeByName(_lineTxtItem, "txt_player")
        if txtPlayer then
            txtPlayer:hide()
        end

        if txtContent then
            txtContent:setString(noticeInfo.content)
            txtContent:setPositionX(offsetX)
            if type == 1 then
                txtContent:setTextColor(cc.c3b(255, 255, 255))
            end
            lineTxtWidth = lineTxtWidth + txtContent:getContentSize().width
        end

    -- 玩家
    else
        -- 是否是vip
        local txtContent = FindNodeByName(_lineTxtItem, "txt_content")
        if txtContent then
            txtContent:setString(noticeInfo.content)
            local contentXOffset = 0
            if type == 1 then
                txtContent:setTextColor(cc.c3b(255, 255, 255))
            end
            if bUser then
                local _user = FindNodeByName(_lineTxtItem, "txt_user")
                if _user then
                    if type == 1 then
                        _user:setTextColor(cc.c3b(255, 255, 255))
                    end
                    _user:show()
                    contentXOffset = contentXOffset + _user:getContentSize().width
                    lineTxtWidth = lineTxtWidth + _user:getContentSize().width
                end
            end

            if noticeInfo.vip then
                local _vip = FindNodeByName(_lineTxtItem, "vip")
                if _vip then
                    _vip:show()
                    _vip:setPositionX(contentXOffset)
                    contentXOffset = contentXOffset + _vip:getContentSize().width
                    lineTxtWidth = lineTxtWidth + _vip:getContentSize().width
                end
            end

            local txtPlayer = FindNodeByName(_lineTxtItem, "txt_player")
            if txtPlayer then
                if type == 1 then
                    txtPlayer:setTextColor(cc.c3b(255, 255, 255))
                end
                txtPlayer:show()
                txtPlayer:setString(noticeInfo.playerName..":")
                txtPlayer:setPositionX(contentXOffset)
                lineTxtWidth = lineTxtWidth + txtPlayer:getContentSize().width
                contentXOffset = contentXOffset + txtPlayer:getContentSize().width
            end

            lineTxtWidth = lineTxtWidth + txtContent:getContentSize().width
            txtContent:setPositionX(contentXOffset)
        end
    end
    return _lineTxtItem, lineTxtWidth
end

function CreateOneNoticeText(noticeInfo, type, bUser)
    local _lineTxtItem = cc.CSLoader:createNode("ui_csb/ui_template_fonts.csb")
    if _lineTxtItem then
        _lineTxtItem:setContentSize(cc.size(_lineTxtItem:getContentSize().width, 35))
        --_lineTxtItem:setAnchorPoint(cc.p(0, 0.5))
        return SetOneNoticeText(_lineTxtItem, noticeInfo, type, bUser)
    end
end

function LocalStringEncrypt( encrypt_data )
    --windows不加密
    if cc.PLATFORM_OS_WINDOWS == cc.Application:getInstance():getTargetPlatform() then
        return encrypt_data
    else
        return WX.WeChatSDKAPIDelegate:LocalStringEncrypt(encrypt_data)
    end
    
end

-- function GetCircleHeadImg( head_sp )
--     head_sp = CloneSprite(head_sp)
--     --模板
--     local circle = cc.Sprite:create("head.png")
--     head_sp:setScale((circle:getContentSize().width) / head_sp:getContentSize().width)
--     --head_sp:setScaleY(circle:getContentSize().height / head_sp:getContentSize().height)
--     local clip_head = cc.ClippingNode:create()
--     --clip_head:retain()
--     clip_head:addChild(head_sp)
--     --设置模板
--     clip_head:setStencil(circle)
--     --是否反转显示模板之外的内容
--     clip_head:setInverted(false)
--     clip_head:setAlphaThreshold(0.5)
--     return clip_head
-- end

function GetRectHeadImg( head_sp )
    head_sp = CloneSprite(head_sp)
    --模板
    local rect = cc.Sprite:create("head_rect_templete.png")
    head_sp:setScaleX(rect:getContentSize().width / head_sp:getContentSize().width)
    head_sp:setScaleY(rect:getContentSize().height / head_sp:getContentSize().height)
    local clip_head = cc.ClippingNode:create()
    --clip_head:retain()
    clip_head:addChild(head_sp)
    --设置模板
    clip_head:setStencil(rect)
    --是否反转显示模板之外的内容
    clip_head:setInverted(false)
    clip_head:setAlphaThreshold(0.5)
clip_head:setPositionY(-3)
    return clip_head
end

function GetCircleHeadImg( head_sp )
    head_sp = CloneSprite(head_sp)
    local circle = display.newSprite("res/res_main/image/head.png")
    local srcContent = head_sp:getContentSize()
    local maskContent = circle:getContentSize()
    local render_texture = cc.RenderTexture:create(srcContent.width, srcContent.height)
    local ratiow = srcContent.width / maskContent.width
    local ratioh = srcContent.height / maskContent.height
    circle:setScaleX(ratiow)
    circle:setScaleY(ratioh)

    head_sp:setPosition(srcContent.width / 2, srcContent.height / 2);
    circle:setPosition(srcContent.width / 2, srcContent.height / 2);

    head_sp:setScale(1.1)

    local blendfunc2 = cc.blendFunc(GL_ONE, GL_ZERO)
    circle:setBlendFunc(blendfunc2)
    local blendfunc3 = cc.blendFunc(GL_DST_ALPHA, GL_ZERO)
    head_sp:setBlendFunc(blendfunc3)

    render_texture:begin()
    circle:visit()
    head_sp:visit()
    render_texture:endToLua()

    local ret_head = cc.Sprite:createWithTexture(render_texture:getSprite():getTexture())
    ret_head:setFlippedY(true)
    ret_head:setScale(circle:getContentSize().width / head_sp:getContentSize().width)
    return ret_head

end

function CloneSprite( src_sprite )
    if src_sprite then
        return cc.Sprite:createWithTexture(src_sprite:getTexture())
    end
end

function AddButtonListener( btn, call_back )
    if btn then
        btn:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if sender["getCustomProperty"] then
                    local _userData = sender:getCustomProperty()
                    if not _userData or _userData == "" then
                       CMusicPlayer:GetInstance():PlayEffect("res/res_main/music/common/button.mp3")
                    end
                else
                    print("not getCustomProperty function")
                end
                sender:setTouchEnabled(false)
                -- 加个延时防止重复误操作
                performWithDelay(sender, function()
                    sender:setTouchEnabled(true)
                    print("延迟按钮触摸恢复")
                end, 0.4)
                if call_back then
                    call_back(sender, eventType)
                else
                    log_error(LOG_FILE_NAME, "按钮回调为空")
                end
                WhiteButton(sender)
            elseif eventType == ccui.TouchEventType.began then
                GrayButton(sender)
            elseif eventType == ccui.TouchEventType.canceled then
                WhiteButton(sender)
            end
        end)
    else
        log_error(LOG_FILE_NAME, "设置按钮监听失败,按钮对象或者回调为空")
    end
end

function ParsePngPath(path)
    local _findflag = string.find(path, '/')
    if _findflag then
        local _strs = StrSplit(path, "/")
        return _strs[#_strs]
    else
        return path
    end
end