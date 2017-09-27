using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class InteralCostAddOrEdit : BasePage
    {
        protected bool isAdd = true;            // 是否新增
        protected ctt_contract_internal_cost intCost = null;
        protected ctt_contract contract = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var contract_id = Request.QueryString["contract_id"];
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                var cost_id = Request.QueryString["cost_id"];
                if (!string.IsNullOrEmpty(cost_id))
                {
                    intCost = new ctt_contract_internal_cost_dal().FindNoDeleteById(long.Parse(cost_id));
                    if (intCost != null)
                    {
                        isAdd = false;
                    }
                }
                
            }
            catch (Exception)
            {

                Response.End();
            }
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var thisCost = AssembleModel<ctt_contract_internal_cost>();
            if (!isAdd)
            {
                thisCost.id = intCost.id;
                thisCost.resource_id = intCost.resource_id;
                thisCost.role_id = intCost.role_id;
            }
            thisCost.contract_id = contract.id;
            var result = new ContractBLL().ConIntCostAddOrUpdate(thisCost,GetLoginUserId());
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');self.opener.location.reload();</script>");
            }
        }
    }
}