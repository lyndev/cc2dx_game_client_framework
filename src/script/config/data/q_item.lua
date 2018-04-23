q_item_index={["Id"]=1,
["Name"]=2,
["Icon"]=3,
["Type"]=4,
["AnimationID"]=5,
["Quality"]=6,
["UseNeedLevel"]=7,
["CanUse"]=8,
["AddItem"]=9,
["Max"]=10,
["BuyPrice"]=11,
["SellPrice"]=12,
["UseTimeLimit"]=13,
["ShowInbag"]=14,
["Describe"]=15,
["TakeMaxMumber"]=16,
}

q_item={[1]={1,"金币","",0,"1",1,0,1,"",-1,"1000","1","-1_0",0,"金币",-1},
[2]={2,"钻石","",0,"1",1,0,1,"",-1,"1000","1","-1_0",0,"钻石",-1},
[3]={3,"补签卡","",0,"1",1,0,1,"",-1,"1000","1","-1_0",1,"可以补钱没有签到的日期",-1},
[4]={4,"开房卡","",0,"1",1,1,1,"1",1,"1","1","1",1,"创建房间消耗",-1},
[5]={5,"VIP月卡","",0,"1",1,1,1,"1",1,"1","1","1",1,"月卡",-1},
[6]={6,"VIP周卡","",0,"1",1,1,1,"1",1,"1","1","1",1,"周卡",-1},
}
q_item.GetTempData = function (key, strName)
                             if not q_item[key] or not q_item_index[strName] or type(key) == "function" then
                                    log_info("q_item.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_item[key]) ~= "table" then
                                    log_info("q_item.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_item[key][q_item_index[strName]]
                             if not pData then
                                 log_info("q_item.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
