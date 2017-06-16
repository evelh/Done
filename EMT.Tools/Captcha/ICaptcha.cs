using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface ICaptcha
    {
        byte[] CreateCaptcha(out string code, int codeLength, int width, int height, int fontSize);
    }
}
