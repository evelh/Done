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

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class DeleteMasterTicket : BasePage
    {
        protected sdk_task ticket = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var tId = Request.QueryString["ticket_id"];
                if (!string.IsNullOrEmpty(tId))
                    ticket = new sdk_task_dal().FindNoDeleteById(long.Parse(tId));
                if (ticket == null)
                    Response.Write("<script>alert('主工单已经删除');window.close();</script>");
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}