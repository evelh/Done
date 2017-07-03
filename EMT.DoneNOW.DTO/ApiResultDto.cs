using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class ApiResultDto
    {
        public int code;
        public string msg;
        public object data;
    }
    public enum ERROR_CODE
    {
        SUCCESS = 0,                                // 成功
        ERROR = 1,                                  // 错误

        /* 通用错误 */
        PARAMS_ERROR = 1000,                        // 参数缺失或错误

        /* 登录验证错误 */
        TIME_OUT = 2000,                            // 登录超时
        USER_NOT_FIND,                              // 用户未注册
        PASSWORD_ERROR,                             // 密码错误
        LOCK,                                       // 限制登录
        USER_LIMITCOUNT,                             // 登录人数超过登录限制人数


        /* CRM */
        CRM_ACCOUNT_NAME_EXIST = 3000,              // 客户名称已存在
    }
}
