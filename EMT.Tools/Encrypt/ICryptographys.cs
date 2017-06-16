using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface ICryptographys
    {
        string AESDecrypt(string text, string password = "abet9fv5!mt2k0p!");

        string AESEncrypt(string text, string password = "abet9fv5!mt2k0p!");

        string DESDecrypt(string text, string sKey);

        string DESEncrypt(string text, string sKey);

        string MD5Encrypt(string text, bool com);

        string MD5EncryptCompatibleJava(string text);

        string SHA1Encrypt(string text, bool toUpper = true);
    }
}
