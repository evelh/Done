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
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// CompanyAjax 的摘要说明
    /// </summary>
    public class CompanyAjax : BaseAjax
    {
        private crm_account_dal _dal = new crm_account_dal();
        public override void AjaxProcess(HttpContext context)
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
                case "OpportunityList":
                    account_id = context.Request.QueryString["account_id"];
                    GetOpportunityList(context, account_id);
                    break;
                case "property":
                    var property_account_id = context.Request.QueryString["account_id"];
                    var propertyName = context.Request.QueryString["property"];
                    GetCompanyProperty(context, property_account_id, propertyName);
                    break;
                case "propertyJson":
                    property_account_id = context.Request.QueryString["account_id"];
                    propertyName = context.Request.QueryString["property"];
                    GetCompanyPropertyJson(context, property_account_id, propertyName);
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
                case "AccReference":
                    var ref_account_id = context.Request.QueryString["account_id"];
                    GetAccountReference(context,long.Parse(ref_account_id));
                    break;
                case "project":
                    var pro_account_id = context.Request.QueryString["account_id"];
                    GetAccountProject(context,long.Parse(pro_account_id));
                    break;
                case "GetAccByRes":
                    GetAccByRes(context,long.Parse(context.Request.QueryString["resource_id"]),context.Request.QueryString["showType"],!string.IsNullOrEmpty(context.Request.QueryString["isShowCom"]));
                    break;
                case "GetAccAlert":
                    GetAccAlert(context);
                    break;
                case "GetAccDetail":
                    GetAccDetail(context);
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
        /// 得到客户下的所有商机
        /// </summary>
        /// <param name="context"></param>
        /// <param name="account_id"></param>
        private void GetOpportunityList(HttpContext context, string account_id)
        {
            try
            {
                StringBuilder opportunitys = new StringBuilder();
                opportunitys.Append("<option value=''></option>");
                var opportinotyList = new crm_opportunity_dal().FindByAccountId(Convert.ToInt64(account_id));
                if (opportinotyList != null)
                {
                    foreach (var opportunity in opportinotyList)
                    {
                        opportunitys.Append("<option value='" + opportunity.id + "'>" + opportunity.name + "</option>");
                    }
                }
                context.Response.Write(opportunitys);
            }
            catch (Exception)
            {
                context.Response.Write("");
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
        private void GetCompanyPropertyJson(HttpContext context, string account_id, string propertyName)
        {
            var account = new CompanyBLL().GetCompany(long.Parse(account_id));
            if (account != null)
            {
                context.Response.Write(new Serialize().SerializeJson(BaseDAL<Core.crm_account>.GetObjectPropertyValue(account, propertyName)));
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

        /// <summary>
        /// 获取到客户的发票模板设置信息
        /// </summary>
        private void GetAccountReference(HttpContext context,long account_id)
        {
            var accRef = new crm_account_reference_dal().GetAccountInvoiceRef(account_id);
            if (accRef != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(accRef));
            }
        }
        /// <summary>
        ///  获取到该客户的项目提案信息
        /// </summary>
        private void GetAccountProject(HttpContext context, long account_id)
        {
            var proList = new pro_project_dal().GetProjectListByAcc(account_id);
            if (proList != null && proList.Count > 0)
            {
                // 筛选项目提案
                proList = proList.Where(_ => _.type_id == (int)DicEnum.PROJECT_TYPE.PROJECT_DAY).ToList();
                StringBuilder proText = new StringBuilder();
                proText.Append("<option value='0'>请选择一个项目提案</option>");
                foreach (var pro in proList)
                {
                    proText.Append($"<option value='{pro.id}'>{pro.name}</option>");
                }
                context.Response.Write(proText.ToString());
            }
        }
        /// <summary>
        /// 根据员工和相关条件获取相对应的客户
        /// </summary>
        private void GetAccByRes(HttpContext context,long rId,string showType,bool isShowComp)
        {
            var list = new crm_account_dal().GetAccByRes(rId,showType,isShowComp);
            if (list != null && list.Count > 0)
            {
                // var accDic = list.GroupBy(_ => _.id).ToDictionary(_ => _.Key, _ => _.FirstOrDefault(f=>!string.IsNullOrEmpty(f.name)).name);
                context.Response.Write(new Tools.Serialize().SerializeJson(list));
            }
          
        }
        /// <summary>
        /// 返回客户的提醒信息
        /// </summary>
        private void GetAccAlert(HttpContext context)
        {
            var accountId = context.Request.QueryString["account_id"];
            if (!string.IsNullOrEmpty(accountId))
            {
                var alertList = new crm_account_alert_dal().FindByAccount(long.Parse(accountId)); 
                if(alertList!=null&& alertList.Count > 0)
                {
                    var accAlert = alertList.FirstOrDefault(_ => _.alert_type_id == (int)DTO.DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);
                    var ticketAlert = alertList.FirstOrDefault(_ => _.alert_type_id == (int)DTO.DicEnum.ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT);
                    var ticketDetail = alertList.FirstOrDefault(_ => _.alert_type_id == (int)DTO.DicEnum.ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT);
                    if(accAlert!=null|| ticketAlert!=null|| ticketDetail != null)
                    {
                        context.Response.Write(new Tools.Serialize().SerializeJson(new {
                            hasAccAlert = accAlert!=null,
                            accAlert = accAlert==null?"":accAlert.alert_text,
                            hasTicketAlert = ticketAlert!=null,
                            ticketAlert = ticketAlert == null ? "" : ticketAlert.alert_text,
                            hasTicketDetail = ticketDetail!=null,
                            ticketDetail = ticketDetail == null ? "" : ticketDetail.alert_text,
                        }));
                    }
                }
            }
        }
        /// <summary>
        /// 获取客户详情
        /// </summary>
        private void GetAccDetail(HttpContext context)
        {
            var accountId = context.Request.QueryString["account_id"];
            if (!string.IsNullOrEmpty(accountId))
            {
                var thisAcc = new CompanyBLL().GetCompany(long.Parse(accountId));
                if (thisAcc != null)
                {
                    // 返回客户Id，名称，地址信息
                    var location = new LocationBLL().GetLocationByAccountId(thisAcc.id);
                    string city ="";
                    string provice = "";
                    string quXian = "";
                    string address1 = "";
                    string address2 = "";
                    int ticketNum = 0;  // 所有打开的工单的数量
                    int monthNum = 0;  // 近三十天工单的数量
                    if (location != null)
                    {
                        var thisCity = new d_district_dal().FindById(location.city_id);
                        if (thisCity != null)
                        {
                            city = thisCity.name;
                        }
                        var thisprovice = new d_district_dal().FindById(location.province_id);
                        if (thisprovice != null)
                        {
                            provice = thisprovice.name;
                        }
                        if (location.district_id != null)
                        {
                            var thisquXian = new d_district_dal().FindById((long)location.district_id);
                            if (thisquXian != null)
                            {
                                quXian = thisquXian.name;
                            }
                        }
                        address1 = location.address;
                        address2 = location.additional_address;


                    }

                    var ticketList = new sdk_task_dal().GetTicketByAccount(thisAcc.id);
                    if(ticketList!=null&& ticketList.Count > 0)
                    {
                        ticketNum = ticketList.Count;
                    }
                    context.Response.Write(new Tools.Serialize().SerializeJson(new {id=thisAcc.id,name=thisAcc.name,phone = thisAcc.phone, city= city, provice = provice, quXian = quXian, address1 = address1, address2 = address2, ticketNum = ticketNum, monthNum = monthNum, }));
                }
            }
        }
    }
}