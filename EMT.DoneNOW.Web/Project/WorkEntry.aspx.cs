using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class WorkEntry : BasePage
    {
        protected bool isAdd = true;
        protected sdk_work_entry thisWorkEntry = null;
        protected sdk_task thisTask = null;
        protected v_task_all v_task = null;
        protected pro_project thisProjetc = null;
        protected ctt_contract thisContract = null;
        protected crm_account thisAccount = null;
        protected sys_resource thisUser = null;
        protected List<sdk_work_entry> entryList = null;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected sdk_service_call thisCall = null;
        protected DateTime showStartDate = DateTime.Now;
        protected DateTime showEndDate = DateTime.Now;
        protected bool noTime = false;      // 可以不输入开始结束时间（根据系统设置进行判断）
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //  是否需要输入开始结束时间
                var isNeedTimeString = Request.QueryString["NoTime"];
                var noTimeSet = new SysSettingBLL().GetSetById(SysSettingEnum.SDK_ENTRY_REQUIRED);
                if (!string.IsNullOrEmpty(isNeedTimeString))
                {
                    if(noTimeSet!=null&& noTimeSet.setting_value == "0")
                    {
                        noTime = true;
                    }
                    
                }
                var callId = Request.QueryString["callId"];
                if (!string.IsNullOrEmpty(callId))
                    thisCall = new sdk_service_call_dal().FindNoDeleteById(long.Parse(callId));
                thisUser = new sys_resource_dal().FindNoDeleteById(GetLoginUserId());
                var resList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<DictionaryEntryDto>;
                if (!IsPostBack)
                {
                    resource_id.DataTextField = "show";
                    resource_id.DataValueField = "val";
                    var entryProxySet = new SysSettingBLL().GetValueById(SysSettingEnum.SDK_ENTRY_PROXY);
                    bool isAgent = false;
                    if(entryProxySet == ((int)DicEnum.PROXY_TIME_ENTRY.DISABLED).ToString())
                    {
                        if(resList!=null&& resList.Count > 0)
                        {
                            resList = resList.Where(_ => _.val == LoginUserId.ToString()).ToList();
                        }
                    }else
                    {
                        var agentResList = new UserResourceBLL().GetAgentUser(LoginUserId, out isAgent);
                        if(agentResList!=null&& agentResList.Count > 0)
                        {
                            resList = (from a in agentResList
                                        select new DictionaryEntryDto() { val=a.id.ToString(),show = a.name}).ToList();
                        }
                        
                    }
                    resource_id.DataSource = resList;
                    resource_id.SelectedValue = LoginUserId.ToString();
                    resource_id.DataBind();

                    var statusList = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value as List<DictionaryEntryDto>;
                     //statusList.Remove(statusList.FirstOrDefault(_=>_.val==((int)DicEnum.TICKET_STATUS.NEW).ToString()));
                    status_id.DataTextField = "show";
                    status_id.DataValueField = "val";
                    status_id.DataSource = statusList;
                    status_id.DataBind();
                    

                    cost_code_id.DataTextField = "name";
                    cost_code_id.DataValueField = "id";
                    cost_code_id.DataSource = new d_cost_code_dal().GetCostCodeByWhere((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
                    cost_code_id.DataBind();

                    notify_id.DataTextField = "name";
                    notify_id.DataValueField = "id";
                    notify_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TICKET_TIME_ENTRY_CREATED_EDITED);
                    notify_id.DataBind();
                }

                var taskId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(taskId));
                }

                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisWorkEntry = new sdk_work_entry_dal().FindNoDeleteById(long.Parse(id));
                    if (thisWorkEntry != null)
                    {
                        if (thisWorkEntry.approve_and_post_date != null || thisWorkEntry.approve_and_post_user_id != null)
                        {
                            Response.Write("<script>alert('审批提交的工时不可以更改！');window.close();</script>");
                            Response.End();
                        }
                        
                        if (!resList.Any(_ => _.val == thisWorkEntry.create_user_id.ToString()))
                        {
                            Response.Write("<script>alert('系统设置不能代理操作！');window.close();</script>");
                            return;
                        }
                        if(thisWorkEntry.end_time==null&& noTimeSet != null && noTimeSet.setting_value == "0")
                        {
                            noTime = true;
                        }
                        entryList = new sdk_work_entry_dal().GetBatchList(thisWorkEntry.batch_id);
                        isAdd = false;
                        thisTask = new sdk_task_dal().FindNoDeleteById(thisWorkEntry.task_id);
                        if (!IsPostBack)
                        {
                            resource_id.ClearSelection();
                            resource_id.SelectedValue = ((long)thisWorkEntry.resource_id).ToString();
                            cost_code_id.SelectedValue = ((long)thisWorkEntry.cost_code_id).ToString();
                            // status_id.SelectedValue = ((long)thisWorkEntry.)
                            // thisTask  = new crm_account_dal().FindNoDeleteById(thisWorkEntry.);
                           
                        }
                       
                        if (thisWorkEntry.contract_id != null)
                        {
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisWorkEntry.contract_id);
                        }
                        if (!IsPostBack)
                        {
                            isBilled.Checked = thisWorkEntry.is_billable == 0;
                            ShowOnInv.Checked = thisWorkEntry.show_on_invoice == 1;
                            if (isBilled.Checked)
                            {
                                ShowOnInv.Enabled = true;
                            }
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('工时已被删除！')window.close();</script>");
                        Response.End();
                    }
                }
                #region 根据批次获取相关工时
                //var batchId = Request.QueryString["batchId"];
                //if (!string.IsNullOrEmpty(batchId))
                //{
                //    entryList = new sdk_work_entry_dal().GetBatchList(long.Parse(batchId));
                //    if(entryList!=null&& entryList.Count > 0)
                //    {
                //        thisWorkEntry = entryList[0];
                //        if (thisWorkEntry.approve_and_post_date != null || thisWorkEntry.approve_and_post_user_id != null)
                //        {
                //            Response.Write("<script>alert('审批提交的工时不可以更改！');window.close();</script>");
                //            Response.End();
                //        }

                //        if (!resList.Any(_ => _.val == thisWorkEntry.create_user_id.ToString()))
                //        {
                //            Response.Write("<script>alert('系统设置不能代理操作！')window.close();</script>");
                //            Response.End();
                //        }
                //        if (thisWorkEntry.end_time == null && noTimeSet != null && noTimeSet.setting_value == "0")
                //        {
                //            noTime = true;
                //        }
                //        entryList = new sdk_work_entry_dal().GetBatchList(thisWorkEntry.batch_id);
                //        isAdd = false;
                //        thisTask = new sdk_task_dal().FindNoDeleteById(thisWorkEntry.task_id);
                //        if (!IsPostBack)
                //        {
                //            resource_id.SelectedValue = ((long)thisWorkEntry.resource_id).ToString();
                //            cost_code_id.SelectedValue = ((long)thisWorkEntry.cost_code_id).ToString();
                //            // status_id.SelectedValue = ((long)thisWorkEntry.)
                //            // thisTask  = new crm_account_dal().FindNoDeleteById(thisWorkEntry.);

                //        }

                //        if (thisWorkEntry.contract_id != null)
                //        {
                //            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisWorkEntry.contract_id);
                //        }
                //        if (!IsPostBack)
                //        {
                //            isBilled.Checked = thisWorkEntry.is_billable == 0;
                //            ShowOnInv.Checked = thisWorkEntry.show_on_invoice == 1;
                //            if (isBilled.Checked)
                //            {
                //                ShowOnInv.Enabled = true;
                //            }
                //        }
                //    }
                //}
                #endregion
                if (thisTask != null)
                {
                    v_task = new v_task_all_dal().FindById(thisTask.id);
                    thisProjetc = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                    if (thisProjetc != null)
                    {
                        thisAccount = new crm_account_dal().FindNoDeleteById(thisProjetc.account_id);
                        if (!IsPostBack)
                        {
                            status_id.SelectedValue = thisTask.status_id.ToString();
                        }
                    }
                }
                // 项目关联合同，并且合同中设置-工时录入需要输入开始结束时间
                if (thisProjetc != null && thisProjetc.contract_id != null)
                {
                    var thisCttContract = new ctt_contract_dal().FindNoDeleteById((long)thisProjetc.contract_id);
                    if (thisCttContract != null)
                    {
                        if (thisCttContract.timeentry_need_begin_end == 1)
                        {
                            noTime = false;
                        }
                    }
                }

                if (thisCall != null)
                {
                    showStartDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time);
                    showEndDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.end_time);
                }
                if (!string.IsNullOrEmpty(Request.QueryString["chooseDate"]))
                {
                    showStartDate = DateTime.Parse(Request.QueryString["chooseDate"]);
                    showEndDate = DateTime.Parse(Request.QueryString["chooseDate"]);
                }
                    

            }
            catch (Exception msg)
            {

                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }
        }

        protected SdkWorkEntryDto GetParam()
        {
            SdkWorkEntryDto para = new SdkWorkEntryDto();
            var pageEntry = AssembleModel<sdk_work_entry>();
            //var pageRecord = AssembleModel<sdk_work_record>();
            //var startTime = Request.Form["startTime"];
            //var endTime = Request.Form["endTime"];
            //var date = Request.Form["tmeDate"];
            //if(!string.IsNullOrEmpty(startTime)&& !string.IsNullOrEmpty(endTime) && !string.IsNullOrEmpty(date))
            //{
            //    var starString = date + " " + startTime;
            //    var endString = date + " " + endTime;
            //    var startDate = DateTime.Parse(starString);
            //    var endDate = DateTime.Parse(endString);
            //    if (endDate < startDate)
            //    {
            //        endDate = endDate.AddDays(1);
            //    }
            //    var startLong = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
            //    var endLong = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
            //    pageEntry.start_time = startLong;
            //    pageEntry.end_time = endLong;
            //    //pageRecord.start_time = startLong;
            //    //pageRecord.end_time = endLong;
            //}
            var PageEntryIds = Request.Form["PageEntryIds"];
            if (!string.IsNullOrEmpty(PageEntryIds))
            {
                var entArr = PageEntryIds.Split(new char[] { ','},StringSplitOptions.RemoveEmptyEntries);
                List<PageEntryDto> entDtoList = new List<PageEntryDto>();
                //var hours_worked = Request.Form["hours_worked"];
                foreach (var thisEntArrId in entArr)
                {
                    var thisSum = Request.Form["summ_" + thisEntArrId];
                    var thisIne = Request.Form["inter_" + thisEntArrId];
                    var thisDate = Request.Form["entry_date_" + thisEntArrId];
                    var thisHour = Request.Form["entry_work_hour_" + thisEntArrId];
                    var thisHoured = Request.Form["entry_worked_" + thisEntArrId];
                    if (string.IsNullOrEmpty(thisDate))
                    {
                        continue;
                    }
                    #region 开始结束时间
                    var startTime = Request.Form["entry_start_date_"+ thisEntArrId];
                    var endTime = Request.Form["entry_end_date_"+ thisEntArrId];

                    long? startLongDate = null;
                    long? endLongDate = null;
                    if (!string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime) )
                    {
                        var starString = thisDate + " " + startTime;
                        var endString = thisDate + " " + endTime;
                        var startDate = DateTime.Parse(starString);
                        var endDate = DateTime.Parse(endString);
                        if (endDate < startDate)
                        {
                            endDate = endDate.AddDays(1);
                        }
                        startLongDate = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                        endLongDate = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
                    }
                    #endregion

                    var thisOffSet = Request.Form["entry_offset_" + thisEntArrId];
                    var thisBill = Request.Form["entry_billed_" + thisEntArrId];

                    decimal? bill = null;
                    if (!string.IsNullOrEmpty(thisBill))
                    {
                        bill = decimal.Parse(thisBill);
                    }

                    if ((!string.IsNullOrEmpty(thisHour)||!string.IsNullOrEmpty(thisHoured)) && !string.IsNullOrEmpty(thisDate))
                    {
                        entDtoList.Add(new PageEntryDto() {
                            id = long.Parse(thisEntArrId),
                            sumNote = thisSum,
                            ineNote = thisIne,
                            time = DateTime.Parse(thisDate),
                            startDate= startLongDate,
                            endDate = endLongDate,
                            workHours = !string.IsNullOrEmpty(thisHour)? decimal.Parse(thisHour): decimal.Parse(thisHoured),
                            offset = !string.IsNullOrEmpty(thisOffSet)?decimal.Parse(thisOffSet) :0,
                            billHours = bill,
                        });
                    }
                }
                para.pagEntDtoList = entDtoList;
            }


            var pageProject = new pro_project_dal().FindNoDeleteById(long.Parse(Request.Form["project_id"]));
            if (pageProject != null)
            {  
                //if (pageProject.type_id == (int)DicEnum.PROJECT_TYPE.IN_PROJECT)
                //{
                //    //pageRecord.entry_type_id = (int)DicEnum.WORK_ENTRY_TYPE.COMPAMY_IN_ENTRY;
                //}
                //else
                //{
                //    pageRecord.entry_type_id = (int)DicEnum.WORK_ENTRY_TYPE.PROJECT_ENTRY;
                //}
            }
            pageEntry.show_on_invoice = (sbyte)(ShowOnInv.Checked ? 1 : 0);
            pageEntry.is_billable = (sbyte)(isBilled.Checked?0:1);
            if (!isAdd)
            {
                thisWorkEntry.contract_id = pageEntry.contract_id;
                thisWorkEntry.task_id = pageEntry.task_id;
                thisWorkEntry.service_id = pageEntry.service_id;
                thisWorkEntry.resource_id = pageEntry.resource_id;
                thisWorkEntry.role_id = pageEntry.role_id;
                thisWorkEntry.cost_code_id = pageEntry.cost_code_id;
                thisWorkEntry.start_time = pageEntry.start_time;
                thisWorkEntry.end_time = pageEntry.end_time;
                thisWorkEntry.hours_worked = pageEntry.hours_worked;
                thisWorkEntry.hours_billed = pageEntry.hours_billed;
                thisWorkEntry.offset_hours = pageEntry.offset_hours;
                thisWorkEntry.internal_notes = pageEntry.internal_notes;
                thisWorkEntry.summary_notes = pageEntry.summary_notes;
                thisWorkEntry.is_billable = pageEntry.is_billable;
                thisWorkEntry.show_on_invoice = pageEntry.show_on_invoice;
                para.workEntry = thisWorkEntry;
                //if (thisWorkEntry != null)
                //{
                //    var thisWorkRecord = new sdk_work_record_dal().FindNoDeleteById((long)thisWorkEntry.work_record_id);
                //    if (thisWorkRecord != null)
                //    {
                //        //thisWorkRecord.contract_id = pageRecord.contract_id;
                //        //thisWorkRecord.task_id = pageRecord.task_id;
                //        //thisWorkRecord.resource_id = pageRecord.resource_id;
                //        //thisWorkRecord.entry_type_id = pageRecord.entry_type_id;
                //        //thisWorkRecord.role_id = pageRecord.role_id;
                //        //thisWorkRecord.cost_code_id = pageRecord.cost_code_id;
                //        //thisWorkRecord.start_time = pageRecord.start_time;
                //        //thisWorkRecord.end_time = pageRecord.end_time;
                //        //para.wordRecord = thisWorkRecord;
                //    }
                //}
                
            }
            else
            {
                para.workEntry = pageEntry;
                // para.wordRecord = pageRecord;

            }
        
            
            var remain_hours = Request.Form["remain_hours"];
            if (!string.IsNullOrEmpty(remain_hours))
            {
                para.remain_hours = decimal.Parse(remain_hours);
            }
            var status_id = Request.Form["status_id"];
            if (!string.IsNullOrEmpty(status_id))
            {
                para.status_id = int.Parse(status_id);
            }

            #region 通知相关
            var notify_id = Request.Form["notify_id"];
            if (!string.IsNullOrEmpty(notify_id))
            {
                para.notify_id = int.Parse(notify_id);
                para.contact_ids = Request.Form["contact_ids"];
                para.resIds = Request.Form["resIds"];
                para.otherEmail = Request.Form["otherEmail"];
                para.subjects = Request.Form["subjects"];
                para.AdditionalText = Request.Form["AdditionalText"];
            }
            #endregion


            return para;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                result = new TaskBLL().AddWorkEntry(param, GetLoginUserId());
            }
            else
            {
                result = new TaskBLL().EditWorkEntry(param, GetLoginUserId());
            }
            
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存工时成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存工时失败！');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}