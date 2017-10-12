using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class AddService : BasePage
    {
        protected int objType;          // 1:服务;2:服务包
        protected string serviceName;   // 名称（服务/服务包）
        protected DateTime effDate;     // 默认生效时间
        protected ctt_contract contract;// 合同信息

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string cId = Request.QueryString["contractId"];
                objType = int.Parse(Request.QueryString["type"]);

                if (objType == 1)
                    serviceName = "服务";
                else if (objType == 2)
                    serviceName = "服务包";

                long contractId = 0;
                if (!long.TryParse(cId,out contractId))
                {
                    Response.Close();
                    return;
                }
                contract = new ContractBLL().GetContract(contractId);

                if (string.IsNullOrEmpty(Request.QueryString["date"]))
                    effDate = contract.start_date > DateTime.Now ? contract.start_date : DateTime.Now;
                else
                    effDate = DateTime.Parse(Request.QueryString["date"]);
            }
            else
            {
                var service = AssembleModel<ctt_contract_service>();
                if (!string.IsNullOrEmpty(Request.Form["adjustCost"]))
                    service.adjusted_price = decimal.Parse(Request.Form["adjustCost"]);
                new ContractServiceBLL().AddServiceServiceBundle(service, GetLoginUserId());

                contract = new ContractBLL().GetContract(service.contract_id);
                effDate = DateTime.Now;
                objType = service.object_type;

                Response.Write("<script>alert('添加成功！');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}