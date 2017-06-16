using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml.Serialization;
using System.Web.Script.Serialization;
namespace EMT.Tools
{
    public class Serialize :ISerialize
    {
        /// <summary>
        /// 序列化对象为XML
        /// </summary>
        public string SerializeXml(object obj)
        {
            Type type = obj.GetType();
            XmlSerializer serializer = new XmlSerializer(type);
            StringBuilder sb = new StringBuilder();
            using (StringWriter write = new StringWriter(sb))
            {
                serializer.Serialize(write, obj);
            }
            return sb.ToString();
        }
        /// <summary>
        /// 把XML反序列化为对象
        /// </summary>
        public T DeserializeXml<T>(string xmlStr) where T : class
        {
            Type type = typeof(T);
            XmlSerializer serializer = new XmlSerializer(type);
            using (StringReader sr = new StringReader(xmlStr))
            {
                Object obj = serializer.Deserialize(sr);
                return obj as T;
            }
        }

        /// <summary>
        /// 序列化JSON对象
        /// </summary>
        public string SerializeJson(object obj)
        {
            return JsonConvert.SerializeObject(obj);
        }
        /// <summary>
        /// 反序列化JSON对象
        /// </summary>
        public T DeserializeJson<T>(string jsonStr)
        {
            return JsonConvert.DeserializeObject<T>(jsonStr);
        }

        /// <summary>
        /// 将json数据反序列化为Dictionary
        /// </summary>
        /// <param name="jsonData">json数据</param>
        /// <returns></returns>
        public Dictionary<string, object> JsonToDictionary(string jsonData)
        {
            //实例化JavaScriptSerializer类的新实例
            JavaScriptSerializer jss = new JavaScriptSerializer();
            try
            {
                //将指定的 JSON 字符串转换为 Dictionary<string, object> 类型的对象
                return jss.Deserialize<Dictionary<string, object>>(jsonData);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
