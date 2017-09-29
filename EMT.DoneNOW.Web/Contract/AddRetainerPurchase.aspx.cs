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
        protected ctt_contract contract;    // 合同
        protected int blockType;    // 预付类型(1:预付时间;2:预付费用;3:事件)
        protected string blocktypeName; // 预付名称
        protected long contractId;  // 合同id
        private ContractBlockBLL bll = new ContractBlockBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                contractId = 0;
                string id = Request.QueryString["id"];
                if (!long.TryParse(id, out contractId))
                {
                    Response.Close();
                    return;
                }

                contract = new ContractBLL().GetContract(contractId);
                if (contract.type_id==(int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                {
                    blocktypeName = "时间";
                    blockType = 1;
                }
                else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.RETAINER)
                {
                    blocktypeName = "费用";
                    blockType = 2;
                }
                else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
                {
                    blocktypeName = "事件";
                    blockType = 3;
                }
                else
                {
                    Response.Close();
                    return;
                }

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
            if (!SaveBlock())
            {
                Response.Write("<script>alert('添加预付失败，必填项填写不完整！');</script>");

            }
            else
                Response.Write("<script>alert('添加预付成功！');window.close();self.opener.location.reload();</script>");

            contract = new ContractBLL().GetContract(contractId);
            if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
            {
                blocktypeName = "时间";
                blockType = 1;
            }
            else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.RETAINER)
            {
                blocktypeName = "费用";
                blockType = 2;
            }
            else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
            {
                blocktypeName = "事件";
                blockType = 3;
            }
        }

        protected void SaveNew_Click(object sender, EventArgs e)
        {
            long ctId = long.Parse(Request.Form["contractId"]);
            int type = int.Parse(Request.Form["blockType"]);

            if (SaveBlock())
            {
                Response.Write("<script>alert('添加预付成功！');</script>");
                Response.Redirect($"AddRetainerPurchase.aspx?id={ctId}&type={type}");
            }
            else
            {
                Response.Write("<script>alert('添加预付失败，必填项填写不完整！');</script>");
            }

            contract = new ContractBLL().GetContract(contractId);
            if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
            {
                blocktypeName = "时间";
                blockType = 1;
            }
            else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.RETAINER)
            {
                blocktypeName = "费用";
                blockType = 2;
            }
            else if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
            {
                blocktypeName = "事件";
                blockType = 3;
            }
        }

        private bool SaveBlock()
        {
            var dto = AssembleModel<ContractBlockAddDto>();
            contractId = dto.contractId;
            if (Request.Form["CreateOneOrMonthly"].Equals("1"))
                dto.isMonthly = false;
            else
                dto.isMonthly = true;
            if (!(Request.Form["useDelay"] != null && Request.Form["useDelay"].Equals("on")))
                dto.delayDays = null;
            if (Request.Form["EndDateLastOrNumbers"].Equals("1"))
                dto.purchaseNum = null;
            else
                dto.endDate = null;
            if (Request.Form["isFirstPart"] != null && Request.Form["isFirstPart"].Equals("on"))
                dto.firstPart = true;
            else
                dto.firstPart = false;
            if (Request.Form["rdStatus"].Equals("1"))
                dto.status = true;
            else
                dto.status = false;

            return bll.NewPurchase(dto, GetLoginUserId());
        }
    }
}