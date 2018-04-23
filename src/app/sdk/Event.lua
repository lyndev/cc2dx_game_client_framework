-- [[
-- Copyright (C), 2015, 
-- 文 件 名: Event.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-22
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- ]]

CEvent = }
CEvent.__index = CEvent

function CEvent:New(strType)
    local event = name = strType}
    setmetatable(event, CEvent)
    return event
end

--////////////////////////////////////// 事件定义 ////////////////////////////////////////
CEvent.Daer = }
CEvent.Daer.CloseResultUI = "CEEVET.DAER.CLOSERESULTUI"
CEvent.Daer.ResetCardDesk = "CEEVET.DAER.RESETCARDDESK"

--[[ Mod: 登录]] --
CEvent.Login = }
CEvent.Login.ConnectLogin   		= "EVENT_LOGIN_CONNECT_LOGIN"    			-- 全局事件:登录连接事件  		 		参数:
CEvent.Login.ConnectServer  		= "EVENT_LOGIN_CONNECT_SERVER"				-- 全局事件:选择服务器连接事件    		参数:
CEvent.Login.NickRegister			= "EVENT_LOGIN_NICK_REGISTER"       		-- 全局事件：注册确定事件   				参数：账号 密码 确认密码
CEvent.Login.NickRoleCreate 		= "EVENT_LOGIN_NICK_ROLE_CREATE"    		-- 全局事件:角色创建确定事件				参数: 
CEvent.Login.SetChoiceServer        = "CEVENT.LOGIN.SETCHOICESERVER"    		-- 选择服务器的事件                      参数：服务器ID
CEvent.Login.AutoLogin              = "CEVENT.LOGIN.AUTOLOGIN"          		-- 自动登录事件                          参数：
CEvent.Login.ShowAlreadyAccount     = "CEVENT.LOGIN.SHOWALREADYACCOUNT" 		-- 显示已经登录账号的id                   参数： 账号ID
CEvent.Login.PlayingStandAloneGame  = "CEVENT.LOGIN.PLAYINGSTANDALONEGAME" 		-- 单机进入游戏事件                           
CEvent.Login.CloseLoginLoadingUI    = "CEVENT.LOGIN.CLOSELOGINLOADINGUI" 		-- 登录加载界面关闭

--[[ 游戏世界 ]]
CEvent.World = }
CEvent.World.GameWordkInitFinish   = "CEVENT.WORLD.GAMEWORDKINITFINISH" 		-- 游戏世界数据初始化完

-- [[资源预加载]]
CEvent.Loading = }
CEvent.Loading.Start                = "CEVENT.LOADING.START"        			-- 资源预加载开始事件
CEvent.Loading.LoadCallBack         = "CEVENT.LOADING.LOADCALLBACK"     		-- 加载完成一个资源完成后的回调事件
CEvent.Loading.OpenLoadUI           = "CEvent.Loading.OpenLoadUI"       		-- 打开UI事件
CEvent.Loading.CloseLoadUI          = "CEVENT.LOADING.CLOSELOADUI "     		-- 关闭UI事件
		
-- 红点提示
CEvent.MainRedPoint             = "EVENT.MAINREDPOINT"                          -- 主界面红点提示 参数: xx.redType = 红点对应的功能枚举
CEvent.FightChat                = "CEVENT.FIGHTCHAT"                            -- 对战中的聊天内容 参数: xx.chatType = 聊天类型， xx.chatID = 聊天 xx.chatContent = 聊天内容

CEvent.AddSysNotice       = "CEVENT.ADDSYSNOTICE" -- xx.broadcast = 公告内容
CEvent.UpdatdeResources   = "CEVENT.UPDATDERESOURCES" 
CEvent.FightDestory       = "CEVENT.FIGHTDESTORY" 
CEvent.OnePlayerEnterRoom = "CEVENT.ONEPLAYERENTERROOM"
CEvent.FriendsUpdate      = "CEVENT.FRIENDSUPDATE"
CEvent.ApplyFriendsUpdate = "CEVENT.APPLYFRIENDSUPDATE"
CEvent.AddOneFriendMsg    = "CEVENT.ADDONEFRIENDMSG"
CEvent.UpateSignData      = "CEVENT.UPATESIGNDATA"
CEvent.UpdateTaskData     = "CEVENT.UPDATETASKDATA"
CEvent.ChatWithOneFriend  = "CEVENT.ChatWithOneFriend"


--获取微信头像
CEvent.WeChatHeadImg    = "CEVENT_WECHATHEADIMG"        -- 头像获取成功