using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// RoleAjax 的摘要说明
    /// </summary>
    public class RoleAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "role":
                    var role_id = context.Request.QueryString["role_id"];
                    GetRole(context,long.Parse(role_id));
                    break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }

        }
        /// <summary>
        /// 获取到这个角色相关的信息返回到页面
        /// </summary>
        /// <param name="context"></param>
        /// <param name="role_id"></param>
        public void GetRole(HttpContext context,long role_id)
        {
            var role = new sys_role_dal().FindSignleBySql<sys_role>($"select * from sys_role where id = {role_id} ");
            if (role != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(role));
            }
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