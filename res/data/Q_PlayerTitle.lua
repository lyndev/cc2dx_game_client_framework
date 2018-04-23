Q_PlayerTitle_index={["q_id"]=1,
["q_comments"]=2,
["q_title_name"]=3,
}

Q_PlayerTitle={[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
[0]={0,"",0},
}
Q_PlayerTitle.GetTempData = function (key, strName)
                             if not Q_PlayerTitle[key] or not Q_PlayerTitle_index[strName] or type(key) == "function" then
                                    log_info("Q_PlayerTitle.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_PlayerTitle[key]) ~= "table" then
                                    log_info("Q_PlayerTitle.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_PlayerTitle[key][Q_PlayerTitle_index[strName]]
                             if not pData then
                                 log_info("Q_PlayerTitle.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
