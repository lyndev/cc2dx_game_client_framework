Q_Task_index={["q_id"]=1,
["q_task_type"]=2,
["q_exp_limit"]=3,
["q_task_name"]=4,
["q_describe"]=5,
["q_icon"]=6,
["q_finish_condition"]=7,
["q_condition1_num"]=8,
["q_condition2_num"]=9,
["q_condition3_num"]=10,
["q_condition4_num"]=11,
["q_script_id"]=12,
["q_repeat_finish"]=13,
["q_automatic_award"]=14,
["q_automatic_task_id"]=15,
["q_task_reward"]=16,
["q_task_reward_exp"]=17,
}

Q_Task={[1]={1,1,0,"团队制胜","参与两场战斗","8001.png","1.0",2,0,0,0,0,0,0,0,"30000_100|30001_10|3000_2|3001_4",50},
[2]={2,1,0,"大杀四方","在战斗中获胜两场","8002.png","2.0",2,0,0,0,0,0,0,0,"30000_101|30001_11|3000_3|3001_5",100},
[3]={3,1,10,"测试用1","参与两场个人匹配","8001.png","4.0",2,0,0,0,0,0,0,0,"30000_100|30001_10|3000_2|3001_4",150},
[4]={4,1,0,"测试用2","猎杀三辆坦克","8002.png","3.0",3,0,0,0,0,0,0,0,"30000_101|30001_11|3000_3|3001_5",200},
[5]={5,1,0,"测试用3","在四场个人匹配中胜利两次","8001.png","2_4",2,4,0,0,0,0,0,0,"30000_100|30001_10|3000_2|3001_4",250},
[6]={6,1,0,"测试用4","在三场战斗内击毁两辆坦克","8002.png","1_3",3,2,0,0,0,0,0,0,"30000_101|30001_11|3000_3|3001_5",300},
[7]={7,1,0,"测试用5","在四场个人匹配中胜利两次","8001.png","2_4",2,4,0,0,0,0,0,0,"30000_100|30001_10|3000_2|3001_4",350},
[8]={8,1,0,"测试用6","在三场战斗内击毁两辆坦克","8002.png","1_3",3,2,0,0,0,0,0,0,"30000_101|30001_11|3000_3|3001_5",400},
[9]={9,1,0,"测试用7","在四场个人匹配中胜利两次","8001.png","2_4",2,4,0,0,0,0,0,0,"30000_100|30001_10|3000_2|3001_4",450},
[10]={10,1,0,"测试用8","在三场战斗内击毁两辆坦克","8002.png","1_3",3,2,0,0,0,0,0,0,"30000_101|30001_11|3000_3|3001_5",500},
}
Q_Task.GetTempData = function (key, strName)
                             if not Q_Task[key] or not Q_Task_index[strName] or type(key) == "function" then
                                    log_info("Q_Task.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Task[key]) ~= "table" then
                                    log_info("Q_Task.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Task[key][Q_Task_index[strName]]
                             if not pData then
                                 log_info("Q_Task.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
