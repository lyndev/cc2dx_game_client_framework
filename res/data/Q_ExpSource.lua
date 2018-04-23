Q_ExpSource_index={["q_id"]=1,
["q_battle_mode"]=2,
["q_base_experience"]=3,
["q_smash"]=4,
["q_hurt"]=5,
["q_victory"]=6,
["q_mvp"]=7,
["q_quit"]=8,
}

Q_ExpSource={[1]={1,"个人匹配","6.0","1.5","0.001","25_-1","1.0",8},
[2]={2,"战队匹配","6.5","1.5","0.001","25_-1","1.0",8},
[3]={3,"周赛","7.0","1.5","0.001","25_-1","1.0",8},
[4]={4,"月赛","7.0","1.5","0.001","25_-1","1.0",8},
[5]={5,"联赛","8.0","1.5","0.001","25_-1","1.0",8},
[6]={6,"公会选拔赛","8.0","1.5","0.001","25_-1","1.0",8},
[7]={7,"国战","9.0","1.5","0.001","25_-1","1.0",8},
}
Q_ExpSource.GetTempData = function (key, strName)
                             if not Q_ExpSource[key] or not Q_ExpSource_index[strName] or type(key) == "function" then
                                    log_info("Q_ExpSource.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_ExpSource[key]) ~= "table" then
                                    log_info("Q_ExpSource.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_ExpSource[key][Q_ExpSource_index[strName]]
                             if not pData then
                                 log_info("Q_ExpSource.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
