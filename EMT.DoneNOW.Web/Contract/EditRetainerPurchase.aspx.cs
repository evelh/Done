using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class EditRetainerPurchase : BasePage
    {
        protected long blockId;  // 预付id
        protected string blocktypeName;     // 预付名称
        protected ctt_contract contract;    // 对应合同
        protected ctt_contract_block block; // 预付信息
        private ContractBlockBLL bll = new ContractBlockBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (!long.TryParse(id, out blockId))
                {
                    Response.Close();
                    return;
                }

                block = bll.GetBlockById(blockId);
                contract = new ContractBLL().GetContract(block.contract_id);

                var dic = bll.GetField();
                paymentType.DataValueField = "val";
                paymentType.DataTextField = "show";
                paymentType.DataSource = dic.FirstOrDefault(_ => _.Key == "paymentType").Value;
                paymentType.DataBind();
                paymentType.Items.Insert(0, new ListItem() { Value = "", Text = "   " });
                if (block.payment_type_id != null)
                    paymentType.SelectedValue = ((int)block.payment_type_id).ToString();
            }
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            ctt_contract_block blk = new ctt_contract_block();
            blk.id = long.Parse(Request.Form["id"]);
            blk.start_date = DateTime.Parse(Request.Form["startDate"]);
            blk.end_date = DateTime.Parse(Request.Form["endDate"]);
            if (string.IsNullOrEmpty(Request.Form["amount"]))
            {
                blk.rate = decimal.Parse(Request.Form["hourlyRate"]);
                blk.quantity = decimal.Parse(Request.Form["hours"]);
            }
            else
            {
                blk.rate = decimal.Parse(Request.Form["amount"]);
                blk.quantity = 1;
            }
            blk.status_id = sbyte.Parse(Request.Form["rdStatus"]);
            blk.date_purchased = DateTime.Parse(Request.Form["datePurchased"]);
            blk.payment_number = Request.Form["paymentNum"];
            if (string.IsNullOrEmpty(paymentType.SelectedValue))
                blk.payment_type_id = null;
            else
                blk.payment_type_id = int.Parse(paymentType.SelectedValue);
            blk.description = Request.Form["id"];

            bll.EditPurchase(blk, GetLoginUserId());
            Response.Write("<script>alert('修改预付成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}