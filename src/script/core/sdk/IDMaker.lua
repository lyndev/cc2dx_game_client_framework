-- [[
-- Copyright (C), 2015, 
-- 文 件 名: IDMaker.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2015-12-23
-- 完成日期: 
-- 功能描述: 游戏中的唯一ID生成器
-- 其它相关: 
-- 修改记录: 
-- ]]

-- 日志文件名
local LOG_FILE_NAME = 'CIDMaker.log'

IDMaker = {}
IDMaker._id = 1
function IDMaker.GetID()
	IDMaker._id  = IDMaker._id + 1
	return IDMaker._id
end