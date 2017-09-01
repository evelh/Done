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
    /// AccountClassAjax 的摘要说明
    /// </summary>
    public class AccountClassAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var class_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "active": Active(context, Convert.ToInt64(class_id)); ; break;
                case "noactive":NoActive(context, Convert.ToInt64(class_id)); ; break;
                case "delete": Delete(context, Convert.ToInt64(class_id)); ; break;
                default: break;

            }
        }
        public void Delete(HttpContext context, long class_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new AccountClassBLL().Delete(class_id,user.id);
                if (result==DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else if(result==DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("系统默认不能删除！");
                }
                else
                {
                    context.Response.Write("删除失败！");
                }
            }
        }

        public void Active(HttpContext context, long class_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new AccountClassBLL().Active(class_id, user.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("激活成功！");
                }
                else if (result == DTO.ERROR_CODE.ACTIVATION)
                {
                    context.Response.Write("已经激活，无需此操作！");
                }
                else {
                    context.Response.Write("激活失败！");
                }
            }
        }
        public void NoActive(HttpContext context, long class_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new AccountClassBLL().NoActive(class_id, user.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("失活成功！");
                }
                else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已经失活，无需此操作！");
                }
                else {
                    context.Response.Write("失活失败！");
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