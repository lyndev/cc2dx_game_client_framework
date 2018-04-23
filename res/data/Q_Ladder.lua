Q_Ladder_index={["q_id"]=1,
["q_ladder_name"]=2,
["q_ladder_icon_id"]=3,
["q_ladder_grade"]=4,
}

Q_Ladder={[1]={1,"青铜Ⅰ","5002.png","50"},
[2]={2,"青铜Ⅱ","5002.png","120"},
[3]={3,"白银Ⅰ","5001.png","180"},
[4]={4,"白银Ⅱ","5001.png","220"},
[5]={5,"铂金Ⅰ","5003.png","250"},
[6]={6,"铂金Ⅱ","5003.png","280"},
[7]={7,"黄金Ⅰ","5004.png","300"},
[8]={8,"黄金Ⅱ","5004.png","300"},
[9]={9,"钻石Ⅰ","5005.png","320"},
[10]={10,"钻石Ⅱ","5005.png","350"},
}
Q_Ladder.GetTempData = function (key, strName)
                             if not Q_Ladder[key] or not Q_Ladder_index[strName] or type(key) == "function" then
                                    log_info("Q_Ladder.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Ladder[key]) ~= "table" then
                                    log_info("Q_Ladder.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Ladder[key][Q_Ladder_index[strName]]
                             if not pData then
                                 log_info("Q_Ladder.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
