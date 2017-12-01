using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectTeamManage : BasePage
    {
        protected bool isAdd = true;
        protected pro_project_team thisProTeam = null;
        protected List<pro_project_team_role> thisProTeamRoleList = null;
        protected pro_project thisProject = null;
        protected crm_account thisAccount = null;
        protected sys_resource thisRes = null;   // 成员的员工
        protected crm_contact thisCon = null;    // 成员的联系人
        protected void Page_Load(object sender, EventArgs e)
        {
            var idString = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(idString))
            {
                thisProTeam = new pro_project_team_dal().FindNoDeleteById(long.Parse(idString));
                if (thisProTeam != null)
                {
                    isAdd = false;
                    thisProTeamRoleList = new pro_project_team_role_dal().GetListTeamRole(thisProTeam.id);
                    thisProject = new pro_project_dal().FindNoDeleteById(thisProTeam.project_id);
                    if (thisProTeam.resource_id != null)
                    {
                        thisRes = new sys_resource_dal().FindNoDeleteById((long)thisProTeam.resource_id);
                    }
                    if (thisProTeam.contact_id != null)
                    {
                        thisCon = new crm_contact_dal().FindNoDeleteById((long)thisProTeam.contact_id);
                    }
                }
            }
            var pId = Request.QueryString["project_id"];
            if (!string.IsNullOrEmpty(pId))
            {
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(pId));
                
            }
            if (thisProject != null)
            {
                thisAccount = new CompanyBLL().GetCompany(thisProject.account_id);
            }
            if(thisProject==null|| thisAccount == null)
            {
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var result = SaveTeam();
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();window.close();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');self.opener.location.reload();window.close();</script>");
            }
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var result = SaveTeam();
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='ProjectTeamManage?project_id=" + thisProject.id + "';</script>");

            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='ProjectTeamManage?project_id=" + thisProject.id + "';</script>");
            }
        }
        /// <summary>
        /// 执行相关操作
        /// </summary>
        private bool SaveTeam()
        {
            var param = GetParam();
            var roleIds = Request.Form["roles"];
            if (isAdd)
            {
                new ProjectBLL().AddProjectTeam(param,roleIds,LoginUserId);
            }
            else
            {
                new ProjectBLL().EditProjetcTeam(param, roleIds, LoginUserId);
            }

            return true;
        }
        /// <summary>
        /// 获取相关参数
        /// </summary>
        private pro_project_team GetParam()
        {
            var pageTeam = AssembleModel<pro_project_team>();
            if (isAdd)
            {
                pageTeam.project_id = thisProject.id;
                return pageTeam;
            }
            else
            {
                thisProTeam.resource_id = pageTeam.resource_id;
                thisProTeam.contact_id = pageTeam.contact_id;
                thisProTeam.resource_daily_hours = pageTeam.resource_daily_hours;
                return thisProTeam;
            }
        }
    }
}