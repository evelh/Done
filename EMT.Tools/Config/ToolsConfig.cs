using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
namespace EMT.Tools
{
    public class ToolsConfig
    {
        //redis 连接字符串
        public static string RedisConnect = GetConfiguration("RedisConnect");

        /// <summary>
        ///根据AppSettings.config配置文件中的key获取对应的value
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string GetConfiguration(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }
}
