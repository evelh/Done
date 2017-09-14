using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;


namespace EMT.DoneNOW.Web.Contract
{
    public partial class AddDefaultCharge : BasePage
    {
        protected bool isAdd = true;
        protected ctt_contract_cost_default conDefCost = null;
        protected ctt_contract contract = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var conDefCostId = Request.QueryString["id"];
                var contract_id = Request.QueryString["contract_id"];
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                if (contract != null)
                {
                    if (!string.IsNullOrEmpty(conDefCostId))
                    {
                        conDefCost = new ctt_contract_cost_default_dal().FindNoDeleteById(long.Parse(conDefCostId));
                        if (conDefCost != null)
                        {
                            isAdd = false;

                            if (!IsPostBack)
                            {
                                isbillable.Checked = conDefCost.is_billable == 1;
                            }
                        }
                    }
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var thisConDefCost = AssembleModel<ctt_contract_cost_default>();
            thisConDefCost.is_billable = (sbyte)(isbillable.Checked ? 1 : 0);
            thisConDefCost.contract_id = contract.id;
            bool result = false;
            if (isAdd)
            {
                result = new ContractCostBLL().ConDefCostAddOrUpdate(thisConDefCost,GetLoginUserId());
            }
            else
            {
                conDefCost.unit_cost = thisConDefCost.unit_cost;
                conDefCost.unit_price = thisConDefCost.unit_price;
                conDefCost.is_billable = thisConDefCost.is_billable;
                conDefCost.cost_code_id = thisConDefCost.cost_code_id;
                result = new ContractCostBLL().ConDefCostAddOrUpdate(conDefCost, GetLoginUserId());
            }

            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存默认成本成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存默认成本失败！');window.close();self.opener.location.reload();</script>");

            }
            
        }
    }
}