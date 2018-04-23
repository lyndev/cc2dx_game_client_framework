q_room_index={["Id"]=1,
["Desc"]=2,
["LevelType"]=3,
["Type"]=4,
["Difen"]=5,
["MinLimit"]=6,
["MaxLimit"]=7,
["GameType"]=8,
["MaxMultiple"]=9,
["RakeRate"]=10,
}

q_room={[1]={1,"大贰试玩场不带归-100",1,1,1,1000,5000,1,64,2},
[2]={2,"大贰试玩场带归-100",1,2,1,1000,5000,1,64,2},
[3]={3,"大贰初级场不带归-200",2,1,50,5000,100000,1,64,2},
[4]={4,"大贰初级场带归-200",2,2,50,5000,100000,1,64,2},
[5]={5,"大贰中级场不带归-100",3,1,500,100000,1000000,1,64,2},
[6]={6,"大贰中级带归-100",3,2,500,100000,1000000,1,64,2},
[7]={7,"大贰高级不带归-200",4,1,1000,1000000,-1,1,64,2},
[8]={8,"大贰高级带归-200",4,2,1000,1000000,-1,1,64,2},
[9]={9,"麻将",1,1,100,1000,10000,2,3,3},
}
q_room.GetTempData = function (key, strName)
                             if not q_room[key] or not q_room_index[strName] or type(key) == "function" then
                                    log_info("q_room.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_room[key]) ~= "table" then
                                    log_info("q_room.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_room[key][q_room_index[strName]]
                             if not pData then
                                 log_info("q_room.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
