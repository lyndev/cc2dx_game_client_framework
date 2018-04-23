-- 地图资源生成
-- Author: hewei
-- Date: 2016-04-01 15:51:19
--

-- 日志文件名
local LOG_FILE_NAME = 'MapConfig.log'

function GetMapResoures( sul )
	local _mapTable = require(sul)
	local _imgTab = {}
 	for k,v in pairs(_mapTable) do
        if k == "tilesets" then
            for kk,vv in pairs(v) do
                table.insert(_imgTab,#_imgTab + 1,vv.image)
            end
        else
        	log_error(LOG_FILE_NAME, "解析失败")
        end
    end
    return _imgTab
end
