using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// GeneralViewAjax 的摘要说明
    /// </summary>
    public class GeneralViewAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var general_id = context.Request.QueryString["id"];
            switch (action)
            {
                //case "edit": Edit(context, Convert.ToInt64(general_id)); ; break;
                case "delete": Delete(context, Convert.ToInt64(general_id)); ; break;
                default: break;

            }
            }
        public void Delete(HttpContext context, long general_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user!= null)
            {
                var ss = new GeneralBLL().Delete(general_id, user.id);
                if (ss == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else if (ss == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("系统默认不能删除！");
                }
                else {
                    context.Response.Write("删除失败！");
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