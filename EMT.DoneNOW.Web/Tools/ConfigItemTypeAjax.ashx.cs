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
    /// ConfigItemTypeAjax 的摘要说明
    /// </summary>
    public class ConfigItemTypeAjax : IHttpHandler, IRequiresSessionState
    {       
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var type_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "delete":
                    Delete(context, Convert.ToInt64(type_id)); break;
                case "delete_valid":
                    Delete(context, Convert.ToInt64(type_id)); break;
                case "Active":
                    Active(context, Convert.ToInt64(type_id)); break;
                case "No_Active":
                    No_Active(context, Convert.ToInt64(type_id)); break;
                default: break;
            }
        }
        public void Delete_Valid(HttpContext context, long type_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string returnvalue = string.Empty;
                var result = new ConfigTypeBLL().Delete_Valid(type_id, res.id, out returnvalue);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Delete(context, type_id);
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    context.Response.Write(returnvalue);
                }
                else if (result == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("system");
                }
                else {
                    context.Response.Write("other");
                }
            }

        }
        public void Delete(HttpContext context, long type_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new ConfigTypeBLL().Delete(type_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else
                {
                    context.Response.Write("删除失败！");
                }
            }

        }
        public void Active(HttpContext context, long type_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new GeneralBLL().Active(type_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("激活成功！");
                }
                else if (result == DTO.ERROR_CODE.ACTIVATION)
                {
                    context.Response.Write("已是激活状态，无需此操作！");
                }
                else
                {
                    context.Response.Write("激活失败！");
                }
            }

        }
        public void No_Active(HttpContext context, long type_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new GeneralBLL().NoActive(type_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("停用成功！");
                }
                else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已是停用状态，无需此操作！");
                }
                else
                {
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