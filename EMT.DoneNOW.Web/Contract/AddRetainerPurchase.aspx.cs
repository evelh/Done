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
    public partial class AddRetainerPurchase : BasePage
    {
        protected ContractEditDto contract;    // 合同
        protected int blockType;    // 预付类型(1:预付时间;2:预付费用;3:事件)
        protected long contractId;  // 合同id
        private ContractBlockBLL bll = new ContractBlockBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                contractId = 0;
                string id = Request.QueryString["id"];
                if (!long.TryParse(id, out contractId))
                    contractId = 0;
                if (!int.TryParse(Request.QueryString["type"], out blockType))
                    blockType = 1;

                contract = new ContractBLL().GetContract(contractId);

                var dic = bll.GetField();
                paymentType.DataValueField = "val";
                paymentType.DataTextField = "show";
                paymentType.DataSource = dic.FirstOrDefault(_ => _.Key == "paymentType").Value;
                paymentType.DataBind();
                paymentType.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            }
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            SaveBlock();
            Response.Write("<script>alert('添加预付成功！');window.close();self.opener.location.reload();</script>");
        }

        protected void SaveNew_Click(object sender, EventArgs e)
        {
            long ctId = long.Parse(Request.Form["contractId"]);
            int type = int.Parse(Request.Form["blockType"]);
            SaveBlock();
            Response.Write("<script>alert('添加预付成功！');</script>");
            Response.Redirect($"AddRetainerPurchase.aspx?id={ctId}&type={type}");
        }

        private void SaveBlock()
        {
            var dto = AssembleModel<ContractBlockAddDto>();
            bll.NewPurchase(dto, GetLoginUserId());
        }
    }
}