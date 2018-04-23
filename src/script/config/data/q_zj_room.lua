q_zj_room_index={["GameType"]=1,
["Desc"]=2,
["Difen"]=3,
["ChangCi"]=4,
["BeiShu"]=5,
["NameMinLength"]=6,
["NameMaxLength"]=7,
["PwdMinLength"]=8,
["PwdMaxLength"]=9,
["DifenMinLimit"]=10,
["DifenMaxLimit"]=11,
["EnterRoomMinLimit"]=12,
["TimesMinLimit"]=13,
["TimesMaxLimit"]=14,
["IDLength"]=15,
["MaxPeople"]=16,
["WaitTime"]=17,
["RechargeCoinTime"]=18,
["CreateRoomInterval"]=19,
["CreateRoomMinLimit"]=20,
["MinMultipleLimit"]=21,
["MaxMultipleLimit"]=22,
["RakeRate"]=23,
["CoinWaitingReadyTime"]=24,
["CreditsWaitingReadyTime"]=25,
["CreditsStartDissolveTime"]=26,
["CreditsMiddleDissolveTime"]=27,
}

q_zj_room={[1]={1,"大贰房间","10_200_300_3000","5_10_20_30","5_10_20_30",3,12,2,6,10,4000,1000,1,10,4,3,120,120,60,1000,1,100,10,20,20,60,30},
[2]={2,"麻将","10_200_300_3000","5_10_20_30","5_10_20_30",4,12,2,6,10,4000,1000,1,10,4,3,120,120,60,1000,1,100,10,20,20,60,30},
[3]={3,"德州","10_200_300_3000","5_10_20_30","5_10_20_30",5,12,2,6,10,4000,1000,1,10,4,3,120,120,60,1000,1,100,10,20,20,60,30},
}
q_zj_room.GetTempData = function (key, strName)
                             if not q_zj_room[key] or not q_zj_room_index[strName] or type(key) == "function" then
                                    log_info("q_zj_room.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_zj_room[key]) ~= "table" then
                                    log_info("q_zj_room.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_zj_room[key][q_zj_room_index[strName]]
                             if not pData then
                                 log_info("q_zj_room.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
