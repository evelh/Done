using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// DepartmentAjax 的摘要说明
    /// </summary>
    public class DepartmentAjax : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];            
            switch (action)
            {
                case "delete": var departmen_id = context.Request.QueryString["id"];
                    Delete(context, Convert.ToInt64(departmen_id));break;
                case "GetNameByIds":
                    var dIds = context.Request.QueryString["ids"];
                    GetNameByIds(context,dIds);
                    break;
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

        private void GetNameByIds(HttpContext context,string ids)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                var depList = new sys_department_dal().GetDepartment($" and id in ({ids})");
                if (depList != null && depList.Count > 0)
                {
                    StringBuilder depStringBuilder = new StringBuilder();
                    depList.ForEach(_ => depStringBuilder.Append(_.name + ";"));
                    var depString = depStringBuilder.ToString();
                    if (!string.IsNullOrEmpty(depString))
                    {
                        context.Response.Write(depString);
                    }
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