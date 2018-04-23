--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************

if not MSGID then 
    MSGID = {}
end
if not MSGTYPE then 
    MSGTYPE = {}
end
require("script.Message.MsgAck")
require("script.Message.MsgAgent")
require("script.Message.MsgBackpack")
require("script.Message.MsgBaseMessage")
require("script.Message.MsgChat")
require("script.Message.MsgFriend")
require("script.Message.MsgGuide")
require("script.Message.MsgKeys")
require("script.Message.MsgLogin")
require("script.Message.MsgMail")
require("script.Message.MsgNewFeature")
require("script.Message.MsgNotify")
require("script.Message.MsgOperActivity")
require("script.Message.MsgPlayer")
require("script.Message.Msgrank")
require("script.Message.MsgRebate")
require("script.Message.MsgRecharge")
require("script.Message.MsgRoom")
require("script.Message.MsgSignIn")
require("script.Message.MsgTask")
require("script.Message.MsgVip")
protobuf.register_file("pb/Ack.pb")
protobuf.register_file("pb/Agent.pb")
protobuf.register_file("pb/Backpack.pb")
protobuf.register_file("pb/BaseMessage.pb")
protobuf.register_file("pb/Chat.pb")
protobuf.register_file("pb/Friend.pb")
protobuf.register_file("pb/Guide.pb")
protobuf.register_file("pb/Keys.pb")
protobuf.register_file("pb/Login.pb")
protobuf.register_file("pb/Mail.pb")
protobuf.register_file("pb/NewFeature.pb")
protobuf.register_file("pb/Notify.pb")
protobuf.register_file("pb/OperActivity.pb")
protobuf.register_file("pb/Player.pb")
protobuf.register_file("pb/Rank.pb")
protobuf.register_file("pb/Rebate.pb")
protobuf.register_file("pb/Recharge.pb")
protobuf.register_file("pb/Room.pb")
protobuf.register_file("pb/SignIn.pb")
protobuf.register_file("pb/Task.pb")
protobuf.register_file("pb/Vip.pb")
