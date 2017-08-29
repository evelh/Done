﻿using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class SysRoleInfoBLL
    {
        private readonly sys_role_dal _dal = new sys_role_dal();
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("Tax_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)));        // 税收种类
            return dic;
        }
        public ERROR_CODE Insert(sys_role role, long user_id) {
            role.id=(int)(_dal.GetNextIdCom());
            role.create_time=role.update_time=Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            role.create_user_id = user.id;
            _dal.Insert(role);
            return ERROR_CODE.SUCCESS;
        }

        public ERROR_CODE Update(sys_role role, long user_id)
        {
           role.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            role.update_user_id = user.id;

            if (_dal.Update(role) == false) {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        public sys_role GetOneData(int id) {
            return _dal.FindById(id);
        }

    }
}