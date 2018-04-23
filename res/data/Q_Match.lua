Q_Match_index={["q_id"]=1,
["q_name"]=2,
["q_type"]=3,
["q_describ"]=4,
["q_enter_begin_time"]=5,
["q_enter_end_time"]=6,
["match_begin_time"]=7,
["match_end_time"]=8,
["q_max_num"]=9,
["q_victory_grade_num"]=10,
["q_reward3_num"]=11,
["q_victory_reward"]=12,
["q_victory_exp"]=13,
["q_fail_reward"]=14,
["q_fail_exp"]=15,
["q_the_first_reward"]=16,
}

Q_Match={[1]={1,"周赛",1,"周赛是普通战队通向更高阶的唯一的基础比赛，通过周赛会筛选出高水平的战队，参与月赛。","7_17:30","2_17:31","2_17:32","6_17:33",0,3,1,"30000_50",30,"30000_10",10,"30000_5000|30001_100;30000_5000|30001_100|222_1;30000_5000|30001_100|3000_10;30000_5000|30001_100"},
[2]={2,"月赛",1,"月赛的水平很高，一般战队参加不了，但凡参加的，已经有了荣誉，如果再取得名字，则可以晋级联赛。","7_17:31","2_17:32","5_17:33","6_17:34",0,3,1,"30000_80",60,"30000_30",20,"30000_5000|30001_100;30000_5000|30001_100|222_1;30000_5000|30001_100|3000_10;30000_5000|30001_100"},
[3]={3,"联赛",1,"神圣的比赛殿堂，只有少数顶级战队才能参与的比赛，普通战队甚至都接触不到。","2_17:32","4_17:33","7_15:00","7_19:00",0,3,1,"30000_150",100,"30000_50",50,"30000_5000|30001_100;30000_5000|30001_100|222_1;30000_5000|30001_100|3000_10;30000_5000|30001_100"},
[4]={4,"国战资格赛",2,"国战资格赛是未国战服务的比赛，要想参与国战，必须先在资格赛中证明自己的能力。","2_17:33","4_17:34","5_17:35","6_17:36",50,3,1,"30000_20",20,"30000_10",10,""},
}
Q_Match.GetTempData = function (key, strName)
                             if not Q_Match[key] or not Q_Match_index[strName] or type(key) == "function" then
                                    log_info("Q_Match.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Match[key]) ~= "table" then
                                    log_info("Q_Match.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Match[key][Q_Match_index[strName]]
                             if not pData then
                                 log_info("Q_Match.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
