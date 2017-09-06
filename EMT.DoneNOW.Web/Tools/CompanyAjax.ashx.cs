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
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// CompanyAjax 的摘要说明
    /// </summary>
    public class CompanyAjax : IHttpHandler
    {
        private crm_account_dal _dal = new crm_account_dal();
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
                    var isUserParentContact = context.Request.QueryString["userParentContact"];//userParentContact
                    GetCompanyContact(context, account_id, isUserParentContact);
                    break;
                case "contactList":    // 通过客户id去获取联系人列表
                    account_id = context.Request.QueryString["account_id"];
                    GetCompanyContactList(context, account_id);
                    break;
                case "companyPhone":
                    var id = context.Request.QueryString["account_id"];
                    GetCompanyPhone(context, id);
                    break;
                case "opportunity":
                    var opportunity_account_id = context.Request.QueryString["account_id"];
                    GetOpportunity(context, opportunity_account_id);
                    break;
                case "property":
                    var property_account_id = context.Request.QueryString["account_id"];
                    var propertyName = context.Request.QueryString["property"];
                    GetCompanyProperty(context, property_account_id, propertyName);
                    break;
                case "Location":
                    var location_account_id = context.Request.QueryString["account_id"];
                    GetCompanyDefaultLocation(context, location_account_id);
                    break;
                case "names":
                    var ids = context.Request.QueryString["ids"];
                    GetCompanyNamesByIds(context, ids);
                    break;
                case "vendorList":
                    var product_id = context.Request.QueryString["product_id"];
                    GetVendorsByProductId(context,long.Parse(product_id));
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
        private void companyNameCheck(HttpContext context, string companyName)
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
            if (compareAccountName != null && compareAccountName.Count > 0)
            {

                compareAccountName.ForEach(_ => { similar += _.id.ToString() + ","; });
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
        private void GetCompanyContact(HttpContext context, string account_id,string parentContact="")
        {
            try
            {
                StringBuilder contacts = new StringBuilder("<option value='0'>     </option>");
                var contactList = new ContactBLL().GetContactByCompany(Convert.ToInt64(account_id));
                if (contactList != null && contactList.Count > 0)
                {
                    foreach (var contact in contactList)
                    {
                        contacts.Append("<option value='" + contact.id + "'>" + contact.name + "</option>");
                    }
                }
                if ( !string.IsNullOrEmpty(parentContact))
                {
                    var account = new CompanyBLL().GetCompany(Convert.ToInt64(account_id));
                    if (account.parent_id != null)
                    {
                        var parentContactList = new ContactBLL().GetContactByCompany((long)account.parent_id);
                        if (parentContactList != null && parentContactList.Count > 0)
                        {
                            contacts.Append("<option value='0'> ------- </option>");
                            foreach (var contact in parentContactList)
                            {
                                contacts.Append("<option value='" + contact.id + "'>" + contact.name + "</option>");
                            }
                        }
                    }
                }
             
                context.Response.Write(contacts);
                return;
            }
            catch (Exception)
            {
                context.Response.End();
            }
        }

        /// <summary>
        /// 获取联系人列表
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        private void GetCompanyContactList(HttpContext context, string account_id)
        {
            try
            {
                StringBuilder contacts = new StringBuilder("<option value=''>     </option>");
                var contactList = new ContactBLL().GetContactByCompany(Convert.ToInt64(account_id));
                if (contactList != null && contactList.Count > 0)
                {
                    foreach (var contact in contactList)
                    {
                        contacts.Append("<option value='" + contact.id + "'>" + contact.name + "</option>");
                    }
                }

                context.Response.Write(new Tools.Serialize().SerializeJson(contacts));
                return;
            }
            catch (Exception)
            {
                context.Response.End();
            }
        }

        /// <summary>
        /// 根据客户id获取客户phone
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        private void GetCompanyPhone(HttpContext context, string account_id)
        {
            var company = new CompanyBLL().GetCompany(long.Parse(account_id));
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(company.phone));
            context.Response.End();
        }

        /// <summary>
        /// 得到该用户下的所有商机
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        private void GetOpportunity(HttpContext context, string account_id)
        {
            try
            {
               
                StringBuilder opportunitys = new StringBuilder();


                var NoQuoteOpportinotyList = new crm_opportunity_dal().GetNoQuoteOppo(Convert.ToInt64(account_id));
                if (NoQuoteOpportinotyList != null && NoQuoteOpportinotyList.Count > 0)
                {
                    opportunitys.Append("<option value='0'>---无报价商机---</option>");
                    foreach (var opportunity in NoQuoteOpportinotyList)
                    {
                        opportunitys.Append("<option value='" + opportunity.id + "'>" + opportunity.name + "</option>");
                    }
                }

                var HasQuoteOpportinotyList = new crm_opportunity_dal().GetHasQuoteOppo(Convert.ToInt64(account_id));
                if (HasQuoteOpportinotyList != null && HasQuoteOpportinotyList.Count > 0)
                {
                    opportunitys.Append("<option value='0'>---有报价商机---</option>");
                    foreach (var opportunity in HasQuoteOpportinotyList)
                    {
                        opportunitys.Append("<option value='" + opportunity.id + "'>" + opportunity.name + "</option>");

                    }
                }
                          
                context.Response.Write(opportunitys);
               
            }
            catch (Exception)
            {

                context.Response.End();
            }
        }

        /// <summary>
        /// 获取到客户下的某个属性的值   
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        /// <param name="propertyName"></param>
        private void GetCompanyProperty(HttpContext context, string account_id, string propertyName)
        {
            var account = new CompanyBLL().GetCompany(long.Parse(account_id));
            if (account != null)
            {
                context.Response.Write(BaseDAL<Core.crm_account>.GetObjectPropertyValue(account, propertyName));
            }
        }

        private void GetCompanyDefaultLocation(HttpContext context, string account_id)
        {
            var location = new LocationBLL().GetLocationByAccountId(long.Parse(account_id));
            if (location != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(location));
            }
        }

        /// <summary>
        /// 根据客户id返回客户名称列表
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        private void GetCompanyNamesByIds(HttpContext context, string ids)
        {
            var names = new CompanyBLL().GetCompanyNames(ids);
            context.Response.Write(new Tools.Serialize().SerializeJson(names));
        }


        private void GetVendorsByProductId(HttpContext context, long product_id)
        {
            var vendorList = new crm_account_dal().FindListBySql<crm_account>($"SELECT * from crm_account where id in(  select vendor_account_id from ivt_product_vendor where  product_id = {product_id} )");

            if (vendorList != null && vendorList.Count > 0)
            {
                StringBuilder vendors = new StringBuilder();
                foreach (var vendor in vendorList)
                {
                    vendors.Append("<option value='" + vendor.id + "'>" + vendor.name + "</option>");
                }
                context.Response.Write(vendors);
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