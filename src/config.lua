
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}

-- res update on-off
GAME_HOT_UPDATE = false
USE_ZIP_GAME_HOT_UPDATE = false

-- network
GAME_CONNECT_TIMEOUT   = 14
GAME_SERVER_IP         = "127.0.0.1"
GAME_SERVER_PORT       =  10086
GAME_PROXY_SERVER_IP   = "127.0.0.1"
GAME_PROXY_SERVER_PORT =  10086
GAME_SERVER_UDP_PORT   = 7777
GAME_CLIENT_UDP_PORT   = 20002