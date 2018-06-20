using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskToLibrary : BasePage
    {
        protected sdk_task thisTask = null;
        protected List<sys_department> depList = new sys_department_dal().GetDepartment();
        protected List<d_general> libCateList = new GeneralBLL().GetGeneralList((int)GeneralTableEnum.TASK_LIBRARY_CATE);
        protected bool isAdd = true;
        protected sdk_task_library taskLib;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var taskId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(taskId));
                }
                long id = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                    taskLib = new sdk_task_library_dal().FindNoDeleteById(id);
                if (taskLib != null)
                {
                    isAdd = false;
                }
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = AssembleModel<sdk_task_library>();
            bool result = false;
            if(isAdd)
                result = new TaskBLL().AddTaskToLibary(param, LoginUserId);
            else
                result = new TaskBLL().EditTaskLibary(param, LoginUserId);
             
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}