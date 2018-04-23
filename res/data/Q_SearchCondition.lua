Q_SearchCondition_index={["q_id"]=1,
["q_team_level"]=2,
["q_team_online"]=3,
["q_team_reamian_location"]=4,
["q_often_use_tank_type"]=5,
["q_role_level"]=6,
["q_match_level"]=7,
}

Q_SearchCondition={[0]={0,"0_16","0_6","0_6","0_3","0_51","0_22"},
}
Q_SearchCondition.GetTempData = function (key, strName)
                             if not Q_SearchCondition[key] or not Q_SearchCondition_index[strName] or type(key) == "function" then
                                    log_info("Q_SearchCondition.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_SearchCondition[key]) ~= "table" then
                                    log_info("Q_SearchCondition.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_SearchCondition[key][Q_SearchCondition_index[strName]]
                             if not pData then
                                 log_info("Q_SearchCondition.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
