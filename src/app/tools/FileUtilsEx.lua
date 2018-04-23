
--[[
    如果工程在F:\RDTankGame\目录下,runtime在F:\RDTankGame\runtime\win32\下
    1.用c++调试时,可写目录为：F:\RDTankGame\,
      包内的res和src的搜索路径为：F:\RDTankGame\res\和F:\RDTankGame\src\
      注意:此时热更新的到可写目录的路径会与包内的res和src的搜索路径相同
    2.用lua调试时,可写目录为：C:\Users\Administrator\AppData\Local\RDTankGame\
      包内的res和src的搜索路径为：F:\RDTankGame\runtime\win32\res\和F:\RDTankGame\runtime\win32\src\
]]--

local c = cc
local FileUtils = c.FileUtils

local _addSearchPath = FileUtils.addSearchPath
local _getWritablePath = FileUtils.getWritablePath

local WRITABLE_PATH_SUB_FOLDER = "Download/"


--重写addSearchPath
function FileUtils:addSearchPath(_path, _isFront)
    _addSearchPath(self, _path, _isFront)
end

--重写getWritablePath
function FileUtils:getWritablePath()
    local _path = _getWritablePath(self)
    _path = _path .. WRITABLE_PATH_SUB_FOLDER
    return _path
end

--修正搜索路径,去掉相同的
function FileUtils:LuaCorrectSearchPaths()
    local _paths = self:getSearchPaths()
    if type(_paths) == "table" then
        local _pathsNew = {}
        for i, _path in ipairs(_paths) do
            if nil == table.keyof(_pathsNew, _path) then
                table.insert(_pathsNew, _path)
            end
        end
        --dump(_pathsNew)
        self:setSearchPaths(_pathsNew)
    end
end

--添加搜索路径(默认添加到前面),添加过了就不再添加
function FileUtils:LuaAddSearchPath(_path, _isFront)
    _path = tostring(_path)
    if nil == _isFront then
        _isFront = false
    end
    local _paths = self:getSearchPaths()
    if nil == table.keyof(_paths, _path) then
        self:addSearchPath(_path, _isFront)
    end
    self:LuaCorrectSearchPaths()
end

--[[
--添加搜索路径,(默认添加到前面),添加过了就不再添加,同时添加可写目录下相应的路径
该接口主要是保证热更新正确,例如以下情况
apk保内有文件:res/abc/123.png
sd卡目录下也有文件:SD/res/abc/123.png
如果代码添加了搜索路径:res/abc/
通过代码:cc.Sprite:create("123.png")就不是优先用的SD卡下的文件
所以需要同时为SD添加相应搜索路径:SD/res/abc/
]]--
function FileUtils:LuaAddSearchPathBothSD(_path, _isFront)
    local _writablePath = self:getWritablePath()

    local i, j = string.find(_path, _writablePath)
    if i == nil then
        local __path = _writablePath .. _path
        print("SD PATH: " .. __path)
        self:LuaAddSearchPath(__path, _isFront)
    end

    self:LuaAddSearchPath(_path, _isFront)
end