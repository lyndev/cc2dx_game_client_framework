Q_Map_index={["q_id"]=1,
["q_surname"]=2,
["q_mini_map"]=3,
["q_tmx"]=4,
["q_use_plist"]=5,
["q_lua"]=6,
["q_json"]=7,
["q_fight_mini_map"]=8,
["q_blue_born"]=9,
["q_red_eborn"]=10,
["q_map_music"]=11,
}

Q_Map={[1]={1,"天上人间","png/ui/dirll/drill_map_big.png","save/map_1001.lua","plist/xiaozhen.plist","mapconfig/lua/map_1001.lua","map_1001.json","fightmain_small_tmx.png","98_28|98_32|98_25|97_21|93_23|97_18","13_31|12_27|14_24|13_22|13_20|12_19","50501_1"},
[2]={2,"战争之城","png/ui/dirll/drill_map_big.png","save/map_1002.lua","plist/city.plist","mapconfig/lua/map_1002.lua","map_1002.json","fightmain_small_tmx.png","114_32|110_26|110_23|109_20|114_12","5_32|11_24|11_21|10_18|5_12","50502_1"},
[3]={3,"九州蛮荒","png/ui/dirll/drill_map_big.png","save/map_1003.lua","plist/shamo.plist","mapconfig/lua/map_1003.lua","map_1003.json","fightmain_small_tmx.png","90_28|90_24|90_20|90_16|92_12|92_10","10_28|10_24|10_20|10_17|11_15|6_12","50503_1"},
}
Q_Map.GetTempData = function (key, strName)
                             if not Q_Map[key] or not Q_Map_index[strName] or type(key) == "function" then
                                    log_info("Q_Map.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Map[key]) ~= "table" then
                                    log_info("Q_Map.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Map[key][Q_Map_index[strName]]
                             if not pData then
                                 log_info("Q_Map.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
