Q_PlayerLevel_index={["q_level"]=1,
["q_comments"]=2,
["q_military_rank_name"]=3,
["q_military_rank_icon_id"]=4,
}

Q_PlayerLevel={[1]={1,"","新兵","7000.png"},
[2]={2,"","列兵 I","7001.png"},
[3]={3,"","列兵 II","7002.png"},
[4]={4,"","列兵 III","7003.png"},
[5]={5,"","二等兵 I","7004.png"},
[6]={6,"","二等兵 II","7005.png"},
[7]={7,"","二等兵 III","7006.png"},
[8]={8,"","一等兵 I","7007.png"},
[9]={9,"","一等兵 II","7008.png"},
[10]={10,"","一等兵 III","7009.png"},
[11]={11,"","下士 I","7010.png"},
[12]={12,"","下士 II","7011.png"},
[13]={13,"","下士 III","7012.png"},
[14]={14,"","中士 I","7013.png"},
[15]={15,"","中士 II","7014.png"},
[16]={16,"","中士 III","7015.png"},
[17]={17,"","上士 I","7016.png"},
[18]={18,"","上士 II","7017.png"},
[19]={19,"","上士 III","7018.png"},
[20]={20,"","少尉 I","7019.png"},
[21]={21,"","少尉 II","7020.png"},
[22]={22,"","少尉 III","7021.png"},
[23]={23,"","中尉 I","7022.png"},
[24]={24,"","中尉 II","7023.png"},
[25]={25,"","中尉 III","7024.png"},
[26]={26,"","上尉 I","7025.png"},
[27]={27,"","上尉 II","7026.png"},
[28]={28,"","上尉 III","7027.png"},
[29]={29,"","少校 I","7028.png"},
[30]={30,"","少校 II","7029.png"},
[31]={31,"","少校 III","7030.png"},
[32]={32,"","中校 I","7031.png"},
[33]={33,"","中校 II","7032.png"},
[34]={34,"","中校 III","7033.png"},
[35]={35,"","上校 I","7034.png"},
[36]={36,"","上校 II","7035.png"},
[37]={37,"","上校 III","7036.png"},
[38]={38,"","少将 I","7037.png"},
[39]={39,"","少将 II","7038.png"},
[40]={40,"","少将 III","7039.png"},
[41]={41,"","中将 I","7040.png"},
[42]={42,"","中将 II","7041.png"},
[43]={43,"","中将 III","7042.png"},
[44]={44,"","上将 I","7043.png"},
[45]={45,"","上将 II","7044.png"},
[46]={46,"","上将 III","7045.png"},
[47]={47,"","大将 I","7046.png"},
[48]={48,"","大将 II","7047.png"},
[49]={49,"","大将 III","7048.png"},
[50]={50,"","元帅 I","7049.png"},
[51]={51,"","元帅 II","7050.png"},
[52]={52,"","元帅 III","7051.png"},
[0]={0,"","",""},
}
Q_PlayerLevel.GetTempData = function (key, strName)
                             if not Q_PlayerLevel[key] or not Q_PlayerLevel_index[strName] or type(key) == "function" then
                                    log_info("Q_PlayerLevel.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_PlayerLevel[key]) ~= "table" then
                                    log_info("Q_PlayerLevel.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_PlayerLevel[key][Q_PlayerLevel_index[strName]]
                             if not pData then
                                 log_info("Q_PlayerLevel.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
