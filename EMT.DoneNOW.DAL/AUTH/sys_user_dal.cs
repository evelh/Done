using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_user_dal : BaseDAL<sys_user>
    {
        private const int max_loginNum = 2;//token中最大登陆限制人数
         
        /// <summary>
        /// 检测用户登录数量是否超出限制
        /// </summary>
        /// <param name="user_id">用户Id</param>
        /// <returns></returns>
        public bool IsBeyond(long user_id)
        {
            if (max_loginNum == 0)
                return true;
            string sql = $"SELECT COUNT(0) FROM sys_token WHERE user_id='{user_id}'";
            object obj = GetSingle(sql);
            int cnt = -1;
            if (int.TryParse(obj.ToString(), out cnt))
            {
                if (cnt<max_loginNum)
                    return true;
            }
            return false;
        }

     


    }
}
