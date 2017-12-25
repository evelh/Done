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
using System.Text;

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskAddOrEdit : BasePage
    {
        protected pro_project thisProject = null;
        protected sdk_task thisTask = null;
        protected bool isAdd = true;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected pro_project_dal ppdal = new pro_project_dal();
        protected sdk_task_dal sdDal = new sdk_task_dal();
        protected int type_id;                            // task 的类型
        protected bool isPhase;                           // 判断是否是
        protected List<sdk_task> taskList = null;         // 该项目的task集合 用于任务的前驱任务的选择
        protected sdk_task parTask = null;                // 通过taskId进行新增
        protected List<UserDefinedFieldDto> task_udfList = null;     // task 自定义
        protected List<UserDefinedFieldValue> task_udfValueList = null;
        protected List<ctt_contract_rate> rateList = null;         // 合同角色费率  todo
        protected List<com_activity> noteList = null;
        protected ctt_contract thisProContract = null;            // 修改时使用，项目合同
        protected List<PageMile> thisPhaMile =null;              // 修改阶段时使用，关联里程碑
        protected List<sdk_task_predecessor> preList = null;
        public bool isCopy = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
               
                if (!IsPostBack)
                {
                    ThisPageDataBind();
                }
                task_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);
                var project_id = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = ppdal.FindNoDeleteById(long.Parse(project_id));
                }
                var parTaskId = Request.QueryString["par_task_id"];
                if (!string.IsNullOrEmpty(parTaskId))
                {
                    parTask = sdDal.FindNoDeleteById(long.Parse(parTaskId));
                    if (parTask != null)
                    {
                        if (parTask.project_id != null)
                        {
                            thisProject = ppdal.FindNoDeleteById((long)parTask.project_id);
                        }

                    }
                }

                var typeString = Request.QueryString["type_id"];
                if (!string.IsNullOrEmpty(typeString))
                {
                    type_id = int.Parse(typeString);
                    if (!IsPostBack)
                    {
                        switch (type_id)
                        {
                            case (int)DicEnum.TASK_TYPE.PROJECT_ISSUE:
                                isProject_issue.Checked = true;
                                break;
                            case (int)DicEnum.TASK_TYPE.PROJECT_TASK:
                                isProject_issue.Checked = false;
                                break;
                            default:
                                break;
                        }
                    }

                }
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisTask = sdDal.FindNoDeleteById(long.Parse(id));
                    if (thisTask != null)
                    {
                        if (thisTask.parent_id != null)
                        {
                            parTask = sdDal.FindNoDeleteById((long)thisTask.parent_id);
                        }
                        type_id = thisTask.type_id;
                        isAdd = false;
                        var isCopyString = Request.QueryString["IsCopy"];
                        if (!string.IsNullOrEmpty(isCopyString)&&thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_TASK)
                        {
                            isCopy = true;
                        }
                        if (thisTask.project_id != null)
                        {
                            thisProject = ppdal.FindNoDeleteById((long)thisTask.project_id);
                        }
                        task_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, thisTask.id, task_udfList);
                        noteList = new com_activity_dal().GetActiList($" and (task_id ={thisTask.id} or object_id={thisTask.id} )");

                        preList = new sdk_task_predecessor_dal().GetRelList(thisTask.id);
                        if (!IsPostBack)
                        {
                            status_id.SelectedValue = thisTask.status_id.ToString();
                            if (thisTask.is_visible_in_client_portal == 0)
                            {
                                DisplayInCapNone.Checked = true;
                            }
                            else
                            {
                                if (thisTask.can_client_portal_user_complete_task == 1)
                                {
                                    DisplayInCapYes.Checked = true;
                                }
                                else
                                {
                                    DisplayInCapYesNoComplete.Checked = true;
                                }
                            }

                            if (thisTask.is_project_issue == 1)
                            {
                                isProject_issue.Checked = true;
                            }
                            else
                            {
                                isProject_issue.Checked = false;
                            }

                            if (thisTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK)
                            {
                                TaskTypeFixedWork.Checked = true;
                            }
                            else if (thisTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION)
                            {
                                TaskTypeFixedDuration.Checked = true;
                            }
                            else
                            {

                            }

                            department_id.SelectedValue = thisTask.department_id == null ? "" : ((int)thisTask.department_id).ToString();
                        }

                        //  判断是阶段，查询出相关项目的关联合同的里程碑  和自己的里程碑
                        if (type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE && thisProject != null&&thisProject.contract_id!=null)
                        {
                            // 获取该项目合同下未被关联的里程碑
                            var proConMilList = new ctt_contract_milestone_dal().GetListByProId(thisProject.id);
                            // 获取该阶段下的所有里程碑
                            var phaMilList = new sdk_task_milestone_dal().GetPhaMilList(thisTask.id);
                            thisPhaMile = new List<PageMile>();
                            if (proConMilList != null && proConMilList.Count > 0)
                            {
                                thisPhaMile.AddRange(proConMilList);
                            }
                            if(phaMilList!=null&& phaMilList.Count > 0)
                            {
                                thisPhaMile.AddRange(phaMilList);
                            }
                            if (thisPhaMile.Count > 0)
                            {
                                thisPhaMile = thisPhaMile.OrderBy(_ => _.dueDate).ToList();
                            }


                        }
                        
                    }
                }
                if (type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                {
                    isPhase = true;
                }

                if (thisProject == null)
                {
                    Response.End();
                }
                else
                {
                    if (thisProject.contract_id != null)
                    {
                        thisProContract = new ctt_contract_dal().FindNoDeleteById((long)thisProject.contract_id);
                        rateList = new ctt_contract_rate_dal().GetRateByConId((long)thisProject.contract_id);
                    }
                }



            }
            catch (Exception msg)
            {
                Response.End();
            }
        }

        public void ThisPageDataBind()
        {
            status_id.DataTextField = "show";
            status_id.DataValueField = "val";
            status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value;
            status_id.DataBind();
            // status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            department_id.DataTextField = "name";
            department_id.DataValueField = "id";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            template_id.DataTextField = "name";
            template_id.DataValueField = "id";
            template_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TASK_CREATED_OR_EDITED);
            template_id.DataBind();

            DisplayInCapYesNoComplete.Checked = true;
            TaskTypeFixedWork.Checked = true;
        }

        protected void save_Click(object sender, EventArgs e)
        {
            bool result = false;
            var param = GetParam();
            if (param == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('项目下任务过多，不能保存！');</script>");
                return;
            }
            if (isAdd)
            {
                result = new TaskBLL().AddTask(param, GetLoginUserId());
            }
            else
            {
                if (isCopy)
                {
                    param.task.id = 0;
                    param.task.oid = 0;
                    result = new TaskBLL().AddTask(param, GetLoginUserId());
                }
                else
                {
                    result = new TaskBLL().EditTask(param, GetLoginUserId());
                }
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='TaskAddOrEdit?id=" + param.task.id + "';</script>");
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");

        }

        protected void save_view_Click(object sender, EventArgs e)
        {
            bool result = false;
            var param = GetParam();
            if (param == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('项目下任务过多，不能保存！');</script>");
                return;
            }
            if (isAdd)
            {
                result = new TaskBLL().AddTask(param, GetLoginUserId());
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='TaskView?id=" + param.task.id + "';</script>");
            }
            else
            {
                if (isCopy)
                {
                    param.task.id = 0;
                    param.task.oid = 0;
                    result = new TaskBLL().AddTask(param, GetLoginUserId());
                }
                else
                {
                    result = new TaskBLL().EditTask(param, GetLoginUserId());
                }
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='TaskView?id=" + param.task.id + "';</script>");
            }
          
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
             //  var url = Request.Url;
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='TaskAddOrEdit?project_id="+thisProject.id+ "&type_id="+type_id+ "&par_task_id=" + Request.QueryString["par_task_id"] + "';</script>");
        }

        protected void save2_Click(object sender, EventArgs e)
        {
            bool result = false;
            var param = GetParam();
            if (param == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('项目下任务过多，不能保存！');</script>");
                return;
            }
            if (isAdd)
            {
                result = new TaskBLL().AddTask(param, GetLoginUserId());
            }
            else
            {
                if (isCopy)
                {
                    param.task.id = 0;
                    param.task.oid = 0;
                    result = new TaskBLL().AddTask(param, GetLoginUserId());
                }
                else
                {
                    result = new TaskBLL().EditTask(param, GetLoginUserId());
                }
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='TaskAddOrEdit?id="+ param.task.id+ "';</script>");

        }

        /// <summary>
        /// 保存Task相关操作
        /// </summary>
        private bool SaveTask()
        {
            bool result = false;
            var param = GetParam();
            if (param == null)
            {
                return false;
            }
            if (isAdd)
            {
                result = new TaskBLL().AddTask(param, GetLoginUserId());
            }
            else
            {
                if (isCopy)
                {
                    param.task.id = 0;
                    param.task.oid = 0;
                    result = new TaskBLL().AddTask(param, GetLoginUserId());
                }
                else
                {
                    result = new TaskBLL().EditTask(param, GetLoginUserId());
                }
                
            }

            return false;
        }
        /// <summary>
        /// 获取相应参数
        /// </summary>
        private TaskSaveDto GetParam()
        {

            TaskSaveDto param = AssembleModel<TaskSaveDto>();
            param.resDepIds = Request.Form["resDepList"];     // 员工角色 Id 
            param.contactIds = Request.Form["conIds"];        // 联系人 ID
            var preTaskIds = Request.Form["preIds"];    // 前驱任务IDs
            if (!string.IsNullOrEmpty(preTaskIds))
            {
                var preTasArr = preTaskIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                Dictionary<long, int> predic = new Dictionary<long, int>();
                foreach (var preTasId in preTasArr)
                {
                    var layDays = Request.Form[preTasId + "_lagDays"];
                    if ((!string.IsNullOrEmpty(layDays)) && (!string.IsNullOrWhiteSpace(layDays)))
                    {
                        predic.Add(long.Parse(preTasId), int.Parse(layDays));
                    }
                }
                param.predic = predic;
            }
            var pageTask = AssembleModel<sdk_task>();
            pageTask.cost_code_id = pageTask.cost_code_id == 0 ? null : pageTask.cost_code_id;
            if (pageTask.parent_id == null)
            {
                var subList = new sdk_task_dal().GetAllProTask(thisProject.id);
                if(subList!=null&& subList.Count >= 99)
                {
                    if (isAdd)
                    {
                        Response.Write("<script>alert('项目下任务过多，不能添加！');window.close();</script>");
                        return null;
                    }
                    else
                    {
                        if (!subList.Any(_=>_.id == thisTask.id))
                        {
                            Response.Write("<script>alert('项目下任务过多，不能保存！');window.close();</script>");
                            return null;
                        }
                    }
                   
                }
            }
            //if (parTask != null)
            //{
            //    pageTask.parent_id = parTask.id;
            //}
            if (type_id != (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
            {
                pageTask.is_visible_in_client_portal = (sbyte)(DisplayInCapNone.Checked ? 1 : 0);
                pageTask.can_client_portal_user_complete_task = (sbyte)(DisplayInCapYes.Checked ? 1 : 0);
                if (TaskTypeFixedWork.Checked)
                {
                    pageTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK;
                }
                else if (TaskTypeFixedDuration.Checked)
                {
                    pageTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION;
                }
            }
            else
            {
                if (rateList != null && rateList.Count > 0)
                {
                    Dictionary<long, decimal> rateDic = new Dictionary<long, decimal>();
                    foreach (var rate in rateList)
                    {
                        var hours = Request.Form[rate.id+ "_esHours"];
                        if (!string.IsNullOrEmpty(hours) && !string.IsNullOrWhiteSpace(hours))
                        {
                            rateDic.Add(rate.id,decimal.Parse(hours));
                        }
                    }
                    param.rateDic = rateDic;
                }
                pageTask.status_id = (int)DicEnum.TICKET_STATUS.NEW;
            }

            var startString = Request.Form["estimated_beginTime"];
            if (!string.IsNullOrEmpty(startString))
            {
                pageTask.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(startString));
               // if (type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE) // d
                //{
                    TimeSpan ts1 = new TimeSpan((DateTime.Parse(startString)).Ticks);
                    TimeSpan ts2 = new TimeSpan(((DateTime)pageTask.estimated_end_date).Ticks);
                    TimeSpan ts = ts1.Subtract(ts2).Duration();
                
                    //pageTask.estimated_duration = ts.Days + 1;
                // }
                // RetrunMaxTime 计算结束时间
                if (thisProject.use_resource_daily_hours == 1)  // 用工作量为固定工作任务计算时间
                {
                    decimal teaNum = 0;
                    var dayWorkHours = (decimal)thisProject.resource_daily_hours;
                    if (!string.IsNullOrEmpty(param.resDepIds))
                    {
                        teaNum += param.resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Count();
                    }
                    if (pageTask.owner_resource_id != null)
                    {
                        teaNum += 1;
                    }
                    teaNum = teaNum == 0 ? 1 : teaNum;
                    var workHours = pageTask.estimated_hours;
                    pageTask.estimated_duration = (int)Math.Ceiling(((workHours/teaNum)/ dayWorkHours));
                    pageTask.estimated_end_date = new TaskBLL().RetrunMaxTime(thisProject.id, DateTime.Parse(startString), (int)pageTask.estimated_duration);

                }
            
            }
            if (isAdd)
            {
                param.task = pageTask;
                param.task.type_id = type_id;
                param.task.project_id = thisProject.id;
                param.task.account_id = thisProject.account_id;
            }
            else
            {
                // thisTask
                thisTask.title = pageTask.title;
                thisTask.parent_id = pageTask.parent_id;
                thisTask.description = pageTask.description;
                if(thisTask.estimated_begin_time!= pageTask.estimated_begin_time)
                {
                    thisTask.estimated_begin_time = pageTask.estimated_begin_time;
                    thisTask.start_no_earlier_than_date = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time);
                }
                if (thisTask.estimated_end_date!= pageTask.estimated_end_date)
                {
                    thisTask.estimated_end_date = pageTask.estimated_end_date;
                    thisTask.estimated_duration = new TaskBLL().GetDayByTime((long)thisTask.estimated_begin_time,Tools.Date.DateHelper.ToUniversalTimeStamp((DateTime)pageTask.estimated_end_date),(long)thisTask.project_id);
                }
                else
                {
                    if (thisTask.estimated_duration != pageTask.estimated_duration)
                    {
                        thisTask.estimated_end_date = new TaskBLL().RetrunMaxTime(thisProject.id, DateTime.Parse(startString), (int)pageTask.estimated_duration);
                    }
                    else
                    {
                        thisTask.estimated_end_date = pageTask.estimated_end_date;
                        thisTask.estimated_duration = pageTask.estimated_duration;
                    }
                }
               


                if (!isPhase)
                {
                    thisTask.status_id = pageTask.status_id;
                    thisTask.priority = pageTask.priority;
                    thisTask.purchase_order_no = pageTask.purchase_order_no;
                    thisTask.can_client_portal_user_complete_task = pageTask.can_client_portal_user_complete_task;
                    thisTask.is_visible_in_client_portal = pageTask.is_visible_in_client_portal;
                    thisTask.is_project_issue = pageTask.is_project_issue;
                    thisTask.issue_report_contact_id = pageTask.issue_report_contact_id;
                    thisTask.estimated_type_id = pageTask.estimated_type_id;
                    thisTask.estimated_hours = pageTask.estimated_hours;
                     //      thisTask.estimated_duration = pageTask.estimated_duration;
                    thisTask.hours_per_resource = pageTask.hours_per_resource;
             //       thisTask.start_no_earlier_than_date = pageTask.start_no_earlier_than_date;
                    thisTask.department_id = pageTask.department_id;
                    thisTask.cost_code_id = pageTask.cost_code_id;
                    thisTask.owner_resource_id = pageTask.owner_resource_id;
                    thisTask.template_id = pageTask.template_id;
                    var IsEditEsTime = Request.Form["IsEditEsTime"];
                    var thisVt = new v_task_all_dal().FindById(thisTask.id);
                    if (!string.IsNullOrEmpty(IsEditEsTime))
                    {
                        thisTask.projected_variance = (thisVt.worked_hours == null ? 0 : (decimal)thisVt.worked_hours) - (thisTask.estimated_hours+(thisVt.change_Order_Hours==null?0:(decimal)thisVt.change_Order_Hours))+(thisVt.remain_hours==null?0:(decimal)thisVt.remain_hours);

                    }
                    else
                    {
                        thisTask.projected_variance = (thisVt.worked_hours == null ? 0 : (decimal)thisVt.worked_hours) - (thisTask.estimated_hours + (thisVt.change_Order_Hours == null ? 0 : (decimal)thisVt.change_Order_Hours));
                    }

                }
                param.task = thisTask;
            }

            if (task_udfList != null && task_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in task_udfList)                            // 循环添加
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



            return param;
        }

        protected void save_close2_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close();self.opener.location.reload();</script>");
            }
            // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
        }
    }
    
}