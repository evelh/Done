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
                    case "GetTaskList":
                        var project_id = context.Request.QueryString["project_id"];
                        GetTask(context, long.Parse(project_id));
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
                    case "DeletePro":
                        var dProId = context.Request.QueryString["project_id"];
                        DeletePro(context,long.Parse(dProId));
                        break;
                    default:
                        context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                        break;
                }
            }
            catch (Exception)
            {
                context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
            }
        }
        /// <summary>
        /// 根据项目获取到该项目下的所有任务
        /// </summary>
        private void GetTask(HttpContext context, long project_id)
        {
            var project = new pro_project_dal().FindNoDeleteById(project_id);
            if (project != null)
            {
                taskString.Append($"<tr class='HighImportance'><td class='Interaction'><span class='Text'></span></td><td class='Nesting'><div data-depth='0' class='DataDepth'><div class='Spacer'></div>< div class='IconContainer'></div><div class='Value'>{project.name}</div></div></td><td class='Text'></td></tr>");
                var stDal = new sdk_task_dal();
                var stList = stDal.GetProTask(project.id);
                if (stList != null && stList.Count > 0)
                {
                    int data_depth = 0;
                    string interaction = "";
                    AddSubTask(null, stList, data_depth, interaction);
                    context.Response.Write(taskString.ToString());
                }
            }
        }
        private StringBuilder taskString = new StringBuilder();
        /// <summary>
        /// 获取到这个任务的子集
        /// </summary>
        private void AddSubTask(long? tid, List<sdk_task> sdkList, int data_depth, string interaction)
        {
            var subList = sdkList.Where(_ => _.parent_id == tid).ToList();
            if (subList != null && subList.Count > 0)
            {
                data_depth += 1;

                foreach (var sub in subList)
                {
                    if (string.IsNullOrEmpty(interaction))
                    {
                        interaction = sub.sort_order.ToString();
                    }
                    else
                    {
                        interaction += "." + sub.sort_order.ToString();
                    }
                    taskString.Append($"<tr class='HighImportance' id='{sub.id}'><td class='Interaction'><span class='Text'>{interaction}</span></td><td class='Nesting'><div data-depth='{data_depth}' class='DataDepth'><div class='Spacer'></div>< div class='IconContainer'></div><div class='Value'>{sub.title}</div></div></td><td class='Text'></td></tr>");
                    AddSubTask(sub.id, sdkList, data_depth, interaction);
                }
            }
            else
            {
                return;
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
            if (thisProject != null&& proTeamList!=null&& proTeamList.Count > 0)
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
                        if((!string.IsNullOrEmpty(lineBuss))&& lineBuss != "0")
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
                    

                        param.IsCopyCalendarItem = copyCalItem=="true"?"1":"";
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
        /// 删除项目
        /// </summary>
        private void DeletePro(HttpContext context,long project_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            bool result = false;
            string reson = "";
            if (res != null)
            {
                result = new ProjectBLL().DeletePro(project_id,res.id,out reson);
            }
            context.Response.Write(new { result=result,reason=reson});
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