Q_UnionClubLV_index={["q_id"]=1,
["q_comment"]=2,
["q_name"]=3,
["q_unionclubskill"]=4,
}

Q_UnionClubLV={[1]={1,"1级","乌合","1.0"},
[2]={2,"2级","民团","1.0"},
[3]={3,"3级","杂牌","1.0"},
[4]={4,"4级","行伍","1.0"},
[5]={5,"5级","野战","1.0"},
[6]={6,"6级","百战","1.0"},
[7]={7,"7级","精锐","1.0"},
[8]={8,"8级","先锋","1.0"},
[9]={9,"9级","禁卫","1.0"},
[10]={10,"10级","王牌","1.0"},
[0]={0,"","",""},
}
Q_UnionClubLV.GetTempData = function (key, strName)
                             if not Q_UnionClubLV[key] or not Q_UnionClubLV_index[strName] or type(key) == "function" then
                                    log_info("Q_UnionClubLV.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_UnionClubLV[key]) ~= "table" then
                                    log_info("Q_UnionClubLV.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_UnionClubLV[key][Q_UnionClubLV_index[strName]]
                             if not pData then
                                 log_info("Q_UnionClubLV.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
