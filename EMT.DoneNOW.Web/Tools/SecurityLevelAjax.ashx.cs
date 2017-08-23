using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL.IVT;
using static EMT.DoneNOW.DTO.DicEnum;
using EMT.Tools.Date;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SecurityLevelAjax 的摘要说明
    /// </summary>
    public class SecurityLevelAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "copy": var securitylevel_id = context.Request.QueryString["id"];
                    CopySecurityLevel(context, Convert.ToInt64(securitylevel_id));
                    break;
                default:break;
            }
            }
        public void CopySecurityLevel(HttpContext context, long securitylevel_id)
        {
           //此处写复制逻辑
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}