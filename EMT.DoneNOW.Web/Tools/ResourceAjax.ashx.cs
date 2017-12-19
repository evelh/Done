using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ResourceAjax 的摘要说明
    /// </summary>
    public class ResourceAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "GetInfo":
                        var resou_id = context.Request.QueryString["id"];
                        GetResouInfo(context, long.Parse(resou_id));
                        break;
                    case "GetResouList":
                        var resIds = context.Request.QueryString["ids"];
                        var isReSouIds = context.Request.QueryString["isReSouIds"];
                        GetResousByResDepIds(context,resIds,!string.IsNullOrEmpty(isReSouIds));
                        break;
                    case "GetWorkName":
                        var wIds = context.Request.QueryString["ids"];
                        GetWorkName(context,wIds);
                        break;
                    case "GetActiveRes":
                        GetActiveRes(context);
                        break;
                    case "GetResAndWorkGroup":
                        GetResAndWorkGroup(context);
                        break;
                    case "CheckTeamRes":
                        var teamIds = context.Request.QueryString["resDepIds"];
                        CheckTeamRes(context,teamIds);
                        break;
                    case "CheckPriResInTeam":
                        var priResId = context.Request.QueryString["resource_id"];
                        var teaIds = context.Request.QueryString["resDepIds"];
                        CheckPriResInTeam(context, teaIds,long.Parse(priResId));
                        break;
                    case "CheckResAvailability":
                        CheckResAvailability(context);
                        break;
                    case "CheckResTimeOff":
                        var crtTaskId = context.Request.QueryString["task_id"];
                        CheckResTimeOff(context,long.Parse(crtTaskId));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        /// <summary>
        /// 获取员工相关信息
        /// </summary>
        private void GetResouInfo(HttpContext context,long sys_resource_id)
        {
            var sys_res = new sys_resource_dal().FindNoDeleteById(sys_resource_id);
            if (sys_res != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(sys_res));
            }
        }
        /// <summary>
        /// 根据关系表获取员工信息
        /// </summary>
        private void GetInfoByDepId(HttpContext context, long depId)
        {
            var thisDepRes = new sys_resource_department_dal().FindNoDeleteById(depId);
            if (thisDepRes != null)
            {
                GetResouInfo(context,thisDepRes.resource_id);
            }
        }
        /// <summary>
        /// 返回员工相关邮箱(根据 员工，角色关系表)
        /// </summary>
        private void GetResousByResDepIds(HttpContext context, string ids,bool isResoIds)
        {
            List<sys_resource> resList = null;
            if (isResoIds)
            {
                resList = new sys_resource_dal().GetListByIds(ids);
            }
            else
            {
                resList = new sys_resource_dal().GetListByDepIds(ids);
            }
             
            if (resList != null && resList.Count > 0)
            {
                StringBuilder emailStringBuilder = new StringBuilder();
                resList.ForEach(_ => emailStringBuilder.Append(_.name+";"));
                var emailString = emailStringBuilder.ToString();
                if (!string.IsNullOrEmpty(emailString))
                {
                    // emailString = emailString.Substring(0, emailString.Length - 1);
                    context.Response.Write(emailString);
                }
            }
        }
        /// <summary>
        /// 获取工作组名称
        /// </summary>
        private void GetWorkName(HttpContext context, string ids)
        {
            var workList = new sys_workgroup_dal().GetList($" and id in ({ids})");

            if (workList != null && workList.Count > 0)
            {
                StringBuilder workStringBuilder = new StringBuilder();
                workList.ForEach(_ => workStringBuilder.Append(_.name + ";"));
                var workString = workStringBuilder.ToString();
                if (!string.IsNullOrEmpty(workString))
                {
                    context.Response.Write(workString);
                }
            }
        }
        /// <summary>
        /// 获取所有可用的员工信息
        /// </summary>
        private void GetActiveRes(HttpContext context)
        {
            var resList = new sys_resource_dal().GetSourceList();
            if (resList != null && resList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(resList));
            }
        }
        /// <summary>
        /// 获取到员工和工作组
        /// </summary>
        private void GetResAndWorkGroup(HttpContext context)
        {
            var resAndworList = new List<ResAndWorkGroDto>();

            var resList = new sys_resource_dal().GetSourceList();
            if (resList != null && resList.Count > 0)
            {
                var thisLsit = from a in resList
                               select new ResAndWorkGroDto() { id = a.id, name = a.name, email = a.email, type = "checkRes" };
                resAndworList.AddRange(thisLsit);
            }
            var workList = new sys_workgroup_dal().GetList();
            if(workList!=null&& workList.Count > 0)
            {
                var thisLsit = from a in workList
                               select new ResAndWorkGroDto() { id = a.id, name = a.name, email = "", type = "checkWork" };
                resAndworList.AddRange(thisLsit);
            }

            context.Response.Write(new Tools.Serialize().SerializeJson(resAndworList));
        }
        /// <summary>
        /// 校验是否有重复员工
        /// </summary>
        private void CheckTeamRes(HttpContext context,string ids)
        {
            var result = false;
            var sdrDal = new sys_resource_department_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var resList = sdrDal.GetListByIds(ids);
                if (resList != null && resList.Count > 0)
                {
                    var resArr = resList.Select(_ => _.resource_id).ToList();
                    if(resArr!=null&& resArr.Count > 0)
                    {
                        if (resArr.Count!= resList.Count)
                        {
                            result = false;
                        }
                    }
                }
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 校验员工id是否在关系表中出现
        /// </summary>
        private void CheckPriResInTeam(HttpContext context, string ids,long priResId)
        {
            var result = false;
            var sdrDal = new sys_resource_department_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var resList = sdrDal.GetListByIds(ids);
                if (resList != null && resList.Count > 0)
                {
                    var thisResList = resList.Where(_ => _.resource_id == priResId).ToList();
                    if(thisResList!=null&& thisResList.Count > 0)
                    {
                        result = true;
                    }
                }
            }

            context.Response.Write(result);
        }
        /// <summary>
        /// 检查员工的可用性
        /// </summary>
        private void CheckResAvailability(HttpContext context)
        {
            // 在同一项目下校验
            try
            {
                var project_id = context.Request.QueryString["project_id"];
                var resId = context.Request.QueryString["res_id"];
                var startTime = context.Request.QueryString["startTime"];  // 开始时间
                var endTime = context.Request.QueryString["endTime"];
                var days = context.Request.QueryString["days"];  // 持续时间
                var thisTaskRpeHour = context.Request.QueryString["thisTaskRpeHour"]; // 这个员工在这个任务中的日工作时间
                if (!string.IsNullOrEmpty(project_id)&& !string.IsNullOrEmpty(resId) && !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime)&& !string.IsNullOrEmpty(thisTaskRpeHour))
                {
                    var project = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                    var taskList = new sdk_task_dal().GetListByProAndRes(long.Parse(project_id),long.Parse(resId));
                    int readDays = 0;
                    var startDate = DateTime.Parse(startTime);
                    var endDate = DateTime.Parse(endTime);
                    if (!string.IsNullOrEmpty(days))
                    {
                        readDays = int.Parse(days);
                        endDate = new BLL.TaskBLL().RetrunMaxTime(project.id, startDate, readDays);
                    }
                    else
                    {

                        readDays = new BLL.TaskBLL().GetDayByTime(Tools.Date.DateHelper.ToUniversalTimeStamp(startDate), Tools.Date.DateHelper.ToUniversalTimeStamp(endDate), long.Parse(project_id));
                    }
                    if (readDays != 0)
                    {
                        // 员工在这个项目中应该工作的时长
                        var totalHours = readDays * (decimal)project.resource_daily_hours;

                        if(taskList!=null&& taskList.Count > 0)
                        {
                            var thisList = taskList.Where(_ => (_.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE || _.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK) && (_.estimated_begin_time < Tools.Date.DateHelper.ToUniversalTimeStamp(endDate) && _.estimated_end_date > startDate)).ToList();
                            if(thisList!=null&& thisList.Count > 0)
                            {
                                // 员工在这些天中已经分配的时长
                                var taskTotalHours = thisList.Sum(_ => {

                                    var thisDays = (decimal)_.hours_per_resource * GetDiffDays(startDate, endDate, Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_begin_time), (DateTime)_.estimated_end_date, project.id);
                                    if (thisDays == 0|| _.hours_per_resource == null)
                                    {
                                        return 0;
                                    }
                                    else
                                    {
                                        // 计算员工平均工作时长
                                        TimeSpan ts1 = new TimeSpan(Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_begin_time).Ticks);
                                        TimeSpan ts2 = new TimeSpan(((DateTime)_.estimated_end_date).Ticks);
                                        var allDays = ts1.Subtract(ts2).Duration().Days;
                                        return ((decimal)_.hours_per_resource / allDays) * thisDays;
                                    }
                                 
                                });
                                // 员工的剩余时长
                                 var shengyuHours = totalHours - taskTotalHours;
                                var preHours = decimal.Parse(thisTaskRpeHour);
                                var result = shengyuHours > preHours;
                                context.Response.Write(new {result = result,reason = shengyuHours.ToString("#0.00")});

                            }

                        }
                    }
                    //pageTask.estimated_duration = ts.Days + 1;


                }
            }
            catch (Exception)
            {
                
            }
        }
        /// <summary>
        /// 计算日期交叉天数
        /// </summary>
        public int GetDiffDays(DateTime firstStartDate, DateTime firstEndDate, DateTime secStartDate, DateTime secEndDate,long project_id)
        {
            // 四种情况

            DateTime realStartDate = firstStartDate;
            DateTime realEndDate = firstEndDate;

            if (secStartDate<= firstStartDate)
            {
                if(secEndDate<= firstEndDate)
                {
                    realEndDate = secEndDate;
                }
            }
            else
            {
                realStartDate = secStartDate;
                if (secEndDate <= firstEndDate)
                {
                    realEndDate = secEndDate;
                }
            }

            return new BLL.TaskBLL().GetDayByTime(Tools.Date.DateHelper.ToUniversalTimeStamp(realStartDate), Tools.Date.DateHelper.ToUniversalTimeStamp(realEndDate), project_id);
         
        }
        /// <summary>
        /// 校验员工在任务计划期间是否有审批通过的请假记录，有，则告警
        /// </summary>
        /// <param name="context"></param>
        /// <param name="task_id"></param>
        
        private void CheckResTimeOff(HttpContext context,long task_id)
        {
            var thisTask = new sdk_task_dal().FindNoDeleteById(task_id);
            if (thisTask != null && thisTask.owner_resource_id != null)
            {
                var timeList = new tst_timeoff_request_dal().GetListByTaskAndRes(thisTask.id,(long)thisTask.owner_resource_id);
                if (timeList != null && timeList.Count > 0)
                {
                    string timeInfo = "";
                    timeList.ForEach(_=> {
                        timeInfo += $"{Tools.Date.DateHelper.ConvertStringToDateTime(_.create_time).ToString("yyyy-MM-dd")} ({_.request_hours.ToString("#0.00")} 小时)"+",";
                    });
                    if (!string.IsNullOrEmpty(timeInfo)&& thisTask.estimated_end_date!=null)
                    {
                        timeInfo = timeInfo.Substring(0, timeInfo.Length-1);
                        context.Response.Write(new Tools.Serialize().SerializeJson(new {time=timeInfo,doneTime=((DateTime)thisTask.estimated_end_date).ToString("yyyy-MM-dd")}));

                    }
                }
            }
            
        }
    }
   
    public class ResAndWorkGroDto
    {
        public long id;
        public string name;
        public string email;
        public string type;
    }
}