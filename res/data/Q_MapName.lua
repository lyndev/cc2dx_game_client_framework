Q_MapName_index={["q_id"]=1,
["q_surname"]=2,
["q_res"]=3,
}

Q_MapName={[1]={1,"雷谷","png/ui/dirll/drill_map_big.png"},
[2]={2,"电谷","png/ui/dirll/drill_map_big.png"},
[3]={3,"中国","png/ui/dirll/drill_map_big.png"},
[4]={4,"美国","png/ui/dirll/drill_map_big.png"},
[5]={5,"三角洲","png/ui/dirll/drill_map_big.png"},
[6]={6,"北极","png/ui/dirll/drill_map_big.png"},
[7]={7,"南极","png/ui/dirll/drill_map_big.png"},
[8]={8,"日本","png/ui/dirll/drill_map_big.png"},
}
Q_MapName.GetTempData = function (key, strName)
                             if not Q_MapName[key] or not Q_MapName_index[strName] or type(key) == "function" then
                                    log_info("Q_MapName.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_MapName[key]) ~= "table" then
                                    log_info("Q_MapName.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_MapName[key][Q_MapName_index[strName]]
                             if not pData then
                                 log_info("Q_MapName.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
