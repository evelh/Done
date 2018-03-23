using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class ChangeTicketApprove : BasePage
    {
        protected sdk_task thisTicket = null;
        protected sdk_task_other_person thisOther = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var ticketId = Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));
            }
            if (thisTicket == null)
            {
                Response.Write($"<script>alert('工单已删除！');window.close();</script>");
                return;
            }
            else
            {
                thisOther = new sdk_task_other_person_dal().GetPerson(thisTicket.id,LoginUserId);
            }

            if (thisOther == null)
            {
                Response.Write($"<script>alert('工单审批人已删除！');window.close();</script>");
                return;
            }
        }
    }
}