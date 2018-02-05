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
    public partial class TicketLabour : BasePage
    {
        protected bool isAdd = true;
        protected sdk_task thisTicket = null;
        protected crm_account thisAccount = null;
        protected sdk_work_entry ticketLabour = null;
        protected crm_account_alert accAlert = null;
        protected ctt_contract thisContract = null;
        protected bool isComplete = false;      // 是否完成工单 -- 完成工单时，页面的工单状态为完成，保存时保存
        protected List<DictionaryEntryDto> resList = new sys_resource_dal().GetDictionary(true);
        protected List<d_cost_code> workTypeList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
        protected List<d_cost_code> chargeList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE);
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<sys_role> roleList = new sys_role_dal().GetList();
        protected bool isAllowAgentRes = false;  // 根据系统设置“允许代理输入工时”
        protected sys_resource createUser = null;
        protected long? parent_id = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                isComplete = !string.IsNullOrEmpty(Request.QueryString["is_complete"]);
                if (!IsPostBack)
                {
                    GetPageDataBind();
                }
                var ticket_id = Request.QueryString["ticket_id"];
                if (!string.IsNullOrEmpty(ticket_id))
                {
                    thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticket_id));
                }
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    ticketLabour = new sdk_work_entry_dal().FindNoDeleteById(long.Parse(id));
                    if (ticketLabour != null)
                    {
                        isAdd = false;
                        thisTicket = new sdk_task_dal().FindNoDeleteById(ticketLabour.task_id);
                        if (ticketLabour.resource_id != null)
                            resource_id.SelectedValue = ((long)ticketLabour.resource_id).ToString();
                        if (ticketLabour.cost_code_id != null)
                            cost_code_id.SelectedValue = ticketLabour.cost_code_id.ToString();
                        if (ticketLabour.role_id != null)
                            role_id.SelectedValue = ticketLabour.role_id.ToString();
                        if (ticketLabour.contract_id != null)
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)ticketLabour.contract_id);
                    }
                }

                if (thisTicket != null)
                {
                    thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                    if (!isComplete)
                        status_id.SelectedValue = (thisTicket.status_id).ToString();
                    else
                        status_id.SelectedValue = ((int)DicEnum.TICKET_STATUS.DONE).ToString();
                }
                else
                {
                    Response.Write("<script>alert('未查询到该工单信息！');window.close();</script>");
                }

                if (thisAccount != null)
                {
                    accAlert = new crm_account_alert_dal().FindAlert(thisAccount.id, DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);
                }
            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('" + msg.Message + "');window.close();</script>");
            }

        }

        private void GetPageDataBind()
        {
            resource_id.DataValueField = "val";
            resource_id.DataTextField = "show";
            resource_id.DataSource = resList;
            resource_id.DataBind();
            // resource_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            cost_code_id.DataValueField = "id";
            cost_code_id.DataTextField = "name";
            cost_code_id.DataSource = workTypeList;
            cost_code_id.DataBind();
            cost_code_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            status_id.DataValueField = "id";
            status_id.DataTextField = "name";
            status_id.DataSource = ticStaList;
            status_id.DataBind();

            
            role_id.DataValueField = "id";
            role_id.DataTextField = "name";
            role_id.DataSource = roleList;
            role_id.DataBind();
            role_id.Items.Insert(0, new ListItem() { Value = "", Text = "请选择", Selected = true });

            charge_cost_code_id.DataValueField = "id";
            charge_cost_code_id.DataTextField = "name";
            charge_cost_code_id.DataSource = chargeList;
            charge_cost_code_id.DataBind();
            charge_cost_code_id.Items.Insert(0, new ListItem() { Value = "", Text = "请选择", Selected = true });
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var faileReason = "";
            var result = false;
            if(isAdd)
                result = new TicketBLL().AddTicketLabour(param, LoginUserId, ref faileReason);
            else
                result = new TicketBLL().EditTicketLabour(param, LoginUserId, ref faileReason);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存"+(result?"成功":"失败") +"！');self.opener.location.reload();window.close();</script>");
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var faileReason = "";
            var result = false;
            if (isAdd)
                result = new TicketBLL().AddTicketLabour(param, LoginUserId, ref faileReason);
            else
                result = new TicketBLL().EditTicketLabour(param, LoginUserId, ref faileReason);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存" + (result ? "成功" : "失败") + "！');self.opener.location.reload();location.href='TicketLabour?ticket_id="+ param.ticketId.ToString() + "';</script>");
        }

        protected void save_modify_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 获取相关参数
        /// </summary>s
        protected SdkWorkEntryDto GetParam()
        {
            SdkWorkEntryDto param = new SdkWorkEntryDto();
            var pageEntry = AssembleModel<sdk_work_entry>();
            // 除了工时信息外，获取相关附加信息，成本信息，邮件信息

            if (!string.IsNullOrEmpty(Request.Form["ckIsBilled"]))
                pageEntry.is_billable = 1;
            else
                pageEntry.is_billable = 0;
            if (!string.IsNullOrEmpty(Request.Form["ckShowOnInv"]))
                pageEntry.show_on_invoice = 1;
            else
                pageEntry.show_on_invoice = 0;
            var status_id = Request.Form["status_id"];
            if (!string.IsNullOrEmpty(status_id))
                param.status_id = int.Parse(status_id);
            var labourDate = Request.Form["LabourDate"];
            var startTime = Request.Form["startTime"];
            var endTime = Request.Form["endTime"];
            if(!string.IsNullOrEmpty(labourDate)&& !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime))
            {
                var startDate = DateTime.Parse(labourDate+" "+ startTime);
                var endDate = DateTime.Parse(labourDate + " " + endTime);
                pageEntry.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                pageEntry.end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
            }
            pageEntry.hours_billed = (pageEntry.hours_worked ?? 0) + pageEntry.offset_hours;
            if (!string.IsNullOrEmpty(Request.Form["ckAppThisResou"]))
                param.isAppthisResoule = true;
            if (!string.IsNullOrEmpty(Request.Form["ckAppOtherResou"]))
                param.isAppOtherResoule = true;
            if (!string.IsNullOrEmpty(Request.Form["CkNoteCreat"]))
                param.isAppOtherNote = true;
            if (!string.IsNullOrEmpty(Request.Form["ckBillToAccount"]))
                param.billToAccount = true;
            param.ticketId = thisTicket.id;
            var charge_cost_code_id = Request.Form["charge_cost_code_id"];
            var quantity = Request.Form["quantity"];
            if (!string.IsNullOrEmpty(charge_cost_code_id)&&!string.IsNullOrEmpty(quantity))
            {
                var charge = new ctt_contract_cost()
                {
                    cost_code_id = long.Parse(charge_cost_code_id),
                    description = Request.Form["description"],
                    quantity = decimal.Parse(quantity),
                };
                var unit_price = Request.Form["unit_price"];
                if (!string.IsNullOrEmpty(unit_price))
                    charge.unit_price = decimal.Parse(unit_price);
                param.thisCost = charge;
            }
            pageEntry.task_id = thisTicket.id;
            if (isAdd)
            {
                param.workEntry = pageEntry;
            }
            else
            {
                if (isAllowAgentRes)
                {
                    ticketLabour.resource_id = pageEntry.resource_id;
                }
                ticketLabour.contract_id = pageEntry.contract_id;
                ticketLabour.service_id = pageEntry.service_id;
                ticketLabour.cost_code_id = pageEntry.cost_code_id;
                ticketLabour.is_billable = pageEntry.is_billable;
                ticketLabour.show_on_invoice = pageEntry.show_on_invoice;
                ticketLabour.role_id = pageEntry.role_id;
                ticketLabour.start_time = pageEntry.start_time;
                ticketLabour.end_time = pageEntry.end_time;
                ticketLabour.hours_worked = pageEntry.hours_worked;
                ticketLabour.offset_hours = pageEntry.offset_hours;
                ticketLabour.hours_billed = pageEntry.hours_billed;
                ticketLabour.summary_notes = pageEntry.summary_notes;
                ticketLabour.internal_notes = pageEntry.internal_notes;

                param.workEntry = ticketLabour;
            }


            return param;
        }
    }
}