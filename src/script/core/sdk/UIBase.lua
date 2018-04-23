--[[
-- Copyright (C), 2015, 
-- 文 件 名: UIBase.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-12-20
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CUIBase.log'

CUIBase = class('CUIBase')

--功能: 创建UI
--参数: 无
--返回: 创建结果
--备注: 无
function CUIBase:Create(o)
	--子类必须覆写此接口
    assert(false and 'not implemented')
end

-- 功能: 初始化UI
-- 参数: 无
-- 返回: 无
-- 备注: 无
function CUIBase:Init()
	--子类必须覆写此接口
    assert(false and 'not implemented')
end

-- 功能: 销毁UI
-- 参数: 无
-- 返回: 无
-- 备注: 无
function CUIBase:OnDestroy()
    --子类必须覆写此接口
    assert(false and 'not implemented')
end

-- 功能: 帧更新
-- 参数: dt 根据需求，可能会除以加速倍速：CLuaLogic.GetUpdateSpeed()
-- 返回: 无
-- 备注: 无
function CUIBase:Update(dt)
    --子类根据需求覆写此接口
end

-- 功能: 消息处理
-- 参数: msgId, data, len
-- 返回: 无
-- 备注: 无
function CUIBase:MessageProc(msgId, data, len)
    --子类根据需求覆写此接口
end

--[[
-- 函数类型: public
-- 函数功能: 显示或者显示
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CUIBase:SetVisible(bShow)
    -- 子类根据需求覆写此接口
    -- 加入UI堆栈的UI必须重写 SetVisible() 函数
end

-- 以下为可选接口

-- 数据更新
function CUIBase:UpdateData(MsgTbl)
    print('UpdateData not implemented')
end