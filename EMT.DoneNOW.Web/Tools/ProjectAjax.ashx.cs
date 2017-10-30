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
                        GetTask(context,long.Parse(project_id));
                        break;
                    case "GetSinProject":
                        var sin_project_id = context.Request.QueryString["project_id"];
                        GetSinProject(context,long.Parse(sin_project_id));
                        break;
                    case "GetProResDepIds":
                        var pro_id = context.Request.QueryString["project_id"];
                        var ids = context.Request.QueryString["ids"];
                        GetProResDepIds(context,long.Parse(pro_id),ids);
                        break;
                    case "DisProject":
                        var disProId = context.Request.QueryString["project_id"];
                        DisProject(context,long.Parse(disProId));
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
        private void GetTask(HttpContext context,long project_id)
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
                    AddSubTask(null,stList, data_depth, interaction);
                    context.Response.Write(taskString.ToString());
                }
            }
        }
        private StringBuilder taskString = new StringBuilder();
        /// <summary>
        /// 获取到这个任务的子集
        /// </summary>
        private void AddSubTask(long? tid,List<sdk_task> sdkList,int data_depth,string interaction)
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
                        interaction+="." + sub.sort_order.ToString();
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
        private void GetProResDepIds(HttpContext context,long project_id,string resdepIDs)
        {
            var pptDal = new pro_project_team_dal();
            var pptrDal = new pro_project_team_role_dal();
            var srdDal = new sys_resource_department_dal();
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);
            if (thisProject != null)
            {
                var proTeamList = pptDal.GetResListBuProId(thisProject.id);
                if (proTeamList != null && proTeamList.Count > 0)
                {
                    List<string> idsList = new List<string>();
                    if (!string.IsNullOrEmpty(resdepIDs))
                    {
                        var resdepArr = resdepIDs.Split(new char[] {',' },StringSplitOptions.RemoveEmptyEntries);
                        idsList = resdepArr.ToList();
                    }
                    proTeamList.ForEach(_ => {
                        var teamRole = pptrDal.GetSinTeamRole(_.id);
                        if (teamRole != null&&teamRole.role_id!=null)
                        {
                            var resDepList = srdDal.GetResDepByResAndRole((long)_.resource_id,(long)teamRole.role_id);
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
                        string ids = "";
                        idsList = idsList.Distinct().ToList();
                        idsList.ForEach(_ => { ids += _ + ','; });
                        if (!string.IsNullOrEmpty(ids))
                        {
                            ids = ids.Substring(0,ids.Length-1);
                            context.Response.Write(ids);
                        }

                    }

                }
            }
        }

        /// <summary>
        /// 停用项目
        /// </summary>
        private void DisProject(HttpContext context, long project_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new ProjectBLL().DisProject(project_id,res.id);
                context.Response.Write(result);
            }
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