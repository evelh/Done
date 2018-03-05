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
    public partial class AccountTicketList : BasePage
    {
        protected crm_account thisAccount = null;
        protected long groupId;
        protected sdk_task thisTicket = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var account_id = Request.QueryString["account_id"];
            if (!string.IsNullOrEmpty(account_id))
            {
                thisAccount = new CompanyBLL().GetCompany(long.Parse(account_id));
            }
            var ticket_id = Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticket_id))
            {
                thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticket_id));
                if (thisTicket != null)
                {
                    thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                }
            }
             
            var info = new BLL.QueryCommonBLL().GetQueryGroup((int)DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST);
            if (info != null && info.Count > 0)
            {
                groupId = info[0].id;
            }
            if (thisAccount == null)
            {
                Response.Write("<script>alert('未查询到该客户信息！');window.close();</script>");
            }
        }
    }
}