Q_GameIp_index={["q_id"]=1,
["q_ip_server"]=2,
["q_ip_port"]=3,
["q_ip_name"]=4,
}

Q_GameIp={[1]={1,"192.168.1.150","8008.0","内网-王余华"},
[2]={2,"59.44.60.140","8008.0","外网1"},
[0]={0,"","",""},
[0]={0,"","",""},
}
Q_GameIp.GetTempData = function (key, strName)
                             if not Q_GameIp[key] or not Q_GameIp_index[strName] or type(key) == "function" then
                                    log_info("Q_GameIp.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_GameIp[key]) ~= "table" then
                                    log_info("Q_GameIp.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_GameIp[key][Q_GameIp_index[strName]]
                             if not pData then
                                 log_info("Q_GameIp.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
