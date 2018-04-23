--********************************************************************************
--  generate: protoForLuaTableTool.lua
--  version: v1.0.0
--  author: lyn
--********************************************************************************


 -- filse:proto/Task.proto

local _msgType =
{
    [ 106201 ] = "Task.ReqGetMainTaskAward", -- 领取奖励
    [ 106101 ] = "Task.ResMainTaskInfo", -- 更新任务如果没有则为新增如果有则为更新状态语义
    [ 106102 ] = "Task.ResGetMainTaskAward", -- 领取奖励结果
    [ 106103 ] = "Task.ResUpdateMainTask", -- 任务列表更新
    [ 106211 ] = "Task.ReqGetOneDailyTaskAward", -- 领取一个日常任务奖励
    [ 106111 ] = "Task.ResDailyTaskInfo", -- 更新任务如果没有则为新增如果有则为更新状态语义
    [ 106112 ] = "Task.ResGetOneDailyTaskAward", -- 领取日常任务结果
    [ 106113 ] = "Task.ResUpdateDailyTask", -- 更新任务如果没有则为新增如果有则为更新状态语义
}


local _msgID =
{
    CS_TASK_REQGETMAINTASKAWARD = 106201, -- 领取奖励
    SC_TASK_RESMAINTASKINFO = 106101, -- 更新任务如果没有则为新增如果有则为更新状态语义
    SC_TASK_RESGETMAINTASKAWARD = 106102, -- 领取奖励结果
    SC_TASK_RESUPDATEMAINTASK = 106103, -- 任务列表更新
    CS_TASK_REQGETONEDAILYTASKAWARD = 106211, -- 领取一个日常任务奖励
    SC_TASK_RESDAILYTASKINFO = 106111, -- 更新任务如果没有则为新增如果有则为更新状态语义
    SC_TASK_RESGETONEDAILYTASKAWARD = 106112, -- 领取日常任务结果
    SC_TASK_RESUPDATEDAILYTASK = 106113, -- 更新任务如果没有则为新增如果有则为更新状态语义
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
