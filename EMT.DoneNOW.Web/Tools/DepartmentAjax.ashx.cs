using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// DepartmentAjax 的摘要说明
    /// </summary>
    public class DepartmentAjax : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];            
            switch (action)
            {
                case "delete": var departmen_id = context.Request.QueryString["id"];
                    Delete(context, Convert.ToInt64(departmen_id));break;

                default: break;

            }
        }
        public void Delete(HttpContext context, long departmen_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string returnvalue = string.Empty;
                var result = new DepartmentBLL().Delete(departmen_id, res.id, out returnvalue);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    context.Response.Write(returnvalue);
                }
                else
                {
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