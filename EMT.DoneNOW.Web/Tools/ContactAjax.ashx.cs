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
                    case "AccountContractGroupManage":
                        AccountContractGroupManage(context);
                        break;
                    case "CheckGroupName":
                        CheckGroupName(context);
                        break;
                    case "GroupManage":
                        GroupManage(context);
                        break;
                    case "SaveActionTemp":
                        SaveActionTemp(context);
                        break;
                    case "CheckTempName":
                        CheckTempName(context);
                        break;
                    case "GetTempInfo":
                        GetTempInfo(context);
                        break;
                    case "RemoveContactFromGroup":
                        RemoveContactFromGroup(context);
                        break;
                    case "AddContactsToGroup":
                        AddContactsToGroup(context);
                        break;
                    case "GetContactGroup":
                        GetContactGroup(context);
                        break;
                    case "DeleteContactGroup":
                        DeleteContactGroup(context);
                        break;
                    case "ActiveContactGroup":
                        ActiveContactGroup(context);
                        break;
                    case "SaveActionTempShort":
                        SaveActionTempShort(context);
                        break;
                    case "DeleteContactActionTemp":
                        DeleteContactActionTemp(context);
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
        /// <summary>
        /// 客户的联系人组管理
        /// </summary>
        private void AccountContractGroupManage(HttpContext context)
        {
            var accountId = context.Request.QueryString["accountId"];
            var groupId = context.Request.QueryString["groupId"];
            var ids = context.Request.QueryString["ids"];
            var result = false;
            if (!string.IsNullOrEmpty(accountId) && !string.IsNullOrEmpty(groupId))
                result = new ContactBLL().AccountContractGroupManage(long.Parse(accountId),long.Parse(groupId),ids,LoginUserId) ;
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 将联系人添加到组
        /// </summary>
        private void AddContactsToGroup(HttpContext context)
        {
            var groupId = context.Request.QueryString["groupId"];
            var ids = context.Request.QueryString["ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ids) && !string.IsNullOrEmpty(groupId))
                result = new ContactBLL().AddContactsToGroup(long.Parse(groupId), ids, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        /// 校验联系人群组名称
        /// </summary>
        private void CheckGroupName(HttpContext context)
        {
            var name = context.Request.QueryString["name"];
            var result = false;
            long? id = null;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                id = long.Parse(context.Request.QueryString["id"]);
            if (!string.IsNullOrEmpty(name))
                result = new ContactBLL().CheckGroupName(name, id);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 联系人群组管理（新增，编辑）
        /// </summary>
        private void GroupManage(HttpContext context)
        {
            var name = context.Request.QueryString["name"];
            var result = false;
            long? id = null;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                id = long.Parse(context.Request.QueryString["id"]);
            var isActive = Convert.ToSByte(context.Request.QueryString["isActive"]);
            if (!string.IsNullOrEmpty(name))
                result = new ContactBLL().ContactGroupManage(id,name, isActive,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 保存模板信息
        /// </summary>
        private void SaveActionTemp(HttpContext context)
        {
            crm_contact_action_tmpl actionTemp = null;
            var sendEmail = (sbyte)(context.Request.QueryString["sendEmail"] == "1"?1:0);
            var tempId = context.Request.QueryString["tempId"];
            var noteActionTypeId = context.Request.QueryString["noteActionTypeId"];
            var noteDescription = context.Request.QueryString["noteDescription"];

            var todoActionTypeId = context.Request.QueryString["todoActionTypeId"];
            var todoDescription = context.Request.QueryString["todoDescription"];
            var todoResourceId = context.Request.QueryString["todoResourceId"];
            var todoStartDate = context.Request.QueryString["todoStartDate"];
            var todoEndDate = context.Request.QueryString["todoEndDate"];

            var description = context.Request.QueryString["description"];

            if (!string.IsNullOrEmpty(tempId))
                actionTemp = new ContactBLL().GetTempById(long.Parse(tempId));
            if (actionTemp == null)
            {
                actionTemp = new crm_contact_action_tmpl();
                actionTemp.name = context.Request.QueryString["name"];
            }
            actionTemp.send_email = sendEmail;
            if (!string.IsNullOrEmpty(noteActionTypeId))
            {
                actionTemp.note_action_type_id = int.Parse(noteActionTypeId);
                actionTemp.note_description = noteDescription;
            }
            else
            {
                actionTemp.note_action_type_id = null;
                actionTemp.note_description = string.Empty;
            }
            if (!string.IsNullOrEmpty(todoActionTypeId)&& !string.IsNullOrEmpty(todoStartDate) && !string.IsNullOrEmpty(todoEndDate))
            {
                actionTemp.todo_action_type_id = int.Parse(todoActionTypeId);
                actionTemp.todo_description = todoDescription;
                actionTemp.todo_resource_id = long.Parse(todoResourceId);
                actionTemp.todo_start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(todoStartDate));
                actionTemp.todo_end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(todoEndDate));
            }
            else
            {
                actionTemp.todo_action_type_id = null;
                actionTemp.todo_description = string.Empty;
                actionTemp.todo_resource_id = null;
                actionTemp.todo_start_date = null;
                actionTemp.todo_end_date = null;
            }
            actionTemp.description = description;
            long thisTempId = 0;
            var result = new ContactBLL().SaveActionTemp(actionTemp,LoginUserId,ref thisTempId);
            context.Response.Write(new Tools.Serialize().SerializeJson(new {result= result,id= thisTempId }));
        }
        /// <summary>
        /// 保存联系人模板-只更新名称描述信息，功能同上
        /// </summary>
        private void SaveActionTempShort(HttpContext context)
        {
            crm_contact_action_tmpl actionTemp = null;
            var tempId = context.Request.QueryString["tempId"];
            if (!string.IsNullOrEmpty(tempId))
                actionTemp = new ContactBLL().GetTempById(long.Parse(tempId));
            if (actionTemp == null)
                actionTemp = new crm_contact_action_tmpl();
            actionTemp.name = context.Request.QueryString["name"];
            actionTemp.description = context.Request.QueryString["description"];
            long thisTempId = 0;
            var result = new ContactBLL().SaveActionTemp(actionTemp, LoginUserId, ref thisTempId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        /// 模板名称校验
        /// </summary>
        private void CheckTempName(HttpContext context)
        {
            var result = false;
            var name = context.Request.QueryString["name"];
            if (!string.IsNullOrEmpty(name))
            {
                long id=0;
                if (!string.IsNullOrEmpty(context.Request.QueryString["tempId"]))
                    id = long.Parse(context.Request.QueryString["tempId"]);
                result = new ContactBLL().CheckActionTempName(name,id);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取模板信息
        /// </summary>
        private void GetTempInfo(HttpContext context)
        {
            if (!string.IsNullOrEmpty(context.Request.QueryString["tempId"]))
            {
                var temp = new ContactBLL().GetTempById(long.Parse(context.Request.QueryString["tempId"]));
                if (temp != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(temp));
                }
            }
        }
        /// <summary>
        /// 从联系人组中移除联系人
        /// </summary>
        private void RemoveContactFromGroup(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var groupId = context.Request.QueryString["groupId"];
            var result = false;
            if (!string.IsNullOrEmpty(groupId) && !string.IsNullOrEmpty(ids))
                result = new ContactBLL().RemoveContactFromGroup(long.Parse(groupId), ids,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取联系人组信息
        /// </summary>
        private void GetContactGroup(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                var thisGroup = new ContactBLL().GetGroupById(long.Parse(id));
                if(thisGroup!=null)
                    context.Response.Write(new Tools.Serialize().SerializeJson(thisGroup));
            }
        }

        /// <summary>
        /// 删除联系人组
        /// </summary>
        private void DeleteContactGroup(HttpContext context)
        {
            var groupId = context.Request.QueryString["groupId"];
            var result = false;
            if (!string.IsNullOrEmpty(groupId))
                result = new ContactBLL().DeleteContactGroup(long.Parse(groupId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        ///  激活/失活 联系人组
        /// </summary>
        /// <param name="context"></param>
        private void ActiveContactGroup(HttpContext context)
        {
            var groupId = context.Request.QueryString["groupId"];
            var result = false;
            var isActive = true;
            if (!string.IsNullOrEmpty(context.Request.QueryString["inActive"]))
                isActive = false;
            if (!string.IsNullOrEmpty(groupId))
                result = new ContactBLL().ActiveContactGroup(long.Parse(groupId), isActive, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除联系人活动模板
        /// </summary>
        private void DeleteContactActionTemp(HttpContext context)
        {
            var tempId = context.Request.QueryString["tempId"];
            var result = false;
            if (!string.IsNullOrEmpty(tempId))
                result = new ContactBLL().DeleteContactActionTemp(long.Parse(tempId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

    }
}