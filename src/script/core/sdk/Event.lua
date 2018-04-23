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

CEvent = {}
CEvent.__index = CEvent

function CEvent:New(strType)
    local event = {name = strType}
    setmetatable(event, CEvent)
    return event
end

--////////////////////////////////////// 事件定义 ////////////////////////////////////////
CEvent.GameWordkInitFinish     = "CEVENT.GAMEWORDKINITFINISH"-- 游戏世界数据初始化完
CEvent.MainRedPoint            = "CEVENT.MAINREDPOINT" -- 主界面红点提示 参数: xx.redType = 红点对应的功能枚举
CEvent.FightChat               = "CEVENT.FIGHTCHAT" -- 对战中的聊天内容 参数: xx.chatType = 聊天类型， xx.chatID = 聊天 xx.chatContent = 聊天内容
CEvent.AddSysNotice            = "CEVENT.ADDSYSNOTICE" -- xx.broadcast = 公告内容
CEvent.UpdatdeResources        = "CEVENT.UPDATDERESOURCES" 
CEvent.FightDestory            = "CEVENT.FIGHTDESTORY" 
CEvent.PlayerEnterLeaveRoom    = "CEVENT.ONEPLAYERENTERROOM"
CEvent.FriendsUpdate           = "CEVENT.FRIENDSUPDATE"
CEvent.ApplyFriendsUpdate      = "CEVENT.APPLYFRIENDSUPDATE"
CEvent.AddOneFriendMsg         = "CEVENT.ADDONEFRIENDMSG"
CEvent.UpateSignData           = "CEVENT.UPATESIGNDATA"
CEvent.UpdateTaskData          = "CEVENT.UPDATETASKDATA"
CEvent.ChatWithOneFriend       = "CEVENT.ChatWithOneFriend"
CEvent.WeChatHeadImg           = "CEVENT.WECHATHEADIMG" -- 头像获取成功