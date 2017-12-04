using System;
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
    public class ProjectAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
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
                    case "GetSinProject":     // 获取单个项目信息
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
                    case "IsHasNoDoneTask":
                        var pId = context.Request.QueryString["project_id"];
                        IsHasNoDoneTask(context, long.Parse(pId));
                        break;
                    case "CompleteProject":
                        var cpId = context.Request.QueryString["project_id"];
                        var reason = context.Request.QueryString["reason"];
                        CompleteProject(context, long.Parse(cpId), reason);
                        break;
                    case "UpdateProSet":  // 更改项目设置
                        UpdateProSet(context);
                        break;
                    case "RecalculateProject":
                        var rPid = context.Request.QueryString["project_id"];
                        RecalculateProject(context, long.Parse(rPid));
                        break;
                    case "SaveAsBaseline":
                        var spId = context.Request.QueryString["project_id"];
                        SaveAsBaseline(context, long.Parse(spId));
                        break;
                    case "ChangeTaskTime":
                        var taskIds = context.Request.QueryString["ids"];
                        var sDays = context.Request.QueryString["days"];
                        ChangeTaskTime(context, taskIds, int.Parse(sDays));
                        break;
                    case "CompleteTask":
                        var comTaskIds = context.Request.QueryString["ids"];
                        var comReason = context.Request.QueryString["reason"];
                        CompleteTask(context, comTaskIds, comReason);
                        break;
                    case "DeleteTasks":
                        var dTaskIds = context.Request.QueryString["taskIds"];
                        var isDelSub = context.Request.QueryString["delSub"];
                        DeleteTasks(context, dTaskIds, string.IsNullOrEmpty(isDelSub));
                        break;
                    case "Indend":
                        var iTaskId = context.Request.QueryString["taskId"];
                        Indend(context, long.Parse(iTaskId));
                        break;
                    case "Outdend":
                        var oTaskId = context.Request.QueryString["taskId"];
                        Outdent(context, long.Parse(oTaskId));
                        break;
                    case "GetProByRes":
                        GetProByRes(context, long.Parse(context.Request.QueryString["resource_id"]), context.Request.QueryString["showType"], !string.IsNullOrEmpty(context.Request.QueryString["isShowCom"]),long.Parse(context.Request.QueryString["account_id"]));
                        break;
                    case "GetTaskByRes":
                        GetTaskByRes(context, long.Parse(context.Request.QueryString["resource_id"]), context.Request.QueryString["showType"], !string.IsNullOrEmpty(context.Request.QueryString["isShowCom"]), long.Parse(context.Request.QueryString["project_id"]));
                        break;
                    case "DeleteEntry":
                        var eId = context.Request.QueryString["entry_id"];
                        DeleteEntry(context,long.Parse(eId));
                        break;
                    case "GetTaskFileSes":
                        var stId = context.Request.QueryString["object_id"];
                        GetTaskFileSes(context,long.Parse(stId));
                        break;
                    case "RemoveSess":
                        var rstId = context.Request.QueryString["object_id"];
                        var indNum = context.Request.QueryString["index"];
                        RemoveSession(context,long.Parse(rstId),int.Parse(indNum));
                        break;
                    case "GetProTaskList":
                        var gpId = context.Request.QueryString["project_id"];
                        GetProTaskList(context, long.Parse(gpId));
                        break;
                    case "DeleteExpense":
                        var delEId = context.Request.QueryString["exp_id"];
                        DeleteExpense(context,long.Parse(delEId));
                        break;
                    case "DeleteNote":
                        var note_id = context.Request.QueryString["note_id"];
                        DeleteNote(context,long.Parse(note_id));
                        break;
                    case "AssMile":    // 关联里程碑
                        var assIds = context.Request.QueryString["mileIds"];
                        var phaId = context.Request.QueryString["phaId"];
                        if (!string.IsNullOrEmpty(phaId))
                        {
                            AssMile(context, assIds, long.Parse(phaId));
                        }
                        break;
                    case "DisAssMile":     // 取消关联里程碑
                        var disAssIds = context.Request.QueryString["mileIds"];
                        DisAssMile(context, disAssIds);
                        break;
                    case "ToReadyBill":     // 更改里程碑状态
                        var tbIds = context.Request.QueryString["mileIds"];
                        ToReadyBill(context,tbIds);
                        break;
                    case "CancelTask":   // 取消任务
                        var canTaskId = context.Request.QueryString["task_id"];
                        if (!string.IsNullOrEmpty(canTaskId))
                        {
                            CancelTask(context, long.Parse(canTaskId));
                        }
                        break;
                    case "RecoveTask":   // 恢复任务
                        var recTaskId = context.Request.QueryString["task_id"];
                        if (!string.IsNullOrEmpty(recTaskId))
                        {
                            RecoveTask(context, long.Parse(recTaskId));
                        }
                        break;
                    case "GetSinProTeam":
                        var ptId = context.Request.QueryString["team_id"];
                        GetSinProTeam(context,long.Parse(ptId));
                        break;
                    case "DelProTeam":
                        var dptId = context.Request.QueryString["team_id"];
                        var dptPId = context.Request.QueryString["project_id"];
                        DelProTeam(context,long.Parse(dptPId),long.Parse(dptId));
                        break;
                    case "ResIsInTask":
                        var ritPId = context.Request.QueryString["project_id"];
                        var ritRId = context.Request.QueryString["team_id"];
                        ResIsInTask(context,long.Parse(ritPId),long.Parse(ritRId));
                        break;
                    case "ResInPro":
                        var ripPid = context.Request.QueryString["project_id"];
                        var ripRid = context.Request.QueryString["resource_id"];
                        ResInPro(context,long.Parse(ripPid),long.Parse(ripRid));
                        break;
                    case "ReconcileProject":
                        var rpId = context.Request.QueryString["project_id"];
                        ReconcileProject(context,long.Parse(rpId));
                        break;
                    case "GetSinExpense":
                        var exp_id = context.Request.QueryString["exp_id"];
                        GetSinExpense(context,long.Parse(exp_id));
                        break;
                    case "BillExpense":
                        var billExpIds = context.Request.QueryString["ids"];
                        BillManyExpense(context,billExpIds, !string.IsNullOrEmpty(context.Request.QueryString["isbill"]));
                        break;
                    case "BillSingExp":
                        var sinExpId = context.Request.QueryString["exp_id"];
                        BillSingExp(context,long.Parse(sinExpId),!string.IsNullOrEmpty(context.Request.QueryString["isbill"]));
                        break;
                    case "DeleteSinExp":
                        var dsExpId = context.Request.QueryString["exp_id"];
                        DeleteSinExp(context,long.Parse(dsExpId));
                        break;
                    case "DeleteManyExp":
                        var deIds = context.Request.QueryString["ids"];
                        DeleteManyExp(context,deIds);
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
                        showNo = interaction + "." + (subList.IndexOf(sub) + 1).ToString();
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
                        var teamRoleList = pptrDal.GetListTeamRole(_.id);
                        if (teamRoleList != null && teamRoleList.Count>0)
                        {
                            foreach (var thisTeamRole in teamRoleList)
                            {
                                if (thisTeamRole.role_id != null)
                                {
                                    var resDepList = srdDal.GetResDepByResAndRole((long)_.resource_id, (long)thisTeamRole.role_id);
                                    foreach (var resdep in resDepList)
                                    {
                                        if (!idsList.Contains(resdep.id.ToString()))
                                        {
                                            idsList.Add(resdep.id.ToString());
                                            break;
                                        }
                                    }
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

            bool result = false;

            result = new ProjectBLL().DisProject(project_id, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 将项目转换为项目模板
        /// </summary>
        private void SaveAsTemp(HttpContext context)
        {

            bool result = false;

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
                    result = new ProjectBLL().AddPro(param, LoginUserId);
                }
            }
            catch (Exception msg)
            {

                result = false;
            }



            context.Response.Write(result);

        }
        /// <summary>
        ///  从模板导入
        /// </summary>
        private void ImportFromTemp(HttpContext context)
        {

            bool result = false;

            var tempId = context.Request.QueryString["project_temp_id"];
            var copyCalItem = context.Request.QueryString["copyCalItem"];
            var copyProCha = context.Request.QueryString["copyProCha"];
            var copyProTeam = context.Request.QueryString["copyProTeam"];
            var thisProjetcId = context.Request.QueryString["thisProjetcId"];
            var choIds = context.Request.QueryString["choIds"];
            new TaskBLL().ImportFromTemp(long.Parse(thisProjetcId), choIds, LoginUserId, !string.IsNullOrEmpty(copyProTeam));

            context.Response.Write(result);
        }
        /// <summary>
        /// 删除项目
        /// </summary>
        private void DeletePro(HttpContext context, long project_id)
        {

            bool result = false;
            string reson = "";

            result = new ProjectBLL().DeletePro(project_id, LoginUserId, out reson);

            context.Response.Write(new { result = result, reason = reson });
        }

        /// <summary>
        /// 保存为基准（新建type为基准的项目）
        /// </summary>
        private void SaveAsBaseline(HttpContext context, long project_id)
        {

            bool result = false;

            result = new ProjectBLL().SaveAsBaseline(project_id, LoginUserId);

            context.Response.Write(result);
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
                    // todo 放到里面的时候如果不是阶段，则需要新增阶段，并将原来的task转移到这个阶段下
                    // 此时需要创建新阶段并将新阶段ID作为parentID
                    var parentTask = stDal.FindNoDeleteById((long)parent_id);
                    if (parentTask.type_id != (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                    {
                        var returnID = tBll.InsertPhase((long)parent_id, LoginUserId);
                        if (returnID != null)
                        {
                            parent_id = returnID;
                        }
                    }

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
                            tBll.ChangeTaskSortNo(thisTaskNewSortNo, thisTask.id, LoginUserId);
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
                            tBll.ChangBroTaskSortNoReduce(project_id, thisTask.parent_id, LoginUserId);
                        }
                    }
                    tBll.ChangeBroTaskSortNoAdd((long)parent_id, taskArr.Count(), LoginUserId);
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
                            tBll.ChangeTaskSortNo(thisTaskNewSortNo, thisTask.id, LoginUserId);
                        }
                    }
                }
            }
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
        /// <summary>
        /// 判断项目下是否有未完成的任务
        /// </summary>
        private void IsHasNoDoneTask(HttpContext context, long project_id)
        {
            bool isHas = false;
            var taskList = new sdk_task_dal().GetProjectTask(project_id);
            if (taskList != null && taskList.Count > 0)
            {
                var noDoneList = taskList.Where(_ => _.status_id != (int)DicEnum.TICKET_STATUS.DONE).ToList();
                if (noDoneList != null && noDoneList.Count > 0)
                {
                    isHas = true;
                }
            }

            context.Response.Write(isHas);
        }
        private void CompleteProject(HttpContext context, long project_id, string reason)
        {
            bool result = false;

            result = new ProjectBLL().CompleteProject(project_id, reason, LoginUserId);
            context.Response.Write(result);
        }

        private void UpdateProSet(HttpContext context)
        {
            bool result = false;
            var pid = context.Request.QueryString["project_id"];

            var thisPro = new pro_project_dal().FindNoDeleteById(long.Parse(pid));
            if (thisPro != null)
            {

                var resource_daily_hours = context.Request.QueryString["resource_daily_hours"];
                var useResource_daily_hours = context.Request.QueryString["useResource_daily_hours"];
                var excludeWeekend = context.Request.QueryString["excludeWeekend"];
                var excludeHoliday = context.Request.QueryString["excludeHoliday"];
                var organization_location_id = context.Request.QueryString["organization_location_id"];
                var warnTime_off = context.Request.QueryString["warnTime_off"];
                if (!string.IsNullOrEmpty(resource_daily_hours))
                {
                    thisPro.resource_daily_hours = decimal.Parse(resource_daily_hours);
                }
                if (!string.IsNullOrEmpty(useResource_daily_hours) && useResource_daily_hours == "true")
                {
                    thisPro.use_resource_daily_hours = 1;
                }
                else
                {
                    thisPro.use_resource_daily_hours = 0;
                }
                if (!string.IsNullOrEmpty(excludeWeekend) && excludeWeekend == "true")
                {
                    thisPro.exclude_weekend = 1;
                }
                else
                {
                    thisPro.exclude_weekend = 0;
                }
                if (!string.IsNullOrEmpty(excludeHoliday) && excludeHoliday == "true")
                {
                    thisPro.exclude_holiday = 1;
                }
                else
                {
                    thisPro.exclude_holiday = 0;
                }
                if (!string.IsNullOrEmpty(organization_location_id))
                {
                    thisPro.organization_location_id = long.Parse(organization_location_id);
                }
                if (!string.IsNullOrEmpty(warnTime_off) && warnTime_off == "true")
                {
                    thisPro.warn_time_off = 1;
                }
                else
                {
                    thisPro.warn_time_off = 0;
                }
                var old_project_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                var old_project_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS, thisPro.id, old_project_udfList);
                ProjectDto param = new ProjectDto()
                {
                    udf = old_project_udfValueList,
                    project = thisPro,
                };
                result = new ProjectBLL().EditProject(param, LoginUserId);

            }




            context.Response.Write(result);
        }
        /// <summary>
        /// 重新计算项目进度
        /// </summary>
        private void RecalculateProject(HttpContext context, long project_id)
        {
            var result = false;

            result = new ProjectBLL().RecalculateProject(project_id, LoginUserId);

            context.Response.Write(result);
        }

        private void ChangeTaskTime(HttpContext context, string ids, int days)
        {

            bool result = false;

            result = new TaskBLL().ChangeTaskTime(ids, days, LoginUserId);

            context.Response.Write(result);
        }
        /// <summary>
        /// 批量完成task
        /// </summary>
        private void CompleteTask(HttpContext context, string ids, string reason)
        {

            bool result = false;

            var tBll = new TaskBLL();
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                int wrongNum = 0;
                foreach (var taskId in idArr)
                {
                    var thisResult = tBll.CompleteTask(long.Parse(taskId), reason, LoginUserId);
                    if (!thisResult)
                    {
                        wrongNum++;
                    }
                }
                if (wrongNum == 0)
                {
                    result = true;
                }
            }

            context.Response.Write(result);
        }
        /// <summary>
        /// 删除任务
        /// </summary>
        /// <param name="context"></param>
        /// <param name="taskIds">需要删除的任务id集合</param>
        /// <param name="isDelSub">是否删除子task</param>
        private void DeleteTasks(HttpContext context, string taskIds, bool isDelSub)
        {

            bool result = false;
            if (!string.IsNullOrEmpty(taskIds))
            {
                var stDal = new sdk_task_dal();
                var tBll = new TaskBLL();
                var tasArr = taskIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var chooseTaskList = stDal.GetTaskByIds(taskIds);
                if (chooseTaskList != null && chooseTaskList.Count > 0)
                {
                    foreach (var taskId in tasArr)
                    {
                        var thisTask = chooseTaskList.FirstOrDefault(_ => _.id.ToString() == taskId);
                        if (thisTask != null)
                        {
                            if (thisTask.parent_id != null)
                            {
                                if (tasArr.Any(_ => _ == thisTask.parent_id.ToString()))
                                {
                                    continue;
                                }
                            }
                            tBll.DeleteTasks(thisTask.id, isDelSub, LoginUserId);
                        }
                    }
                }

            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 减少缩进
        /// </summary>
        private void Outdent(HttpContext context, long taskId)
        {

            bool result = false;

            var stDal = new sdk_task_dal();
            var tBll = new TaskBLL();
            var thisTask = stDal.FindNoDeleteById(taskId);
            if (thisTask != null && thisTask.parent_id != null)
            {
                var parTask = stDal.FindNoDeleteById((long)thisTask.parent_id);
                if (parTask != null)
                {
                    // 减少缩进步骤
                    // 1.改变原来的兄弟节点的位置
                    // 2.获取到新的节点的位置，插入节点
                    // 3.计算原来的，和新的父节点的开始时间和结束时间是否调整 // todo
                    var oldThisTaskParId = thisTask.parent_id;
                    thisTask.parent_id = parTask.parent_id;
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, stDal.FindNoDeleteById(thisTask.id), thisTask.id, LoginUserId, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                    stDal.Update(thisTask);
                    tBll.ChangBroTaskSortNoReduce((long)thisTask.project_id, oldThisTaskParId, LoginUserId); // 1.
                    string newNo = "";
                    if (parTask.parent_id != null)
                    {
                        newNo = tBll.GetMinUserSortNo((long)parTask.parent_id);
                    }
                    else
                    {
                        newNo = tBll.GetMinUserNoParSortNo((long)thisTask.project_id);
                    }
                    tBll.ChangeTaskSortNo(newNo, thisTask.id, LoginUserId);
                    tBll.AdjustmentDate((long)thisTask.parent_id, LoginUserId);
                }
            }

            context.Response.Write(result);
        }
        /// <summary>
        /// 增加缩进
        /// </summary>
        private void Indend(HttpContext context, long taskId)
        {

            bool result = false;


            var stDal = new sdk_task_dal();
            var tBll = new TaskBLL();
            var lastTask = tBll.GetLastBroTask(taskId);
            if (lastTask != null)
            {
                // 补充原有位置

                var thisTask = stDal.FindNoDeleteById(taskId);
                var oldTaskId = thisTask.parent_id;
                if (lastTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)  // 是阶段
                {
                    thisTask.parent_id = lastTask.id;
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, stDal.FindNoDeleteById(thisTask.id), thisTask.id, LoginUserId, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                    stDal.Update(thisTask);
                    var newNo = tBll.GetMinUserSortNo(lastTask.id);
                    tBll.ChangeTaskSortNo(newNo, taskId, LoginUserId);
                   
                }
                else
                {
                    var returnID = tBll.InsertPhase(lastTask.id, LoginUserId);
                    if (returnID != null)
                    {
                        var newNo = tBll.GetMinUserSortNo((long)returnID);
                        thisTask.parent_id = returnID;
                        OperLogBLL.OperLogUpdate<sdk_task>(thisTask, stDal.FindNoDeleteById(thisTask.id), thisTask.id, LoginUserId, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                        stDal.Update(thisTask);
                        tBll.ChangeTaskSortNo(newNo, taskId, LoginUserId);
                    }
                }
                tBll.ChangBroTaskSortNoReduce((long)lastTask.project_id, lastTask.parent_id, LoginUserId);
                if (lastTask.parent_id != null)
                {
                    tBll.AdjustmentDate((long)lastTask.parent_id, LoginUserId);
                }
            }



            context.Response.Write(result);
            // 执行顺序
            // 原有兄弟节点改变
            // 上一节点是否是阶段
            // 是阶段，转到阶段下
            // 不是阶段，创建阶段，转到阶段下




        }
        /// <summary>
        /// 根据条件删选项目
        /// </summary>
        private void GetProByRes(HttpContext context, long rId, string showType, bool isShowComp,long account_id)
        {
            var list = new pro_project_dal().GetAccByRes(rId, showType, isShowComp,account_id);
            if (list != null && list.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(list));
            }
        }
        /// <summary>
        /// 根据条件筛选任务
        /// </summary>
        private void GetTaskByRes(HttpContext context, long rId, string showType, bool isShowComp, long project_id)
        {
            var list = new sdk_task_dal().GetTaskByRes(rId, showType, isShowComp, project_id);
            if (list != null && list.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(list));
            }
        }
        /// <summary>
        /// 删除工时，返回结果和删除失败原因
        /// </summary>
        private void DeleteEntry(HttpContext context,long entry_id)
        {
            string reason = "";
            var result = new TaskBLL().DeleteEntry(entry_id,LoginUserId,out reason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new {result=result,reason = reason }));
        }
        /// <summary>
        /// 读取这个对象相对应的暂存文件
        /// </summary>
        private void GetTaskFileSes(HttpContext context,long object_id)
        {
            StringBuilder fileHtml = new StringBuilder();
            var objAtt = context.Session[object_id.ToString() + "_Att"];
            if (objAtt != null)
            {
                var attList = objAtt as List<AddFileDto>;
                if(attList!=null&& attList.Count > 0)
                {
                    foreach (var att in attList)
                    {
                        fileHtml.Append($"<div class='Attachment'><div class='CloseButton' onclick=\"RemoveSess('{attList.IndexOf(att)}')\"></div><div class='Title'>{att.new_filename}</div><div class='Content'>{att.old_filename}</div></div>");
                    }
                }
            }
            context.Response.Write(fileHtml.ToString());
        }
        /// <summary>
        /// 移除暂存文件
        /// </summary>
        private void RemoveSession(HttpContext context,long object_id,int indexNum)
        {
            var objAtt = context.Session[object_id.ToString() + "_Att"];
            if (objAtt != null)
            {
                var attList = objAtt as List<AddFileDto>;
                if (attList != null && attList.Count > 0)
                {
                    if(attList.Count> indexNum)
                    {
                        attList.Remove(attList[indexNum]);
                        
                        GetTaskFileSes(context, object_id);
                    }
                }
            }
        }
        /// <summary>
        /// 返回这个项目的问题和任务
        /// </summary>
        private void GetProTaskList(HttpContext context,long project_id)
        {
            var taskList = new sdk_task_dal().GetProjectTask(project_id);
            if(taskList!=null&& taskList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(taskList));
            }
        }
        /// <summary>
        /// 删除费用
        /// </summary>
        private void DeleteExpense(HttpContext context,long exp_id)
        {
            string faileReason = "";
            var result = new TaskBLL().DeleteExpense(exp_id,LoginUserId,out faileReason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result, reason = faileReason }));
        }
        /// <summary>
        /// 删除备注
        /// </summary>
        private void DeleteNote(HttpContext context, long exp_id)
        {
            var result = new TaskBLL().DeleteTaskNote(exp_id,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 关联里程碑
        /// </summary>
        private void AssMile(HttpContext context,string ids,long phaId)
        {
            var result = new TaskBLL().AssMiles(ids, phaId,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 解除关联里程碑
        /// </summary>
        private void DisAssMile(HttpContext context, string ids)
        {
            var result = new TaskBLL().DisMiles(ids,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 修改里程碑状态为准备计费
        /// </summary>
        private void ToReadyBill(HttpContext context,string ids)
        {
            var result = new TaskBLL().ReadyMiles(ids, LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 取消任务
        /// </summary>
        private void CancelTask(HttpContext context,long task_id)
        {
            var result = new TaskBLL().CancelTask(task_id,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 恢复任务
        /// </summary>
        private void RecoveTask(HttpContext context, long task_id)
        {
            var result = new TaskBLL().RecoveTask(task_id, LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 获取单个的项目成员信息
        /// </summary>
        private void GetSinProTeam(HttpContext context, long team_id)
        {
            var thisTeam = new pro_project_team_dal().FindNoDeleteById(team_id);
            if (thisTeam != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(thisTeam));
            }
        }
        /// <summary>
        /// 员工是否在任务中出现
        /// </summary>
        private void ResIsInTask(HttpContext context, long project_id,long team_id)
        {
            var result = false;
            var thisTeam = new pro_project_team_dal().FindNoDeleteById(team_id);
            if (thisTeam != null && thisTeam.resource_id != null)
            {
                result = new TaskBLL().ResIsInTask(project_id, (long)thisTeam.resource_id);
            }
            
            context.Response.Write(result);
        }
        /// <summary>
        /// 删除项目成员
        /// </summary>
        private void DelProTeam(HttpContext context, long project_id, long team_id)
        {
            var result = new ProjectBLL().DeleteProTeam(project_id,team_id,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 判断该员工是否在项目中出现
        /// </summary>
        private void ResInPro(HttpContext context, long project_id,long resourcec_id)
        {
            var result = new ProjectBLL().IsHasRes(project_id,resourcec_id);
            context.Response.Write(result);
        }
        /// <summary>
        /// 查核内部团队
        /// </summary>
        private void ReconcileProject(HttpContext context, long project_id)
        {
            var result = new ProjectBLL().ReconcileRes(project_id,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 获取单个的费用信息
        /// </summary>
        private void GetSinExpense(HttpContext context, long exp_id)
        {
            var thisExp = new sdk_expense_dal().FindNoDeleteById(exp_id);
            if (thisExp != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(thisExp));
            }
        }
        /// <summary>
        /// 批量计费或者不计费 成本或者费用
        /// </summary>
        private void BillManyExpense(HttpContext context,string ids,bool IsBill)
        {
            var result = new ProjectBLL().BillExpenses(ids,IsBill,LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 单个费用的计费操作
        /// </summary>
        private void BillSingExp(HttpContext context, long exp_id, bool IsBill)
        {
            string reason = "";
            var result = new ProjectBLL().BillExp(exp_id,IsBill,LoginUserId,out reason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result,reason=reason}));
        }
        /// <summary>
        /// 删除单个费用
        /// </summary>
        private void DeleteSinExp(HttpContext context, long exp_id)
        {
            var reason = "";
            var result = new ProjectBLL().DeleteSinExp(exp_id,LoginUserId,out reason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result,reason=reason}));
        }
        /// <summary>
        /// 批量删除费用或者成本
        /// </summary>
        private void DeleteManyExp(HttpContext context,string ids)
        {
            var result = new ProjectBLL().DeleteExpense(ids,LoginUserId);
            context.Response.Write(result);
        }

    }
}