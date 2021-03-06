Q_Global_index={["q_id"]=1,
["q_int_value"]=2,
["q_string_value"]=3,
["q_desc"]=4,
}

Q_Global={[1]={1,0,"1_3_5_7_9|2_4_6_8_10","玩家战斗数据显示格式   UI左列|UI左列右列   “_”显示类型分割， “|”左右部分分割   枚举见枚举说明文件【玩家战斗数据显示枚举】"},
[2]={2,0,"6_7_8_9_10|0_1_3_4_5|2","坦克属性界面对应的火力，防御，动能，要显示的熟悉，枚举见说明文件【玩家战斗数据显示枚举】"},
[3]={3,10,"","副装甲和挂件卸下时需要消耗的钻石"},
[4]={4,0,"21_29|31_32|29_22|24_37|14_39|22_45","红方出生坐标点，从中随机五个"},
[5]={5,0,"104_29|101_22|107_19|96_30|100_37|113_42","蓝方出生坐标点，从中随机五个"},
[6]={6,0,"100_110_120_200_210_220_300_310_320_400_410_420","角色初始坦克配置"},
[7]={7,1,"","房间默认地图id"},
[8]={8,0,"100+499+Q_Tank|1000+2999+Q_Equipment|3000+3999+Q_Item|30000+30007+Q_Item|500+999+Q_FacadeTank|","坦克的ID段，副装甲的ID段，挂件的ID段，战斗道具的ID段"},
[9]={9,180,"","每一场战斗的时长"},
[10]={10,0,"0.02","战斗过程中造成的伤害转换成金币获得量系数"},
[11]={11,0,"0.02","战斗过程中造成的伤害转换成经验获得量系数"},
[12]={12,5,"","战斗开始前的等待时间"},
[13]={13,99,"","邮件数量上限"},
[14]={14,30,"","邮件过期时间"},
[15]={15,3,"","好友数量上限"},
[16]={16,20,"","黑名单数量上限"},
[17]={17,0,"12066.0","受伤时的特效（血量低于40%）"},
[18]={18,0,"12065.0","击毁时的爆炸特效"},
[19]={19,0,"0.4","移动摇杆的内圈半径"},
[20]={20,37,"","击爆玩家坦克一次所获得游戏币"},
[21]={21,125,"","获得MVP一次所获得游戏币"},
[22]={22,150,"","战斗胜利一次获得游戏币"},
[23]={23,0,"306|307|308","loding界面显示的文字"},
[24]={24,0,"0_100|101_200|201_300|301_400|401_500|501_600|601_700|701_800|801_900|901_1000|1001_1100|1101_1200|1201_1300|1301_1400|1401_1500|1501_1600|1601_1700|1701_1800|1801_1900|1901_2000|2001_2100|2101_2200","个人匹配分段"},
[25]={25,300,"","创建公会花费的金币"},
[26]={26,8,"1_8","公会名称字个数"},
[27]={27,0,"0_140","公会简介字数的限制"},
[28]={28,0,"0_140","公会公告字数的限制"},
[29]={29,8,"","参与国战的初始工会数量"},
[29]={29,96,"","国战领土块数"},
[30]={30,12,"","国战地图每一行12个地块【从上往下，从左往右读取】"},
[31]={31,0,"2_100|3_400|4_1000|5_1600","国战建制升到2级到5级需要的积分【国战等级_升级需要积分数量】"},
[32]={32,0,"1_20|2_60|3_150|4_300|5_500","国战建制死亡丢失积分【建制等级_丢失积分】(获胜一方的建制获得的积分也是该数据）"},
[33]={33,0,"1_3|2_3|3_3|4_3|5_3|6_4|7_4|8_4|9_5|10_5","国战建制和工会等级的对应关系【工会等级_建制数量】（工会等级5级以下为三个建制，五级以上通过配置表读取对应建制数量）"},
[34]={34,0,"1_6|2_8|3_10|4_12|5_16","建制行动值与建制等级的关系【建制等级_建制行动值】"},
[35]={35,1,"","在本方领土上移动一格需要消耗行动值数量"},
[36]={36,2,"","在空白领土上移动一格需要消耗行动值数量"},
[37]={37,3,"","在敌方领土上移动一格需要消耗行动值数量"},
[38]={38,0,"30000_100","行动一步，需要消耗的道具ID及数量【道具ID_数量】"},
[39]={39,0,"20.0","国战对战开始时间（小时）"},
[40]={40,0,"15.0","国战对战列表间隔时间（分钟）"},
[41]={41,0,"30000_1000|30001_100","建制复活消耗的道具【道具ID_道具数量】"},
[42]={42,0,"28.0","国战赛季周期4周，28天，28天之后优胜劣汰（配置单位：天）"},
[43]={43,0,"3_20|6_20","国战战斗时间【周几_小时】"},
[44]={44,180,"","国战建制布局结束后最后"},
[45]={45,15,"","自动连接服务器的倒计时"},
[46]={46,0,"30004_100|30003_10|30002_20|30000_100000","国战的财富比例 100财富 = 10科技石 = 20 燃油 = 100000金币"},
[47]={47,0,"30000_200_500_2000_5000|30003_1_2_5_10|","国战分配资源ID和数量"},
[48]={48,0,"20000_20001_20002_20003_20004_20005","战队图标"},
[49]={49,0,"0_10_20_30_40_50","战队设置，军衔等级"},
[50]={50,0,"0_2_4_6_8_10","战队设置，天梯等级"},
[51]={51,0,"30001_50","创建战队消耗的资源"},
[52]={52,100,"","聊天消息数量上限"},
[53]={53,1,"","消息发言间隔"},
[54]={54,1,"","好友聊天间隔"},
[55]={55,1,"","世界聊天间隔"},
[56]={56,1,"","战斗场景聊天间隔"},
[57]={57,0,"1_1_2","新手引导的房间ID 地图模板ID 地图服务器ID"},
[58]={58,8,"1_8","战队名称个数"},
[59]={59,18,"4_18","注册账号个数"},
[60]={60,12,"2_12","注册密码个数"},
[61]={61,12,"2_12","角色昵称个数"},
[62]={62,64,"","战队宣言字数限制"},
[63]={63,0,"0_100|101_200|201_300|301_400|401_500|501_600|601_700|701_800|801_900|901_1000|1001_1100|1101_1200|1201_1300|1301_1400|1401_1500|1501_1600|1601_1700|1701_1800|1801_1900|1901_2000|2001_2100|2101_2200","战队匹配分段"},
[64]={64,0,"1_0|2_1|3_1|4_0|5_0","商城类型显示坦克筛选【1是热销，2是坦克，3是皮肤，4是特权,5是钻石】"},
[65]={65,1,"","特殊提示显示时间"},
[66]={66,10,"","聊天消息在主界面上停留的时间"},
[67]={67,10,"","个人一天之内可以向多少数量的公会发出申请"},
[68]={68,0,"58_59_60_61","战斗内预设语言的ID"},
[69]={69,10,"","每日钻石兑换金币次数"},
[70]={70,0,"1_1000","钻石兑换金币的比率"},
[71]={71,0,"2_20|5_20","国战布局结束时间阶段（以周为单位）【格式为：周几_几点】"},
[72]={72,0,"1_1000","维修坦克需要消耗的金币数量【金币数_血量】(不足整数的向上取整，比如血量一百，消耗1金币，血量一千一百，消耗2金币）"},
[73]={73,0,"30.0","公会申请消息保存最长时间"},
[74]={74,100,"","【个人天梯】天梯积分基础分数"},
[75]={75,20,"","【个人天梯】猎杀天梯系数"},
[76]={76,0,"0.003","【个人天梯】伤害输出累计天梯系数"},
[77]={77,0,"0.5","【个人天梯】击中坦克次数天梯系数"},
[78]={78,0,"0.001","【个人天梯】受到伤害累计天梯系数"},
[79]={79,50,"","【个人天梯】被击毁天梯系数"},
[80]={80,1000,"","战斗中对敌方造成的伤害转换为金币，获得的金币最大值【小于最大值按实际值来算，大于最大值取最大值】"},
[81]={81,0,"500_0_100|2000_5_2000|5000_10_8000|10000_28_30000","【购买燃油的数量_消耗的钻石数量_消耗的金币数量】"},
[82]={82,20,"","打一场战斗消耗的燃油量"},
[83]={83,0,"X号建制","国战建制初始名称"},
[84]={84,5,"1_10","国战建制名称字数限制"},
[85]={85,1000,"","战斗公式中的防御基数"},
[86]={86,110,"","燃油无限的坦克ID"},
[87]={87,500,"","系统赠送的坦克默认携带燃油数量"},
[88]={88,110,"","系统赠送坦克ID"},
[89]={89,100,"","【个人天梯】胜利系数"},
[90]={90,0,"","【个人天梯】失败系数"},
[91]={91,1000,"","【战旗积分】胜利积分的基础增加值"},
[92]={92,100,"","【战旗积分】失败积分基础增加值"},
[93]={93,2000,"","【战旗积分】单场积分增加最大值"},
[94]={94,200,"","【战旗积分】单场积分增加最小值"},
[95]={95,500,"","【战旗积分】失败方/获胜方之后乘以的系数"},
[96]={96,1,"","卸下旧装备消耗的【钻石】数量"},
[97]={97,0,"0.5","未成年防沉迷，累计在线超过3小时，小于五小时，收益降低为百分之五十"},
[98]={98,0,"0.0","未成年防沉迷，累计在线超过五小时，收益为零。"},
}
Q_Global.GetTempData = function (key, strName)
                             if not Q_Global[key] or not Q_Global_index[strName] or type(key) == "function" then
                                    log_info("Q_Global.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Global[key]) ~= "table" then
                                    log_info("Q_Global.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Global[key][Q_Global_index[strName]]
                             if not pData then
                                 log_info("Q_Global.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
