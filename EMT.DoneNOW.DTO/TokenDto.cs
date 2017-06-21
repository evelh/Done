using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class TokenStructDto
    {
        public long uid;          // 用户id
        public long timestamp;    // 开始时间戳
        public long expire;       // 到期时间戳
        public int rand;          // 随机数
        public int server = 0;    // 生成token服务器
    }

    public class TokenDto
    {
        public string token;
        public string refresh;
    }
}
