q_task_index={["Id"]=1,
["Name"]=2,
["Value"]=3,
["Rewards"]=4,
["Icon"]=5,
}

q_task={[1]={1,"分享N次朋友圈",1,"1:100,2:100","task_01.png"},
[2]={2,"分享N次给好友",1,"1:100,2:101","task_01.png"},
[3]={3,"玩大二N盘",2,"1:100,2:102","task_01.png"},
[4]={4,"玩麻将N盘",2,"1:100,2:103","task_01.png"},
[5]={5,"玩扑克N盘",2,"1:100,2:104","task_01.png"},
[6]={6,"赢大二N盘",1,"1:100,2:105","task_01.png"},
[7]={7,"赢麻将N盘",1,"1:100,2:106","task_01.png"},
[8]={8,"赢扑克N盘",1,"1:100,2:107","task_01.png"},
}
q_task.GetTempData = function (key, strName)
                             if not q_task[key] or not q_task_index[strName] or type(key) == "function" then
                                    log_info("q_task.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_task[key]) ~= "table" then
                                    log_info("q_task.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_task[key][q_task_index[strName]]
                             if not pData then
                                 log_info("q_task.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
