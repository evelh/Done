using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using JWT;

namespace EMT.DoneNOW.BLL
{
    public class AuthBLL
    {
        private readonly sys_user_dal _dal = new sys_user_dal();

        public ERROR_CODE Login(string loginName, string password)
        {
            StringBuilder where = new StringBuilder();
            if (new RegexOp().IsEmail(loginName))
            {
                where.Append($" email='{loginName}' ");
            }
            else if (new RegexOp().IsMobilePhone(loginName))
            {
                where.Append($" mobile='{loginName}' ");
            }
            else
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            where.Append($" AND delete_time=0 ");

            List<sys_user> user = _dal.FindListBySql($"SELECT * FROM sys_user WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            if (!new Cryptographys().SHA1Encrypt(password).Equals(user[0].password))
            {
                // TODO: 输入错误密码处理
                return ERROR_CODE.PASSWORD_ERROR;
            }

            // 根据user表信息进入租户数据库获取详细信息，以判断用户状态
            sys_resource resource = new sys_resource_dal().FindById(user[0].id);
            if (resource.is_locked == 1)
                return ERROR_CODE.LOCK;
            if (resource.active == 0)
                return ERROR_CODE.LOCK;


            return ERROR_CODE.ERROR;
        }
    }
}
