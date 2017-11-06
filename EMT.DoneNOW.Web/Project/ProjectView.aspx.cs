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
    public partial class ProjectView : BasePage
    {
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    var type = Request.QueryString["type"];
                    switch (type)
                    {
                        case "Schedule":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id;
                            break;
                        case "ScheduleTemp":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id+ "&isTranTemp=1";
                            break;
                        default:
                            viewProjectIframe.Src = "ProjectSummary?id=" + thisProject.id;
                            break;
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