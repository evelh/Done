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
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    department_id.DataTextField = "name";
                    department_id.DataValueField = "id";
                    department_id.DataSource = new sys_department_dal().GetDepartment();
                    department_id.DataBind();
                    department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

                    cate_id.DataTextField = "show";
                    cate_id.DataValueField = "val";
                    cate_id.DataSource = new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TASK_LIBRARY_CATE));
                    cate_id.DataBind();
                    cate_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

                }
                var id = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(id));
                    if (thisTask != null)
                    {
                        if (!IsPostBack)
                        {
                            if (thisTask.department_id != null)
                            {
                                department_id.SelectedValue = thisTask.department_id.ToString();
                            }
                        }
                    }
                }
                if (thisTask == null || thisTask.type_id != (int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
                {
                    Response.End();
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
            var result = new TaskBLL().AddTaskToLibary(param,GetLoginUserId());
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}