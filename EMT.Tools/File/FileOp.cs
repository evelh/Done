using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace EMT.Tools
{
    public class FileOp:IFileOp
    {
        /// <summary>
        /// 把一个字符串写到文件
        /// </summary>
        public void WriteStringToFile(string content, string fullFileName, bool append = true, string encoding = "UTF-8")
        {
            using (StreamWriter sw = new StreamWriter(fullFileName, append, Encoding.GetEncoding(encoding)))
            {
                sw.Write(content);
            }
        }
        /// <summary>
        /// 读取一个文本文件成为字符串
        /// </summary>
        public string ReadFileToString(string fullFileName, string encoding = "UTF-8")
        {
            string content = "";
            using (StreamReader sr = new StreamReader(fullFileName, Encoding.GetEncoding(encoding)))
            {
                content = sr.ReadToEnd();
            }
            return content;
        }
    }
}
