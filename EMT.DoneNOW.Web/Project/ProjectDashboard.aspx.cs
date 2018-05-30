using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectDashboard : BasePage
    {
        protected string[] weekName = new string[] {"星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
        protected List<pro_project> myProjectList;      // 我的项目列表（本人作为项目负责人、停用和完成状态的不显示。注意权限控制）
        protected List<pro_project> myTeamProjectList;  // 团队成员项目列表（本人作为项目组成员但不是负责人、停用和完成状态的不显示。注意权限控制）
        protected List<pro_project> myDepProjectList;   // 部门项目列表（本人所属部门（本人是负责人）下的项目、停用和完成状态的不显示。注意权限控制）
        protected DAL.pro_project_dal ppDal = new DAL.pro_project_dal();
        protected DAL.v_project_dal vpDal = new DAL.v_project_dal();
        protected ProjectBLL proBll = new ProjectBLL();
        protected List<sys_resource> resList;
        protected int openIssueCount;

        protected void Page_Load(object sender, EventArgs e)
        {
            const string proLimitJson = "{\"row\":\"7\",\"t1\":\"p\",\"col1\":\"0\",\"col2\":\"0\"}";
            var projectLimitSql = Convert.ToString(ppDal.GetSingle($"select f_rpt_getsql_limit('{proLimitJson}',{LoginUserId.ToString()})"));

            
            myProjectList = ppDal.FindListBySql<pro_project>($"SELECT p.id,p.name from pro_project p where p.delete_time = 0 and p.owner_resource_id = {LoginUserId.ToString()} and p.status_id not in(1345,1352) " + projectLimitSql);
            // 

            myTeamProjectList = ppDal.FindListBySql<pro_project>($"SELECT DISTINCT p.id,p.name from pro_project p INNER JOIN pro_project_team ppt on p.id =ppt.project_id where p.delete_time =0 and ppt.delete_time = 0 and ppt.resource_id ={LoginUserId.ToString()} and p.status_id not in(1345,1352) " + projectLimitSql);

            myDepProjectList = ppDal.FindListBySql<pro_project>($"SELECT p.id,p.name from pro_project p where p.delete_time = 0 and p.owner_resource_id = {LoginUserId.ToString()} and p.status_id not in(1345,1352) and p.department_id in ( SELECT DISTINCT department_id from sys_resource_department) " + projectLimitSql);

            // SELECT DISTINCT owner_resource_id from pro_project where delete_time =0 and owner_resource_id is not NULL
            var priResIds = ppDal.GetRes($"SELECT DISTINCT owner_resource_id from pro_project p where p.delete_time =0 and p.owner_resource_id is not NULL "+ projectLimitSql);
            var otherIds = ppDal.GetRes($"SELECT DISTINCT ppt.resource_id from pro_project p INNER JOIN pro_project_team ppt on p.id =ppt.project_id where p.delete_time =0 and ppt.delete_time = 0 and ppt.resource_id is not null "+ projectLimitSql);
            string ids = string.Empty;
            if(priResIds!=null&& priResIds.Count > 0)
                priResIds.ForEach(_=> { ids += _.ToString() + ','; });
            if (otherIds != null && otherIds.Count > 0)
                otherIds.ForEach(_ => { ids += _.ToString() + ','; });
            if (!string.IsNullOrEmpty(ids))
            {
                ids = ids.Substring(0, ids.Length-1);
                resList = new DAL.sys_resource_dal().GetListByIds(ids);
                if (resList != null && resList.Count > 0)
                    resList = resList.Distinct().ToList();
            }
            
            openIssueCount = Convert.ToInt32(ppDal.GetSingle("SELECT count(1) from sdk_task st INNER join pro_project p on st.project_id = p.id  where st.delete_time = 0 and p.delete_time = 0 and st.type_id = 1808 and st.status_id <> 1894 and p.status_id <> 1352 "));
        }
    }
}