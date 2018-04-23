Q_Notice_index={["q_id"]=1,
["q_notice_condition"]=2,
["q_display_ime"]=3,
["q_display_time_interval"]=4,
["q_notice_concent"]=5,
["q_notice_times"]=6,
["q_time_interval"]=7,
}

Q_Notice={[1]={1,"1.0",0,0,"大家快来玩游戏了哦year！",2,20},
}
Q_Notice.GetTempData = function (key, strName)
                             if not Q_Notice[key] or not Q_Notice_index[strName] or type(key) == "function" then
                                    log_info("Q_Notice.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Notice[key]) ~= "table" then
                                    log_info("Q_Notice.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Notice[key][Q_Notice_index[strName]]
                             if not pData then
                                 log_info("Q_Notice.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
