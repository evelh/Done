using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Net;
using System.IO;
namespace EMT.Tools
{
    public class HttpOp:IHttpOp
    {
        /// <summary>
        /// http get
        /// </summary>
        /// <param name="url">请求地址</param>
        /// <param name="mapParas">请求参数</param>
        /// <returns></returns>
        public string HttpGet(string url, Dictionary<string, string> mapParas)
        {
            string queryString = string.Empty;
            if (url.Contains('?'))
            {
                queryString = "&";
            }
            else
            {
                queryString = "?";
            }
            if (mapParas != null)
            {
                queryString += GetSerializeDicPram(mapParas).ToString();
            }
            HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(url + queryString);
            httpWebRequest.ContentType = "application/json";
            httpWebRequest.Method = "GET";
            httpWebRequest.Timeout = 20000;
            HttpWebResponse httpWebResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            StreamReader streamReader = new StreamReader(httpWebResponse.GetResponseStream());
            string responseContent = streamReader.ReadToEnd();
            httpWebResponse.Close();
            streamReader.Close();
            return responseContent;
        }
        /// <summary>
        ///http post
        /// </summary>
        /// <param name="body">body是要传递的参数,格式"roleId=1&uid=2"</param>
        /// <param name="contentType">post的cotentType填写:"application/x-www-form-urlencoded" </param>
        /// soap填写:"text/xml; charset=utf-8"
        /// <returns></returns>
        public string HttpPost(string url, Dictionary<string, string> mapParas)
        {
            string body = GetSerializeDicPram(mapParas);
            HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
            httpWebRequest.ContentType = "application/x-www-form-urlencoded";
            httpWebRequest.Method = "POST";
            httpWebRequest.Timeout = 20000;
            byte[] btBodys = Encoding.UTF8.GetBytes(body);
            httpWebRequest.ContentLength = btBodys.Length;
            httpWebRequest.GetRequestStream().Write(btBodys, 0, btBodys.Length);
            HttpWebResponse httpWebResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            StreamReader streamReader = new StreamReader(httpWebResponse.GetResponseStream());
            string responseContent = streamReader.ReadToEnd();
            httpWebResponse.Close();
            streamReader.Close();
            httpWebRequest.Abort();
            httpWebResponse.Close();
            return responseContent;
        }
        /// <summary>
        /// 序列化参数，拼接URL
        /// </summary>
        /// <param name="mapParas"></param>
        /// <returns></returns>
        public string GetSerializeDicPram(Dictionary<string, string> mapParas)
        {
            if (mapParas == null || mapParas.Count <= 0)
                return "";
            string[] keys = new string[mapParas.Count];
            int j = 0;
            foreach (KeyValuePair<string, string> item in mapParas)
            {
                keys[j] = item.Key;
                j++;
            }
            Array.Sort(keys);
            string stringToSigned = string.Empty;
            for (int i = 0; i < mapParas.Count; i++)
            {
                foreach (KeyValuePair<string, string> item in mapParas)
                {
                    if (item.Key.ToString() == keys[i])//获取header数据
                    {
                        string strValue = item.Value;
                        if (null == strValue)
                        {
                            stringToSigned += UrlEncode(keys[i]) + "=" + string.Empty;
                        }
                        else
                        {
                            //stringToSigned += string.Format("{0}={1}", keys[i].ToLower(), HttpUtility.UrlEncode(strValue, Encoding.UTF8)).ToUpper();
                            stringToSigned += UrlEncode(keys[i]) + "=" + UrlEncode(strValue);
                        }
                        if (i != mapParas.Count - 1)
                        {
                            stringToSigned += "&";
                        }
                    }
                }
            }
            return stringToSigned;
        }

        /// <summary>
        /// URLENcode 输出的转换字符为大写的
        /// </summary>
        public string UrlEncode(string text)
        {
            Encoding encoding = Encoding.UTF8;
            StringBuilder stringBuilder = new StringBuilder();
            for (int i = 0; i < text.Length; i++)
            {
                string t = text[i].ToString();
                string k = HttpUtility.UrlEncode(t, encoding);
                if (t == k)
                {
                    stringBuilder.Append(t);
                }
                else
                {
                    stringBuilder.Append(k.ToUpper());
                }
            }
            return stringBuilder.ToString();
        }


       /// <summary>
       /// 下载
       /// </summary>
       /// <param name="url"></param>
       /// <param name="savePath"></param>
       /// <param name="codeType"></param>
        public void DownLoadString(string url, string savePath, string codeType)
        {
            string loadContent;
            WebClient webClient;

            using (webClient = new WebClient())
            {
                loadContent = webClient.DownloadString(url);
                File.WriteAllText(savePath, loadContent, Encoding.GetEncoding(codeType));
                webClient.Dispose();
            }
        }
    }
}
