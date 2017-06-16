using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public static class StringHelper
    {
        /// <summary>
        /// 字符串为空或者null 就替换为对应的字符串
        /// </summary>
        /// <param name="str"></param>
        /// <param name="reps"></param>
        /// <returns></returns>
        public static string EmptyRep(this string str, string rep)
        {
            if (string.IsNullOrEmpty(str))
                return rep;
            return str;
        }
        /// <summary>
        /// 扩展方法 判断字符串为null 或者 empty
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static bool IsNullOrEmpty(this string str)
        {
            if (string.IsNullOrEmpty(str))
                return true;
            return false;
        }

        /// <summary>
        /// 拆分字符串（并去除空值）
        /// </summary>
        /// <param name="str"></param>
        /// <param name="splitChar"></param>
        /// <returns></returns>
        public static string[] SplitExt(this string str, params char[] splitChar)
        {
            if (string.IsNullOrEmpty(str)) return null;
            string spstr = new string(splitChar);
            if (str.LastIndexOf(spstr) == str.Length - 1)
            {
                str = str.Substring(0, str.Length - 1);
            }
            string[] results = str.Split(splitChar, StringSplitOptions.RemoveEmptyEntries);
            return results;
        }
    }
}
