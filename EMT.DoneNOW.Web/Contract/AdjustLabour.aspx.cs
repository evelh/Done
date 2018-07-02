using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class AdjustLabour : BasePage
    {
        protected crm_account_deduction deduction;
        protected v_widget_posted_item vItem;
        protected crm_account account;
        protected ctt_contract contract;
        protected sys_resource resource;
        protected sdk_task task;
        protected ctt_contract_block dedBlock;
        protected ctt_contract_block block;
        protected d_general contractType;
        protected InvoiceBLL invBll = new InvoiceBLL();
        protected decimal? rate;
        protected decimal? taxRate;
        protected d_cost_code costCode;
        protected sdk_work_entry labour;

        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                deduction = invBll.GetDeduction(id);

            //if (deduction == null)
            //{
            //    Response.Write("<script>alert('未获取到相关条目');window.close();</script>");
            //}
            long blockId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["blockId"]) && long.TryParse(Request.QueryString["blockId"], out blockId))
                block = new ContractBlockBLL().GetBlockById(blockId);

            if (deduction != null)
            {
                vItem = new DAL.v_widget_posted_item_dal().FindById(deduction.id);
                rate = vItem?.rate;
                account = new CompanyBLL().GetCompany(deduction.account_id);
                if (deduction.contract_id != null)
                    contract = new ContractBLL().GetContract((long)deduction.contract_id);
                if (deduction.task_id != null)
                    task = new TicketBLL().GetTask((long)deduction.task_id);
                labour = new WorkEntryBLL().GetEntryById((long)deduction.object_id);
                if(vItem?.tax_category_id!=null&& vItem?.tax_region_id != null)
                {
                    var thisTax = new DAL.d_tax_region_cate_dal().GetSingleTax((long)vItem?.tax_region_id,(long)vItem?.tax_category_id);
                    taxRate = thisTax?.total_effective_tax_rate;
                }
                if (vItem?.resource_id != null)
                    resource = new UserResourceBLL().GetResourceById((long)vItem.resource_id);
                if (deduction.contract_block_id != null)
                    dedBlock = new ContractBlockBLL().GetBlockById((long)deduction.contract_block_id);
            }
            if (block != null)
            {
                contract = new ContractBLL().GetContract(block.contract_id);
                if (contract != null)
                {
                    account = new CompanyBLL().GetCompany(contract.account_id);
                    contractType = new GeneralBLL().GetSingleGeneral(contract.type_id);
                }
            }
            if (block == null && deduction == null)
            {
                Response.Write("<script>alert('未获取到相关条目');window.close();</script>");
            }

        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            decimal adjustNum = 0;
            if (!string.IsNullOrEmpty(Request.Form["AdjustNum"]))
                decimal.TryParse(Request.Form["AdjustNum"], out adjustNum);
            if (Request.Form["adjustType"] == "Reduce")
                adjustNum = 0 - adjustNum;

            decimal adjustMoney = 0;
            if (!string.IsNullOrEmpty(Request.Form["AdjustMoney"]))
                decimal.TryParse(Request.Form["AdjustMoney"], out adjustMoney);

            var result = false;
            string failReason = string.Empty;
            if (!string.IsNullOrEmpty(Request.Form["reason"]))
            {
                if (block != null)
                {
                    result = invBll.AjustBlock(block.id, adjustNum, Request.Form["reason"], LoginUserId,ref failReason);
                }
                else if (deduction != null)
                {
                    result = invBll.AjustDeduction(deduction.id,adjustNum,adjustMoney, Request.Form["reason"], LoginUserId);
                }
            }

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result? "成功！" : $"失败.{failReason}")}');window.close();self.opener.location.reload(); </script>");


        }
    }
}