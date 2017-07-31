using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// OpportunityAjax 的摘要说明
    /// </summary>
    public class OpportunityAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var opportunity_id = context.Request.QueryString["id"];
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {
                context.Response.End();

            }
        }

        public void DeleteOpportunity(HttpContext context,long opportunity_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new OpportunityBLL().DeleteOpportunity(opportunity_id,user.id);
                if (result)
                {
                    context.Response.Write("删除商机成功！");
                }                               
                else                            
                {                               
                    context.Response.Write("删除商机失败！");
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