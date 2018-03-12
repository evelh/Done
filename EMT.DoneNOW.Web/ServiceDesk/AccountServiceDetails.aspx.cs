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
    public partial class AccountServiceDetails : BasePage
    {
        protected sdk_task thisTicket = null;
        protected crm_account thisAccount = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var ticketId = Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
                thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));

            if (thisTicket != null)
                thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
            else
                Response.Write("<script>alert('未查询到该工单信息！');window.close();</script>");
        }
    }
}