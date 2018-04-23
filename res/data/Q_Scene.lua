Q_Scene_index={["q_id"]=1,
["q_comment"]=2,
["q_type"]=3,
["q_path"]=4,
["q_script"]=5,
}

Q_Scene={[1000]={1000,"中央枢纽",1,"ui/scn_lobby_center.csb","CUISceneLobby"},
[1001]={1001,"舰桥舱",1,"ui/scn_bridge_cabin.csb","CUISceneBridgeCabin"},
[1002]={1002,"机械舱",1,"ui/scn_machine_cabin.csb","CUISceneMachineCabin"},
[1003]={1003,"整备舱",1,"ui/scn_ready_cabin.csb","CUISceneReadyCabin"},
}
Q_Scene.GetTempData = function (key, strName)
                             if not Q_Scene[key] or not Q_Scene_index[strName] or type(key) == "function" then
                                    log_info("Q_Scene.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Scene[key]) ~= "table" then
                                    log_info("Q_Scene.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Scene[key][Q_Scene_index[strName]]
                             if not pData then
                                 log_info("Q_Scene.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
