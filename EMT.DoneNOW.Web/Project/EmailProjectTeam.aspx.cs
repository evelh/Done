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
    public partial class EmailProjectTeam : BasePage
    {
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));

                    if (!IsPostBack)
                    {
                        interna.Checked = true;   
                     }
                }

                if (thisProject == null)
                {
                    Response.End();
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void send_Click(object sender, EventArgs e)
        {
            var subject = Request.Form["subject"];
            var type = Request.Form["team"];
            var message = Request.Form["message"];
            var result = new ProjectBLL().EmailProTeam(thisProject.id, type,subject,message,LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();window.close();</script>");

        }
    }
}