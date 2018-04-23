Q_GoldSource_index={["q_id"]=1,
["q_battle_mode"]=2,
["q_base_gold"]=3,
["q_smash"]=4,
["q_hurt"]=5,
["q_victory"]=6,
["q_mvp"]=7,
["q_quit"]=8,
}

Q_GoldSource={[1]={1,"个人匹配","4.0","1.0","5.0E-4","16_-1","1.0","5.0"},
[2]={2,"战队匹配","4.5","1.0","5.0E-4","16_-1","1.0","5.0"},
[3]={3,"周赛","5.0","1.0","5.0E-4","16_-1","1.0","5.0"},
[4]={4,"月赛","5.0","1.0","5.0E-4","16_-1","1.0","5.0"},
[5]={5,"联赛","5.0","1.0","5.0E-4","16_-1","1.0","5.0"},
[6]={6,"公会选拔赛","5.0","1.0","5.0E-4","16_-1","1.0","5.0"},
[7]={7,"国战","6.0","1.0","5.0E-4","16_-1","1.0","5.0"},
}
Q_GoldSource.GetTempData = function (key, strName)
                             if not Q_GoldSource[key] or not Q_GoldSource_index[strName] or type(key) == "function" then
                                    log_info("Q_GoldSource.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_GoldSource[key]) ~= "table" then
                                    log_info("Q_GoldSource.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_GoldSource[key][Q_GoldSource_index[strName]]
                             if not pData then
                                 log_info("Q_GoldSource.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
