using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractAdd : BasePage
    {
        protected int contractType; // 合同类型
        protected string contractTypeName;  // 合同类型名称

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["type"], out contractType))
                contractType = 0;

        }
    }
}