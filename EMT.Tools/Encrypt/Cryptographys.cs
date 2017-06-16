using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace EMT.Tools
{
    public class Cryptographys:ICryptographys
    {
        /// <summary>
        /// AES加密
        /// </summary>
        /// <param name="text">需要加密的文本</param>
        /// <param name="password">密码</param>
        public string AESEncrypt(string text, string password = "abet9fv5!mt2k0p!")
        {
            RijndaelManaged rijndaelCipher = new RijndaelManaged();
            rijndaelCipher.Mode = CipherMode.ECB;
            rijndaelCipher.Padding = PaddingMode.PKCS7;
            rijndaelCipher.KeySize = 128;
            rijndaelCipher.BlockSize = 128;
            byte[] pwdBytes = System.Text.Encoding.UTF8.GetBytes(password);
            byte[] keyBytes = new byte[16];
            int len = pwdBytes.Length;
            if (len > keyBytes.Length) len = keyBytes.Length;
            System.Array.Copy(pwdBytes, keyBytes, len);
            rijndaelCipher.Key = keyBytes;
            // byte[] ivBytes = { 0 };
            // rijndaelCipher.IV = ivBytes;
            ICryptoTransform transform = rijndaelCipher.CreateEncryptor();
            byte[] plainText = Encoding.UTF8.GetBytes(text);
            byte[] cipherBytes = transform.TransformFinalBlock(plainText, 0, plainText.Length);
            string result = string.Empty;
            for (int i = 0; i < cipherBytes.Length; i++)//逐字节变为16进制字符
            {
                result += cipherBytes[i].ToString("X2");// Convert.ToString(cipherBytes[i], 16);
            }
            //Console.WriteLine(result);
            return result;
            //return Convert.ToBase64String(cipherBytes);
        }
        /// <summary>
        /// AES解密
        /// </summary>
        /// <param name="text">需要解密的密文</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        public string AESDecrypt(string text, string password = "abet9fv5!mt2k0p!")
        {
            RijndaelManaged rijndaelCipher = new RijndaelManaged();
            rijndaelCipher.Mode = CipherMode.ECB;
            rijndaelCipher.Padding = PaddingMode.PKCS7;
            rijndaelCipher.KeySize = 128;
            rijndaelCipher.BlockSize = 128;
            //byte[] encryptedData = Encoding.UTF8.GetBytes(text);
            byte[] encryptedData = new byte[text.Length / 2];
            for (int i = 0; i < encryptedData.Length; i++)
            {
                try
                {
                    // 每两个字符是一个 byte。
                    encryptedData[i] = byte.Parse(text.Substring(i * 2, 2),
                    System.Globalization.NumberStyles.HexNumber);
                }
                catch
                {
                    // Rethrow an exception with custom message.
                    throw new ArgumentException("hex is not a valid hex number!", "hex");
                }
            }
            byte[] pwdBytes = System.Text.Encoding.UTF8.GetBytes(password);
            byte[] keyBytes = new byte[16];
            int len = pwdBytes.Length;
            if (len > keyBytes.Length) len = keyBytes.Length;
            System.Array.Copy(pwdBytes, keyBytes, len);
            rijndaelCipher.Key = keyBytes;
            //byte[] ivBytes = System.Text.Encoding.UTF8.GetBytes(iv);
            //rijndaelCipher.IV = ivBytes;
            ICryptoTransform transform = rijndaelCipher.CreateDecryptor();
            byte[] plainText = transform.TransformFinalBlock(encryptedData, 0, encryptedData.Length);
            return Encoding.UTF8.GetString(plainText);
        }
        /// <summary>
        /// Des带key加密（8位密钥，16位加密结果）
        /// </summary>
        /// <param name="text"></param>
        /// <param name="sKey">Key必须是8位</param>
        /// <returns></returns>
        public string DESEncrypt(string text, string sKey)
        {
            //8位密钥，16位加密结果
            try
            {
                if (string.IsNullOrEmpty(text)) return "";
                DESCryptoServiceProvider des = new DESCryptoServiceProvider();
                byte[] inputByteArray = System.Text.Encoding.Default.GetBytes(text);
                des.Key = System.Text.ASCIIEncoding.ASCII.GetBytes(sKey);
                des.IV = System.Text.ASCIIEncoding.ASCII.GetBytes(sKey);
                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(), CryptoStreamMode.Write);
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                System.Text.StringBuilder ret = new System.Text.StringBuilder();
                foreach (byte b in ms.ToArray())
                {
                    ret.AppendFormat("{0:X2}", b);
                }
                ret.ToString();
                return ret.ToString();
            }
            catch
            {
                throw new Exception("DesEncrypt is invalid!");
            }
        }
        /// <summary>
        /// DES带key解密（8位密钥，16位加密结果）
        /// </summary>
        /// <param name="text"></param>
        /// <param name="sKey">Key必须是8位</param>
        /// <returns></returns>
        public string DESDecrypt(string text, string sKey)
        {
            try
            {
                if (string.IsNullOrEmpty(text)) return "";
                DESCryptoServiceProvider des = new DESCryptoServiceProvider();
                byte[] inputByteArray = new byte[text.Length / 2];
                for (int x = 0; x < text.Length / 2; x++)
                {
                    int i = (Convert.ToInt32(text.Substring(x * 2, 2), 16));
                    inputByteArray[x] = (byte)i;
                }
                des.Key = System.Text.ASCIIEncoding.ASCII.GetBytes(sKey);
                des.IV = System.Text.ASCIIEncoding.ASCII.GetBytes(sKey);
                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write);
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                System.Text.StringBuilder ret = new System.Text.StringBuilder();
                return System.Text.Encoding.Default.GetString(ms.ToArray());
            }
            catch
            {
                return "";
            }
        }
        /// <summary>
        /// MD5加密 兼容老系统的java版本
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public string MD5EncryptCompatibleJava(string text)
        {
            StringBuilder sb = new StringBuilder();
            char[] chars = { 's', 'a', '2', '3', 'b', '5', '6', '7', '8', 'h', 'A', 'B', 'C', 'Z', 'm', 'V' };
            byte[] bytes = Encoding.ASCII.GetBytes(text);

            HashAlgorithm sha = new MD5CryptoServiceProvider();
            byte[] targ = sha.ComputeHash(bytes);
            foreach (var item in targ)
            {
                int j = item >> 4 & 0xFF;
                int k = item & 0x0F;
                sb.Append(chars[j]);
                sb.Append(chars[k]);
            }
            var result = sb.ToString();
            return result;
        }
        /// <summary>
        /// MD5加密 C#版本 
        /// </summary>
        /// <param name="text"></param>
        /// <param name="is16Bit">false-32位 true-16位</param>
        /// <returns></returns>
        public string MD5Encrypt(string text, bool is16Bit = true )
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            var t2 = "";
            if (is16Bit)
                t2 = BitConverter.ToString(md5.ComputeHash(UTF8Encoding.Default.GetBytes(text)), 4, 8);
            else
                t2 = BitConverter.ToString(md5.ComputeHash(UTF8Encoding.Default.GetBytes(text)));
            t2 = t2?.Replace("-", "");
            t2 = t2?.ToLower();
            return t2;
        }

        /// <summary>
        /// 计算SHA-1码
        /// </summary>
        /// <param name="word">字符串</param>
        /// <param name="toUpper">返回哈希值格式 true：英文大写，false：英文小写</param>
        /// <returns></returns>
        public string SHA1Encrypt(string text, bool toUpper = true)
        {
            try
            {
                SHA1CryptoServiceProvider SHA1CSP = new SHA1CryptoServiceProvider();

                byte[] bytValue = System.Text.Encoding.UTF8.GetBytes(text);
                byte[] bytHash = SHA1CSP.ComputeHash(bytValue);
                SHA1CSP.Clear();

                //根据计算得到的Hash码翻译为SHA-1码
                string sHash = "", sTemp = "";
                for (int counter = 0; counter < bytHash.Count(); counter++)
                {
                    long i = bytHash[counter] / 16;
                    if (i > 9)
                    {
                        sTemp = ((char)(i - 10 + 0x41)).ToString();
                    }
                    else
                    {
                        sTemp = ((char)(i + 0x30)).ToString();
                    }
                    i = bytHash[counter] % 16;
                    if (i > 9)
                    {
                        sTemp += ((char)(i - 10 + 0x41)).ToString();
                    }
                    else
                    {
                        sTemp += ((char)(i + 0x30)).ToString();
                    }
                    sHash += sTemp;
                }

                //根据大小写规则决定返回的字符串
                return toUpper ? sHash : sHash.ToLower();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        
    }
}
