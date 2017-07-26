// <%@ WebHandler Language = "C#" CodeBehind="CompanyAjax.ashx.cs" Class="EMT.DoneNOW.Web.Tools.CompanyAjax" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// CompanyAjax 的摘要说明
    /// </summary>
    public class CompanyAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)


        {
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            string act = DNRequest.GetQueryString("act");
            switch (act)
            {
                case "name": //国家
                    var companyName = context.Request.QueryString["companyName"];
                    companyNameCheck(context, companyName);
                    break;
 
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    return;
            }
        }
        /// <summary>
        /// 校验客户名称
        /// </summary>
        /// <param name="context"></param>
        /// <param name="companyName"></param>
        public void companyNameCheck(HttpContext context,string companyName)
        {
            // var companyList = new crm_account_dal().GetAllCompany();
            var similar = "";
            CompanyBLL comBLL = new CompanyBLL();
            var compareAccountName = comBLL.CheckCompanyName(comBLL.CompanyNameDeal(companyName.Trim()));
            if(compareAccountName != null && compareAccountName.Count > 0)
            {
               
                compareAccountName.ForEach(_ => { similar += _.id.ToString()+","; });
                if (similar != "")
                {
                    similar = similar.Substring(0, similar.Length - 1);                   
                }
            }
            context.Response.Write(similar);

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