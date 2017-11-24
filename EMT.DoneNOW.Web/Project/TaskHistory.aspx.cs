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
    public partial class TaskHistory : BasePage
    {
        protected sdk_task thisTask = null;
        protected List<sys_oper_log> logList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var tId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(tId))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(tId));
                    if (thisTask != null)
                    {
                        logList = new sys_oper_log_dal().GetLogByOId(thisTask.id);
                    }
                }
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
    }
}