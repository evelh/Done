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
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class RelatiobContract : System.Web.UI.Page
    {
        protected crm_installed_product iProduct = null;
        protected List<ctt_contract_service> serviceList = null;
        protected ctt_contract contract = null;
        protected InstalledProductBLL insBLL = new InstalledProductBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var insProId = Request.QueryString["insProId"];
                var contractId = Request.QueryString["contractId"];
                if(!string.IsNullOrEmpty(insProId)&& !string.IsNullOrEmpty(contractId))
                {
                    iProduct = new crm_installed_product_dal().FindNoDeleteById(long.Parse(insProId));
                    serviceList = new ctt_contract_service_dal().GetConSerList(long.Parse(contractId));
                    contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contractId));
                    if (iProduct!=null&& serviceList!=null&& serviceList.Count > 0)
                    {

                    }
                }
                if(contract==null|| iProduct == null)
                {
                    Response.Write("<script>alert('未获取到相关配置项，合同信息');window.close();</script>");
                }
                
                
            }
            catch (Exception error)
            {

                Response.Write("<script>alert('"+ error.Message + "');window.close();</script>");
            }
        }
    }
}