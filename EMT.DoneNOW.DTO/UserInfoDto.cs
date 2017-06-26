using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class UserInfoDto
    {
        public long id;         // userid
        public long dbid;       // 租户id【预留】
        public string name;     // 用户姓名
        public int security_Level_id;   // 权限对应id
        public int department_id;       // 部门id
        public string mobile;           // 手机号
        public string email;            // 邮箱
    }
}
