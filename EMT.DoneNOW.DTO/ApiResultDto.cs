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
        // Occupy

        /* CRM */
        CRM_ACCOUNT_NAME_EXIST = 3000,              // 客户名称已存在
        PHONE_OCCUPY,                               // 电话被占用
        MOBILE_PHONE_OCCUPY,



        ACTIVATION,                                  //已经激活
        NO_ACTIVATION,                               //已经失活
        SYS_NAME_EXIST,                              //员工姓名已存在
        EXIST,                                       //已经存在
        DEFAULT,                                     //已经设为默认
    }
}
