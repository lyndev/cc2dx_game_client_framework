CSimpleList = {}
CSimpleList.__index = CSimpleList

--功能: 构造
function CSimpleList:New()
    local list = {data = nil, next = nil, size = 0}
    setmetatable(list, CSimpleList)
    return list
end

--功能: 压入对链表头
--参数: 压入元素
function CSimpleList:PushFront(value)
    local head = self
    local node = {data = value, next = head.next}
    head.next = node
    self.size = self.size + 1    
end

--功能: 压入链表尾
--参数: 压入元素
function CSimpleList:PushBack(value)
    local head = self
    local node = {data = value, next = nil}
    while head.next ~= nil do
        head = head.next
    end
    head.next = node
    self.size = self.size + 1
end

--功能: 弹出链表尾
--返回: 链表尾元素
function CSimpleList:PopFront()
    local head = self
    if self.size == 0 then
        return nil
    else
        local data = head.next.data
        self.size = self.size - 1 
        head.next = head.next.next
        return data
    end
end

--功能: 弹出链表头
--返回: 链表头元素
function CSimpleList:PopBack()
    local head = self
    local father = head
    if self.size == 0 then
        return nil
    else
        while head.next ~= nil do
            father = head
            head = head.next
        end
        data = head.data
        self.size = self.size - 1
        father.next = nil
        return data
    end
end

--功能: 删除指定位置元素（位置由迭代器提供）
--参数: father:父节点，val:要删除的位置
--返回: 链表头元素
function CSimpleList:Erase(Iter)
    Iter.father.next = Iter.head.next
    self.size = self.size - 1
end

--功能: 获得链表尾
--返回: 链表尾元素
function CSimpleList:GetFront()
    if self.size == 0 then  
        return nil  
    else
        return self.next.data 
    end
end

--功能: 获得链表头
--返回: 链表头元素
function CSimpleList:GetBack()
    local head = self
    if self.size == 0 then  
        return nil  
    else  
        while head.next ~= nil do
            head = head.next
        end
        return head.data
    end
end

--功能: 链表列是否为空
--返回: true/false
function CSimpleList:IsEmpty()
    return (self.size == 0)
end

--功能: 链表长度
--返回: int
function CSimpleList:Size()
    return self.size
end

--功能: 清空链表
function CSimpleList:Clear()
    while 0 ~= self.size do  
        self:PopFront()
    end
    self.size = 0
end

--功能: 链表遍历迭代器
function CSimpleList:Iter()
    local head = self
    local father = self
    return function()
        father  = head
        head = head.next
        if head ~= nil then
            return {["head"]=head, ["father"] = father, ["data"] = head.data}
        else
            return nil
        end
    end
end