--[[
-- Copyright (C), 2015, 
-- 文 件 名: MusicPlayer.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2016-08-03
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 注明按钮的点击音效在：UI编辑器里面添加mp3路径（C++的UIWidget统一处理，便于管理有的按钮不需要按钮点击）
-- 修改记录: 
--]]

-- 日志文件名
local LOG_FILE_NAME = 'CMusicPlayer.lua.log'

CMusicPlayer = class("CMusicPlayer")

CMusicPlayer._instance = nil

local SOUND_TYPE = 

    EFFECT = 1,        -- 音效
    MUSIC  = 2,        -- 音乐 
}

--[[
-- 函数类型: public
-- 函数功能: 构造音乐播放
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注: 
--]]
function CMusicPlayer:New(o)
    o = o or }
    setmetatable(o, CMusicPlayer)
    o.m_Engine = cc.SimpleAudioEngine:getInstance()
    o.m_EnableBg = true
    o.m_EnableEffect = true
    o.m_BgPath = nil
    o.m_BgLoop = false
    o.m_PreLoadList = }
    o.m_PreLoadFightList = }
    o.m_EffectIDList = }
    o.m_BlockIdList = }
    o.m_PreLoadOver = true
    return o
end

--[[
-- 函数类型: public
-- 函数功能: 音乐管理器单例
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:GetInstance()
    if not CMusicPlayer._instance then
        CMusicPlayer._instance = self:New()
    end
    return CMusicPlayer._instance 
end

--[[
-- 函数类型: public
-- 函数功能: 设置背景音乐大小
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:SetBGMVolume(volume)
     self.m_Engine:setMusicVolume(volume)
end

--[[
-- 函数类型: public
-- 函数功能: 设置音效音量大小
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:SetEffectVolume(volume)
     self.m_Engine:setEffectsVolume(volume)
end

--[[
 -- 函数类型: public
 -- 函数功能: 设置是播放背景音乐
 -- 参数[IN]: 无
 -- 返 回 值: 无
 -- 备    注:
 --]] 
function CMusicPlayer:SetIsEnabledBGM(bEnable)
    self.m_EnableBg = bEnable
    if not bEnable and self.m_Engine then
        self.m_Engine:stopMusic(bEnable)
    else
        self.m_Engine:playMusic(self.m_BgPath, self.m_BgLoop)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 设置是否播放音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:SetIsEnabledEffect(bEnable)
    self.m_EnableEffect = bEnable

    if not bEnable and self.m_Engine then
        self.m_Engine:stopAllEffects()
    end
end

--[[
-- 函数类型: public
-- 函数功能: 背景乐音乐是否开启
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:IsEnableBGM()
    return self.m_EnableBg
end

--[[
-- 函数类型: public
-- 函数功能: 音效是否开启
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:IsEnableEffect()
    return self.m_EnableEffect
end

--[[
-- 函数类型: public
-- 函数功能: 停止所有音乐和音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:StopAll()

    self.m_BgPath = nil
    self.m_Engine:stopMusic(true)
    self.m_Engine:stopAllEffects()

    _instance = nil
end

--[[
-- 函数类型: public
-- 函数功能: 停止所有音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:StopAllEffects()
    self.m_Engine:stopAllEffects()
end

--[[
-- 函数类型: public
-- 函数功能: 停止播放音效通过事例ID
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:StopEffectById(soundInstanceId)
    self.m_Engine:stopEffect(soundInstanceId)
end


--[[
-- 函数类型: public
-- 函数功能: 
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PlayBGMById(id, bLoop)
    local _path = q_music.GetTempData(id, 'Path')
    if _path and _path ~= '' then
        self:PlayBGM(_path, bLoop or true)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 播放悲剧音乐
-- 参数[IN]: 路径, 是否循环
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PlayBGM(strPath, bLoop)
    self.m_BgPath = strPath
    self.m_BgLoop = bLoop
    local strPath = cc.FileUtils:getInstance():fullPathForFilename(strPath)
    print("player music ", strPath)
    self.m_Engine:playMusic(strPath, true)
end

--[[
-- 函数类型: public
-- 函数功能: 停止背景音乐
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:StopBGM()
    if IsGameServer then
        return
    end
    self.m_BgPath = nil
    self.m_Engine:stopMusic(false)
end

--[[
-- 函数类型: public
-- 函数功能: 暂停背景音乐
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PauseBGM()
    if not self.m_EnableBg then
        return
    end
    self.m_Engine:pauseMusic()
end

--[[
-- 函数类型: public
-- 函数功能: 回复背景音乐
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:ResumeBGM()
    if not self.m_EnableBg then
        return
    end
    self.m_Engine:resumeMusic()
end

--[[
-- 函数类型: public
-- 函数功能: 播放音效根据音效ID
-- 参数[IN]: 当前播放音效的事例id
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PlayEffectById(nEffectId, bLoop, nDelay)
    local strPath = q_music.GetTempData(nEffectId, "Path")
    local _effectInstanceId = 0
    if strPath ~= '' then
        -- 播放
       _effectInstanceId = self:PlayEffect(strPath, bLoop, nDelay)
       print("播放音效的实例id", _effectInstanceId)
        -- 同类型音效过滤
        self:SameCoustomTypeCheck(nEffectId, _effectInstanceId)
    end
    return _effectInstanceId
end

--[[
-- 函数类型: public
-- 函数功能: 播放音效根据音效名字, 是否延迟, 是否循环
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PlayEffect(strPath, bLoop, nDelay)
    strPath = cc.FileUtils:getInstance():fullPathForFilename(strPath)
    print("播放音效的路径", strPath)
    local _instanceId = self.m_Engine:playEffect(strPath, bLoop or false)
    return _instanceId
end

--[[
-- 函数类型: public
-- 函数功能: 同类型的音乐或音效检测
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:SameCoustomTypeCheck(nSoundId, instanceId)

    -- 音效自定义类型
    local _soundCoustomType = q_music.GetTempData(nSoundId, "CustomType")
    if _soundCoustomType then
        -- 处理屏蔽项
        if self.m_BlockIdList[_soundCoustomType] then
            local _lastSoundId = self.m_BlockIdList[_soundCoustomType].soundId
            local _soudType = q_music.GetTempData(_lastSoundId, "MusicType")
            if _soudType == SOUND_TYPE.EFFECT then
                self:StopEffectById(self.m_BlockIdList[_soundCoustomType].instanceId)
            end
            self.m_BlockIdList[_soundCoustomType] = nil
        end
        if not self.m_BlockIdList[_soundCoustomType] then
            self.m_BlockIdList[_soundCoustomType] = }
        end
        self.m_BlockIdList[_soundCoustomType].soundId = nSoundId
        self.m_BlockIdList[_soundCoustomType].instanceId = instanceId
    else
        log_error(LOG_FILE_NAME, "音效自定义类型获取错误:%d", nSoundId)
    end
end

--[[
-- 函数类型: public
-- 函数功能: 播放战斗音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PlayFightEffect( strPath, bLoop )
    if not strPath or type(strPath) ~= "string" then
        return
    end

    --解析参数
    local var = StrSplit(strPath, "|")
    local delay = tonumber(var[2] or 0)
    self:PlayEffect(var[1] or "", delay, bLoop)
end

--[[
-- 函数类型: public
-- 函数功能: 暂停所有音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PauseAllEffect()
    if not self.m_EnableEffect then
        return
    end
    self.m_Engine:pauseAllEffects()
end

--[[
-- 函数类型: public
-- 函数功能: 恢复所有音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:ResumeAllEffect()
    if not self.m_EnableEffect then
        return
    end
    self.m_Engine:resumeAllEffects()
end

--[[
-- 函数类型: public
-- 函数功能: 预加载战斗音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PreLoadEffect(heroList)
    -- TODO:根据坦克技能效果配置的音效，预加载音效
end

--[[
-- 函数类型: public
-- 函数功能: 添加预加载音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:AddPreLoadEffect(strName)
    if strName and type(strName) == "string" and #strName > 0 then
        if not self.m_PreLoadList[strName] then
            self.m_Engine:preloadEffect(strName)
            self.m_PreLoadList[strName] = true
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 加载战斗音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:AddPreLoadFightEffect(strName)
    if strName and type(strName) == "string" and #strName > 0 then
        if not self.m_PreLoadFightList[strName] then
            self.m_Engine:preloadEffect(strName)
            self.m_PreLoadFightList[strName] = true
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 预加载一次音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:PreLoadEffectOnce()
    self.m_PreLoadOver = true
    for k,v in pairs(self.m_PreLoadList) do
        if v == false then
            self.m_Engine:preloadEffect(k)
            self.m_PreLoadList[k] = true
            self.m_PreLoadOver = false
            break
        end
    end
end

--[[
-- 函数类型: public
-- 函数功能: 后期预加载是否加载完毕
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:GetPreLoadOver()
    return self.m_PreLoadOver
end

--[[
 -- 函数类型: public
 -- 函数功能: 卸载战斗音效
 -- 参数[IN]: 无
 -- 返 回 值: 无
 -- 备    注:
 --]] 
function CMusicPlayer:UnloadFightEffect(  )
    for path, _ in pairs(self.m_PreLoadFightList) do
        self.m_Engine:unloadEffect(path)
    end
    self.m_PreLoadFightList = }
    self.m_PreLoadOver = true
end

--[[
-- 函数类型: public
-- 函数功能: 卸载所有的音效
-- 参数[IN]: 无
-- 返 回 值: 无
-- 备    注:
--]]
function CMusicPlayer:UnloadAllEffect()
    for path, _ in pairs(self.m_PreLoadList) do
        self.m_Engine:unloadEffect(path)
    end
    self.m_PreLoadList = }
    self.m_PreLoadOver = true
end

function CMusicPlayer:Destroy()
   self:StopAll() 
   self:UnloadAllEffect()
end