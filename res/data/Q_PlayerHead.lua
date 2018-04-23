Q_PlayerHead_index={["q_id"]=1,
["q_comments"]=2,
["q_icon_id"]=3,
["q_half_body"]=4,
}

Q_PlayerHead={[1]={1,"大叔","share_dashu_icon.png","share_dashu_head.png"},
[2]={2,"萝莉","share_lulita_icon.png","share_lulita_head.png"},
[3]={3,"美男子","share_man_icon.png","share_man_head.png"},
[4]={4,"御姐","share_women_icon.png","share_women_head.png"},
}
Q_PlayerHead.GetTempData = function (key, strName)
                             if not Q_PlayerHead[key] or not Q_PlayerHead_index[strName] or type(key) == "function" then
                                    log_info("Q_PlayerHead.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_PlayerHead[key]) ~= "table" then
                                    log_info("Q_PlayerHead.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_PlayerHead[key][Q_PlayerHead_index[strName]]
                             if not pData then
                                 log_info("Q_PlayerHead.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
