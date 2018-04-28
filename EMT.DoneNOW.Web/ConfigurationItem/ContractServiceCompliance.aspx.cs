using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class ContractServiceCompliance : BasePage
    {
        protected ctt_contract contract;
        protected ctt_contract_service contractService;
        protected crm_installed_product insPro;
        protected void Page_Load(object sender, EventArgs e)
        {
            var contratId = Request.QueryString["contractId"];
            var seviceId = Request.QueryString["serviceId"];
            var insProId = Request.QueryString["insProId"];
            if (!string.IsNullOrEmpty(contratId))
                contract = new ContractBLL().GetContract(long.Parse(contratId));
            if (!string.IsNullOrEmpty(insProId))
                insPro = new crm_installed_product_dal().FindNoDeleteById(long.Parse(insProId));
            if (!string.IsNullOrEmpty(seviceId))
                contractService = new ctt_contract_service_dal().FindNoDeleteById(long.Parse(seviceId));
            if(contractService == null|| contract==null|| insPro == null)
            {
                Response.Write("<script>alert('未获取到相关配置项，合同信息');window.close();</script>");
                return;
            }
        }
    }
}