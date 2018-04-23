Q_Selector_index={["q_id"]=1,
["q_Selector_name"]=2,
["q_center_point"]=3,
["q_target_type"]=4,
["q_direction"]=5,
["q_length"]=6,
["q_with"]=7,
}

Q_Selector={[1001]={1001,"","0|0",4,"1.0",10,1},
[1002]={1002,"敌方范围","0|0",4,"1|2|3|4",2,5},
[1003]={1003,"单体发射碰撞，子弹类，敌方","0|0",4,"1.0",1,1},
[1004]={1004,"己方范围","0|0",2,"1|2|3|4",10,10},
[1005]={1005,"自身","0|0",1,"1.0",0,0},
[1006]={1006,"光线","0|0",4,"1.0",10,5},
[1007]={1007,"4方向，敌方","0|0",4,"1|2|3|4",10,1},
[1008]={1008,"范围，敌方","0|0",4,"1|2|3|4",5,5},
[1009]={1009,"己方全体","0|0",2,"1|2|3|4",0,0},
[1010]={1010,"全体","0|0",5,"1.0",3,3},
[1011]={1011,"地面","0|0",6,"1.0",1,3},
}
Q_Selector.GetTempData = function (key, strName)
                             if not Q_Selector[key] or not Q_Selector_index[strName] or type(key) == "function" then
                                    log_info("Q_Selector.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Selector[key]) ~= "table" then
                                    log_info("Q_Selector.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Selector[key][Q_Selector_index[strName]]
                             if not pData then
                                 log_info("Q_Selector.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
