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
    /// ContractAjax 的摘要说明
    /// </summary>
    public class ContractAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var cicid = context.Request.QueryString["cicid"];
                        DeleteConIntCost(context, Convert.ToInt64(cicid));
                        break;
                    default:
                        break;
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
        /// <summary>
        /// 删除合同内部成本
        /// </summary>
        /// <param name="context"></param>
        /// <param name="cicId"></param>
        public void DeleteConIntCost(HttpContext context,long cicId)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                context.Response.Write(new ContractBLL().DeleteConIntCost(cicId,res.id));
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