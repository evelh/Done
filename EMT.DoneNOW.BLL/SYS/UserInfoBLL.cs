using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class UserInfoBLL
    {
        /// <summary>
        /// 根据用户id获取用户信息
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static UserInfoDto GetUserInfo(long userId)
        {
            sys_user user = new sys_user_dal().FindById(userId);
            if (user == null)
                return null;

            return new UserInfoDto
            {
                id = user.id,
                email = user.email,
                mobile = user.mobile_phone,
                name = user.name
            };
        }
    }
}
