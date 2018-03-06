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
    public partial class AdjustService : BasePage
    {
        protected long serviceId = 0;       // 服务/服务包id
        protected string serviceTypeName;   // 名称（服务/服务包）
        protected string serviceName;       // 服务/服务包名称
        protected ctt_contract_service service;
        protected ctt_contract contract;
        private ContractServiceBLL bll = new ContractServiceBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string cId = Request.QueryString["id"];
                serviceId = long.Parse(cId);
            }
            else
            {
                serviceId = long.Parse(Request.Form["serId"]);
            }
            service = bll.GetService(serviceId);
            contract = new ContractBLL().GetContract(service.contract_id);
            DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod, maxPeriod;
            decimal rate = bll.GetPeriodRate((DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, service.id, 0, out svcPeriod, out maxPeriod);
            if (rate > 1)
            {
                service.unit_cost = service.unit_cost / rate;
                service.unit_price = service.unit_price / rate;
            }
            if (service.object_type == 1)
                serviceTypeName = "服务";
            else if (service.object_type == 2)
                serviceTypeName = "服务包";
            serviceName = bll.GetServiceName(service);

            if (IsPostBack)
            {
                ctt_contract_service ser = new ctt_contract_service();
                ser.id = serviceId;
                try
                {
                    ser.quantity = int.Parse(Request.Form["serUnits"]);
                    ser.unit_price = decimal.Parse(Request.Form["serPrice"]);
                    ser.unit_cost = decimal.Parse(Request.Form["serCost"]);
                    ser.adjusted_price = int.Parse(Request.Form["serAdjustCost"]);
                    ser.effective_date = DateTime.Parse(Request.Form["effective_date"]);
                }
                catch
                {
                    Response.Write("<script>alert('输入有误，调整失败！');</script>");
                    return;
                }
                if (service.object_type == 1)
                    new ContractServiceBLL().AdjustService(ser, GetLoginUserId());
                else if (service.object_type == 2)
                    new ContractServiceBLL().AdjustServiceBundle(ser, GetLoginUserId());
                Response.Write("<script>alert('调整成功！');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}