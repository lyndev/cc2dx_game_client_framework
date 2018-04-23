-- =========================================================================
-- 文 件 名: StartUpCommand.lua
-- 作    者: lyn
-- 创建日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- =======================================================================

StartUpCommand = class(StartUpCommand, ControllerCommand)
function StartUpCommand:Execute(message)
    -- 初始化管理器
    AppFacade:GetInstance():AddManager("MusicPlayer")
    AppFacade:GetInstance():AddManager("TimerManager")
    AppFacade:GetInstance():AddManager("NetworkManager")
    AppFacade:GetInstance():AddManager("ResourceManager")
    AppFacade:GetInstance():AddManager("MusicPlayer")
    AppFacade:GetInstance():AddManager("ObjectPoolManager")
end
