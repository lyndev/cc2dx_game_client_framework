Q_TeamIcon_index={["q_id"]=1,
["q_name"]=2,
}

Q_TeamIcon={[40000]={40000,"40000.png"},
[40001]={40001,"40001.png"},
[40002]={40002,"40002.png"},
[40003]={40003,"40003.png"},
[40004]={40004,"40004.png"},
[40005]={40005,"40005.png"},
[40006]={40006,"40006.png"},
}
Q_TeamIcon.GetTempData = function (key, strName)
                             if not Q_TeamIcon[key] or not Q_TeamIcon_index[strName] or type(key) == "function" then
                                    log_info("Q_TeamIcon.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_TeamIcon[key]) ~= "table" then
                                    log_info("Q_TeamIcon.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_TeamIcon[key][Q_TeamIcon_index[strName]]
                             if not pData then
                                 log_info("Q_TeamIcon.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
