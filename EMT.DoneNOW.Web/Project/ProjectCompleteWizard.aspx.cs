using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectCompleteWizard : BasePage
    {
        protected pro_project thisProject = null;
        protected List<sdk_task> actTaskList = null;  // 未完成的任务
        protected List<ctt_contract_cost> noCicostList = null;  // 没有配置项的项目产品
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    var taskList = new sdk_task_dal().GetProTask(thisProject.id);
                    if (taskList != null && taskList.Count > 0)
                    {
                        actTaskList = taskList.Where(_ => _.status_id != (int)DTO.DicEnum.TICKET_STATUS.DONE).ToList();
                    }
                    var costList = new ctt_contract_cost_dal().GetCostByProId(thisProject.id);
                    if (costList != null && costList.Count > 0)
                    {
                        noCicostList = costList.Where(_ => _.product_id == null).ToList();
                    }
                    if (!IsPostBack)
                    {
                        // noTempId
                        noTempId.DataTextField = "name";
                        noTempId.DataValueField = "id";
                        noTempId.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.PROJECT_COMPLETED);
                        noTempId.DataBind();
                    }

                }
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }

        protected void finish_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new ProjectBLL().CompleteProject(param, GetLoginUserId());
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('项目完成向导完成！');window.close();self.opener.location.reload();</script>");
            }
            else
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('项目完成向导失败！');window.close();self.opener.location.reload();</script>");
            }
        }
        /// <summary>
        /// 获取相应参数
        /// </summary>
        private CompleteProjectDto GetParam()
        {
            var param = AssembleModel<CompleteProjectDto>();
            param.project = thisProject;
            param.taskList = actTaskList;
            var costIds = Request.Form["costIds"];
            if (!string.IsNullOrEmpty(costIds))
            {
                List<SaveInsPro> insProList = new List<SaveInsPro>();
                var costIdList = costIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var costId in costIdList)
                {
                    try
                    {
                        var insPro = new SaveInsPro();
                        insPro.id = long.Parse(costId);
                        if (!string.IsNullOrEmpty(Request.Form[costId + "_date_purchased"]))
                        {
                            insPro.installOn = DateTime.Parse(Request.Form[costId + "_date_purchased"]);
                        }
                        if (!string.IsNullOrEmpty(Request.Form[costId + "_through_date"]))
                        {
                            insPro.warExpiration = DateTime.Parse(Request.Form[costId + "_through_date"]);
                        }
                        insPro.product_id = long.Parse(Request.Form[costId + "_product_idHidden"]);
                        insPro.serial_number = Request.Form[costId + "_serial_number"];
                        insProList.Add(insPro);
                    }
                    catch (Exception msg)
                    {
                        continue;
                    }
                }

                param.insProList = insProList;
            }

            if (thisProject.opportunity_id != null)
            {
                var proStartDate = Request.QueryString["ProStartDate"];
                if (!string.IsNullOrEmpty(proStartDate))
                {
                    param.ProStartDate = DateTime.Parse(proStartDate);
                }
                param.isUpdateOppDate = cbStaTime.Checked;
                param.isUpdateOppStatus = cbStatus.Checked;
            }




            return param;
        }
    }
}