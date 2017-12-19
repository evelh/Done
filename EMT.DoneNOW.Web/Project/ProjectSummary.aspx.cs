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

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectSummary : BasePage
    {
        protected pro_project thisProject = null;
        protected List<sdk_task> taskList = null;
        protected ProjectBLL proBLL = new ProjectBLL();
        protected bool isTemp = false;      // 判断项目是否时项目模板
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    if (AuthBLL.GetUserProjectAuth(LoginUserId, LoginUser.security_Level_id, thisProject.id).CanView == false)
                    {
                        Response.Write("<script>alert('无权查看');window.close();</script>");
                        Response.End();
                        return;
                    }
                    taskList = new sdk_task_dal().GetProjectTask(thisProject.id);
                    if (thisProject.type_id == (int)DicEnum.PROJECT_TYPE.TEMP)
                    {
                        isTemp = true;
                    }
                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
    }
}