Q_Technology_index={["q_id"]=1,
["q_technology_name"]=2,
["q_technology_desc"]=3,
["q_technology_icon_id"]=4,
["q_open_consume_id"]=5,
["q_produce_consume_id"]=6,
["q_produce_id"]=7,
["q_produce_skill_id"]=8,
["q_produce_buff_id"]=9,
["q_produce_time"]=10,
["q_continue_time"]=11,
}

Q_Technology={[1]={1,"国战燃油","用于国战建制移动，抢夺更多领土","30002.png","30000_1000","30003_2","30002_1",0,0,5,0},
}
Q_Technology.GetTempData = function (key, strName)
                             if not Q_Technology[key] or not Q_Technology_index[strName] or type(key) == "function" then
                                    log_info("Q_Technology.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Technology[key]) ~= "table" then
                                    log_info("Q_Technology.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Technology[key][Q_Technology_index[strName]]
                             if not pData then
                                 log_info("Q_Technology.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
