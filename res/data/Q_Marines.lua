Q_Marines_index={["q_id"]=1,
["q_marines_rank_name"]=2,
["q_grade"]=3,
}

Q_Marines={[1]={1,"青铜—什鬣","5500"},
[2]={2,"青铜—环蛇","16500"},
[3]={3,"青铜—狈屠","33000"},
[4]={4,"青铜—爪狐","55000"},
[5]={5,"白银—鳞鲨","82500"},
[6]={6,"白银—暴猿","115500"},
[7]={7,"白银—血蟒","154000"},
[8]={8,"白银—狼伍","198000"},
[9]={9,"黄金—铁鳄","247500"},
[10]={10,"黄金—豹略","302500"},
[11]={11,"黄金—战犀","363000"},
[12]={12,"黄金—熊奇","429000"},
[13]={13,"钻石—狮韬","500500"},
[14]={14,"钻石—虎霸","577500"},
[15]={15,"钻石—凤势","660000"},
[16]={16,"钻石—龙威","748000"},
[0]={0,"","0"},
}
Q_Marines.GetTempData = function (key, strName)
                             if not Q_Marines[key] or not Q_Marines_index[strName] or type(key) == "function" then
                                    log_info("Q_Marines.log"," the data is nil or the index data is nil or key is function key =%s , strName = %s" , tostring(key) , tostring( strName))
                                    return nil
                             end
                             if type(Q_Marines[key]) ~= "table" then
                                    log_info("Q_Marines.log"," the data is not table key =%s , strName = %s" , tostring(key) , tostring( strName))
                                return nil
                             end
                             local pData = Q_Marines[key][Q_Marines_index[strName]]
                             if not pData then
                                 log_info("Q_Marines.log"," the data is nil key =%s , strName = %s" , tostring(key) , tostring( strName))
                                 return nil
                             end
                             return pData
                         end
