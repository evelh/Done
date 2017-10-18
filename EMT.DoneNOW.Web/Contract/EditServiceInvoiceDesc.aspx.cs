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
    public partial class EditServiceInvoiceDesc : BasePage
    {
        protected ctt_contract_service service;     // 合同服务
        protected string serviceName;               // 服务名称
        protected string description;               // 服务默认发票描述
        private ContractServiceBLL bll = new ContractServiceBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            long serId;
            if (string.IsNullOrEmpty(id) || !long.TryParse(id, out serId))
            {
                Response.Close();
                return;
            }
            service = bll.GetService(serId);
            if (service.object_type == 1)
            {
                var ser = new ServiceBLL().GetServiceById(service.object_id);
                serviceName = ser.name;
                description = ser.invoice_description;
            }
            else
            {
                var ser = new ServiceBLL().GetServiceBundleById(service.object_id);
                serviceName = ser.name;
                description = ser.invoice_description;
            }

            if (IsPostBack)
            {
                var ser = AssembleModel<ctt_contract_service>();
                bll.EditServiceInvoiceDescription(ser, GetLoginUserId());
                Response.Write("<script>alert('修改发票描述成功！');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}