q_chatface_index={["Id"]=1,
["FaceAnimationPath"]=2,
["FacePath"]=3,
["EffectPath"]=4,
}

q_chatface={[4001]={4001,"","face_4001.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4002]={4002,"","face_4002.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4003]={4003,"","face_4003.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4004]={4004,"","face_4004.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4005]={4005,"","face_4005.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4006]={4006,"","face_4006.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4007]={4007,"","face_4007.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4008]={4008,"","face_4008.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4009]={4009,"","face_4009.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4010]={4010,"","face_4010.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4011]={4011,"","face_4011.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4012]={4012,"","face_4012.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4013]={4013,"","face_4013.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4014]={4014,"","face_4014.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[4015]={4015,"","face_4015.png","ui_res/facenormaleffect/chatfacenomalplist.plist"},
[5001]={5001,"","face_5001.png","ui_res/facevipeffect/chatfacevipplist.plist"},
[5002]={5002,"","face_5002.png","ui_res/facevipeffect/chatfacevipplist.plist"},
[5003]={5003,"","face_5003.png","ui_res/facevipeffect/chatfacevipplist.plist"},
[5004]={5004,"","face_5004.png","ui_res/facevipeffect/chatfacevipplist.plist"},
[5005]={5005,"","face_5005.png","ui_res/facevipeffect/chatfacevipplist.plist"},
[5006]={5006,"","face_5006.png","ui_res/facevipeffect/chatfacevipplist.plist"},
}
q_chatface.GetTempData = function (key, strName)
                             if not q_chatface[key] or not q_chatface_index[strName] or type(key) == "function" then
                                    log_info("q_chatface.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_chatface[key]) ~= "table" then
                                    log_info("q_chatface.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_chatface[key][q_chatface_index[strName]]
                             if not pData then
                                 log_info("q_chatface.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
