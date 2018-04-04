﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class RegularTimeAddEdit : BasePage
    {
        protected bool isAdd = true;
        protected bool showResource = false;
        protected long resourceId;
        protected DateTime startDate;
        protected List<sdk_work_entry> workEntryList;
        private WorkEntryBLL bll = new WorkEntryBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long batchId;
            if (long.TryParse(Request.QueryString["id"], out batchId))
                isAdd = false;
            if (!string.IsNullOrEmpty(Request.QueryString["resourceId"]))
                resourceId = long.Parse(Request.QueryString["resourceId"]);
            else
                resourceId = LoginUserId;

            var entryProxySet = new SysSettingBLL().GetValueById(SysSettingEnum.SDK_ENTRY_PROXY);
            if (entryProxySet == ((int)DicEnum.PROXY_TIME_ENTRY.ENABLED_TIMESHEET_APPROVERS).ToString())
                showResource = true;

            if (string.IsNullOrEmpty(Request.QueryString["startDate"]))
                startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            else
                startDate = DateTime.Parse(Request.QueryString["startDate"]);
            if (startDate.DayOfWeek != DayOfWeek.Monday)
            {
                if (startDate.DayOfWeek == DayOfWeek.Sunday)
                    startDate = startDate.AddDays(-6);
                else
                    startDate = startDate.AddDays((int)startDate.DayOfWeek - (int)DayOfWeek.Monday);
            }

            var costCodeList = bll.GetTimeCostCodeList();
            if (!IsPostBack)
            {
                if (isAdd)
                {
                    costCodeName.Visible = false;
                    cost_code_id.DataValueField = "id";
                    cost_code_id.DataTextField = "name";
                    cost_code_id.DataSource = costCodeList;
                    cost_code_id.DataBind();

                }
                else
                {
                    cost_code_id.Visible = false;

                }
                if (showResource)
                {
                    var resList = new UserResourceBLL().GetResourceList();
                    resource_id.DataValueField = "val";
                    resource_id.DataTextField = "show";
                    resource_id.DataSource = resList;
                    resource_id.DataBind();
                    if (resList.Exists(_ => _.val == LoginUserId.ToString()))
                        resource_id.SelectedValue = LoginUserId.ToString();
                }
                notify_tmpl_id.DataTextField = "name";
                notify_tmpl_id.DataValueField = "id";
                notify_tmpl_id.DataSource = new DAL.sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TICKET_TIME_ENTRY_CREATED_EDITED);
                notify_tmpl_id.DataBind();
            }
            else
            {
                List<string> weNames = new List<string> { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" };
                if (isAdd && showResource)
                    resourceId = long.Parse(resource_id.SelectedValue);

                var weList = new List<sdk_work_entry>();
                for (int i = 0; i < weNames.Count; i++)
                {
                    decimal hours_worked;
                    if (!decimal.TryParse(Request.Form[weNames[i]], out hours_worked))
                        continue;
                    sdk_work_entry we = new sdk_work_entry();
                    if (isAdd)
                    {
                        long taskId = long.Parse(cost_code_id.SelectedValue);
                        we.task_id = taskId;
                        we.cost_code_id = taskId;
                    }
                    else
                        we.batch_id = batchId;
                    we.resource_id = resourceId;
                    we.hours_worked = hours_worked;
                    we.hours_billed = hours_worked;
                    we.offset_hours = 0;
                    we.internal_notes = Request.Form[weNames[i] + "Inter"];
                    we.summary_notes = Request.Form[weNames[i] + "Nodes"];
                    we.is_billable = 0;
                    we.show_on_invoice = 0;
                    weList.Add(we);
                }

                if (isAdd)
                    bll.AddWorkEntry(weList, LoginUserId);
                else if (!bll.EditWorkEntry(weList, batchId, LoginUserId))
                {
                    Response.Write("<script>alert('工时审批提交后不能编辑');</script>");
                    return;
                }

                if (Request.Form["subAct"] == "SaveNew")
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    Response.End();
                }
                else
                {
                    Response.Write("<script>window.location.href='RegularTimeAddEdit';self.opener.location.reload();</script>");
                    Response.End();
                }
            }
        }
    }
}