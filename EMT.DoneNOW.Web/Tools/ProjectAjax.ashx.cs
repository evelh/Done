﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.Core;
using System.Web.SessionState;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ProjectAjax 的摘要说明
    /// </summary>
    public class ProjectAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "GetTaskList":         // 获取到前置条件
                        var project_id = context.Request.QueryString["project_id"];
                        var showType = context.Request.QueryString["showType"];
                        GetTask(context, long.Parse(project_id), showType);
                        break;

                    case "GetSinProject":
                        var sin_project_id = context.Request.QueryString["project_id"];
                        GetSinProject(context, long.Parse(sin_project_id));
                        break;
                    case "GetProResDepIds":
                        var pro_id = context.Request.QueryString["project_id"];
                        var ids = context.Request.QueryString["ids"];
                        GetProResDepIds(context, long.Parse(pro_id), ids);
                        break;
                    case "DisProject":
                        var disProId = context.Request.QueryString["project_id"];
                        DisProject(context, long.Parse(disProId));
                        break;
                    case "SaveTemp":
                        SaveAsTemp(context);
                        break;
                    case "ImportFromTemp":
                        ImportFromTemp(context);
                        break;
                    case "DeletePro":
                        var dProId = context.Request.QueryString["project_id"];
                        DeletePro(context, long.Parse(dProId));
                        break;
                    case "GetSinTask":
                        var tid = context.Request.QueryString["task_id"];
                        GetSinTask(context, long.Parse(tid));
                        break;
                    case "GetLastPhaseId":
                        var cIds = context.Request.QueryString["ids"];
                        GetLastPhaseId(context, cIds);
                        break;
                    default:
                        context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                        break;
                }
            }
            catch (Exception msg)
            {
                context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
            }
        }
        /// <summary>
        /// 根据项目获取到该项目下的所有任务
        /// </summary>
        private void GetTask(HttpContext context, long project_id, string showType)
        {
            var project = new pro_project_dal().FindNoDeleteById(project_id);
            if (project != null)
            {
                taskString.Append($"<tr class='HighImportance'><td class='Interaction'><span class='Text'></span></td><td class='Nesting'><div data-depth='0' class='DataDepth'><div class='Spacer' style='width:0px;min-width:0px;'></div><div class='IconContainer'></div><div class='Value'>{project.name}</div></div></td>");
                switch (showType)
                {
                    case "showTime":
                        taskString.Append("<td class='Date'></td><td class='Date'></td>");
                        break;
                    case "Precondition":
                        taskString.Append("<td class='Text'></td>");
                        break;
                    default:
                        break;
                }
                taskString.Append("</tr>");
                // ");
                var stDal = new sdk_task_dal();
                var stList = stDal.GetAllProTask(project.id);  // 获取阶段，问题类型的task
                if (stList != null && stList.Count > 0)
                {
                    int data_depth = 0;
                    string interaction = "";
                    AddSubTask(null, stList, data_depth, interaction, showType);
                    context.Response.Write(taskString.ToString());
                }
            }
        }
        private StringBuilder taskString = new StringBuilder();
        /// <summary>
        /// 获取到这个任务的子集
        /// </summary>
        /// <param name="tid">父taskId 为空代表第一节点</param>
        /// <param name="sdkList">该节点下的子节点</param>
        /// <param name="data_depth">深度（样式调整，距离左边的距离）</param>
        /// <param name="interaction">序号</param>
        /// <param name="showType">显示类型（控制显示的数据）</param>
        private void AddSubTask(long? tid, List<sdk_task> sdkList, int data_depth, string interaction, string showType)
        {
            var subList = sdkList.Where(_ => _.parent_id == tid && (_.type_id == (int)TASK_TYPE.PROJECT_TASK || _.type_id == (int)TASK_TYPE.PROJECT_ISSUE || _.type_id == (int)TASK_TYPE.PROJECT_PHASE)).ToList();
            if (subList != null && subList.Count > 0)
            {
                // data_depth += 1;  
                subList = subList.OrderBy(_ => _.sort_order).ToList();
                foreach (var sub in subList)
                {
                    var showNo = "";
                    if (string.IsNullOrEmpty(interaction))
                    {
                        showNo = (subList.IndexOf(sub) + 1).ToString();
                    }
                    else
                    {
                        showNo = interaction+ "." + (subList.IndexOf(sub) + 1).ToString();
                    }
                    var isParent = "";
                    var thisSubList = sdkList.Where(_ => _.parent_id == sub.id && (_.type_id == (int)TASK_TYPE.PROJECT_TASK || _.type_id == (int)TASK_TYPE.PROJECT_ISSUE || _.type_id == (int)TASK_TYPE.PROJECT_PHASE)).ToList();
                    if (thisSubList != null && thisSubList.Count > 0)
                    {
                        isParent = "<div class='Toggle Collapse'><div class='Vertical' style='display: none;'></div><div class='Horizontal'></div></div>";
                    }
                    else
                    {
                    
                    }
                    taskString.Append($"<tr class='HighImportance' id='{sub.id}' value='{sub.id}' data-val='{sub.id}'><td class='Interaction'><span class='Text'>{showNo}</span></td><td class='Nesting'><div data-depth='{data_depth}' class='DataDepth'><div class='Spacer' style='width:{data_depth * 11}px;min-width:{data_depth * 11}px;'></div><div class='IconContainer'>{isParent}</div><div class='Value'>{sub.title}</div></div></td>");
                    switch (showType)
                    {
                        case "showTime":
                            taskString.Append($"<td class='Date'>{Tools.Date.DateHelper.ConvertStringToDateTime((long)sub.estimated_begin_time).ToString("yyyy-MM-dd")}</td><td class='Date'>{((DateTime)sub.estimated_end_date).ToString("yyyy-MM-dd")}</td>");
                            break;
                        case "Precondition":
                            taskString.Append("<td class='Text'></td>");
                            break;
                        default:

                            break;
                    }
                    taskString.Append("</tr>");
               
                    AddSubTask(sub.id, sdkList, data_depth + 1, showNo, showType);
                }
                // data_depth += 1;     预留 以后task多之后判断使用
            }
            else
            {
                return;
            }
        }

        /// <summary>
        /// 获取项目的task相关
        /// </summary>
        private void GetSinTask(HttpContext context, long task_id)
        {
            var task = new sdk_task_dal().FindNoDeleteById(task_id);
            if (task != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(task));
            }
        }

        private void GetSinProject(HttpContext context, long project_id)
        {
            var project = new pro_project_dal().FindNoDeleteById(project_id);
            if (project != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(project));
            }
        }
        /// <summary>
        /// 根据项目ID，获取到相对应的员工角色关系表ID
        /// </summary>
        private void GetProResDepIds(HttpContext context, long project_id, string resdepIDs)
        {
            var ids = ReturnResDepids(project_id, resdepIDs);
            context.Response.Write(ids);
        }

        /// <summary>
        ///  返回项目员工角色关系表ID
        /// </summary>
        private string ReturnResDepids(long project_id, string resdepIDs)
        {
            var pptDal = new pro_project_team_dal();
            var pptrDal = new pro_project_team_role_dal();
            var srdDal = new sys_resource_department_dal();
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);
            string ids = "";
            if (thisProject != null)
            {
                var proTeamList = pptDal.GetResListByProId(thisProject.id);
                if (proTeamList != null && proTeamList.Count > 0)
                {
                    List<string> idsList = new List<string>();
                    if (!string.IsNullOrEmpty(resdepIDs))
                    {
                        var resdepArr = resdepIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        idsList = resdepArr.ToList();
                    }
                    proTeamList.ForEach(_ =>
                    {
                        var teamRole = pptrDal.GetSinTeamRole(_.id);
                        if (teamRole != null && teamRole.role_id != null)
                        {
                            var resDepList = srdDal.GetResDepByResAndRole((long)_.resource_id, (long)teamRole.role_id);
                            foreach (var resdep in resDepList)
                            {
                                if (!idsList.Contains(resdep.id.ToString()))
                                {
                                    idsList.Add(resdep.id.ToString());
                                    break;
                                }
                            }
                        }
                    });
                    if (idsList != null && idsList.Count > 0)
                    {

                        idsList = idsList.Distinct().ToList();
                        idsList.ForEach(_ => { ids += _ + ','; });
                        if (!string.IsNullOrEmpty(ids))
                        {
                            ids = ids.Substring(0, ids.Length - 1);
                        }
                    }
                }
            }

            return ids;
        }

        /// <summary>
        /// 返回项目团队联系人ID
        /// </summary>
        private string ReturnConIds(long project_id)
        {
            var pptDal = new pro_project_team_dal();
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);
            var proTeamList = pptDal.GetConListByProId(project_id);
            string ids = "";
            if (thisProject != null && proTeamList != null && proTeamList.Count > 0)
            {
                proTeamList.ForEach(_ => { ids += ((long)_.contact_id).ToString() + ','; });
                if (!string.IsNullOrEmpty(ids))
                {
                    ids = ids.Substring(0, ids.Length - 1);
                }
            }
            return ids;
        }
        /// <summary>
        /// 停用项目
        /// </summary>
        private void DisProject(HttpContext context, long project_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            bool result = false;
            if (res != null)
            {
                result = new ProjectBLL().DisProject(project_id, res.id);
            }
            context.Response.Write(result);
        }

        /// <summary>
        /// 将项目转换为项目模板
        /// </summary>
        private void SaveAsTemp(HttpContext context)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            bool result = false;
            if (res != null)
            {
                var TranProjectId = context.Request.QueryString["TranProjectId"];
                var name = context.Request.QueryString["name"];
                var startDate = context.Request.QueryString["startDate"];
                var endDate = context.Request.QueryString["endDate"];
                var duration = context.Request.QueryString["duration"];
                var lineBuss = context.Request.QueryString["lineBuss"];
                var department_id = context.Request.QueryString["department_id"];
                var proLead = context.Request.QueryString["proLead"];
                var description = context.Request.QueryString["description"];
                var TempChooseTaskids = context.Request.QueryString["TempChooseTaskids"];
                var copyCalItem = context.Request.QueryString["copyCalItem"];
                var copyProCha = context.Request.QueryString["copyProCha"];
                var copyProTeam = context.Request.QueryString["copyProTeam"];
                try
                {
                    ProjectDto param = new ProjectDto();
                    var ppDal = new pro_project_dal();
                    var thisProject = ppDal.FindNoDeleteById(long.Parse(TranProjectId));
                    if (thisProject != null)
                    {
                        if ((!string.IsNullOrEmpty(name)) && (!string.IsNullOrEmpty(startDate)) && (!string.IsNullOrEmpty(endDate)) && (!string.IsNullOrEmpty(duration)))
                        {
                            thisProject.name = name;
                            thisProject.start_date = DateTime.Parse(startDate);
                            thisProject.end_date = DateTime.Parse(endDate);
                            thisProject.duration = int.Parse(duration);
                            thisProject.end_date = ((DateTime)thisProject.start_date).AddDays(((double)thisProject.duration) - 1);
                        }
                        if ((!string.IsNullOrEmpty(lineBuss)) && lineBuss != "0")
                        {
                            thisProject.line_of_business_id = int.Parse(lineBuss);
                        }
                        if ((!string.IsNullOrEmpty(department_id)) && department_id != "0")
                        {
                            thisProject.department_id = int.Parse(department_id);
                        }
                        if ((!string.IsNullOrEmpty(proLead)) && proLead != "0")
                        {
                            thisProject.owner_resource_id = long.Parse(proLead);
                        }
                        thisProject.description = description;
                        thisProject.template_id = null;
                        thisProject.status_id = (int)DicEnum.PROJECT_STATUS.NEW;
                        thisProject.type_id = (int)DicEnum.PROJECT_TYPE.TEMP;
                        param.project = thisProject;
                        var project_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                        var udfValue = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS, thisProject.id, project_udfList);
                        param.udf = udfValue;
                        param.fromTempId = thisProject.id.ToString();
                        param.tempChoTaskIds = TempChooseTaskids;


                        param.IsCopyCalendarItem = copyCalItem == "true" ? "1" : "";
                        param.IsCopyProjectCharge = copyProCha == "true" ? "1" : "";
                        param.IsCopyTeamMember = copyProTeam == "true" ? "1" : "";
                        if (!string.IsNullOrEmpty(param.IsCopyTeamMember))
                        {
                            param.resDepIds = ReturnResDepids(thisProject.id, "");
                            param.contactIds = ReturnConIds(thisProject.id);
                        }


                        param.project.id = ppDal.GetNextIdCom();
                        result = new ProjectBLL().AddPro(param, res.id);
                    }
                }
                catch (Exception msg)
                {

                    result = false;
                }


            }
            context.Response.Write(result);

        }
        /// <summary>
        ///  从模板导入
        /// </summary>
        private void ImportFromTemp(HttpContext context)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            bool result = false;
            if (res != null)
            {
                var tempId = context.Request.QueryString["project_temp_id"];
                var copyCalItem = context.Request.QueryString["copyCalItem"];
                var copyProCha = context.Request.QueryString["copyProCha"];
                var copyProTeam = context.Request.QueryString["copyProTeam"];
                var thisProjetcId = context.Request.QueryString["thisProjetcId"];
                var choIds = context.Request.QueryString["choIds"];
                new TaskBLL().ImportFromTemp(long.Parse(thisProjetcId), choIds,res.id,!string.IsNullOrEmpty(copyProTeam));
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 删除项目
        /// </summary>
        private void DeletePro(HttpContext context, long project_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            bool result = false;
            string reson = "";
            if (res != null)
            {
                result = new ProjectBLL().DeletePro(project_id, res.id, out reson);
            }
            context.Response.Write(new { result = result, reason = reson });
        }

        /// <summary>
        /// 保存为基准（新建type为基准的项目）
        /// </summary>
        private void SaveAsBaseline(HttpContext context,long project_id)
        {

        }
        /// <summary>
        /// 任务父阶段的修改 （修改后刷新页面排序方式改变）
        /// </summary>
        /// <param name="context"></param>
        /// <param name="project_id">项目Id</param>
        /// <param name="parent_id">父阶段ID</param>
        /// <param name="task_id">选择的task</param>
        /// <param name="location">位置（成为子节点或者兄弟节点）</param>
        private void ChangeTaskParent(HttpContext context, long project_id, long? parent_id, string taskIds, string location)
        {
            //  当父task是阶段，直接将parent_id指向阶段
            //  当父task不是阶段时，创建指向Task命名的阶段，同时将指向的task和选择的task 移向阶段之下
            //  没有父Task的时候直接放入项目下
            // todo
            var stDal = new sdk_task_dal();
            var tBll = new TaskBLL();
            var parentTask = stDal.FindNoDeleteById((long)parent_id);
            var res = context.Session["dn_session_user_info"] as sys_user;
            var user = UserInfoBLL.GetUserInfo(res.id);
            // 1.获取到要插入的位置，获取相关序号
            // 2.根据序号更改task排序号以及子节点相关排序号
            // 3.更改兄弟节点相关排序号以及兄弟节点的子节点的排序号
            // 4.更改插入位置的相关兄弟节点的排序号以及相关子节点的排序号

            if (!string.IsNullOrEmpty(taskIds))
            {
                var taskArr = taskIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                taskArr = taskArr.Reverse().ToArray(); // 进行倒序处理

                if (location == "in") // 插入节点里面成为子节点
                {
                    foreach (var taskId in taskArr)
                    {
                        var thisTaskNewSortNo = "";
                        var thisTask = stDal.FindNoDeleteById(long.Parse(taskId));
                        if (thisTask != null)
                        {
                            if (thisTask.parent_id != null)
                            {
                                if (taskArr.Contains(((long)thisTask.parent_id).ToString())) // 父节点已经处理，子节点不用处理
                                {
                                    continue;
                                }
                            }
                            
                            thisTask.parent_id = parent_id;
                            stDal.Update(thisTask);
                            thisTaskNewSortNo = tBll.ReturnSortOrder(project_id, parent_id);
                            tBll.ChangeTaskSortNo(thisTaskNewSortNo, thisTask.id, user);
                        }
                    }
                }
                else if (location == "above") // 插入节点上面成为兄弟节点(回取代原有的位置)
                {

                    // 类型为above,则parent_id为插入的兄弟节点的位置

                    // 处理顺序--1.原有兄弟节点相关改变，相关子节点改变
                    // 2.插入后的相关兄弟节点以及兄弟子节点的改变（倒序处理+1）

                    // 3.移动的节点的改变。相关子节点的改变

                    foreach (var taskId in taskArr)
                    {
                        var thisTask = stDal.FindNoDeleteById(long.Parse(taskId));
                        if (thisTask != null)
                        {
                            tBll.ChangBroTaskSortNoReduce(project_id,thisTask.parent_id,user);
                        }
                    }
                    tBll.ChangeBroTaskSortNoAdd((long)parent_id, taskArr.Count(),user);
                    long? reaParentId = null;  // 真正的父节点的id 
                
                    if (parent_id != null)
                    {
                        var broTask = stDal.FindNoDeleteById((long)parent_id);
                        if (broTask != null && broTask.parent_id != null)
                        {
                            reaParentId = (long)broTask.parent_id;
                        }
                    }
                    foreach (var taskId in taskArr)
                    {
                        var thisTask = stDal.FindNoDeleteById(long.Parse(taskId));
                        if (thisTask != null)
                        {
                            thisTask.parent_id = reaParentId;
                            
                            stDal.Update(thisTask);
                            var thisTaskNewSortNo = tBll.ReturnSortOrder(project_id, reaParentId);
                            tBll.ChangeTaskSortNo(thisTaskNewSortNo, thisTask.id, user);
                        }
                    }
                }
            }

            //var thisTask = stDal.FindNoDeleteById(task_id);
            //var res = context.Session["dn_session_user_info"] as sys_user;
            //bool result = false;
            //if (thisTask != null&&res!=null)
            //{
            //    thisTask.sort_order = new TaskBLL().ReturnSortOrder(project_id,parent_id);
            //    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, stDal.FindNoDeleteById(thisTask.id), thisTask.id, res.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
            //    result = new sdk_task_dal().Update(thisTask);
            //}
         
        }

        /// <summary>
        /// 根据选择的ids获取到最后的阶段id
        /// </summary>
        private void GetLastPhaseId(HttpContext context, string ids)
        {
            var phaseId = "";
            var stDal = new sdk_task_dal();
            var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = idArr.Length - 1; i >= 0; i--)
            {
                var thisTask = stDal.FindNoDeleteById(long.Parse(idArr[i]));
                if (thisTask != null && thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                {
                    phaseId = thisTask.id.ToString();
                    break;
                }
            }
            context.Response.Write(phaseId);
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}