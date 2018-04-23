Q_Bullet_index={["q_id"]=1,
["q_comments"]=2,
["q_type"]=3,
["q_name"]=4,
["q_icon_id"]=5,
["q_level"]=6,
["q_atk_kinetic"]=7,
["q_atk_chemistry"]=8,
["q_atk_heat"]=9,
["q_fly_distance"]=10,
["q_speed"]=11,
["q_skill_id"]=12,
}

Q_Bullet={[5000]={5000,"暗夜行者主战",1,"邪制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,748,0,187,1316,1198,6000},
[5001]={5001,"业火主战",1,"邪制105mm穿甲弹","png/ui/login/ready_default_icon.png",1,753,0,188,1328,1204,6000},
[5002]={5002,"陆王主战",2,"邪制150mm高爆弹","png/ui/login/ready_default_icon.png",1,758,0,190,1339,1209,6001},
[5003]={5003,"黑色犀牛主战",1,"中制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,763,0,191,1350,1215,6000},
[5004]={5004,"神骨主战",1,"中制120mm穿甲弹","png/ui/login/ready_default_icon.png",1,192,0,769,1361,1221,6000},
[5005]={5005,"龙皇主战",1,"中制130mm穿甲弹","png/ui/login/ready_default_icon.png",1,193,0,774,1372,1226,6000},
[5006]={5006,"赤卫者主战坦克",1,"美制105mm穿甲弹","png/ui/login/ready_default_icon.png",1,195,0,779,1384,1232,6000},
[5007]={5007,"北美蛮牛主战坦克",1,"美制128mm穿甲弹","png/ui/login/ready_default_icon.png",1,196,0,784,1350,1237,6000},
[5008]={5008,"血祭突击",2,"美制105mm高爆弹","png/ui/login/ready_default_icon.png",1,511,0,128,883,883,6001},
[5009]={5009,"合金夸父突击",1,"俄制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,516,0,129,978,889,6000},
[5010]={5010,"北极光突击",1,"俄制152mm穿甲弹","png/ui/login/ready_default_icon.png",1,522,0,130,989,894,6000},
[5011]={5011,"恐怖走鹫突击",2,"俄制120mm高爆弹","png/ui/login/ready_default_icon.png",1,526,0,132,1000,900,6001},
[5012]={5012,"颅灭突击",1,"邪制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,133,0,532,1011,906,6000},
[5013]={5013,"鬼相柳突击",1,"邪制105mm穿甲弹","png/ui/login/ready_default_icon.png",1,134,0,537,1022,911,6000},
[5014]={5014,"突出部突击坦克",1,"邪制150mm高爆弹","png/ui/login/ready_default_icon.png",1,136,0,542,1034,917,6000},
[5015]={5015,"疯狂火鸡突击坦克",1,"中制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,137,0,547,1045,922,6000},
[5016]={5016,"黑眼侦察",1,"中制120mm穿甲弹","png/ui/login/ready_default_icon.png",1,327,0,82,616,568,6000},
[5017]={5017,"魑魅侦察",2,"中制130mm穿甲弹","png/ui/login/ready_default_icon.png",1,332,0,83,628,574,6001},
[5018]={5018,"极夜尖兵侦察",1,"美制105mm穿甲弹","png/ui/login/ready_default_icon.png",1,338,0,84,639,579,6000},
[5019]={5019,"郊狼侦察",1,"美制128mm穿甲弹","png/ui/login/ready_default_icon.png",1,342,0,86,650,585,6000},
[5020]={5020,"蝠翼侦察",1,"美制105mm高爆弹","png/ui/login/ready_default_icon.png",1,87,0,348,661,591,6000},
[5021]={5021,"谛听侦察",2,"俄制90mm穿甲弹","png/ui/login/ready_default_icon.png",1,88,0,353,672,596,6001},
[5022]={5022,"英雄侦察坦克",1,"俄制152mm穿甲弹","png/ui/login/ready_default_icon.png",1,90,0,358,684,602,6000},
[5023]={5023,"海雕侦察坦克",1,"俄制120mm高爆弹","png/ui/login/ready_default_icon.png",1,91,0,363,695,607,6000},
}
Q_Bullet.GetTempData = function (key, strName)
                             if not Q_Bullet[key] or not Q_Bullet_index[strName] or type(key) == "function" then
                                    log_info("Q_Bullet.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Bullet[key]) ~= "table" then
                                    log_info("Q_Bullet.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Bullet[key][Q_Bullet_index[strName]]
                             if not pData then
                                 log_info("Q_Bullet.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
