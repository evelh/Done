using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;


namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectNoteShow : BasePage
    {
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["project_id"];
                if(!string.IsNullOrEmpty(thisId))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(thisId));
                }
                if (thisProject != null)
                {

                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}