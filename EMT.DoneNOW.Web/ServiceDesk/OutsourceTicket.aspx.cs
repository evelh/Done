using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class OutsourceTicket : BasePage
    {
        protected sdk_task ticket;
        protected crm_account account;
        protected TicketBLL ticBll = new TicketBLL();
        protected List<d_general> chargeTypeList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.OUTSOURCE_RATE_TYPE);
        protected List<d_cost_code> billCodeList = new CostCodeBLL().GetCodeByCate((long)DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE);
        protected List<sys_role> roleList = new SysRoleInfoBLL().GetRoleList();
        protected void Page_Load(object sender, EventArgs e)
        {
            long ticketId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["ticketId"]) && long.TryParse(Request.QueryString["ticketId"], out ticketId))
                ticket = new TicketBLL().GetTask(ticketId);

            if (ticket != null)
            {
                account = new CompanyBLL().GetCompany(ticket.account_id);
            }

        }

        protected void save_close_Click(object sender, EventArgs e)
        {

        }
    }
}