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
        protected bool isAdd = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            var idString = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(idString))
            {

            }
        }
    }
}