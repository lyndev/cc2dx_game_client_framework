--[[
-- Copyright (C), 2015, 
-- 文 件 名: TankPackage.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-03-14
-- 完成日期: 
-- 功能描述: 坦克仓库
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CTankPackage.log'

CTankPackage = {}
CTankPackage.__index = CTankPackage
CTankPackage._instance = nil

--[[
-- 函数类型: public
-- 函数功能: 构造一个坦克库
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:New(o)
	o = o or {}
	setmetatable(o, CTankPackage)
	o.m_tTankMap            = {}                   -- 坦克的实例表 key = 模版ID, value = 坦克事例
	o.m_tTankID             = {}                   -- 坦克的ID表   key = 模版ID, value = 坦克的ID
	o.m_nCurTankTemplateID  = 0                    -- 当前选择的tank模版ID
	o.m_tTankType 			= {}				   -- 根据类型保存坦克的id
	o.m_tAllTankType 		= {}
	o.m_nUpdateTankId       = nil
	return o
end

--[[
-- 函数类型: public
-- 函数功能: 单例获取
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetInstance( msg )
	if not CTankPackage._instance then
		CTankPackage._instance = self:New()
	end
	return  CTankPackage._instance
end

--[[
-- 函数类型: public
-- 函数功能: 初始化
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:Init(param)
	self:OnRegisterMsgHandler_()
	--self:ReqInitTank()
end

--[[
-- 函数类型: public
-- 函数功能: 消息处理函数初始化
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:OnRegisterMsgHandler_()

	-- 坦克列表初始化
	MsgEventRegister:AddMsgEventListener(MSGID.SC_TANK_RESTANKS, self, self.ResInitTanks)

	-- 坦克信息更新
	MsgEventRegister:AddMsgEventListener(MSGID.SC_TANK_RESCHANGEITEM, self, self.ResUpdateTankInfo)
end

--[[
-- 函数类型: public
-- 函数功能: 请求初始化坦克数据
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqInitTank()
	local _roleId = CPlayer:GetInstance():GetRoleID()
	if _roleId == 0 then
		log_error(LOG_FILE_NAME, '请求坦克列表错误, 玩家ID不存在 = 0')
	end
	local sendData = 
	{
		roleId = _roleId,
	}
	local buffer = protobuf.encode(MSGTYPE[MSGID.CS_TANK_REQROLETANKS], sendData)
	SendMsgToServer(MSGID.CS_TANK_REQROLETANKS, buffer, #buffer)   
end

--[[
-- 函数类型: public
-- 函数功能: 坦克列表初始化
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ResInitTanks( nMsgID, pData, nLen )
	local msgData = ParseMsgId( nMsgID, pData, nLen )
	if msgData then
		if msgData.tanks then
			for k, tankInfo in pairs(msgData.tanks) do
				self:AddTank(tankInfo.tankConfigId, tankInfo)
			end 

			local _curUseTankInfo = self:GetTankByTankID(msgData.currentTankId)
			if _curUseTankInfo then
				
				-- 设置当前出战的坦克
				self:SetCurrentTankID(_curUseTankInfo:GetTemplateID())
			else
				log_error(LOG_FILE_NAME, '当前出战的坦克的实例数据不存在！')
			end

			-- 发送更新坦克列表事件
			local _event = {name = CEvent.Tank.InitTankList}
			gPublicDispatcher:DispatchEvent(_event)
		else
			log_error(LOG_FILE_NAME, '初始化坦克数据失败,坦克列表服务器返回的数据为空!')
		end
	else
		log_error(LOG_FILE_NAME, '初始化坦克数据失败,服务器返回的数据为空!')
	end
end

--[[
-- 函数类型: public
-- 函数功能: 更新单个坦克的信息
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ResUpdateTankInfo( nMsgID, pData, nLen )
	local msgData = ParseMsgId( nMsgID, pData, nLen )
	if msgData then
		local _tankInfo = msgData.tank

		dump(_tankInfo, "坦克信息更新")

		self:AddTank(_tankInfo.tankConfigId, _tankInfo)

		-- 更新坦克准备仓皮肤界面
		SendLocalMsg(MSGID.CC_UI_UPDATA_REAYTANKCABINSKIN, 0, 0)

		-- 发送界面更新消息
		SendLocalMsg(MSGID.CC_UI_UPDATE_TANKEQUIP, 0, 0)

		-- 更新当前可装配列表
		SendLocalMsg(MSGID.CC_UI_UPDATE_EQUIPLISTUI, 0, 0)

		-- 保存当前更新的坦克ID
		self:SetUpdateTankId(_tankInfo.tankConfigId)

	else
		log_error(LOG_FILE_NAME, "更新坦克道具失败")
	end
end

--[[
-- 函数类型: public
-- 函数功能: 消息处理函数
-- 参数[IN]: nMsgId: 消息ID, pData: 消息数据首地址, nLen: 消息数据长度
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:MessageProc(nMsgId, pData, nLen)
	local parser = ParseMsgId( nMsgId, pData, nLen )
end

--[[
-- 函数类型: public
-- 函数功能: 添加一辆tank
-- 参数[IN]: 坦克事例
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:AddTank(templateID, tankInfo)
	local _pTank = CTemplateFactory.CreateObject( ENUM.CLASS_TYPE.CLASS_TANKITEM, templateID, tankInfo)
	if _pTank then
		local _tankType = _pTank:GetTankType()
		local _templateId = _pTank:GetTemplateID()
		local _serverId = _pTank:GetServerID()
		if not self.m_tTankType[_tankType] then
			self.m_tTankType[_tankType] = {}
		end
		self.m_tTankType[_tankType][_templateId]  = _templateId
		self.m_tAllTankType[_templateId]  = _templateId
		self.m_tTankMap[_templateId] = _pTank
		self.m_tTankID[_serverId] = _templateId
	else
		log_error(LOG_FILE_NAME, "创建坦克道具实体失败")
	end
end

function CTankPackage:GetTankListByType(tankType)
	if self.m_tTankType and self.m_tTankType[tankType] then
		return self.m_tTankType[tankType]
	end
	return self.m_tAllTankType
end

--[[
-- 函数类型: public
-- 函数功能: 移除一辆坦克
-- 参数[IN]: 模版ID
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:RemoveTank( nTemplateID )
	self.m_tTankMap[nTemplateID] = nil
	self.m_tTankID[nTemplateID]  = nil
end

--[[
-- 函数类型: public
-- 函数功能: 获取tank列表
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetAllTank()
	return self.m_tTankMap or {}
end

--[[
-- 函数类型: public
-- 函数功能: 获取坦克通过
-- 参数[IN]: 坦克ID
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetTankByTankID( tankID )
	local _nTemplateID = self:GetTemplateIDByTankID(tankID)
	if _nTemplateID then
		return self:GetTankByTemplateID(_nTemplateID)
	else
		log_error(LOG_FILE_NAME, "不存在的坦克事例,坦克ID:%d", tankID)
	end
	return nil
end

--[[
-- 函数类型: public
-- 函数功能: 获取坦克通过
-- 参数[IN]: 坦克模版ID
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetTankByTemplateID( nTemplateID )
	return self.m_tTankMap[nTemplateID]
end

--[[
-- 函数类型: public
-- 函数功能: 通过tankId获取坦克事例
-- 参数[IN]: 模版ID
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetTemplateIDByTankID( nTankID )
	return self.m_tTankID[nTankID]
end

--[[
-- 函数类型: public
-- 函数功能: 通过模版ID获取坦克的服务器ID
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetTankIDByTemplateID(nTemplateID)
	local _pTank = self.m_tTankMap[nTemplateID]
	if _pTank then
		return _pTank:GetServerID()
	else
		log_error(LOG_FILE_NAME, '获取坦克失败：%d', nTemplateID)
	end
end

--[[
-- 函数类型: public
-- 函数功能: 设置当前选择的坦克
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:SetCurrentTankID( nTemplateID )
	if nTemplateID and type(nTemplateID) == 'number' then
		self.m_nCurTankTemplateID = nTemplateID
	else
		log_error(LOG_FILE_NAME, "设置当前坦克失败，模版ID数据类型不对")
	end
end

--[[
-- 函数类型: public
-- 函数功能: 获取当前使用的坦克模版ID
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetCurrentUseTankTemplateID()
	return self.m_nCurTankTemplateID
end

--[[
-- 函数类型: public
-- 函数功能: 请求设置自动修理的状态
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqSetRepairState()
	-- body
end

--[[
-- 函数类型: public
-- 函数功能: 请求当前选择的tank
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqSetCurrentSelectTank( curTankID )
	local sendData = 
	{
		roleId = CPlayer:GetInstance():GetRoleID(),
		tankId = curTankID,
	}
	local buffer = protobuf.encode(MSGTYPE[MSGID.CS_TANK_REQSELECTTANKS], sendData)
	SendMsgToServer(MSGID.CS_TANK_REQSELECTTANKS, buffer, #buffer)    
end

--[[
-- 函数类型: public
-- 函数功能: 请求手动修理坦克
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqManualRepair( ... )
	-- body
end

--[[
-- 函数类型: public
-- 函数功能: 响应获取一辆坦克
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ResAddTank()

end

--[[
-- 函数类型: public
-- 函数功能: 请求穿戴坦克皮肤 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqUseTankSkin(params)
	if params then
		local msgData = 
		{
			tankId = params.tankId,
			tankSkinId = params.tankSkinId,
		}
		local buffer = protobuf.encode(MSGTYPE[MSGID.CS_TANK_REQUSESKIN], msgData)
    	SendMsgToServer(MSGID.CS_TANK_REQUSESKIN, buffer, #buffer)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 请求购买和穿戴该坦克皮肤 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:ReqBuyAndTankSkin(params)
	if params then
		local msgData = 
		{
			tankId = params.tankId,
			tankSkinId = params.tankSkinId,
		}
		local buffer = protobuf.encode(MSGTYPE[MSGID.CS_TANK_REQBUYANDUSESKIN], msgData)
    	SendMsgToServer(MSGID.CS_TANK_REQBUYANDUSESKIN, buffer, #buffer)  
	end
end

function CTankPackage:ReqAutoFill(params)
	local msgData = 
	{
		autoFillState = params.state or 1,
	}
	local buffer = protobuf.encode(MSGTYPE[MSGID.CS_TANK_REQAUTOFILL], msgData)
	SendMsgToServer(MSGID.CS_TANK_REQAUTOFILL, buffer, #buffer)  	
end

--[[
-- 函数类型: public
-- 函数功能: 获取当前更新的坦克id
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:GetUpdateTankId()
	return self.m_nUpdateTankId
end

function CTankPackage:SetUpdateTankId(tankConfigId)
	self.m_nUpdateTankId = tankConfigId
end

--[[
-- 函数类型: public
-- 函数功能: 销毁(析构)
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CTankPackage:Destroy()
	
	-- 移除消息处理函数
	MsgEventRegister:RemoveMsgEventListener(self)
	
	self.m_tTankMap = nil
	self.m_tTankID = nil
	self.m_nCurTankTemplateID = nil
	self.m_tTankType = nil
	self.m_tTankMap = nil
	CTankPackage._instance = nil
end