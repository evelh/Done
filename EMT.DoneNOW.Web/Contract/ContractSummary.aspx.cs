using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractSummary : BasePage
    {
        protected ctt_contract contract;    // 合同
        protected v_contract_summary summary;   // 合同摘要

        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!long.TryParse(Request.QueryString["id"], out id))
                id = 0;

            var bll = new ContractBLL();
            summary = bll.GetContractSummary(id);
            contract = bll.GetContract(id);
        }
    }
}