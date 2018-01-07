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
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var cid = Request.QueryString["contract_id"];
                var project_id = Request.QueryString["project_id"];
                var ccid = Request.QueryString["cost_id"];
                if (!string.IsNullOrEmpty(cid))
                {
                    contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(cid));
                }
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                }
                
                conCost = new ctt_contract_cost_dal().FindNoDeleteById(long.Parse(ccid));
                if (conCost != null)
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

                if(contract==null&& thisProject == null)
                {
                    Response.End();
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
                    bool isDelShiCost = false;
                    new ContractCostBLL().UpdateCost(dto, GetLoginUserId(),out isDelShiCost);
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
            if (contract != null)
            {
                param.account_id = contract.account_id;
            }
            if (thisProject != null)
            {
                param.account_id = thisProject.account_id;
            }
            
            param.installed_by = (int)LoginUserId;
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