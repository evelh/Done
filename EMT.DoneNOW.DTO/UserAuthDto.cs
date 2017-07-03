using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class UserAuthDto
    {
        /// <summary>
        /// 登录名（用户手机号或邮箱）
        /// </summary>
        public string name;
        /// <summary>
        /// 密码（用户密码的md5值）
        /// </summary>
        public string password;
    }
}
