q_animationeffect_index={["Id"]=1,
["Comment"]=2,
["DurationTime"]=3,
["AnimationType"]=4,
["FrameCount"]=5,
["FrameName"]=6,
["EffectPath"]=7,
}

q_animationeffect={[4001]={4001,"白旗",0,1,8,"face_4001","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4002]={4002,"鄙视",0,1,10,"face_4002","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4003]={4003,"闭嘴",0,1,11,"face_4003","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4004]={4004,"吃惊",0,1,13,"face_4004","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4005]={4005,"大骂",0,1,8,"face_4005","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4006]={4006,"大笑",0,1,8,"face_4006","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4007]={4007,"发怒",0,1,11,"face_4007","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4008]={4008,"尴尬",0,1,10,"face_4008","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4009]={4009,"鬼脸",0,1,6,"face_4009","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4010]={4010,"害羞",0,1,14,"face_4010","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4011]={4011,"瞌睡",0,1,13,"face_4011","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4012]={4012,"哭",0,1,9,"face_4012","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4013]={4013,"流汗",0,1,16,"face_4013","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4014]={4014,"色",0,1,14,"face_4014","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[4015]={4015,"晕",0,1,10,"face_4015","ui_res/chat/facenormaleffect/chatfacenomalplist.plist"},
[5001]={5001,"被砸了",0,1,16,"face_5001","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
[5002]={5002,"冲马桶",0,1,4,"face_5002","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
[5003]={5003,"该吃药了",0,1,21,"face_5003","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
[5004]={5004,"惊恐",0,1,6,"face_5004","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
[5005]={5005,"你妹的",0,1,13,"face_5005","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
[5006]={5006,"约不约",0,1,4,"face_5006","ui_res/chat/facevipeffect/chatfacevipplist.plist"},
}
q_animationeffect.GetTempData = function (key, strName)
                             if not q_animationeffect[key] or not q_animationeffect_index[strName] or type(key) == "function" then
                                    log_info("q_animationeffect.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_animationeffect[key]) ~= "table" then
                                    log_info("q_animationeffect.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_animationeffect[key][q_animationeffect_index[strName]]
                             if not pData then
                                 log_info("q_animationeffect.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
