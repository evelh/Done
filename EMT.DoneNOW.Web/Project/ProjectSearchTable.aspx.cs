using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectSearchTable : BasePage
    {
        protected List<pro_project> proList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var ids = Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                proList = new pro_project_dal().GetProListByIds(ids);
            }
        }
    }
}