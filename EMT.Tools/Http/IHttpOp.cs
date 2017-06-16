using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface IHttpOp
    {

        string HttpGet(string url, Dictionary<string, string> mapParas);
        string HttpPost(string url, Dictionary<string, string> mapParas);
        string UrlEncode(string text);
        string GetSerializeDicPram(Dictionary<string, string> mapParas);
        void DownLoadString(string url, string savePath, string codeType);
    }
}
