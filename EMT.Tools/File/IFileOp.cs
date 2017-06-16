using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface IFileOp
    {
        string ReadFileToString(string fullFileName, string encoding = "UTF-8");
        void WriteStringToFile(string content, string fullFileName, bool append = true, string encoding = "UTF-8");
    }
}
