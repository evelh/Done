﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class Notes : BasePage
    {
        protected com_activity note = null;
        protected List<crm_contact> contactList = null;             // 可选联系人列表
        protected List<crm_opportunity> opportunityList = null;     // 可选商机列表
        protected List<d_general> actionTypeList;                   // 活动类型列表
        protected List<DictionaryEntryDto> resourceList;            // 负责人列表

        protected long accountId = 0;       // 初始客户id
        protected long contactId = 0;       // 初始联系人id
        protected long opportunityId = 0;   // 初始商机id
        protected long saleOrderId = 0;     // 初始销售订单id
        protected int objType = 0;          // 对象类型
        protected long objId = 0;           // 对象id
        protected sys_bookmark thisBookMark;

        private ActivityBLL bll = new ActivityBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            thisBookMark = new IndexBLL().GetSingBook(Request.RawUrl, LoginUserId);
            actionTypeList = bll.GetCRMActionType();
            resourceList = new UserResourceBLL().GetResourceList();

            if (!IsPostBack)
            {
                long noteid;
                if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out noteid))
                {
                    if (AuthBLL.GetUserNoteAuth(LoginUserId, LoginUser.security_Level_id, noteid).CanEdit == false)
                    {
                        Response.Write("<script>alert('您不能编辑此备注');</script>");
                        Response.End();
                        return;
                    }

                    note = bll.GetActivity(noteid);
                    contactList = new ContactBLL().GetContactByCompany((long)note.account_id);
                    opportunityList = new OpportunityBLL().GetOpportunityByCompany((long)note.account_id);
                    var accountName = "";
                    if (note.account_id != null)
                    {
                        var account = new CompanyBLL().GetCompany((long)note.account_id);
                        accountName = account == null ? "" : account.name;
                    }
                    var history = new sys_windows_history()
                    {
                        title = "备注:" + note.description + ":"+ accountName,
                        url = Request.RawUrl,
                    };
                    new IndexBLL().BrowseHistory(history, LoginUserId);
                }

                if (long.TryParse(Request.QueryString["accountId"], out accountId))
                {
                    objType = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
                    objId = accountId;
                }
                if (long.TryParse(Request.QueryString["contactId"], out contactId))
                {
                    accountId = new ContactBLL().GetContact(contactId).account_id;
                    objType = (int)DicEnum.OBJECT_TYPE.CONTACT;
                    objId = contactId;
                }
                if (long.TryParse(Request.QueryString["opportunityId"], out opportunityId))
                {
                    objType = (int)DicEnum.OBJECT_TYPE.OPPORTUNITY;
                    objId = opportunityId;
                    var opp = new OpportunityBLL().GetOpportunity(opportunityId).general;
                    accountId = opp.account_id;
                    if (opp.contact_id != null)
                        contactId = (long)opp.contact_id;
                }
                if (long.TryParse(Request.QueryString["saleorderId"], out saleOrderId))
                {
                    objType = (int)DicEnum.OBJECT_TYPE.SALEORDER;
                    objId = saleOrderId;
                    var saleOrder = new SaleOrderBLL().GetSaleOrder(saleOrderId);
                    var opp = new OpportunityBLL().GetOpportunity(saleOrder.opportunity_id).general;
                    opportunityId = opp.id;
                    accountId = opp.account_id;
                    if (opp.contact_id != null)
                        contactId = (long)opp.contact_id;
                }
            }
            else
            {
                com_activity activity = AssembleModel<com_activity>();
                if (activity.contact_id == 0)
                    activity.contact_id = null;
                activity.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["start_date2"]));
                activity.end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["end_date2"]));

                com_activity todo = null;
                if (!string.IsNullOrEmpty(Request.Form["action_type_id1"]))
                {
                    todo = new com_activity();
                    todo.action_type_id = int.Parse(Request.Form["action_type_id1"]);
                    todo.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["start_date1"]));
                    todo.end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["end_date1"]));
                    todo.description = Request.Form["description1"];
                    if (!string.IsNullOrEmpty(Request.Form["resource_id1"]))
                        todo.resource_id = long.Parse(Request.Form["resource_id1"]);
                }

                if (string.IsNullOrEmpty(Request.Form["id"]))
                    bll.AddCRMNote(activity, todo, GetLoginUserId());
                else
                    bll.EditCRMNote(activity, todo, GetLoginUserId());

                if (Request.Form["action"] != null && Request.Form["action"].Equals("SaveNew"))
                    Response.Write("<script>alert('保存备注成功');window.location.href='Notes.aspx';self.opener.location.reload();</script>");
                else
                    Response.Write("<script>alert('保存备注成功');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}