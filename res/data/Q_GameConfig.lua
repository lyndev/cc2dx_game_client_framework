Q_GameConfig_index={["q_tank_config"]=1,
["q_max_mountequip"]=2,
["q_max_equipment"]=3,
["q_max_backpack"]=4,
["q_room_mapconfig"]=5,
}

Q_GameConfig={["100_101_102"]={"100_101_102",2,1,1000,1},
}
Q_GameConfig.GetTempData = function (key, strName)
                             if not Q_GameConfig[key] or not Q_GameConfig_index[strName] or type(key) == "function" then
                                    log_info("Q_GameConfig.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_GameConfig[key]) ~= "table" then
                                    log_info("Q_GameConfig.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_GameConfig[key][Q_GameConfig_index[strName]]
                             if not pData then
                                 log_info("Q_GameConfig.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
