Q_Guide_index={["q_id"]=1,
["q_comment"]=2,
["q_main_item_id"]=3,
["q_sub_item_id"]=4,
["q_last_id"]=5,
["q_next_id"]=6,
["q_isforce"]=7,
["q_begin_conditions"]=8,
["q_end_conditions"]=9,
["q_force_highlight_show_x_y_h_w"]=10,
["q_disable_scorll"]=11,
["q_restore_step"]=12,
["q_talk_ui_move_by"]=13,
["q_need_notice_ui"]=14,
["q_notice_ui_pos"]=15,
["q_notice_language"]=16,
["q_talk_language"]=17,
["q_finger_offset"]=18,
["q_guide_type"]=19,
}

Q_Guide={[1081]={1081,"选择一辆坦克",108,1,0,1082,1,"1_2","","ui_ready_cabin_show;ready_tank_show_bg_5|305_0_84_90_0",1,"","",1,"0_-10_-10",106,106,"0_0_0",1},
[1082]={1082,"选择玩家头像",108,2,1081,1083,1,"","","btn_player_head|0_0_112_130_0",0,"108_1","",1,"0_-10_-10",107,107,"0_0_0",1},
[1083]={1083,"打开玩家信息面板-查看对战记录",108,3,1082,1084,1,"1_4","","btn_fight_log|0_0_140_50_0",1,"108_1;108_2","",1,"0_-10_-10",108,108,"0_0_0",1},
[1084]={1084,"关闭玩家信息面板",108,4,1083,0,1,"","","ui_player_info;btn_close|0_0_86_82_0",1,"108_1;108_2;108_1;108_3","",1,"0_-10_-10",109,109,"1_0_0",1},
[1091]={1091,"打开训练模式",109,1,1084,1092,1,"1_2","","ui_ready_cabin_show;ready_bg_btn_1|230_0_202_72_0",1,"","",1,"0_-10_-10",109,109,"0_0_0",1},
[1092]={1092,"创建房间",109,2,1091,1093,1,"1_5","","ui_lobby;btn_create_room|0_0_208_72_0",1,"109_1","",1,"0_-10_-10",109,109,"0_0_1",1},
[1093]={1093,"开始游戏",109,3,1092,0,1,"1_6","","ui_room;btn_play_game|0_0_208_72_0",1,"109_1;109_2","",1,"0_-10_-10",109,109,"0_0_2",1},
[1101]={1101,"在主界面上切换坦克",110,1,1093,1102,1,"1_2","","ui_ready_cabin_show;ready_tank_show_bg_5|305_0_84_90_0",1,"","",1,"0_-10_-10",109,109,"0_0_0",1},
[1102]={1102,"开始匹配战斗",110,2,1101,0,1,"1_2","","ui_ready_cabin_show;ready_bg_btn_1|415_0_202_72_0",1,"110_1","",1,"0_-10_-10",109,109,"0_0_0",1},
[1111]={1111,"点击主界面坦克打开坦克工厂",111,1,1102,1112,1,"1_2","","ui_ready_cabin_showready_tank_show_bg_5|415_0_180_250_0",1,"","",1,"0_-10_-10",109,109,"0_0_0",1},
[1112]={1112,"选中工厂里的坦克",111,2,1111,1113,1,"1_33","","ui_tank_factory;ready_tank_list_bg_45|0_305_163_83_0",1,"111_1","",1,"0_-10_-10",109,109,"0_0_0",1},
[1113]={1113,"携带道具上阵",111,3,1112,1114,1,"1_3","","ui_tank_factory;2|0_0_66_66_0",1,"111_1;111_2","",1,"0_-10_-10",109,109,"0_0_0",1},
[1114]={1114,"开始匹配战斗",111,4,1113,0,1,"1_2","","ui_ready_cabin_show;ready_bg_btn_1|415_0_202_72_0",1,"111_1;111_2;111_3","",1,"0_-10_-10",109,109,"0_0_0",1},
[1121]={1121,"穿戴装备",112,1,1114,1122,1,"1_3","","ui_tank_factory;4|0_305_66_66_0",1,"","",1,"0_-10_-10",109,109,"0_0_0",1},
[1122]={1122,"开始匹配战斗",112,2,1121,0,1,"1_2","","ui_ready_cabin_show;ready_bg_btn_1|415_0_202_72_0",1,"112_1","",1,"0_-10_-10",109,109,"0_0_0",1},
[1131]={1131,"穿戴被动技能",113,1,1122,1132,1,"1_3","","ui_tank_factory;1|0_305_66_66_0",1,"","",1,"0_-10_-10",109,109,"0_0_0",1},
[1132]={1132,"开始匹配战斗",113,2,1131,0,1,"1_2","","ui_ready_cabin_show;ready_bg_btn_1|415_0_202_72_0",1,"113_1","",1,"0_-10_-10",109,109,"0_0_0",1},
}
Q_Guide.GetTempData = function (key, strName)
                             if not Q_Guide[key] or not Q_Guide_index[strName] or type(key) == "function" then
                                    log_info("Q_Guide.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Guide[key]) ~= "table" then
                                    log_info("Q_Guide.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Guide[key][Q_Guide_index[strName]]
                             if not pData then
                                 log_info("Q_Guide.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
