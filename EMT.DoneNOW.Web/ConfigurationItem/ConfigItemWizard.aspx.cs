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
            if (CheckOne.Checked)
            {
                var param = GetParam();
                var result = new InstalledProductBLL().ConfigurationItemAdd(param,GetLoginUserId());
                if (result)
                {
                    conCost.create_ci = 1;
                    AddChargeDto dto = new AddChargeDto()
                    {
                        cost = conCost,
                        isAddCongigItem = false
                    };
                    new ContractCostBLL().UpdateCost(dto, GetLoginUserId());
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('配置项向导成功！');window.close();self.opener.location.reload();</script>");
                }
                else
                {

                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            }
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
            param.location = "";
            param.number_of_users = null;
            param.status = 1;
            param.contact_id = null;
            param.contract_id = null;
            param.service = null;
            if (product.installed_product_cate_id != null)
            {
                param.installed_product_cate_id = product.installed_product_cate_id;
            }
            else
            {
                var thisGeneral = new d_general_dal().GetGeneralById((long)product.cate_id);
                if (thisGeneral != null)
                {
                    param.installed_product_cate_id = int.Parse(thisGeneral.ext1);
                }
            }
            
            param.vendor_id = null;
            param.contract_cost_id = conCost.id;
            // 是否经过合同审核
            param.terms = new Terms();
            param.notice = new Notice();
            param.udf = null;
            return param;
        }
    }
}