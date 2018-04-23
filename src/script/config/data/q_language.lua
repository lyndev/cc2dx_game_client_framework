q_language_index={["Id"]=1,
["DescCN"]=2,
}

q_language={[1]={1,"胡数:"},
[2]={2,"{NUM}胡[点炮]"},
[3]={3,"{NUM}胡[自摸]"},
[4]={4,"{NUM}胡[摆牌]"},
[5]={5,"黑摆:"},
[6]={6,"乱胡:"},
[7]={7,"天胡:"},
[8]={8,"地胡:"},
[9]={9,"报牌:"},
[10]={10,"水上漂:"},
[11]={11,"海底捞:"},
[12]={12,"坤牌:"},
[13]={13,"红牌:"},
[14]={14,"黑牌:"},
[15]={15,"查叫:"},
[16]={16,"炸天报:"},
[17]={17,"杀报:"},
[18]={18,"归:"},
[19]={19,"自摸:"},
[20]={20,"{NUM}番"},
[21]={21,"您的帐号在另一台设备上登陆！"},
[22]={22,"游客Id重复"},
[23]={23,"该账号已经编写过了"},
[24]={24,"该账号已经绑定过，请直接登陆"},
[25]={25,"已经是好友，不能重复添加"},
[26]={26,"请求ID错误"},
}
q_language.GetTempData = function (key, strName)
                             if not q_language[key] or not q_language_index[strName] or type(key) == "function" then
                                    log_info("q_language.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(q_language[key]) ~= "table" then
                                    log_info("q_language.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = q_language[key][q_language_index[strName]]
                             if not pData then
                                 log_info("q_language.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
