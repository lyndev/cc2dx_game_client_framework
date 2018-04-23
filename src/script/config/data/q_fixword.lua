q_fixword_index={["Id"]=1,
["Word"]=2,
}

q_fixword={[1]={1,"不要慌等我考虑一下！"},
[2]={2,"打牌就打牌不要开腔！"},
[3]={3,"打一张来吃撒！"},
[4]={4,"哦豁给我碰的稀巴烂！"},
[5]={5,"喂从个打得弄慢哦！"},
[6]={6,"耶这把遭得甩！"},
[7]={7,"这把安逸你们全部都跑不脱！"},
[8]={8,"自己都打得慢还好意思说人家！"},
}
q_fixword.GetTempData = function (key, strName)
                             if not q_fixword[key] or not q_fixword_index[strName] or type(key) == "function" then
                                    log_info("q_fixword.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_fixword[key]) ~= "table" then
                                    log_info("q_fixword.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_fixword[key][q_fixword_index[strName]]
                             if not pData then
                                 log_info("q_fixword.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
