using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Reflection;
using System.ComponentModel.DataAnnotations.Schema;
using AutoMapper;
using System.Net;
using System.Net.Sockets;
namespace EMT.Tools
{
    public static class Utils
    {
        #region IOC

        private static IIOC _IOC = null;

        public static IIOC IOC
        {
            get
            {
                if (_IOC == null)
                {
                    _IOC = new CastleIOC();
                }
                return _IOC;
            }
        }

        #endregion IOC
        #region 浏览器客户端信息 处理

        /// <summary>
        /// 检查IP地址格式
        /// </summary>
        /// <returns></returns>
        public static bool IsIP(string ip)
        {
            return System.Text.RegularExpressions.Regex.IsMatch(ip, @"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$");
        }

        /// <summary>
        /// 检查是否微信浏览器
        /// </summary>
        /// <returns></returns>
        public static bool IsWeiXin()
        {
            var isWeiXin1 = false;//是否微信客户端打开
            var agent = HttpContext.Current.Request.ServerVariables["http_user_agent"];
            if (!string.IsNullOrWhiteSpace(agent) && agent.ToLower().IndexOf("micromessenger") >= 0)
                isWeiXin1 = true;
            return isWeiXin1;
        }

        //判断是不是android系统
        public static bool IsAndroid()
        {
            var userAgent = HttpContext.Current.Request.UserAgent.ToLower();
            if (userAgent != null && userAgent.Contains("android"))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 取得客户端IP地址，可绕过CDN地址
        /// </summary>
        /// <param name="Request"></param>
        /// <returns></returns>
        public static string GetClientIP(HttpRequestBase Request)
        {
            var ip1 = Request.ServerVariables["HTTP_CDN_SRC_IP"];
            if (string.IsNullOrWhiteSpace(ip1))
            {
                ip1 = Request.ServerVariables["HTTP_CLIENT_IP"];
                if (string.IsNullOrWhiteSpace(ip1))
                {
                    ip1 = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                }
                if (string.IsNullOrWhiteSpace(ip1))
                {
                    ip1 = Request.ServerVariables["REMOTE_ADDR"];
                }
            }
            return ip1;
        }
        #endregion
        #region 随机数部分

        /// <summary>
        /// 随机数生产对象
        /// </summary>
        private static Random _randomer;

        private static Random Randomer
        {
            get
            {
                if (_randomer == null) _randomer = new Random();
                return _randomer;
            }
        }

        /// <summary>
        /// 获取一个随机数
        /// </summary>
        public static int GetNext(int min, int max)
        {
            return Randomer.Next(min, max);
        }

        /// <summary>
        /// 得到一个GUID字符串
        /// </summary>
        /// <returns></returns>
        public static string GetNewGuidStr(bool hasSplitChar = false)
        {
            var guid1 = Guid.NewGuid();
            return GetGuidStr(ref guid1, hasSplitChar);
        }

        private static string GetGuidStr(ref Guid guid, bool hasSplitChar = false)
        {
            if (hasSplitChar == false)
            {
                return guid.ToString("N");
            }
            return guid.ToString("D");
        }

        #endregion 随机数部分
        #region 序列化部分

        public static ISerialize Serialize
        {
            get
            {
                return IOC.Resolve<ISerialize>();
            }
        }

        #endregion 序列化部分
        #region 缓存部分

        public static ICacheder Cache
        {
            get
            {
                return IOC.Resolve<ICacheder>();
            }
        }

        #endregion 缓存部分
        #region 文件操作部分

        public static IFileOp FileHelper
        {
            get
            {
                return IOC.Resolve<IFileOp>();
            }
        }

        #endregion 文件操作部分
        #region 时间操作

        public static string FullDTStd()
        {
            return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }

        public static long GetTotalSecs1970()
        {
            return (long)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
        }

        #endregion 时间操作
        #region 图形验证码生成
        private static ICaptcha _captcha;
        public static ICaptcha CaptchaCode
        {
            get
            {
                if (_captcha == null)
                    _captcha = IOC.Resolve<ICaptcha>();
                return _captcha;
            }
        }
        #endregion 验证码生成
        #region Http操作帮助库

        public static IHttpOp HttpHelper
        {
            get
            {
                return IOC.Resolve<IHttpOp>();
            }
        }

        #endregion Http操作帮助库
        #region 目录、路径

        /// <summary>
        /// 获取可执行应用程序集所在目录
        /// </summary>
        public static string ExeAssemblyPath
        {
            get
            {
                return AppDomain.CurrentDomain.BaseDirectory + (HttpContext.Current == null ? "" : "bin\\");
            }
        }

        #endregion 目录、路径
        #region Sql检测部分
        public static string HandleInjectSqls(string strContent)
        {
            if (!string.IsNullOrEmpty(strContent))
            {
                strContent = strContent.Replace("'", "‘")
                .Replace("exec", "ｅｘｅ ｃ")
                .Replace("insert ", "ｉｎｓｅｒｔ")
                .Replace("select ", "ｓｅｌｅｃｔ")
                .Replace("delete ", "ｄｅｌｅｔｅ")
                .Replace("update ", "ｕｐｄａｔｅ")
                .Replace("*", "＊")
                .Replace("%", "％")
                .Replace(" master", "ｍａｓｔｅｒ")
                .Replace("truncate ", "ｔｒｕｎｃａｔｅ")
                .Replace("declare ", "ｄｅｃｌａｒｅ")
                .Replace(" where ", "ｗｈｅｒｅ");
            }
            return strContent;
        }

        #endregion SQL检测部分
        #region 属性相关操作
        /// <summary>
        /// 获取成员的ColumnAttribute的Name
        /// </summary>
        public static string GetColumnAttributeName(MemberInfo member)
        {
            if (member == null) return null;
            var attrib = (ColumnAttribute)Attribute.GetCustomAttribute(member, typeof(ColumnAttribute), false);
            return attrib == null ? member.Name : attrib.Name;
        }

        #endregion 属性（XxxAttribute）相关操作
        #region AutoMapper
        private static IMapper _mapperObj;
        public static void InitialMapper(IMapper mapper)
        {
            _mapperObj = mapper;
        }
        public static IMapper DtoMapper
        {
            get
            {
                return _mapperObj;
            }
        }
        #endregion AutoMapper
        #region Enum 相关操作
        public static string Enum2Str(Type t)
        {
            if (!t.IsEnum)
                return null;
            var vals = Enum.GetValues(t);
            var rslt = "";
            foreach (var v in vals)
            {
                rslt = $"{rslt},{v:d}={v}";
            }
            if (rslt.Length > 0)
                rslt = rslt.Substring(1);
            return rslt;
        }

        #endregion Enum 相关操作
        #region 网络相关
        public static IList<IPAddress> GetLocalIPv4()
        {
            IPHostEntry ips = Dns.GetHostEntry(Dns.GetHostName());
            return ips.AddressList.Where(ip => ip.AddressFamily == AddressFamily.InterNetwork).ToList();
        }
        #endregion 网络相关

    }
}
