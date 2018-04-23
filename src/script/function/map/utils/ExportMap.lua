-- *******************************************************************************
-- Copyright (C), 2016, 
-- 文 件 名: ExportMap.lua
-- 作    者: lyn
-- 创建日期: 2017-01-16
-- 完成日期: 
-- 功能描述: 
-- 其它相关: 
-- 修改记录: 
-- *******************************************************************************
local LOG_FILE_NAME = 'ExportMap.lua.log'

ExportMap = class("ExportMap")

ExportMap.ExportType = {}
ExportMap.ExportType.Json = "json"
ExportMap.ExportType.Lua  = "lua"

function ExportMap:Export(exportType, mapData, path, desc)
	if exportType == ExportMap.ExportType.Lua then
		self:ExportToLua(mapData, path, desc)
	elseif exportType == ExportMap.ExportType.Json then
		self:ExprotToJson(mapData, desc)
	else
		log_error(LOG_FILE_NAME, "无效导出类型:%s", exportType)
	end
end

function ExportMap:ExportToLua(mapData, path, desc)
	local _exports = "return {\n"
	local _export_name   = "\tmap_name = ".."\""..(mapData.mapName or mapData.mapID).."\""..",\n"
	local _exprot_map_id = "\tmap_id = "..mapData.mapID..",\n"
	local _export_w      = "\twidth = "..mapData.width..",\n"
	local _export_h      = "\theight = "..mapData.height..",\n"
	local _export_tile_w = "\ttile_width = "..mapData.tileWidth..",\n"
	local _export_tile_H = "\ttile_height = "..mapData.tileHeight..",\n"
	local _export_bg_id  = "\tbackground_id = "..mapData.bgID..",\n"
	local _export_el_ids = "\telement_ids = {"
	local _ids = ""

	for x, v in pairs(mapData.tiles) do
		for y, tileInfo in pairs(v) do
			if tileInfo.sprite and tileInfo.id >= 0 then
				if x == mapData.width and y == mapData.height then
					_ids = _ids..tileInfo.id
				else
					_ids = _ids..tileInfo.id..","
				end
			else
				if x == mapData.width and y == mapData.height then
					_ids = _ids.."0"
				else
					_ids = _ids.."0,"
				end
				
			end
		end
		_ids = _ids.."\t\t\t\n"
	end
	_ids = _ids.."}\n}\n"

	_exports = _exports.._export_name .. _exprot_map_id.._export_w.._export_h.._export_tile_w.._export_tile_H.._export_bg_id.._export_el_ids.._ids

	local _fileName = "map_"..mapData.mapID..".lua"
	path = path or 'res/export_map_config/lua'
	local _outFile = io.open(path.."/".._fileName, "w+")
	if _outFile then
		_outFile:write(_exports)
		_outFile:flush()
   		Notice(desc or "地图数据导出Lua成功！")
   	else
   		Notice("地图数据导出Lua失败，路径不存在！")
   	end
end

function ExportMap:ExprotToJson(mapData)
	local _exports = "{\n"
	local _exprot_name   = "\t\"map_name\" :".."\""..(mapData.mapName or mapData.mapID).."\""..",\n"
	local _exprot_map_id = "\t\"map_id\" :"..mapData.mapID..",\n"
	local _export_w      = "\t\"width\" :"..mapData.width..",\n"
	local _export_h      = "\t\"height\" :"..mapData.height..",\n"
	local _export_tile_w = "\t\"tile_width\" :"..mapData.tileWidth..",\n"
	local _export_tile_H = "\t\"tile_height\" :"..mapData.tileHeight..",\n"
	local _export_bg_id  = "\t\"background_id\" :"..mapData.bgID..",\n"
	local _export_el_ids = "\t\"element_ids\":["

	local _ids = ""
	for x=1, mapData.width do
		for y=1, mapData.height do
			local tileInfo = mapData.tiles[x][y]
			if tileInfo.sprite and tileInfo.id >= 0 then
				if x == mapData.width and y == mapData.height then
						_ids = _ids..tileInfo.id
				else
					_ids = _ids..tileInfo.id..","
				end
			else
				if x == mapData.width and y == mapData.height then
					_ids = _ids.."0"
				else
					_ids = _ids.."0,"
				end
				
			end
		end
	end
	_ids = _ids.."]\n}"
	_exports = _exports.._exprot_name.._exprot_map_id.._export_w.._export_h.._export_tile_w.._export_tile_H.._export_bg_id.._export_el_ids.._ids

	local _fileName = "map_"..mapData.mapID..".json"
	local _outFile = io.open('res/export_map_config/json/'.._fileName, "w+")
    _outFile:write(_exports)
	_outFile:flush()
   	Notice("地图数据导出Json成功！")
end