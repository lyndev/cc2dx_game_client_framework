
FilterMsgID = {}

FilterMsgID.filterMsgID = 
{	
	-- 这里配置不需要打印的msg的id
	[151210] = true,
	[151211] = true,
	[151110] = true,
	[151111] = true,
	[151212] = true,
	[151212] = true,
	[100199] = true,
	[1404] = true,
	
}
function FilterMsgID.ShowLog(msgId)
	return not FilterMsgID.filterMsgID [msgId]
end
