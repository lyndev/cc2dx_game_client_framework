Q_FunctionOpen_index={["q_functionId"]=1,
["q_comment"]=2,
["q_player_level"]=3,
["q_default_open"]=4,
["q_server_openday"]=5,
}

Q_FunctionOpen={[30000]={30000,"匹配模式",1,0,0},
[30001]={30001,"训练模式",1,1,0},
[30002]={30002,"主界面聊天",1,1,0},
[30003]={30003,"商城模块",1,1,0},
[30004]={30004,"任务模块",1,1,0},
[30005]={30005,"好友模块",1,1,0},
[30006]={30006,"公会模块",1,1,0},
[30007]={30007,"战队模块",1,1,0},
[30008]={30008,"设置模块",1,1,0},
[30009]={30009,"邮箱模块",1,1,0},
[30010]={30010,"仓库模块",1,1,0},
[30011]={30011,"排行榜模块",1,0,0},
[30012]={30012,"国战",1,1,0},
}
Q_FunctionOpen.GetTempData = function (key, strName)
                             if not Q_FunctionOpen[key] or not Q_FunctionOpen_index[strName] or type(key) == "function" then
                                    log_info("Q_FunctionOpen.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_FunctionOpen[key]) ~= "table" then
                                    log_info("Q_FunctionOpen.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_FunctionOpen[key][Q_FunctionOpen_index[strName]]
                             if not pData then
                                 log_info("Q_FunctionOpen.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
