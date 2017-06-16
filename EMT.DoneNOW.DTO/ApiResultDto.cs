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

        TIME_OUT = 1000,                            // 登录超时
        PARAMS_ERROR = 1001,                        // 参数缺失或错误

        CRM_ACCOUNT_NAME_EXIST = 2000,              // 客户名称已存在
    }
}
