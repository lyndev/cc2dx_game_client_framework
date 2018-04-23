--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Friend.proto

local _msgType =
{
    [ 130501 ] = "Friend.ReqAllFriendInfo", -- 获取所有好友信息
    [ 130502 ] = "Friend.ReqApplyFriend", -- 申请好友
    [ 130503 ] = "Friend.ReqRemoveFriend", -- 删除好友
    [ 130504 ] = "Friend.ReqSearchFriend", -- 搜索好友
    [ 130601 ] = "Friend.ResAllFriendInfo", -- 服务器返回所有好友信息
    [ 130602 ] = "Friend.ResApplyFriend", -- 服务器返回添加好友结果
    [ 130603 ] = "Friend.ResRemoveFriend", -- 服务器返回删除好友结果
    [ 130604 ] = "Friend.ResSearchFriend", -- 服务器返回搜索到的玩家
    [ 130606 ] = "Friend.NotifyFriendOnline", -- 好友上线通知
    [ 130607 ] = "Friend.NotifyFriendOffline", -- 好友下线通知
}


local _msgID =
{
    _FRIEND_REQALLFRIENDINFO = 130501, -- 获取所有好友信息
    _FRIEND_REQAPPLYFRIEND = 130502, -- 申请好友
    _FRIEND_REQREMOVEFRIEND = 130503, -- 删除好友
    _FRIEND_REQSEARCHFRIEND = 130504, -- 搜索好友
    _FRIEND_RESALLFRIENDINFO = 130601, -- 服务器返回所有好友信息
    _FRIEND_RESAPPLYFRIEND = 130602, -- 服务器返回添加好友结果
    _FRIEND_RESREMOVEFRIEND = 130603, -- 服务器返回删除好友结果
    _FRIEND_RESSEARCHFRIEND = 130604, -- 服务器返回搜索到的玩家
    _FRIEND_NOTIFYFRIENDONLINE = 130606, -- 好友上线通知
    _FRIEND_NOTIFYFRIENDOFFLINE = 130607, -- 好友下线通知
}

if not MSGTYPE then
	MSGTYPE = {}
	rawset(_G, "MSGTYPE", MSGTYPE)
end
if not MSGID then
	MSGID = {}
	rawset(_G, "MSGID", MSGID)
end
TableMerge(_msgType, MSGTYPE)
TableMerge(_msgID, MSGID)
