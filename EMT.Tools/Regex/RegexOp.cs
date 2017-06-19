using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
namespace EMT.Tools
{
    /// <summary>
    /// 正则表达式相关操作
    /// </summary>
    public class RegexOp:IRegexOp
    {
        /// <summary>
        /// 手机号格式判断
        /// </summary>
        /// <param name="phoneNumber"></param>
        /// <returns></returns>
        public bool IsMobilePhone(string phoneNumber)
        {
            if (phoneNumber.IsNullOrEmpty())
                return false;
            Regex reg = new Regex(@"^1[3|4|5|7|8][0-9]\d{8}$");
            return reg.Matches(phoneNumber).Count > 0;
        }

        /// <summary>
        /// 邮箱格式判断
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool IsEmail(string email)
        {
            if (email.IsNullOrEmpty())
                return false;
            Regex reg = new Regex(@"/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/");
            return reg.Matches(email).Count > 0;
        }

        /// <summary>
        /// 判断是否为数字字符串
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public bool IsNumeric(string num)
        {
            if (num.IsNullOrEmpty())
                return false;
            return Regex.IsMatch(num, @"^\d+$");
        }

    }
}
