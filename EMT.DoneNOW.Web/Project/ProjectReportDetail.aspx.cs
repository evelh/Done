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
    public partial class ProjectReportDetail : BasePage
    {
        protected pro_project thisProject = null;
        protected DateTime chooseDate = DateTime.Now;
        protected List<sdk_task> taskList = null;   // 项目task集合
        protected List<pro_project_calendar> proCalList = null;  // 项目日历条目集合
        protected UserInfoDto user = null; // 用户信息
        protected bool isSeven = false;    // 是否显示七天的task-先显示一天的
        protected bool isShowDetai = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        var chooseDateString = Request.QueryString["chooseDate"];
                        if (!string.IsNullOrEmpty(chooseDateString))
                        {
                            chooseDate = DateTime.Parse(chooseDateString);
                        }
                        var  allTaskList = new sdk_task_dal().GetProTask(thisProject.id);
                        if (allTaskList != null && allTaskList.Count > 0)
                        {
                            taskList = allTaskList.Where(_ => _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_ISSUE || _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE || _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_TASK).ToList();
                        }
                        proCalList = new pro_project_calendar_dal().GetCalByPro(thisProject.id);
                        user =  UserInfoBLL.GetUserInfo(GetLoginUserId());
                        if (!string.IsNullOrEmpty(Request.QueryString["isSeven"]))
                        {
                            isSeven = true;
                        }
                        if (!string.IsNullOrEmpty(Request.QueryString["isShowDetai"]))
                        {
                            isShowDetai = true;
                        }
                    }
                }
            }
            catch (Exception msg)
            {
                Response.End();
            }

        }
    }
}