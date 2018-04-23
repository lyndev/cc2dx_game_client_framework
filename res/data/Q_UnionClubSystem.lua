Q_UnionClubSystem_index={["q_id"]=1,
["q_comment"]=2,
["q_name"]=3,
["q_max_have"]=4,
["q_consume"]=5,
}

Q_UnionClubSystem={[1]={1,"1级","连",30,"30000_5000"},
[2]={2,"2级","营",50,"30000_10000"},
[3]={3,"3级","团",80,"30000_15000"},
[4]={4,"4级","旅",100,"30000_20000"},
[5]={5,"5级","师",130,"30000_25000"},
[6]={6,"6级","军",150,"30000_30000"},
[7]={7,"7级","集团军",180,"30000_35000"},
[8]={8,"8级","方面军",200,"0.0"},
[0]={0,"","",0,""},
}
Q_UnionClubSystem.GetTempData = function (key, strName)
                             if not Q_UnionClubSystem[key] or not Q_UnionClubSystem_index[strName] or type(key) == "function" then
                                    log_info("Q_UnionClubSystem.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_UnionClubSystem[key]) ~= "table" then
                                    log_info("Q_UnionClubSystem.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_UnionClubSystem[key][Q_UnionClubSystem_index[strName]]
                             if not pData then
                                 log_info("Q_UnionClubSystem.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
