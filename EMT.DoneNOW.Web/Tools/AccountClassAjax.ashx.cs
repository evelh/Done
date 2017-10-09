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
                case "delete_validate": Delete_Validate(context, Convert.ToInt64(class_id)); ; break;
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
                    context.Response.Write("success");
                }
                else if(result==DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("system");
                }
                else
                {
                    context.Response.Write("error");
                }
            }
        }
        /// <summary>
        /// 删除前进行数据校验
        /// </summary>
        /// <param name="context"></param>
        /// <param name="class_id"></param>
        public void Delete_Validate(HttpContext context, long class_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                int n;//记录受影响的客户个数
                var result = new AccountClassBLL().Delete_Validate(class_id, user.id,out n);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Delete(context, class_id);
                }
                else if (result == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("system");
                }
                else if (result==DTO.ERROR_CODE.ACCOUNT_TYPE_USED) {
                    context.Response.Write(n);
                }
                else
                {
                    context.Response.Write("other");
                }
            }
        }
        public void Active(HttpContext context, long class_id)
        {
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
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new AccountClassBLL().NoActive(class_id, user.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("停用成功！");
                }
                else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已经是停用状态，无需此操作！");
                }
                else {
                    context.Response.Write("停用失败！");
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