Q_Look_index={["q_id"]=1,
["q_look_name"]=2,
["q_look_img"]=3,
}

Q_Look={[1]={1,"9001.png","9001_1.png"},
[2]={2,"9002.png","9002_1.png"},
[3]={3,"9003.png","9003_1.png"},
[4]={4,"9004.png","9004_1.png"},
[5]={5,"9005.png","9005_1.png"},
[6]={6,"9006.png","9006_1.png"},
[7]={7,"9007.png","9007_1.png"},
[8]={8,"9008.png","9008_1.png"},
[9]={9,"9009.png","9009_1.png"},
[10]={10,"9010.png","9010_1.png"},
[11]={11,"9011.png","9011_1.png"},
[12]={12,"9012.png","9012_1.png"},
[13]={13,"9013.png","9013_1.png"},
[14]={14,"9014.png","9014_1.png"},
[15]={15,"9015.png","9015_1.png"},
[16]={16,"9016.png","9016_1.png"},
[17]={17,"9017.png","9017_1.png"},
[18]={18,"9018.png","9018_1.png"},
[19]={19,"9019.png","9019_1.png"},
[20]={20,"9020.png","9020_1.png"},
[21]={21,"9021.png","9021_1.png"},
[22]={22,"9022.png","9022_1.png"},
[23]={23,"9023.png","9023_1.png"},
[24]={24,"9024.png","9024_1.png"},
[25]={25,"9025.png","9025_1.png"},
[26]={26,"9026.png","9026_1.png"},
[27]={27,"9027.png","9027_1.png"},
[28]={28,"9028.png","9028_1.png"},
[29]={29,"9029.png","9029_1.png"},
[30]={30,"9030.png","9030_1.png"},
[31]={31,"9031.png","9031_1.png"},
[32]={32,"9032.png","9032_1.png"},
[33]={33,"9033.png","9033_1.png"},
[34]={34,"9034.png","9034_1.png"},
[35]={35,"9035.png","9035_1.png"},
[36]={36,"9036.png","9036_1.png"},
[37]={37,"9037.png","9037_1.png"},
[38]={38,"9038.png","9038_1.png"},
[39]={39,"9039.png","9039_1.png"},
[40]={40,"9040.png","9040_1.png"},
[41]={41,"9041.png","9041_1.png"},
[42]={42,"9042.png","9042_1.png"},
[43]={43,"9043.png","9043_1.png"},
[44]={44,"9044.png","9044_1.png"},
[45]={45,"9045.png","9045_1.png"},
[46]={46,"9046.png","9046_1.png"},
[47]={47,"9047.png","9047_1.png"},
[48]={48,"9048.png","9048_1.png"},
[49]={49,"9049.png","9049_1.png"},
[50]={50,"9050.png","9050_1.png"},
[51]={51,"9051.png","9051_1.png"},
[52]={52,"9052.png","9052_1.png"},
}
Q_Look.GetTempData = function (key, strName)
                             if not Q_Look[key] or not Q_Look_index[strName] or type(key) == "function" then
                                    log_info("Q_Look.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Look[key]) ~= "table" then
                                    log_info("Q_Look.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Look[key][Q_Look_index[strName]]
                             if not pData then
                                 log_info("Q_Look.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
