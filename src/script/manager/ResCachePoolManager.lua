--[[
-- Copyright (C), 2016, 
-- 文 件 名: ResCachePoolManager.lua
-- 作    者: 
-- 版    本: V1.0.0
-- 创建日期: 2016-03-3
-- 完成日期: 
-- 功能描述:资源缓冲池
-- 其它相关: 
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CResCachePoolManager.log'
CResCachePoolManager = {}
CResCachePoolManager.__index = CResCachePoolManager 
CResCachePoolManager._instance = nil

-- /////////////////////////// 宏 //////////////////////
local CACHE_POOL_MAX  = 50     -- 缓冲池能装资源的最多个数

local RES_ENEM = {
	IMAGE        = 1,    -- 纹理
	SPRITEFRAMES = 2,    -- 帧缓存

}

function CResCachePoolManager:New()
    local o = {}
    o.m_tCaCaheTab  = {}  -- 缓冲池
    setmetatable( o, CResCachePoolManager )
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 得到单例
-- 参    数: 
-- 返 回 值: 返回单例
-- 备    注:
-- ]]
function CResCachePoolManager:GetInstance()
    if not CResCachePoolManager._instance then
        CResCachePoolManager._instance = self:New()
    end
    return  CResCachePoolManager._instance
end

--[[
-- 函数类型: public
-- 函数功能: 加入一个到缓冲池中
-- 参数[IN]: m_type (资源类型) m_name(资源名字)  保存的格式如：ResType= 1 ResName = "" ResAddTime = 12545
-- 返 回 值: 无
-- 备    注:
--]]
function CResCachePoolManager:AddResToCachePool( m_type, m_name )
	if m_type ~= nil and m_name ~= nil then
		local _tempTab = {
			ResType = m_type,
			ResName = m_name,
			ResAddTime = os.time(),
		}
		if #self.m_tCaCaheTab < CACHE_POOL_MAX then
			table.insert(self.m_tCaCaheTab, #self.m_tCaCaheTab + 1, _tempTab)
		else
			self:ReMoveResFromCachePool()
			table.insert(self.m_tCaCaheTab, #self.m_tCaCaheTab + 1, _tempTab)
		end		
	else
	  	log_error(LOG_FILE_NAME,"传入参数有误")
	end
end

--[[
-- 函数类型: private
-- 函数功能: 从缓冲池移除一个缓冲,根据加入的时间
-- 参数[IN]: 
-- 返 回 值: 无
-- 备    注:
--]]
function CResCachePoolManager:ReMoveResFromCachePool( )
	local _resAddTime = self.m_tCaCaheTab[1] or 0
	local _resIndex = 1
	if _resAddTime == 0 then
		return
	end

	-- 获得最早加入资源的k值
	for k,v in pairs(self.m_tCaCaheTab) do
		if v.ResAddTime > _resAddTime then
			_resIndex = k
		end
	end
	self:RemoveResFromeGameCache(self.m_tCaCaheTab[_resIndex])

	-- 从缓冲池中移除该资源
	table.remove(self.m_tCaCaheTab, _resIndex)
end

--[[
-- 函数类型: private
-- 函数功能: 从缓存中移除资源
-- 参数[IN]: m_tab 包含资源的类型,名字
-- 返 回 值: 无
-- 备    注:
--]]
function CResCachePoolManager:RemoveResFromeGameCache( m_tab )
	if m_tab then
		if m_tab.ResType == RES_ENEM.IMAGE then
			display.removeImage(m_tab.ResName..".png")
		elseif m_tab.ResType == RES_ENEM.SPRITEFRAMES  then
			display.removeSpriteFrames(m_tab.ResName..".pvr", m_tab.ResName..".png" )
		end
	else
		log_error(LOG_FILE_NAME,"移除资源有误")
	end
end

-- [[
-- 函数类型: private
-- 函数功能: 销毁单例
-- 参    数: 无
-- 返 回 值: 
-- 备    注:
-- ]]
function CResCachePoolManager:Destroy()
    CResCachePoolManager._instance = nil
end
