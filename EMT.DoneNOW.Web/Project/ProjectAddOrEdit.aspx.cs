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
        protected List<sdk_task> taskList = null;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected List<UserDefinedFieldDto> project_udfList = null;
        protected List<UserDefinedFieldValue> project_udfValueList = null;
        protected string thisType = ""; // 项目的类型--type_id
        protected string isFromTemp = ""; // 入口是否从模板添加
        protected string isTemp = "";     // 是否添加模板-- 模板
        protected string callBaclFunction = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //var checkLimitType = Request.QueryString["type_id"];
                //if (checkLimitType == ((int)DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT).ToString() || checkLimitType == ((int)DicEnum.PROJECT_TYPE.IN_PROJECT).ToString())
                //{
                //    var result = GetLimitValue(AuthLimitEnum.PROClientAdd);
                //    if (result == DicEnum.LIMIT_TYPE_VALUE.NO960)
                //    {
                //        Response.Write("alert(没有新增项目权限);window.close();");
                //        return;
                //    }

                //}
                //else if (checkLimitType == ((int)DicEnum.PROJECT_TYPE.PROJECT_DAY).ToString())
                //{
                //    var result = GetLimitValue(AuthLimitEnum.PROProposalAdd);
                //    if (result == DicEnum.LIMIT_TYPE_VALUE.NO960)
                //    {
                //        Response.Write("alert(没有新增项目提案权限);window.close();");
                //        return;
                //    }
                //}
                //else if (checkLimitType == ((int)DicEnum.PROJECT_TYPE.TEMP).ToString())
                //{
                //    var result = GetLimitValue(AuthLimitEnum.PROTemplatesAdd);
                //    if (result == DicEnum.LIMIT_TYPE_VALUE.NO960)
                //    {
                //        Response.Write("alert(没有新增项目模板权限);window.close();");
                //        return;
                //    }
                //}
                var accountIdString = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(accountIdString))
                {
                    account = new CompanyBLL().GetCompany(long.Parse(accountIdString));
                }
                callBaclFunction = Request.QueryString["callFunc"];

                isFromTemp = Request.QueryString["isFromTemp"];
                isTemp = Request.QueryString["isTemp"];
               

                var id = Request.QueryString["id"];
                project_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        if (thisProject.contract_id != null)
                        {
                            contract = new ctt_contract_dal().FindNoDeleteById((long)thisProject.contract_id);
                        }
                        if (thisProject.type_id == (int)DicEnum.PROJECT_TYPE.TEMP)
                        {
                            isTemp = "1";
                        }
                        taskList = new sdk_task_dal().GetProTask(thisProject.id);
                        account = new crm_account_dal().FindNoDeleteById(thisProject.account_id);
                        project_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS, thisProject.id, project_udfList);
                        isAdd = false;
                        
                    }
                }
                else
                {
                    if (!IsPostBack)
                    {
                        is_active.Checked = true;
                        excludeWeekend.Checked = true;
                        excludeHoliday.Checked = true;
                        warnTime_off.Checked = true;
                    }
                }
                if (!IsPostBack)
                {
                    PageDataBind();
                }

                if (thisProject != null)
                {
                    #region 根据项目信息为页面数据赋值
                    if (!IsPostBack)
                    {
                        line_of_business_id.SelectedValue = thisProject.line_of_business_id == null ? "0" : thisProject.line_of_business_id.ToString();
                        type_id.SelectedValue = thisProject.type_id == null ? "0" : thisProject.type_id.ToString();
                        status_id.SelectedValue = thisProject.status_id.ToString();
                        department_id.SelectedValue = thisProject.department_id == null ? "0" : thisProject.department_id.ToString();
                        organization_location_id.SelectedValue = thisProject.organization_location_id.ToString();
                        template_id.SelectedValue = thisProject.template_id == null ? "0" : thisProject.template_id.ToString();
                        useResource_daily_hours.Checked = thisProject.use_resource_daily_hours == 1;
                        owner_resource_id.SelectedValue = thisProject.owner_resource_id == null ? "0" : thisProject.owner_resource_id.ToString();
                        excludeWeekend.Checked = thisProject.exclude_weekend == 1;
                        excludeHoliday.Checked = thisProject.exclude_holiday == 1;
                        warnTime_off.Checked = thisProject.warn_time_off == 1;
                        if (!string.IsNullOrEmpty(isTemp))
                        {
                            is_active.Checked = thisProject.status_id == (int)DicEnum.PROJECT_STATUS.NEW;
                        }
                    }
                    #endregion
                }
            }
            catch (Exception msg)
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
            temp_line_of_business_id.DataTextField = "show";
            temp_line_of_business_id.DataValueField = "val";
            temp_line_of_business_id.DataSource = dic.FirstOrDefault(_ => _.Key == "project_line_of_business").Value;
            temp_line_of_business_id.DataBind();
            temp_line_of_business_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });



            type_id.DataTextField = "show";
            type_id.DataValueField = "val";
            var thisTypeList = dic.FirstOrDefault(_ => _.Key == "project_type").Value as List<DictionaryEntryDto>;
            if (!string.IsNullOrEmpty(isTemp))  // 是否是模板
            {
                var temp = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.TEMP).ToString());
                if (temp != null)
                {
                    thisTypeList = new List<DictionaryEntryDto>() { temp };
                    if (GetLimitValue(AuthLimitEnum.PROTemplatesAdd) == DicEnum.LIMIT_TYPE_VALUE.NO960)
                    {
                        thisTypeList.Remove(temp);
                    }
                }

            }
            else
            {
                var temp = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.TEMP).ToString());
                if (temp != null)
                {
                    thisTypeList.Remove(temp);
                }
                var benchmark = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.BENCHMARK).ToString());
                if (benchmark != null)
                {
                    thisTypeList.Remove(benchmark);
                }
                // 权限过滤，部分不可新增则不显示。
                if (GetLimitValue(AuthLimitEnum.PROClientAdd) == DicEnum.LIMIT_TYPE_VALUE.NO960)
                {
                    var cline = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT).ToString());
                    if (cline != null)
                    {
                        thisTypeList.Remove(cline);
                    }
                    var inter = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.IN_PROJECT).ToString());
                    if (inter != null)
                    {
                        thisTypeList.Remove(inter);
                    }
                }
                if (GetLimitValue(AuthLimitEnum.PROProposalAdd) == DicEnum.LIMIT_TYPE_VALUE.NO960)
                {
                    var popal = thisTypeList.FirstOrDefault(_ => _.val == ((int)DicEnum.PROJECT_TYPE.PROJECT_DAY).ToString());
                    if (popal != null)
                    {
                        thisTypeList.Remove(popal);
                    }
                }

            }

            type_id.DataSource = thisTypeList;
            type_id.DataBind();
            thisType = Request.QueryString["type_id"];
            if (!string.IsNullOrEmpty(thisType))
            {
                type_id.SelectedValue = thisType;
            }

            temp_type_id.DataTextField = "show";
            temp_type_id.DataValueField = "val";
            temp_type_id.DataSource = thisTypeList;
            temp_type_id.DataBind();

            status_id.DataTextField = "show";
            status_id.DataValueField = "val";
            status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "project_status").Value;
            status_id.DataBind();

            owner_resource_id.DataTextField = "show";
            owner_resource_id.DataValueField = "val";
            owner_resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
            owner_resource_id.DataBind();
            owner_resource_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            // temp_owner_resource_id
            temp_owner_resource_id.DataTextField = "show";
            temp_owner_resource_id.DataValueField = "val";
            temp_owner_resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
            temp_owner_resource_id.DataBind();
            temp_owner_resource_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            department_id.DataTextField = "name";
            department_id.DataValueField = "id";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            temp_department_id.DataTextField = "name";
            temp_department_id.DataValueField = "id";
            temp_department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            temp_department_id.DataBind();
            temp_department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });


            organization_location_id.DataTextField = "name";
            organization_location_id.DataValueField = "id";
            organization_location_id.DataSource = dic.FirstOrDefault(_ => _.Key == "org_location").Value;
            organization_location_id.DataBind();

            template_id.DataTextField = "name";
            template_id.DataValueField = "id";
            template_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.PROJECT_CREATED);
            template_id.DataBind();

            if (string.IsNullOrEmpty(isTemp))
            {
                var tempList = new pro_project_dal().GetTempList();
                // 项目模板  --project_temp
                if (tempList != null && tempList.Count > 0)
                {
                    project_temp.DataTextField = "name";
                    project_temp.DataValueField = "id";
                    project_temp.DataSource = tempList;
                    project_temp.DataBind();
                }

            }

        }

        /// <summary>
        /// 获取相应参数
        /// </summary>
        private ProjectDto GetParam()
        {
            ProjectDto param = AssembleModel<ProjectDto>();
            param.project = AssembleModel<pro_project>();
            // var test = Request.Form["fromTempId"];
            param.project.use_resource_daily_hours = (sbyte)(useResource_daily_hours.Checked ? 1 : 0);
            param.project.exclude_weekend = (sbyte)(excludeWeekend.Checked ? 1 : 0);
            param.project.exclude_holiday = (sbyte)(excludeHoliday.Checked ? 1 : 0);
            param.project.warn_time_off = (sbyte)(warnTime_off.Checked ? 1 : 0);
            if ( !string.IsNullOrEmpty(isTemp))
            {
                if (isAdd)
                {
                    param.project.status_id = is_active.Checked ? (int)DicEnum.PROJECT_STATUS.NEW : (int)DicEnum.PROJECT_STATUS.DISABLE;
                }
                else
                {
                    param.project.status_id = thisProject.status_id;
                    param.project.status_detail = thisProject.status_detail;
                    param.project.status_time = thisProject.status_time;
                }
               
            }
            #region 结束时间和持续时间天数



            if (!isAdd)
            {
                if (param.project.duration != thisProject.duration)
                {
                    param.project.end_date = ((DateTime)param.project.start_date).AddDays((double)param.project.duration-1);
                }
                else
                {
                    if(param.project.end_date!= thisProject.end_date)
                    {
                        TimeSpan ts1 = new TimeSpan(((DateTime)param.project.start_date).Ticks);
                        TimeSpan ts2 = new TimeSpan(((DateTime)param.project.end_date).Ticks);
                        TimeSpan ts = ts1.Subtract(ts2).Duration();
                        param.project.duration = ts.Days+1;
                     
                    }
                    else
                    {
                        param.project.end_date = ((DateTime)param.project.start_date).AddDays((double)param.project.duration-1);
                    }
               
                }

                if (taskList != null && taskList.Count > 0)
                {
                    var lastDate = taskList.Max(_ => _.estimated_end_date);
                    if(lastDate> param.project.end_date)
                    {
                        param.project.end_date = lastDate;
                        TimeSpan ts1 = new TimeSpan(((DateTime)param.project.start_date).Ticks);
                        TimeSpan ts2 = new TimeSpan(((DateTime)param.project.end_date).Ticks);
                        TimeSpan ts = ts1.Subtract(ts2).Duration();
                        param.project.duration = ts.Days+1;
                    }
                }


                var statusTime = Request.Form["statustime"];
                if (!string.IsNullOrEmpty(statusTime))
                {
                    param.project.status_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(statusTime));
                }

            }
            else
            {
              
                if (param.project.duration != null)
                {
                    param.project.end_date = ((DateTime)param.project.start_date).AddDays(((double)param.project.duration) - 1);
                }
                else
                {
                    TimeSpan ts1 = new TimeSpan(((DateTime)param.project.start_date).Ticks);
                    TimeSpan ts2 = new TimeSpan(((DateTime)param.project.end_date).Ticks);
                    TimeSpan ts = ts1.Subtract(ts2).Duration();
                    param.project.duration = ts.Days+1;
                }

                
            }
            #endregion
            if (project_udfList != null && project_udfList.Count > 0)
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
                if (string.IsNullOrEmpty(isTemp))
                {
                    param.project.status_id = (int)DicEnum.PROJECT_STATUS.NEW;
                }

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
                param.project.baseline_project_id = thisProject.baseline_project_id;
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
                result = new ProjectBLL().AddPro(param, GetLoginUserId());
                if (!string.IsNullOrEmpty(callBaclFunction) && param.project_id != null)
                {
                    Response.Write("<script>window.opener." + callBaclFunction + "('" + param.project_id + "');</script>");
                }
            }
            else
            {
                result = new ProjectBLL().EditProject(param, GetLoginUserId());
            }
            return result;
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var result = Save();
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存项目成功！');window.close();</script>");
                
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存项目失败！');window.close();</script>");
            }
            if (string.IsNullOrEmpty(callBaclFunction))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "刷新主页面", "<script>self.opener.location.reload();</script>");
            }
        }
    }
}