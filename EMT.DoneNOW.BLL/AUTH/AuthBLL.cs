using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.Tools;

namespace EMT.DoneNOW.BLL
{
    public class AuthBLL
    {
        private readonly AuthDal _dal = new AuthDal();

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
            //where.Append($" AND password='{password}' ");

            List<Auth> user = _dal.FindListBySql($"SELECT * FROM auth WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            // TODO: if (new Tools.Cryptographys().SHA1Encrypt(password).Equals(user[0].))



            return ERROR_CODE.ERROR;
        }
    }
}
