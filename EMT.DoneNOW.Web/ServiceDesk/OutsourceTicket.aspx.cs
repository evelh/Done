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
            var pageOut = AssembleModel<sdk_task_outsource>();
            var accountId = Request.Form["partnerAcc"];
            if (!string.IsNullOrEmpty(accountId))
                pageOut.account_id = long.Parse(Request.Form["partnerAcc"]);
            pageOut.task_id = ticket.id;
            pageOut.type_id = (int)DicEnum.OUTSOURCE_TYPE.SUBCONTRACTOR_PORTAL;
            pageOut.outsourced_by_resource_id = LoginUserId;
            pageOut.status_id = (int)DicEnum.OUTSOURCE_STATUS_TYPE.ACCEPTED; // 待确认，外包状态
            if (!string.IsNullOrEmpty(Request.Form["chargeType"]))
                pageOut.rate_type_id = int.Parse(Request.Form["chargeType"]);
            var AdjustTime = DateTime.Now.AddHours(1);
            if (!string.IsNullOrEmpty(Request.Form["AdjustTimeHidden"]))
                AdjustTime = DateTime.Parse(Request.Form["AdjustTimeHidden"]);
            pageOut.auto_decline_if_not_accepted_by_time = Tools.Date.DateHelper.ToUniversalTimeStamp(AdjustTime);
            if (!string.IsNullOrEmpty(Request.Form["authorizedTime"]))
                pageOut.authorized_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["authorizedTime"]));
            pageOut.decline_reason = string.Empty;
            if (string.IsNullOrEmpty(pageOut.description))
                pageOut.description = string.Empty;
            if (string.IsNullOrEmpty(pageOut.instructions))
                pageOut.instructions = string.Empty;
            bool result = ticBll.OutsourceTicket(pageOut,LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}