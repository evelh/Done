using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// GeneralAjax 的摘要说明
    /// </summary>
    public class GeneralAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "general":
                        var general_id = context.Request.QueryString["id"];
                        GetGeneralInfo(context,long.Parse(general_id));
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



        private void GetGeneralInfo(HttpContext context,long id)
        {
            var general = new d_general_dal().GetGeneralById(id);
            if (general != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(general)); 
            }
        }
        private void GetTaxInfo(HttpContext context, long id)
        {
            
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