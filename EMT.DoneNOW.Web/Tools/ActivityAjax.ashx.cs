using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ActivityAjax 的摘要说明
    /// </summary>
    public class ActivityAjax : IHttpHandler, IRequiresSessionState
    {
        private ActivityBLL bll = new ActivityBLL();
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "CheckIsNote":
                        var id = context.Request.QueryString["id"];  // 活动
                        CheckIsNote(context, long.Parse(id));
                        break;
                    case "Delete":
                        id = context.Request.QueryString["id"];  // 活动
                        DeleteActivity(context, long.Parse(id));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {
                context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
            }
        }

        /// <summary>
        /// 判断一个待办是否是备注
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void CheckIsNote(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.CheckIsNote(id)));
        }

        /// <summary>
        /// 删除活动
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void DeleteActivity(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteActivity(id, (context.Session["dn_session_user_info"] as sys_user).id)));
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