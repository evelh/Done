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

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ProjectAjax 的摘要说明
    /// </summary>
    public class ProjectAjax : IHttpHandler
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
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}