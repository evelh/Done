using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectAddOrEdit : BasePage
    {
        protected bool isAdd = true;
        protected pro_project thisProject = null;
        protected crm_account account = null;
        protected ctt_contract contract = null;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected List<UserDefinedFieldDto> project_udfList = null;
        protected List<UserDefinedFieldValue> project_udfValueList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    PageDataBind();
                }
                var id = Request.QueryString["id"];
                project_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        project_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS,thisProject.id, project_udfList);
                        isAdd = false;
                        #region 根据项目信息为页面数据赋值
                        if (!IsPostBack)
                        {
                            line_of_business_id.SelectedValue = thisProject.line_of_business_id == null ? "0" : thisProject.line_of_business_id.ToString();
                            type_id.SelectedValue = thisProject.type_id == null ? "0" : thisProject.type_id.ToString();
                            status_id.SelectedValue =  thisProject.status_id.ToString();
                            department_id.SelectedValue = thisProject.department_id == null ? "0" : thisProject.department_id.ToString();
                            organization_location_id.SelectedValue = thisProject.organization_location_id.ToString();
                            template_id.SelectedValue = thisProject.template_id == null ? "0" : thisProject.template_id.ToString();
                            useResource_daily_hours.Checked = thisProject.use_resource_daily_hours == 1;
                            excludeWeekend.Checked = thisProject.exclude_weekend == 1;
                            excludeHoliday.Checked = thisProject.exclude_holiday == 1;
                            warnTime_off.Checked = thisProject.warn_time_off == 1;
                        }
                        #endregion
                    }
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 页面数据源配置
        /// </summary>
        private void PageDataBind()
        {
            line_of_business_id.DataTextField = "show";
            line_of_business_id.DataValueField = "val";
            line_of_business_id.DataSource = dic.FirstOrDefault(_ => _.Key == "project_line_of_business").Value;
            line_of_business_id.DataBind();
            line_of_business_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            type_id.DataTextField = "show";
            type_id.DataValueField = "val";
            type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "project_type").Value;
            type_id.DataBind();
            var thisTypeId = Request.QueryString["type"];
            if (!string.IsNullOrEmpty(thisTypeId))
            {
                type_id.SelectedValue = thisTypeId;
            }

            status_id.DataTextField = "show";
            status_id.DataValueField = "val";
            status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "project_status").Value;
            status_id.DataBind();

            department_id.DataTextField = "show";
            department_id.DataValueField = "val";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            organization_location_id.DataTextField = "show";
            organization_location_id.DataValueField = "val";
            organization_location_id.DataSource = dic.FirstOrDefault(_ => _.Key == "org_location").Value;
            organization_location_id.DataBind();

            template_id.DataTextField = "name";
            template_id.DataValueField = "id";
            template_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.PROJECT_CREATED);
            template_id.DataBind();
        }

        /// <summary>
        /// 获取相应参数
        /// </summary>
        private ProjectDto GetParam()
        {
            ProjectDto param = new ProjectDto();
            param.project = AssembleModel<pro_project>();
            param.project.use_resource_daily_hours = (sbyte)(useResource_daily_hours.Checked ? 1 : 0);
            param.project.exclude_weekend = (sbyte)(excludeWeekend.Checked ? 1 : 0);
            param.project.exclude_holiday = (sbyte)(excludeHoliday.Checked ? 1 : 0);
            param.project.warn_time_off = (sbyte)(warnTime_off.Checked ? 1 : 0);
            param.notify = AssembleModel<com_notify_email>();
            if(project_udfList!=null&& project_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in project_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = string.IsNullOrEmpty(Request.Form[udf.id.ToString()]) ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }

            if (isAdd)
            {
                param.resDepIds = Request.Form["resDepList"];
                param.contactIds = Request.Form["conIds"];
            }
            else
            {
                param.project.id = thisProject.id;
                #region 暂时不知道哪里会用，从旧的项目中获取
                param.project.no = thisProject.no;
                param.project.actual_project_time = thisProject.actual_project_time;
                param.project.actual_project_billed_time = thisProject.actual_project_billed_time;
                param.project.est_project_time = thisProject.est_project_time;
                param.project.change_orders_revenue = thisProject.change_orders_revenue;
                param.project.change_orders_budget = thisProject.change_orders_budget;
                param.project.probability = thisProject.probability;
                param.project.project_costs = thisProject.project_costs;
                param.project.importance_id = thisProject.importance_id;
                param.project.sales_id = thisProject.sales_id;
                param.project.completed_percentage = thisProject.completed_percentage;
                param.project.completed_time = thisProject.completed_time;
                param.project.cash_collected = thisProject.cash_collected;
                param.project.baseline_id = thisProject.baseline_id;
                param.project.edit_event_id = thisProject.edit_event_id;
                param.project.percent_complete = thisProject.percent_complete;
                param.project.automatic_leveling_end_date_offset_days = thisProject.automatic_leveling_end_date_offset_days;
                #endregion
            }
            return param;
        }

        /// <summary>
        /// 保存操作
        /// </summary>
        /// <returns></returns>
        private bool Save()
        {
            var param = GetParam();
            bool result = false;
            if (param.project.id == 0)
            {
                result = new ProjectBLL().AddPro(param,GetLoginUserId());
            }
            else
            {

            }
            return result;
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var result = Save();
            if (result)
            {

            }
            else
            {

            }
        }
    }
}