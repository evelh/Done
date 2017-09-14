using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ApproveAndPostAjax 的摘要说明
    /// </summary>
    public class ApproveAndPostAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "init":
                    var type = context.Request.QueryString["type"];
                    var id = context.Request.QueryString["id"];
                    Init(context, Convert.ToInt32(id), Convert.ToInt32(type));
                    break;
                default: break;

            }
        }
        /// <summary>
        /// 恢复初始值
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        /// <param name="type"></param>
        public void Init(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();           
                var user = context.Session["dn_session_user_info"] as sys_user;
                if (user != null)
                {
                    if (aapbll.Restore_Initial(id, type, user.id))
                    {
                        context.Response.Write("已经恢复初始值！");
                    }
                    else {
                        context.Response.Write("失败！");
                    }
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