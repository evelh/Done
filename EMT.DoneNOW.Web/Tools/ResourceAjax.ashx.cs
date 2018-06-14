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
                    case "GetResByDepRes":
                        GetResByDepRes(context);
                        break;
                    case "CheckResInResDepIds":
                        CheckResInResDepIds(context);
                        break;
                    case "GetResInfo":
                        GetResInfo(context);
                        break;
                    case "AddResInternalCost":
                        AddResInternalCost(context);
                        break;
                    case "DeleteResInternalCost":
                        DeleteResInternalCost(context);
                        break;
                    case "AddTimesheetApporver":
                        AddTimesheetApporver(context);
                        break;
                    case "AddExpenseApporver":
                        AddExpenseApporver(context);
                        break;
                    case "DeleteApprover":
                        DeleteApprover(context);
                        break;
                    case "GetDepartmentList":
                        GetDepartmentList(context);
                        break;
                    case "GetRoleList":
                        GetRoleList(context);
                        break;
                    case "AddDepartment":
                        AddDepartment(context);
                        break;
                    case "AddQueue":
                        AddQueue(context);
                        break;
                    case "DeleteDepartment":
                        DeleteDepartment(context);
                        break;
                    case "AddSkills":
                        AddSkills(context);
                        break;
                    case "AddCert":
                        AddCert(context);
                        break;
                    case "DeleteSkill":
                        DeleteSkill(context);
                        break;
                    case "DeleteAttachment":
                        DeleteAttachment(context);
						break;
                    case "GetResList":
                        GetResList(context);
                        break;
                    case "GetWorkList":
                        GetWorkList(context);
                        break;
                    case "ChechByResRole":
                        ChechByResRole(context);
                        break;  
                    case "ChangeResourceGoal":
                        ChangeResourceGoal(context);
                        break;  
                    case "ChangeUserDataProtected":
                        ChangeUserDataProtected(context);
                        break;
                    case "DeleteGroup":
                        DeleteGroup(context);
                        break;
                    case "DeleteGroupResource":
                        DeleteGroupResource(context);
                        break;
                    case "GetResApproval":
                        GetResApproval(context);
                        break;
                    case "ApprovalManage":
                        ApprovalManage(context);
                        break;
                    case "DeleteApproval":
                        DeleteApproval(context);
                        break;
                    case "GetResByIds":
                        GetResByIds(context);
                        break; 
                    case "GetResByDepId":
                        GetResByDepId(context);
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
        /// 添加员工内部成本
        /// </summary>
        /// <param name="context"></param>
        private void AddResInternalCost(HttpContext context)
        {
            var costList = context.Session["ResInternalCost"] as List<sys_resource_internal_cost>;
            if (string.IsNullOrEmpty(context.Request.QueryString["userId"]))
            {
                if (costList == null)
                    costList = new List<sys_resource_internal_cost>();
                context.Response.Write(new Tools.Serialize().SerializeJson(costList));
                return;
            }
            long userId = long.Parse(context.Request.QueryString["userId"]);
            if (userId == 0)
            {
                if (costList == null)
                    costList = new List<sys_resource_internal_cost>();
                sys_resource_internal_cost cost = new sys_resource_internal_cost();
                if (!string.IsNullOrEmpty(context.Request.QueryString["date"]))
                    cost.start_date = DateTime.Parse(context.Request.QueryString["date"]);
                if (cost.start_date != null)    // 填写了开始时间，计算其他项结束时间
                {
                    var fd = costList.Find(_ => _.start_date == cost.start_date);
                    if (fd != null)     // 开始时间不能重复
                    {
                        context.Response.Write(new Tools.Serialize().SerializeJson(false));
                        return;
                    }
                    if (costList[0].end_date != null && costList[0].end_date.Value >= cost.start_date.Value)    // 生效时间最前，作为第二条
                    {
                        costList[0].end_date = cost.start_date.Value.AddDays(-1);
                        cost.end_date = costList[1].start_date.Value.AddDays(-1);
                        costList.Insert(1, cost);
                    }
                    else if (costList[0].end_date == null)      // 当前只有一条，作为第二条
                    {
                        costList[0].end_date = cost.start_date.Value.AddDays(-1);
                        costList.Insert(1, cost);
                    }
                    else if (cost.start_date.Value > costList[costList.Count - 1].start_date.Value)     // 生效时间最后，最后一条
                    {
                        costList[costList.Count - 1].end_date = cost.start_date.Value.AddDays(-1);
                        costList.Add(cost);
                    }
                    else    // 生效时间在中间
                    {
                        for (int i = 1; i < costList.Count - 2; i++)
                        {
                            if (costList[i].start_date.Value < cost.start_date.Value && costList[i + 1].start_date.Value > cost.start_date.Value)   // 找到按顺序的时间前后项
                            {
                                costList[i].end_date = cost.start_date.Value.AddDays(-1);
                                cost.end_date = costList[i + 1].start_date.Value.AddDays(-1);
                                costList.Insert(i + 1, cost);
                            }
                        }
                    }
                }
                else if (costList.Count > 0)    // 有其他项需要填写开始时间
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(false));
                    return;
                }
                else    // 第一条
                {
                    costList.Add(cost);
                }
                cost.hourly_rate = decimal.Parse(context.Request.QueryString["rate"]);
                if (costList.Count == 0)
                    cost.id = 1;
                else
                    cost.id = costList.Max(_ => _.id) + 1;

                context.Session["ResInternalCost"] = costList;
                context.Response.Write(new Tools.Serialize().SerializeJson(costList));
                return;
            }
            else
            {
                if (!string.IsNullOrEmpty(context.Request.QueryString["add"]))
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().GetInternalCostList(userId)));
                    return;
                }
                DateTime dt = DateTime.MinValue;
                if (!string.IsNullOrEmpty(context.Request.QueryString["date"]))
                    dt = DateTime.Parse(context.Request.QueryString["date"]);
                var rtn = new BLL.UserResourceBLL().AddInternalCost(userId, dt, decimal.Parse(context.Request.QueryString["rate"]), LoginUserId);

                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
            }
        }

        /// <summary>
        /// 删除员工内部成本
        /// </summary>
        /// <param name="context"></param>
        private void DeleteResInternalCost(HttpContext context)
        {
            long userId = long.Parse(context.Request.QueryString["userId"]);
            if (userId == 0)
            {
                var costList = context.Session["ResInternalCost"] as List<sys_resource_internal_cost>;
                if (costList == null || costList.Count == 1)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(false));
                    return;
                }
                long id = long.Parse(context.Request.QueryString["id"]);

                int idx = costList.FindIndex(_ => _.id == id);
                if (idx == -1)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(false));
                    return;
                }
                if (idx == 0)   // 第一个
                {
                    costList[1].start_date = null;
                }
                else if (idx == costList.Count - 1)  // 最后一个
                {
                    costList[idx - 1].end_date = null;
                }
                else
                {
                    costList[idx - 1].end_date = costList[idx].end_date;
                }
                costList.RemoveAt(idx);
                context.Session["ResInternalCost"] = costList;
                context.Response.Write(new Tools.Serialize().SerializeJson(costList));
                return;
            }
            else
            {
                var rtn = new BLL.UserResourceBLL().DeleteInternalCost(userId, long.Parse(context.Request.QueryString["id"]), LoginUserId);
                if (rtn == null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(false));
                    return;
                }
                else
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
                    return;
                }
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
        /// 获取员工列表
        /// </summary>
        private void GetResList(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var resList = new sys_resource_dal().GetListByIds(ids);
                if (resList != null && resList.Count > 0)
                    context.Response.Write(new Tools.Serialize().SerializeJson(resList));
            }
        }
        /// <summary>
        ///  获取联系人列表
        /// </summary>
        private void GetWorkList(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var workList = new sys_workgroup_dal().GetList($" and id in ({ids})");
                if (workList != null && workList.Count > 0)
                    context.Response.Write(new Tools.Serialize().SerializeJson(workList));
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
                            var startDateLong = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                            var thisList = taskList.Where(_ => (_.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE || _.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK) && (_.estimated_begin_time < Tools.Date.DateHelper.ToUniversalTimeStamp(endDate) && _.estimated_end_time > startDateLong)).ToList();
                            if(thisList!=null&& thisList.Count > 0)
                            {
                                // 员工在这些天中已经分配的时长
                                var taskTotalHours = thisList.Sum(_ => {

                                    var thisDays = (decimal)_.hours_per_resource * GetDiffDays(startDate, endDate, Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_begin_time), Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_end_time), project.id);
                                    if (thisDays == 0|| _.hours_per_resource == null)
                                    {
                                        return 0;
                                    }
                                    else
                                    {
                                        // 计算员工平均工作时长
                                        TimeSpan ts1 = new TimeSpan(Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_begin_time).Ticks);
                                        TimeSpan ts2 = new TimeSpan(Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_end_time).Ticks);
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
                    if (!string.IsNullOrEmpty(timeInfo)&& thisTask.estimated_end_time != null)
                    {
                        timeInfo = timeInfo.Substring(0, timeInfo.Length-1);
                        context.Response.Write(new Tools.Serialize().SerializeJson(new {time=timeInfo,doneTime= Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_end_time).ToString("yyyy-MM-dd")}));

                    }
                }
            }
            
        }
        /// <summary>
        /// 返回选择的员工Id 和角色ID
        /// </summary>
        private void GetResByDepRes(HttpContext context)
        {
            var depResId = context.Request.QueryString["resDepId"];
            if (!string.IsNullOrEmpty(depResId))
            {
                var thisResDep = new sys_resource_department_dal().FindById(long.Parse(depResId));
                if (thisResDep != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(new { resId= thisResDep.resource_id, roleId = thisResDep.role_id }) );
                }
            }
        }
        /// <summary>
        ///  检查是否有重复的员工存在(主负责人查找带回时使用，有重复员工直接移除)
        /// </summary>
        /// <param name="context"></param>
        private void CheckResInResDepIds(HttpContext context)
        {
            var isRepeatRes = false;
            var depResId = context.Request.QueryString["resDepIds"];
            var priDepResId = context.Request.QueryString["resDepId"];
            if (!string.IsNullOrEmpty(depResId))
            {
                depResId = ClearRepeatRes(depResId);
            }
            var isDelete = !string.IsNullOrEmpty(context.Request.QueryString["isDelete"]);
            long? priResId = null;
            var srdDal = new sys_resource_department_dal();
            if (!string.IsNullOrEmpty(priDepResId))
            {
                var priDepRes = srdDal.FindById(long.Parse(priDepResId));
                if (priDepRes != null)
                {
                    priResId = priDepRes.resource_id;
                }
            }
            var priRes = context.Request.QueryString["priRes"];
            if (!string.IsNullOrEmpty(priRes))
                priResId = long.Parse(priRes);
            if (!string.IsNullOrEmpty(depResId)&& priResId != null)
            {
                var resDepList = srdDal.GetListByIds(depResId);
                if(resDepList!=null&& resDepList.Count > 0)
                {
                    var repeatResList = resDepList.Where(_ => _.resource_id == priResId).ToList();
                    if(repeatResList != null&& repeatResList.Count > 0)
                    {
                        isRepeatRes = true;
                        if (isDelete)
                        {
                            foreach (var item in repeatResList)
                            {
                                resDepList.Remove(item);
                            }
                            string newDepResIds = "";
                            if (resDepList != null && resDepList.Count > 0)
                            {
                                resDepList.ForEach(_ => {
                                    newDepResIds += _.id.ToString() + ',';
                                });
                                if (newDepResIds != "")
                                {
                                    newDepResIds = newDepResIds.Substring(0, newDepResIds.Length - 1);
                                }
                            }
                            depResId = newDepResIds;
                        }
                        
                    }
                    
                }
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(new { isRepeat= isRepeatRes, newDepResIds = depResId }));
        }

        /// <summary>
        /// 剔除掉选择的重复的员工
        /// </summary>
        private string ClearRepeatRes(string resDepIds)
        {
            string newResDepIds = resDepIds;
            var resDepList = new sys_resource_department_dal().GetListByIds(resDepIds);
            if(resDepList!=null&& resDepList.Count > 0)
            {
                var resDepArr = resDepList.ToArray();
                foreach (var resDep in resDepArr)
                {
                    // 获取到重复的员工信息
                    if (resDepList.Any(_=>_.id == resDep.id))
                    {
                        var repList = resDepArr.Where(thisResDep => thisResDep.id != resDep.id && thisResDep.resource_id == resDep.resource_id).ToList();
                        if (repList != null && repList.Count > 0)
                        {
                            repList.ForEach(_ => { resDepList.Remove(_); });
                        }
                        resDepArr = resDepList.ToArray();
                    }
                }
                if(resDepList!=null&& resDepList.Count > 0)
                {
                    newResDepIds = "";
                    resDepList.ForEach(_ => { newResDepIds += _.id.ToString() + ","; });
                    if (newResDepIds != "")
                    {
                        newResDepIds = newResDepIds.Substring(0, newResDepIds.Length-1);
                    }
                }
            }
            return newResDepIds;
        }
        /// <summary>
        /// 根据 员工Id 获取相关信息
        /// </summary>
        private void GetResInfo(HttpContext context)
        {
            var ids = context.Request.QueryString["resIds"];
            if (!string.IsNullOrEmpty(ids))
            {
                var oldResIds = context.Request.QueryString["oldResIds"];
                if (!string.IsNullOrEmpty(oldResIds))
                {
                   
                    var oldResArr = oldResIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                    var thisResArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    ids = "";
                    foreach (var thisResId in thisResArr)
                    {
                        if (!oldResArr.Contains(thisResId))
                            ids += thisResId+ ",";
                    }
                    if (ids != "")
                        ids = ids.Substring(0, ids.Length-1);
                }
                var resList = new sys_resource_dal().GetListByIds(ids);
                if(resList!=null&& resList.Count > 0)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(resList));
                }
            }
        }

        private void ChechByResRole(HttpContext context)
        {
            bool isRepeat = false;  //是否有重复
            var priResRole = context.Request.QueryString["ResRole"];
            var otherIds = context.Request.QueryString["OtherIds"];
            if(!string.IsNullOrEmpty(priResRole)&& !string.IsNullOrEmpty(otherIds))
            {
                otherIds = ClearRepeatRes(otherIds);
                var priArr = priResRole.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                var resDepList = new sys_resource_department_dal().GetListByIds(otherIds);
                if(priArr.Count()==2&& resDepList!=null&& resDepList.Count > 0)
                {
                    var thisResDep = resDepList.FirstOrDefault(_ => _.resource_id.ToString() == priArr[0]);
                    if (thisResDep != null)
                    {
                        isRepeat = true;
                        resDepList.Remove(thisResDep);
                        otherIds = string.Empty;
                        resDepList.ForEach(_ => {
                            otherIds += _.id.ToString() + ',';
                        });
                        if (!string.IsNullOrEmpty(otherIds))
                            otherIds = otherIds.Substring(0, otherIds.Length-1);
                    }
                   
                }
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(new { isRepeat = isRepeat, newDepResIds = otherIds }));


        }
        // CheckResInResDepIds


        /// <summary>
        /// 添加员工工时表审批人
        /// </summary>
        /// <param name="context"></param>
        private void AddTimesheetApporver(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            long approver = long.Parse(context.Request.QueryString["approver"]);
            int tier = int.Parse(context.Request.QueryString["tier"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddApprover(approver, tier, resId, DTO.DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE)));
        }

        /// <summary>
        /// 添加员工费用报表审批人
        /// </summary>
        /// <param name="context"></param>
        private void AddExpenseApporver(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            long approver = long.Parse(context.Request.QueryString["approver"]);
            int tier = int.Parse(context.Request.QueryString["tier"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddApprover(approver, tier, resId, DTO.DicEnum.APPROVE_TYPE.EXPENSE_APPROVE)));
        }

        /// <summary>
        /// 删除员工审批人
        /// </summary>
        /// <param name="context"></param>
        private void DeleteApprover(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().DeleteApprover(id)));
        }

        /// <summary>
        /// 获取部门列表
        /// </summary>
        /// <param name="context"></param>
        private void GetDepartmentList(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request.QueryString["dptType"]))
                context.Response.Write(new Tools.Serialize().SerializeJson(new sys_department_dal().GetDepartment()));
            else
                context.Response.Write(new Tools.Serialize().SerializeJson(new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE)));
        }

        /// <summary>
        /// 获取角色列表
        /// </summary>
        /// <param name="context"></param>
        private void GetRoleList(HttpContext context)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(new sys_role_dal().GetList()));
        }

        /// <summary>
        /// 新增员工技能
        /// </summary>
        /// <param name="context"></param>
        private void AddSkills(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            int cate = int.Parse(context.Request.QueryString["cate"]);
            int level = int.Parse(context.Request.QueryString["level"]);
            string desc = context.Request.QueryString["desc"];
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddSkill(resId, cate, level, desc, null, LoginUserId)));
        }

        /// <summary>
        /// 删除员工技能
        /// </summary>
        /// <param name="context"></param>
        private void DeleteSkill(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().DeleteSkill(id)));
        }

        private void AddCert(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            int cate = int.Parse(context.Request.QueryString["cate"]);
            string desc = context.Request.QueryString["desc"];
            sbyte complete = sbyte.Parse(context.Request.QueryString["complete"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddSkill(resId, cate, null, desc, complete, LoginUserId)));
        }

        /// <summary>
        /// 添加员工部门
        /// </summary>
        /// <param name="context"></param>
        private void AddDepartment(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            long dptId = long.Parse(context.Request.QueryString["dptId"]);
            long role = long.Parse(context.Request.QueryString["role"]);
            sbyte dft = sbyte.Parse(context.Request.QueryString["dft"]);
            sbyte dpt = sbyte.Parse(context.Request.QueryString["dpt"]);
            sbyte act = sbyte.Parse(context.Request.QueryString["isact"]);
            sys_resource_department department = new sys_resource_department
            {
                department_id = dptId,
                is_active = act,
                is_default = dft,
                is_lead = dpt,
                resource_id = resId,
                role_id = role
            };
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddDepartment(department, 1, LoginUserId)));
        }

        /// <summary>
        /// 新增员工服务队列
        /// </summary>
        /// <param name="context"></param>
        private void AddQueue(HttpContext context)
        {
            long resId = long.Parse(context.Request.QueryString["resId"]);
            long queId = long.Parse(context.Request.QueryString["queId"]);
            long role = long.Parse(context.Request.QueryString["role"]);
            sbyte dft = sbyte.Parse(context.Request.QueryString["dft"]);
            sbyte isact = sbyte.Parse(context.Request.QueryString["isact"]);
            sys_resource_department department = new sys_resource_department
            {
                department_id = queId,
                is_active = isact,
                is_default = dft,
                is_lead = null,
                resource_id = resId,
                role_id = role
            };
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().AddDepartment(department, 2, LoginUserId)));
        }

        /// <summary>
        /// 删除员工部门
        /// </summary>
        /// <param name="context"></param>
        private void DeleteDepartment(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.UserResourceBLL().DeleteDepartment(id)));
        }

        /// <summary>
        /// 删除员工附件
        /// </summary>
        /// <param name="context"></param>
        private void DeleteAttachment(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            new BLL.AttachmentBLL().DeleteAttachment(id, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }
        /// <summary>
        /// 更改用户的周目标设置
        /// </summary>
        private void ChangeResourceGoal(HttpContext context)
        {
            long resAvaId; decimal goal;
            long.TryParse(context.Request.QueryString["id"],out resAvaId);
            decimal.TryParse(context.Request.QueryString["goal"], out goal);
            bool result = false;
            if (resAvaId != 0)
                result = new BLL.UserResourceBLL().EditResAvaGoal(resAvaId, goal,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 编辑用户的被保护权限
        /// </summary>
        private void ChangeUserDataProtected(HttpContext context)
        {
            long resId=0;
            bool result = false;
            if (long.TryParse(context.Request.QueryString["id"], out resId))
            {
                var thisRes = new BLL.UserResourceBLL().GetResourceById(resId);
                if (thisRes != null)
                {
                    result = new BLL.UserResourceBLL().EditResProtected(resId, context.Request.QueryString["isEdit"] =="1", context.Request.QueryString["isView"] == "1", context.Request.QueryString["isEditUn"] == "1", context.Request.QueryString["isViewUn"] == "1", LoginUserId);
                }
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        /// 删除员工工作组
        /// </summary>
        /// <param name="context"></param>
        private void DeleteGroup(HttpContext context)
        {
            var result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                if (long.TryParse(context.Request.QueryString["id"], out id))
                    result = new BLL.UserResourceBLL().DeleteGroup(id,LoginUserId);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除员工工作组员工
        /// </summary>
        /// <param name="context"></param>
        private void DeleteGroupResource(HttpContext context)
        {
            var result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                if (long.TryParse(context.Request.QueryString["id"], out id))
                    result = new BLL.UserResourceBLL().DeleteGroupResource(id, LoginUserId);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 获取审批设置相关信息
        /// </summary>
        private void GetResApproval(HttpContext context)
        {
            long resId = 0;

            if (!string.IsNullOrEmpty(context.Request.QueryString["resId"])&&long.TryParse(context.Request.QueryString["resId"], out resId))
            {
                int typeId = (int)DTO.DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE;
                if(!string.IsNullOrEmpty(context.Request.QueryString["type"]) && context.Request.QueryString["type"]=="expense")
                    typeId = (int)DTO.DicEnum.APPROVE_TYPE.EXPENSE_APPROVE;
                BLL.UserResourceBLL userBll = new BLL.UserResourceBLL();
                List<sys_resource_approver> approList = userBll.GetApprover(resId, typeId);
                List<sys_resource> allResList = new DAL.sys_resource_dal().GetSourceList();
                List<ResAndWorkGroDto> appDtoList = new List<ResAndWorkGroDto>();
                if(approList!=null&& approList.Count>0&& allResList!=null&& allResList.Count > 0)
                {
                    appDtoList = (from a in approList
                                 join b in allResList on a.resource_id equals b.id
                                 select new ResAndWorkGroDto {name=b.name,id=b.id,isActive=b.is_active==1?"":"unActive",tier=a.tier.ToString() }).ToList();
                }

                List<sys_resource> noAppRes = userBll.GetResourceNoApprover(resId, typeId);
                WriteResponseJson(new {appro= appDtoList,noAppro= noAppRes });
            }
        }
        /// <summary>
        /// 员工审批设置管理
        /// </summary>
        void ApprovalManage(HttpContext context)
        {
            string resId = context.Request.QueryString["resId"];
            string toResIds = context.Request.QueryString["toResIds"];
            int type = (int)DTO.DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE;
            if(!string.IsNullOrEmpty(context.Request.QueryString["type"]) && context.Request.QueryString["type"] =="expense")
                type = (int)DTO.DicEnum.APPROVE_TYPE.EXPENSE_APPROVE;
            bool result = false;
            if (!string.IsNullOrEmpty(resId) && !string.IsNullOrEmpty(toResIds))
                result = new BLL.UserResourceBLL().ApprovalSet(long.Parse(resId), toResIds,LoginUserId,type);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除员工审批
        /// </summary>
        void DeleteApproval(HttpContext context)
        {
            string resId = context.Request.QueryString["resId"];
            int type = (int)DTO.DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE;
            if (!string.IsNullOrEmpty(context.Request.QueryString["type"]) && context.Request.QueryString["type"] == "expense")
                type = (int)DTO.DicEnum.APPROVE_TYPE.EXPENSE_APPROVE;
            bool result = false;
            if (!string.IsNullOrEmpty(resId) )
                result = new BLL.UserResourceBLL().DeleteUserApproval(long.Parse(resId), type,LoginUserId);
            WriteResponseJson(result);
        }

        void GetResByIds(HttpContext context)
        {
            if(!string.IsNullOrEmpty(context.Request.QueryString["resIds"]))
            {
                List<sys_resource> resList = new sys_resource_dal().GetListByIds( context.Request.QueryString["resIds"], false);
                if (resList != null && resList.Count > 0)
                    WriteResponseJson(resList);
            }
        }
        /// <summary>
        /// 获取部门下的员工
        /// </summary>
        void GetResByDepId(HttpContext context)
        {
            if (!string.IsNullOrEmpty(context.Request.QueryString["depId"]))
            {
                List<sys_resource> resList = new sys_resource_dal().GetResByDepId(long.Parse(context.Request.QueryString["depId"]));
                if (resList != null && resList.Count > 0)
                    WriteResponseJson(resList);
            }

            
        }
    }
   
    public class ResAndWorkGroDto
    {
        public long id;
        public string name;
        public string email;
        public string type;
        public string isActive;
        public string tier;
    }
}