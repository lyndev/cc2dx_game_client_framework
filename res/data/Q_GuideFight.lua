Q_GuideFight_index={["q_id"]=1,
["q_player_id"]=2,
["q_camp_id"]=3,
["q_tank_id"]=4,
["q_pos_x"]=5,
["q_pos_y"]=6,
["q_location"]=7,
["q_name"]=8,
["q_facade_id"]=9,
}

Q_GuideFight={[1]={1,"1.0",1,100,3360,1088,1,"的的",600},
[2]={2,"2.0",2,110,3360,900,6,"重装",602},
[3]={3,"3.0",2,102,3360,800,7,"前线",611},
}
Q_GuideFight.GetTempData = function (key, strName)
                             if not Q_GuideFight[key] or not Q_GuideFight_index[strName] or type(key) == "function" then
                                    log_info("Q_GuideFight.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_GuideFight[key]) ~= "table" then
                                    log_info("Q_GuideFight.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_GuideFight[key][Q_GuideFight_index[strName]]
                             if not pData then
                                 log_info("Q_GuideFight.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
