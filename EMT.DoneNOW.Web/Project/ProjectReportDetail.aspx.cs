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
        protected List<pro_project> projectList;
        protected bool isAll = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var chooseDateString = Request.QueryString["chooseDate"];
                if (!string.IsNullOrEmpty(chooseDateString))
                    chooseDate = DateTime.Parse(chooseDateString);
                user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                if (!string.IsNullOrEmpty(Request.QueryString["isSeven"]))
                    isSeven = true;
                if (!string.IsNullOrEmpty(Request.QueryString["isShowDetai"]))
                    isShowDetai = true;

                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        taskList = new sdk_task_dal().GetProTask(thisProject.id," and type_id in (1807,1808,1812)");
                        proCalList = new pro_project_calendar_dal().GetCalByPro(thisProject.id);
                    }
                }
                if (!string.IsNullOrEmpty(Request.QueryString["isAll"]))
                    isAll = true;
                if (isAll)
                {
                    taskList = new sdk_task_dal().FindListBySql($"select* from sdk_task where delete_time = 0 and type_id in (1807,1808,1812)");
                    var ppDal = new DAL.pro_project_dal();
                    proCalList = new pro_project_calendar_dal().FindListBySql($"SELECT * from pro_project_calendar where delete_time = 0");
                    const string proLimitJson = "{\"row\":\"7\",\"t1\":\"p\",\"col1\":\"0\",\"col2\":\"0\"}";
                    var projectLimitSql = Convert.ToString(ppDal.GetSingle($"select f_rpt_getsql_limit('{proLimitJson}',{LoginUserId.ToString()})"));
                    projectList = ppDal.FindListBySql("select* from pro_project p where p.delete_time =0 "+ projectLimitSql);
                }
            }
            catch (Exception msg)
            {
                Response.End();
            }

        }
    }
}