using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class ConfigItemWizard : BasePage
    {
        protected ctt_contract contract = null;
        protected ctt_contract_cost conCost = null;
        protected ivt_product product = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var cid = Request.QueryString["contract_id"];
                var ccid = Request.QueryString["cost_id"];
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(cid));
                conCost = new ctt_contract_cost_dal().FindNoDeleteById(long.Parse(ccid));
                if (contract != null && conCost != null)
                {
                    if (conCost.product_id != null)
                    {
                        product = new ivt_product_dal().FindNoDeleteById((long)conCost.product_id);
                    }
                    else
                    {
                        product = new ivt_product_dal().GetDefaultProduct();
                    }
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        /// <returns></returns>
        protected ConfigurationItemAddDto GetParam()
        {
            var param = AssembleModel<ConfigurationItemAddDto>();
            param.account_id = contract.account_id;
            param.installed_by =(int) GetLoginUserId();
            return param;
        }
    }
}