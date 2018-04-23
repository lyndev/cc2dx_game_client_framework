local mark={}
function Snapshot(source, parent)
    if parent == true then
        mark = {}
    end
    local ret = {}
    mark[source] = parent
    for k, v in pairs(source) do
        if type(v) == "table" then
            if mark[v] then
                ret[k] = "_table_"
            else
                ret[k] = Snapshot(v, source)
            end
        else
            ret[k] = v
        end
    end
    return ret
end

function Compare(source, target, fatherK)
    mark = {}
    for k, v in pairs(source) do
        local ret = target[k]
        if not ret then
            release_print("add:", k, v, fatherK)
        elseif type(v) == "table" and type(ret) == "table" then
            Compare(v, ret, k)
        elseif type(v) ~= type(ret) and ret ~= "_table_" then
            release_print("change:", k, type(v), type(ret))
        end
    end
end

--debug.getregistry()
--_G
-- release_print(collectgarbage("count"))
-- local snap = Snapshot(_G, true)
-- Compare(_G, snap)
-- snap = nil
-- collectgarbage("collect")
-- release_print(collectgarbage("count"))