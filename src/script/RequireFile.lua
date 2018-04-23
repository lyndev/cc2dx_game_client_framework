-- 垃圾回收 
collectgarbage("setpause", 100)  
collectgarbage("setstepmul", 5000) 

-- 游戏核心类
require "script.core.utils.Utility"
require "script.Enum"
require "script.core.net.MsgRegister"
require "script.core.net.NetManager"
require "script.core.animation.AnimationCreateManager"
require "script.core.entity.TemplateFactory"
require "script.core.entity.EntityManager"
require "script.core.entity.Player"
require "script.manager.WidgetManager"
require "script.manager.UIManager"
require "script.LuaLogic"

-- 游戏SDK
require "script.core.sdk.IDMaker"
require "script.core.sdk.Log"
require "script.core.sdk.MusicPlayer"
require "script.core.sdk.EventDispatcher"
require "script.core.sdk.PlistCache"
require "script.core.sdk.Event"
require "script.core.sdk.json"
require "script.core.sdk.TimerBase"
require "script.core.sdk.TimerManager"
require "script.core.sdk.TimerEvent"
require "script.core.sdk.TimerUtility"
require "script.core.sdk.SimpleQueue"
require "script.core.sdk.utf8"
require "script.core.sdk.UIOpenStack"

-- 功能模块
require "script.function.dirtyword.dirtyword"    
require "script.function.system.LocalNotice"
require "script.function.system.SystemSetting"
require "script.function.lobby.LobbyManager"

-- 其他
require "script.ui.UIWXHeadHelper"

-- 配置表
require "res.data.Q_Map"
require "res.data.Q_MapElement"


-- message加载
require "script.message.MsgRequire"

print("========================================")
print("\tload require finish")
print("========================================")