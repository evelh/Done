using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectCalendarShow : BasePage
    {
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(thisId));
                }
                if (thisProject != null)
                {
                    ShowCalendarList.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_CALENDAR + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_CALENDAR + "&id=" + thisProject.id;
                }
                else
                {
                    Response.End();
                }
                // project_calendar
            }
            catch (Exception)
            {
                Response.End();
            }
           
        }
    }
}