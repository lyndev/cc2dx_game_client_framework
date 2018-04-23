CSimpleQueue = {}
CSimpleQueue.__index = CSimpleQueue

--功能: 无
--参数: 无
--返回: 无
--备注: 无
function CSimpleQueue:New()
    local queue = {first = 0, last = -1, size = 0}
    setmetatable(queue, CSimpleQueue)
    return queue
end

--功能: 压入对头
--参数: 压入元素
--返回: 无
--备注: 无
function CSimpleQueue:PushFront(value)
    if value == nil then
        return
    end

    local first = self.first - 1
    self.first = first
    self[first] = value
    self.size = self.size + 1
end

--功能: 压入队尾
--参数: 压入元素
--返回: 无
--备注: 无
function CSimpleQueue:PushBack(value)
    if value == nil then
        return
    end
    local last = self.last + 1
    self.last = last
    self[last] = value
    self.size = self.size + 1
end

--功能: 弹出队尾
--参数: 无
--返回: 队尾元素
--备注: 无
function CSimpleQueue:PopFront()
    local first = self.first
    if self.size == 0 then
        return nil
    else
        local value = self[first]
        self[first] = nil
        self.first = first + 1
        self.size = self.size - 1
        return value
    end
end

--功能: 弹出队头
--参数: 无
--返回: 队头元素
--备注: 无
function CSimpleQueue:PopBack()
    local last = self.last
    if self.size == 0 then
        return nil
    end
    local value = self[last]
    self[last] = nil
    self.last = last - 1
    self.size = self.size - 1
    return value
end

--功能: 获得队尾
--参数: 无
--返回: 队尾元素
--备注: 无
function CSimpleQueue:GetFront()
    if self:IsEmpty() then  
        return nil  
    else  
        local value = self[self.first]  
        return value  
    end
end

--功能: 获得队头
--参数: 无
--返回: 队头元素
--备注: 无
function CSimpleQueue:GetBack()
    if self:IsEmpty() then  
        return nil  
    else  
        local value = self[self.last]  
        return value  
    end
end

--功能: 队列是否为空
--参数: 无
--返回: true/false
--备注: 无
function CSimpleQueue:IsEmpty()
    return (self.size == 0)
end

--功能: 队列长度
--参数: 无
--返回: int
--备注: 无
function CSimpleQueue:Size()
    return self.size
end

--功能: 清空队列
--参数: 无
--返回: 无
--备注: 无
function CSimpleQueue:Clear()
    while false == self:IsEmpty() do  
        self:PopFront()
    end
end

--功能: 队列遍历迭代器
--参数: 无
--返回: 无
--备注: 无
function CSimpleQueue:Iter()
    local start = self.first
    return function()
        if(start > self.last) then
            return nil
        else
            local value = self[start]
            start = start + 1
            return value
        end
    end
end