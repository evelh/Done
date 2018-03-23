using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

using System.Web.SessionState;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ContactAjax 的摘要说明
    /// </summary>
    public class ContactAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var contact_id = context.Request.QueryString["id"];
                        DeleteContact(context, Convert.ToInt64(contact_id));
                        break;
                    case "GetConList":
                        var conIds = context.Request.QueryString["ids"];
                        GetConList(context, conIds);
                        break;
                    case "GetConName":
                        var conNameIds = context.Request.QueryString["ids"];
                        GetConName(context, conNameIds);
                        break;
                    case "GetContacts":
                        var aId = context.Request.QueryString["account_id"];
                        GetConAccAndPar(context,long.Parse(aId));
                        break;
                    case "GetParAndAccSelect":
                        var saId = context.Request.QueryString["account_id"];
                        GetParAndAccSelect(context,long.Parse(saId));
                        break;
                    case "GetContactInfo":
                        GetContactInfo(context);
                        break;
                    case "GetContactDetail":
                        GetContactDetail(context);
                        break;
                    case "GetConByAccount":
                        GetConByAccount(context);
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

        /// <summary>
        /// 删除联系人的事件
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contact_id"></param>
        public void DeleteContact(HttpContext context, long contact_id)
        {
            if (AuthBLL.GetUserContactAuth(LoginUserId, LoginUser.security_Level_id, contact_id).CanDelete == false)
            {
                return;
            }

            var result = new ContactBLL().DeleteContact(contact_id, LoginUserId);

            if (result)
            {
                context.Response.Write("删除联系人成功！");
            }
            else
            {
                context.Response.Write("删除联系人失败！");
            }
        }
        private void GetConList(HttpContext context, string ids)
        {
            StringBuilder con = new StringBuilder();
            if (!string.IsNullOrEmpty(ids))
            {
                var conList = new crm_contact_dal().GetContactByIds(ids);
                if (conList != null && conList.Count > 0)
                {
                    conList.ForEach(_ => con.Append($"<option value='{_.id}'>{_.name}</option>"));
                }
            }
            context.Response.Write(con.ToString());
        }

        private void GetConName(HttpContext context, string ids)
        {
            StringBuilder con = new StringBuilder();
            if (!string.IsNullOrEmpty(ids))
            {
                var conList = new crm_contact_dal().GetContactByIds(ids);
                if (conList != null && conList.Count > 0)
                {
                    conList.ForEach(_ => con.Append($";{_.name}"));
                }
            }
            context.Response.Write(con.ToString());
        }
        /// <summary>
        /// 获取到客户和父客户的联系人
        /// </summary>
        private void GetConAccAndPar(HttpContext context,long account_id)
        {
            StringBuilder conHtml = new StringBuilder();
            
            var account = new crm_account_dal().FindNoDeleteById(account_id);
            if (account != null)
            {
                var conList = new crm_contact_dal().GetContactByAccountId(account.id);
                if (conList != null && conList.Count > 0)
                {
                    foreach (var con in conList)
                    {
                        conHtml.Append("<tr><td><input type='checkbox' value='" + con.id + "' class='checkCon' /></td><td>" + con.name + "</td><td><a href='mailto:" + con.email + "'>" + con.email + "</a></td></tr>");
                    }
                }
                if (account.parent_id != null)
                {
                    var parConList = new crm_contact_dal().GetContactByAccountId((long)account.parent_id);
                    if(parConList!=null&& parConList.Count > 0)
                    {
                        conHtml.Append("<tr><td colspan='3'>父客户联系人</td></tr>");
                        foreach (var con in conList)
                        {
                            conHtml.Append("<tr><td><input type='checkbox' value='" + con.id + "' class='checkCon' /></td><td>" + con.name + "</td><td><a href='mailto:" + con.email + "'>" + con.email + "</a></td></tr>");
                        }
                    }
                }
            }
            context.Response.Write(conHtml.ToString());
        }
        /// <summary>
        /// 获取到下拉框中客户和父客户的联系人
        /// </summary>
        private void GetParAndAccSelect(HttpContext context, long account_id)
        {
            StringBuilder conHtml = new StringBuilder();

            var account = new crm_account_dal().FindNoDeleteById(account_id);
            if (account != null)
            {
                var conList = new crm_contact_dal().GetContactByAccountId(account.id);
                if (conList != null && conList.Count > 0)
                {
                    foreach (var con in conList)
                    {
                        conHtml.Append($"<option value='{con.id}'>{con.name}</option>");
                    }
                }
                if (account.parent_id != null)
                {
                    var parConList = new crm_contact_dal().GetContactByAccountId((long)account.parent_id);
                    if (parConList != null && parConList.Count > 0)
                    {
                        conHtml.Append("<option value=''>-----</option>");
                        foreach (var con in conList)
                        {
                            conHtml.Append($"<option value='{con.id}'>{con.name}</option>");
                        }
                    }
                }
            }
            context.Response.Write(conHtml.ToString());
        }

        private void GetContactInfo(HttpContext context)
        {
            var contatc_id = context.Request.QueryString["contact_id"];
            if (!string.IsNullOrEmpty(contatc_id))
            {
                var thisContact = new crm_contact_dal().FindNoDeleteById(long.Parse(contatc_id));
                if (thisContact != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(thisContact));
                }
            }
        }
        /// <summary>
        /// 获取联系人的详情信息
        /// </summary>
        private void GetContactDetail(HttpContext context)
        {
            var contatc_id = context.Request.QueryString["contact_id"];
            if (!string.IsNullOrEmpty(contatc_id))
            {
                var thisContact = new crm_contact_dal().FindNoDeleteById(long.Parse(contatc_id));
                if (thisContact != null)
                {
                    int ticketNum = 0;  // 所有打开的工单的数量
                    int monthNum = 0;  // 近三十天工单的数量
                    var ticketList = new sdk_task_dal().GetTicketByContact(thisContact.id);
                    if (ticketList != null && ticketList.Count > 0)
                    {
                        ticketNum = ticketList.Count;
                    }
                    context.Response.Write(new Tools.Serialize().SerializeJson(new { id = thisContact.id, name = thisContact.name, phone = thisContact.phone,  ticketNum = ticketNum, monthNum = monthNum, }));
                }
            }
        }
        /// <summary>
        /// 获取客户下的联系人列表
        /// </summary>
        private void GetConByAccount(HttpContext context)
        {
            var accountId = context.Request.QueryString["account_id"];
            if (!string.IsNullOrEmpty(accountId))
            {
                var conList = new DAL.crm_contact_dal().GetContactByAccountId(long.Parse(accountId));
                if(conList!=null&& conList.Count>0)
                    context.Response.Write(new Tools.Serialize().SerializeJson(conList));
            }
        }
    }
}