// <%@ WebHandler Language = "C#" CodeBehind="CompanyAjax.ashx.cs" Class="EMT.DoneNOW.Web.Tools.CompanyAjax" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using EMT.DoneNOW.DAL;
using System.Text;

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
                case "name": // 代表用于校验用户的名称
                    var companyName = context.Request.QueryString["companyName"];
                    companyNameCheck(context, companyName);
                    break;
                case "contact":    // 通过客户id去获取联系人列表
                    var account_id = context.Request.QueryString["account_id"];
                    GetCompanyContact(context,account_id);
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
            if (comBLL.ExistCompany(companyName))   // 客户名称重复，返回错误信息
            {
                context.Response.Write("repeat");
                return;
            }
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

        /// <summary>
        /// 获取联系人列表
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        public void GetCompanyContact(HttpContext context, string account_id)
        {
            try
            {
                var contactList = new ContactBLL().GetContactByCompany(Convert.ToInt64(account_id));
                if (contactList != null && contactList.Count > 0)
                {
                    StringBuilder contacts = new StringBuilder("<option value='0'>     </option>");
                    foreach (var contact in contactList)
                    {
                        contacts.Append("<option value="+contact.id+"'>"+contact.name+"</option>");
                    }
                    context.Response.Write(contacts);
                }
            }
            catch (Exception)
            {

                context.Response.End();
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