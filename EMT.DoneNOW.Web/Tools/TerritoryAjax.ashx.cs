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
    /// TerritoryAjax 的摘要说明
    /// </summary>
    public class TerritoryAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];

                switch (action)
                {
                    case "delete":
                        var account_id = context.Request.QueryString["aid"];
                        var territory_id = context.Request.QueryString["tid"];
                        Delete(context, long.Parse(account_id), long.Parse(territory_id));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        public void Delete(HttpContext context, long aid, long tid)
        {

            if (new TerritoryBLL().DeleteAccount_Territory(aid, tid, LoginUserId))
            {
                context.Response.Write("yes");
            }
            else
            {
                context.Response.Write("no");
            }

        }
    }
}