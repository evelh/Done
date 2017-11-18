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
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                if (!IsPostBack)
                {
                    resource_id.DataTextField = "show";
                    resource_id.DataValueField = "val";
                    resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                    resource_id.DataBind();

                    var statusList = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value as List<DictionaryEntryDto>;
                     statusList.Remove(statusList.FirstOrDefault(_=>_.val==((int)DicEnum.TICKET_STATUS.NEW).ToString()));
                    status_id.DataTextField = "show";
                    status_id.DataValueField = "val";
                    status_id.DataSource = statusList;
                    status_id.DataBind();
                    

                    cost_code_id.DataTextField = "name";
                    cost_code_id.DataValueField = "id";
                    cost_code_id.DataSource = new d_cost_code_dal().GetCostCodeByWhere((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
                    cost_code_id.DataBind();
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
                        isAdd = false;
                        thisTask = new sdk_task_dal().FindNoDeleteById(thisWorkEntry.task_id);

                        resource_id.SelectedValue = ((long)thisWorkEntry.resource_id).ToString();
                        cost_code_id.SelectedValue = ((long)thisWorkEntry.cost_code_id).ToString();
                        // status_id.SelectedValue = ((long)thisWorkEntry.)
                        // thisTask  = new crm_account_dal().FindNoDeleteById(thisWorkEntry.);
                        if (thisWorkEntry.contract_id != null)
                        {
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisWorkEntry.contract_id);
                        }
                        if (!IsPostBack)
                        {
                            isBilled.Checked = thisWorkEntry.is_billable == 1;
                            ShowOnInv.Checked = thisWorkEntry.show_on_invoice == 1;
                            if (isBilled.Checked)
                            {
                                ShowOnInv.Enabled = true;
                            }
                        }
                    }
                }
                if (thisTask != null)
                {
                    v_task = new v_task_all_dal().FindById(thisTask.id);
                    thisProjetc = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                    if (thisProjetc != null)
                    {
                        thisAccount = new crm_account_dal().FindNoDeleteById(thisProjetc.account_id);
                    }
                }


            }
            catch (Exception msg)
            {

                Response.End();
            }
        }

        protected SdkWorkEntryDto GetParam()
        {
            SdkWorkEntryDto para = new SdkWorkEntryDto();
            var pageEntry = AssembleModel<sdk_work_entry>();
            var pageRecord = AssembleModel<sdk_work_record>();
            var startTime = Request.Form["startTime"];
            var endTime = Request.Form["endTime"];
            var date = Request.Form["tmeDate"];
            var starString = date + " " + startTime;
            var endString = date + " " + endTime;
            var startDate = DateTime.Parse(starString);
            var endDate = DateTime.Parse(endString);
            if (endDate < startDate)
            {
                endDate = endDate.AddDays(1);
            }
            var startLong = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
            var endLong = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
            pageEntry.start_time = startLong;
            pageEntry.end_time = endLong;
            pageRecord.start_time = startLong;
            pageRecord.end_time = endLong;
            var pageProject = new pro_project_dal().FindNoDeleteById(long.Parse(Request.Form["project_id"]));
            if (pageProject != null)
            {
                if (pageProject.type_id == (int)DicEnum.PROJECT_TYPE.IN_PROJECT)
                {
                    pageRecord.entry_type_id = (int)DicEnum.WORK_ENTRY_TYPE.COMPAMY_IN_ENTRY;
                }
                else
                {
                    pageRecord.entry_type_id = (int)DicEnum.WORK_ENTRY_TYPE.PROJECT_ENTRY;
                }
            }
            pageEntry.show_on_invoice = (sbyte)(ShowOnInv.Checked ? 1 : 0);
            pageEntry.is_billable = (sbyte)(isBilled.Checked?1:0);
            para.workEntry = pageEntry;
            para.wordRecord = pageRecord;
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
            return para;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new TaskBLL().AddWorkEntry(param,GetLoginUserId());
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