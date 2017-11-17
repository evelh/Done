using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 权限点信息
    /// </summary>
    public class AuthPermitDto
    {
        public sys_permit permit { get; set; }
        public List<AuthUrlDto> url { get; set; }
    }

    /// <summary>
    /// 权限点URL信息
    /// </summary>
    public class AuthUrlDto
    {
        public string url { get; set; }
        public List<UrlPara> parms { get; set; }
    }

    /// <summary>
    /// URL参数信息
    /// </summary>
    public class UrlPara
    {
        public string name { get; set; }
        public string value { get; set; }
    }
}
